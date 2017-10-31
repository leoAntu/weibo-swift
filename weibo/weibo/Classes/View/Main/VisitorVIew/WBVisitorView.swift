//
//  WBVisitorView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/26.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    private lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    
    private lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))

    private lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    private lazy var tipLab:UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜。", fontSize: 14, color: UIColor.darkGray)
    
    lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")

    
    var visitorInfo: [String: String]? {
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                return
            }
            
            tipLab.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 15
        //完成动画后不删除 如果iconvie被释放，动画会一起销毁
        animation.isRemovedOnCompletion = false
        iconView.layer .add(animation, forKey: "animation")
    }
}

extension WBVisitorView {
    func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        // 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLab)
        addSubview(registerButton)
        addSubview(loginButton)

        
        tipLab.textAlignment = .center
        // 取消autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //自动布局
        
        let margin:CGFloat = 20
        
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -60))
        
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: tipLab, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLab, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLab, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .width, multiplier: 0, constant: 230))

        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -50))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLab, attribute: .bottom, multiplier: 1, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 60))

        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 50))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: tipLab, attribute: .bottom, multiplier: 1, constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 60))
        
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .bottom, relatedBy: .equal, toItem: registerButton, attribute: .top, multiplier: 1, constant: margin))




    }
}
