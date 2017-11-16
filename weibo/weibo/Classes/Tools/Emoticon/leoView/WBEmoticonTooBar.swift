//
//  WBEmoticonTooBar.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/15.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBEmoticonTooBar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.width / CGFloat(subviews.count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i, btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
}

private extension WBEmoticonTooBar {
    func setupUI() {
        
        let manager = CZEmoticonManager.shared
        
        for p in manager.packages {
            let btn = UIButton()
            
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            let imgName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imgSelectedName = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var img = UIImage(named: imgName, in: manager.bundle, compatibleWith: nil)
            var selectedImg = UIImage(named: imgSelectedName, in: manager.bundle, compatibleWith: nil)

            //拉伸图片
            let size = img?.size
            let inset = UIEdgeInsetsMake((size?.height)! * 0.5, (size?.width)! * 0.5, (size?.height)! * 0.5, (size?.width)! * 0.5)
            
            img = img?.resizableImage(withCapInsets: inset)
            selectedImg = selectedImg?.resizableImage(withCapInsets: inset)
            
            
            btn.setBackgroundImage(img, for: .normal)
            btn.setBackgroundImage(selectedImg, for: .selected)
            btn.setBackgroundImage(selectedImg, for: .highlighted)

            btn.sizeToFit()
            addSubview(btn)
        }
    }
}
