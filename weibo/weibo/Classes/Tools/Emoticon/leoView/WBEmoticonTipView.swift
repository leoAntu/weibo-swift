

//
//  WBEmoticonTipView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/17.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBEmoticonTipView: UIImageView {

  
    init() {
        
        let bundle = CZEmoticonManager.shared.bundle
        let img = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        super.init(image: img)
        
        //设置锚点， 就是定位点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
