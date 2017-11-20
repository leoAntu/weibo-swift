
//
//  WBComposeTextView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/14.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {

    lazy var placeholderLab = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //纯字符串，传给后台使用
    var textViewString: String? {
        
        //获取属性文本
        guard let attrStr = attributedText else {
            return ""
        }
        
        //定义变量接受字符串
        var resultStr = String()
        //遍历属性文本
        attrStr.enumerateAttributes(in:NSRange(location: 0, length: attrStr.length), options: [], using: { (dict, range, _) in
            
            if let attachment = dict[NSAttributedStringKey.attachment] as? CZEmoticonAttachment  {
                resultStr = resultStr + (attachment.chs ?? "")
            } else {
                resultStr = resultStr + (attrStr.string as NSString).substring(with: range)
            }
            
        })
        
        return resultStr
    }
    
    
    private func setupUI() {
        placeholderLab.text = "分享新鲜事..."
        placeholderLab.textColor = UIColor.gray
        placeholderLab.font = UIFont.systemFont(ofSize: 14)
        placeholderLab.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLab.sizeToFit()
        addSubview(placeholderLab)
        
        //添加监听方法  不能再使用代理，代理只能有一个，在controll里面已经设置了代理
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    // MARK: - 向文本视图中插入表情符号/图文混排
    func insertEmoticon(em: CZEmoticon?) {
        
        guard let em = em else {
            //删除文本
            deleteBackward()
            return
        }
        
        //2 emoji 字符串
        if let emoji = em.emoji, let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            return
        }
        
      
        
        //所有排版的文字系统中，几乎都有一个共同的特点，插入的字符的显示，跟随前一个字符的属性，但是本身没有属性 所以imageText 要设置font属性
        //3 获取图片属性文本
        let imageText = em.imageText(font: font!)
        
        //获取当前属性文本
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        
        //将图像属性文本插入到当前光标位置
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        
        //记录变化之前的光标位置
        let range = selectedRange
        
        //重新设置属性文本，光标位置发生变化
        attributedText = attrStrM
        
        //恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        //代理方法通知控制器改变发送按钮的状态,调用系统代理方法
        delegate?.textViewDidChange?(self)
        
        //解决bug, 当text没有文字的时候插入图片，不会隐藏placeholder，调用通知方法
        textViewDidChange()
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension WBComposeTextView {
    @objc func textViewDidChange() {
        
        placeholderLab.isHidden = self.hasText
    }
}
