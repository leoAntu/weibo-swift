

//
//  WBEmoticonTipView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/17.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import pop

class WBEmoticonTipView: UIImageView {

    private lazy var tipBtn = UIButton()
    //记录之前选择的表情
    private var preEmoticon: CZEmoticon?
    
    var emoticon: CZEmoticon? {
        didSet{
            
            if emoticon == preEmoticon {
                return
            }
            
            preEmoticon = emoticon
            
            // 设置表情数据
            tipBtn.setTitle(emoticon?.emoji, for: [])
            tipBtn.setImage(emoticon?.image, for: [])
            
            //表情动画 ,弹力动画，不需要指定duration
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //值越大，弹的越远，选择适当的值
            anim?.fromValue = 30
            anim?.toValue = 8
            
            anim?.springBounciness = 20
            anim?.springSpeed = 20
            
            tipBtn.layer.pop_add(anim, forKey: nil)
        }
    }
    init() {
        
        let bundle = CZEmoticonManager.shared.bundle
        let img = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        super.init(image: img)
        
        //设置锚点， 就是定位点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        //添加按钮,为了显示emoji
        //设置锚点，动画的时候位置会发生偏移
        tipBtn.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipBtn.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        tipBtn.center.x = bounds.width * 0.5
        
        tipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    
        addSubview(tipBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
