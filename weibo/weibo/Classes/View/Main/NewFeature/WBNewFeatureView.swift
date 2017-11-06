


//
//  WBNewFeatureView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/2.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterBtnAciton(_ sender: Any) {
        
    }
    class func newFeatureView() -> WBNewFeatureView {
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        //从xib加载的View视图默认是600 * 600
        v.frame = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        //在此方法中从xib加载的View视图默认还是600 * 600

        let count = 4;
        let rect = UIScreen.main.bounds
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            
        }
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(5), height: rect.height)

        for i in 0..<4 {
            let imgName = "new_feature_\(i+1)"
            let img = UIImage(named: imgName)
            let iv = UIImageView(image: img)
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy:0)
            scrollView.addSubview(iv)
            print(iv,scrollView)
        }
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.bringSubview(toFront: enterBtn)
        scrollView.bringSubview(toFront: pageControl)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.layoutIfNeeded()
    }
    
}
