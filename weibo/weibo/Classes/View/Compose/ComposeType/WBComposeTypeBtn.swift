

//
//  WBComposeTypeBtn.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/9.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBComposeTypeBtn: UIControl {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    var clsName: String?
    
    class func composeTypeBtn(imageName: String, title: String) -> WBComposeTypeBtn {
        let nb = UINib(nibName: "WBComposeTypeBtn", bundle: nil)
        let v = nb.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeBtn
        v.imgIcon.image = UIImage(named: imageName)
        v.titleLab.text = title
        return v
    }
    
}
