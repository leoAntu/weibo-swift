

//
//  UIScreen+Extension.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/20.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

extension UIScreen {
    
    func wb_screenWidth() -> Float {
        return Float(UIScreen.main.bounds.size.width);
    }
    
    func wb_screenHeight() -> Float {
        return Float(UIScreen.main.bounds.size.width);
    }
    
    var screenWidth: Float {
        return Float(UIScreen.main.bounds.size.width);
    }
}
