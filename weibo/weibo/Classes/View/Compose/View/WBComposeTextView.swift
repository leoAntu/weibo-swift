
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension WBComposeTextView {
    @objc func textViewDidChange() {
        
        placeholderLab.isHidden = self.hasText
    }
}
