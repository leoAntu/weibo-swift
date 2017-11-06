


//
//  WBWelcomeView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/2.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import SDWebImage
class WBWelcomeView: UIView {
 
    @IBOutlet weak var avatorView: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //还没有和代码连线建立关系，只是XIB的二进制文件刚刚加载完，在这个方法里面不能处理UI问题
    }
    
    
    /// xib加载完后加载，还不能获取UI的frame
    override func awakeFromNib() {
        let urlString = WBNetworkManager.shared.userAccount.avatar_large ?? ""
        let url = URL(string: urlString)
        avatorView.sd_setImage(with: url, placeholderImage:  UIImage(named: "avatar_default_big"), options: [], progress: nil, completed: nil)
    }
    
    class func welcomeView() -> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        //从xib加载的View视图默认是600 * 600
        v.frame = UIScreen.main.bounds
        return v
    }
    
    //视图添加到window上，表示视图已经被显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        //执行之后，控件所在位置，就是XIB所在的位置，要不然动画出问题
        self.layoutIfNeeded()

        bottomLayout.constant = bounds.size.height - 200
        
        //如果控件们的frame还没计算好，所有的约束会一起动画
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        //更新约束
                        self.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.nameLab.alpha = 1

            }, completion: { (bool) in
                self.removeFromSuperview()
            })
        }
    }
}
