//
//  WBRefreshView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/9.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBRefreshView: UIView {

    @IBOutlet weak var freshIcon: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textLab: UILabel!
    
    var refreshState: WBRefreshState = .Normol {
        didSet{
            switch refreshState {
            case .Normol:
                textLab.text = "下拉刷新"
                
                //显示提示图标
                freshIcon.isHidden = false
                
                //隐藏菊花
                indicator.isHidden = true
                indicator.stopAnimating()
                
                //恢复的初始化位置
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    self?.freshIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                textLab.text = "松开刷新"
                
                //要想实现同方向旋转，需要调整非常少的数字，就近原则，如果旋转360度，需要CABaseAnimation
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    self?.freshIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + 0.001))
                })
            case .willRefresh:
                textLab.text = "正在刷新"
                
                //隐藏提示图标
                freshIcon.isHidden = true
                
                //显示菊花
                indicator.isHidden = false
                indicator.startAnimating()
            }
        }
    }
    
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBRefreshView
        return v
    }
    
    override func awakeFromNib() {
    }
}
