//
//  CZEmoticon.swift
//  004-表情包数据
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import YYModel

/// 表情模型
class CZEmoticon: NSObject {

    /// 表情类型 false - 图片表情 / true - emoji
    var type = false
    /// 表情字符串，发送给新浪微博的服务器(节约流量)
    var chs: String?
    /// 表情图片名称，用于本地图文混排
    var png: String?
    /// emoji 的十六进制编码
    var code: String? {
        didSet {
            //unicode 的编码，展现使用 UTF8 1-4个字节表示一个字符
            guard let code = code else {
                return
            }
            //实例化字符扫描
            let scanner = Scanner(string: code)
            
            //从code 中扫描出十六进制的数值
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            //使用UInt32 的数值，生成一个UTF8的字符
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    /// 表情使用次数
    var times: Int = 0
    /// emoji 的字符串
    var emoji: String?
    
    /// 表情模型所在的目录
    var directory: String?
    
    /// `图片`表情对应的图像
    var image: UIImage? {
        
        // 判断表情类型
        if type {
            return nil
        }
        
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
            else {
                return nil
        }
    
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 将当前的图像转换生成图片的属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        
        // 1. 判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        // 2. 创建文本附件
        let attachment = CZEmoticonAttachment()
        
        // 记录属性文本文字
        attachment.chs = chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        // 3. 返回图片属性文本
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        //所有排版的文字系统中，几乎都有一个共同的特点，插入的字符的显示，跟随前一个字符的属性，但是本身没有属性 所以imageText 要设置font
        // 设置字体属性
        attrStrM.addAttributes([NSAttributedStringKey.font: font], range: NSRange(location: 0, length: 1))
        
        // 4. 返回属性文本
        return attrStrM
    }
    
    func initDictionary(dic: [String: Any]) {
        type = (dic["type"] as? String) != "0" ? true : false
        chs = dic["chs"] as? String
        png = dic["png"] as? String
        code = dic["code"] as? String
     }
    
    override var description: String {
        return yy_modelDescription()
    }
}
