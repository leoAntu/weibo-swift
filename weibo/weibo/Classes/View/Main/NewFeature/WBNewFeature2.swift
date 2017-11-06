
//
//  WBNewFeature2.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/3.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBNewFeature2: UIView {

    private lazy var scrollView = UIScrollView()
    private lazy var enterBtn = UIButton(type: .custom)
    private lazy var pageControl = UIPageControl()
    let count = 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        scrollView.frame = self.bounds
        addSubview(self.scrollView)
        
        setScollViewSubviews()
        
        enterBtn .setTitle("进入首页", for: .normal)
        enterBtn.setTitleColor(UIColor.black, for: .normal)
        enterBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), for: .normal)
        enterBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), for: .highlighted)
        enterBtn.addTarget(self, action: #selector(enterBtnAction), for: .touchUpInside)
       enterBtn.isHidden = true
        
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.purple
        pageControl.isUserInteractionEnabled = false  // 禁用交互
        addSubview(enterBtn)
        addSubview(pageControl)
        
        enterBtn.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: enterBtn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: enterBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -100))
        addConstraint(NSLayoutConstraint(item: enterBtn, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 90))

        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .top, relatedBy: .equal, toItem: enterBtn, attribute: .bottom, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 40))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 37))
    }
    
    @objc private func enterBtnAction() {
       removeSubviews()
    }
    
    private func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    private func setScollViewSubviews() {
        let rect = UIScreen.main.bounds
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            
        }
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(count + 1), height: rect.height)
        
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
        scrollView.delegate = self
    }
    
}

extension WBNewFeature2: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        print(page)
        
        if page == count {
            removeSubviews()
        }
        enterBtn.isHidden = (page != count - 1)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterBtn.isHidden = true
        let page = Int(scrollView.contentOffset.x / (scrollView.bounds.width + 0.5))
        
        pageControl.currentPage = page
        pageControl.isHidden = (page == count - 1)
        
    }
}
