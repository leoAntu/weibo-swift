

//
//  WBStatus.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import YYModel

class WBStatus: NSObject {

    var id:Int64 = 0
    
    var text: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
