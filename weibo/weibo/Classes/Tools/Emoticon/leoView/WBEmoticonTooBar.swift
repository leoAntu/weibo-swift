//
//  WBEmoticonTooBar.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/15.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

@objc protocol WBEmoticonTooBarDelegate: NSObjectProtocol {
    func emoticonToolBarSelectedIndex(btn: UIButton, index: Int)
}

class WBEmoticonTooBar: UIView {

    var currentSection: Int? {
        didSet{
            let btn = viewWithTag(currentSection! + 1) as? UIButton
            if btn?.isSelected == true {
                return
            }
            clearBtnsSelected()
            btn?.isSelected = true
        }
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    weak var delegate: WBEmoticonTooBarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.width / CGFloat(subviews.count)
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        
        for (i, btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
    
    @objc private func clickItemAction(btn: UIButton) {
        
        if btn.isSelected == true {
            return
        }
        
        clearBtnsSelected()
       
        btn.isSelected = true
        delegate?.emoticonToolBarSelectedIndex(btn: btn, index: btn.tag - 1)
    }
    
}

private extension WBEmoticonTooBar {
    func setupUI() {
        
        let manager = CZEmoticonManager.shared
        
        for (i, p) in manager.packages.enumerated() {
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
            btn.tag = i + 1
            btn.addTarget(self, action: #selector(clickItemAction), for: .touchUpInside)
            btn.sizeToFit()
            addSubview(btn)
        }
        
        (subviews[0] as? UIButton)?.isSelected = true
    }
    
    func clearBtnsSelected() {
        for v in subviews {
            (v as? UIButton)?.isSelected = false
        }
    }
}
