
//
//  UIBarButtonItem+Extension.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/20.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 创建barItem
    ///
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    convenience  init(title: String, target: AnyObject, action: Selector, isBack: Bool = false) {
        let btn:UIButton = UIButton(type: .custom);
        btn.setTitle(title, for: UIControlState(rawValue: 0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState(rawValue: 0))
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)

        if isBack {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        self.init(customView:btn)
    }
}
