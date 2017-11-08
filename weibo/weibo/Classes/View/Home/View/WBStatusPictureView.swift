
//
//  WBStatusPictureView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/7.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    @IBOutlet weak var heightConstant: NSLayoutConstraint!

    var viewModel: WBStatusViewModel? {
        didSet{
            calcPicViewHeight()
        }
    }
    
    private func calcPicViewHeight() {
        heightConstant.constant = viewModel?.pictureSize.height ?? 0
        
        //修改单个图片
        if viewModel?.picUrls?.count == 1 {
            let size = viewModel?.pictureSize ?? CGSize()
            
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: CGFloat(WBPictureViewOutMargin), width: size.width, height: size.height - CGFloat(WBPictureViewOutMargin))
            
        } else {
            //多张图片时要恢复九宫格第一张的size
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                              y: CGFloat(WBPictureViewOutMargin),
                              width: CGFloat(WBPictureViewItemWidth),
                              height: CGFloat(WBPictureViewItemWidth))
            
        }
    }
    
    var urls: [WBStatusPictureModel]? {
        didSet {
            //隐藏所有的imgView
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                //获取对应index 的imgview
                let iv = subviews[index] as? UIImageView
                
                //设置图片
                iv?.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                //显示图片
                iv?.isHidden = false
                
                //处理四张图片问题 
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                //索引值加1
                index = index + 1
            }
        }
    }
    
    override func awakeFromNib() {
        setupUI()
    }
}

extension WBStatusPictureView {
    private func setupUI() {
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        let count = 3
        let rect = CGRect(x: 0,
                          y: CGFloat(WBPictureViewOutMargin),
                          width: CGFloat(WBPictureViewItemWidth),
                          height: CGFloat(WBPictureViewItemWidth))
        
        for i in 0..<count * count {
            
            let iv = UIImageView()
            
            //设置imgView 显示比例
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //列 -- x
            let col = CGFloat(i % count)
            //行 -- y
            let row = CGFloat(i / count)
            
            let dx = CGFloat(Float(col) * (WBPictureViewItemWidth + WBPictureViewItemMargin))
            let dy = CGFloat(Float(row) * (WBPictureViewItemWidth + WBPictureViewItemMargin))
            iv.frame = rect.offsetBy(dx: dx, dy: dy)
            addSubview(iv)
        }
    }
}
