

//
//  WBComposeTypeView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/9.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import pop

private let kButtonPositionY: CGFloat = 300

class WBComposeTypeView: UIView {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var closeBtnConstraintX: NSLayoutConstraint!
    @IBOutlet weak var returnBtnConstraintY: NSLayoutConstraint!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var returnBtn: UIButton!
    
    @IBAction func closeAction(_ sender: UIButton) {
        
        animationDissmissButton()
    }
    
    @IBAction func returnBtnAction(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        //调整底部bar
        resetBottomBar()
    }
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    
    //定义闭包私有变量
    private var completionBlock: ((_ clsName: String?) -> ())?
    
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        v.frame = UIScreen.main.bounds
        v.setupUI()
        return v
    }
    
    deinit {
        print(self)
    }
    
}

private extension WBComposeTypeView {
    func setupUI() {
        
        //强行更新布局，特别动画中很重要
        layoutIfNeeded()
        
        //设置底部bar
        resetBottomBar()
        
        //获取scroview 的 bounds
        let rect = scrollView.bounds
        
        //创建view 添加btn
        for i in 0..<2 {
            let v = UIView()
            v.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            //添加到scrollview
            scrollView.addSubview(v)
            
            //添加btn
            addButton(v: v, idx: i * 6)
        }
        
        //设置scrollview的 contentsize
        scrollView.contentSize = CGSize(width: rect.width * 2, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //xib默认开启，按钮动画需要从下面弹出
        scrollView.clipsToBounds = false
        
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    
    /// 添加btn
    ///
    /// - Parameters:
    ///   - v: 父视图
    ///   - idx: 初始索引
    func addButton(v: UIView, idx: Int) {
        
        let count = 6
        
        //循环遍历
        for i in idx..<(idx + count) {
            
            //防止数组越界
            if i >= buttonsInfo.count {
                break
            }
            //获取数组中字典
            let dict = buttonsInfo[i]
            
            //获取字典中imagename，title
            guard let imageName = dict["imageName"],
                  let title = dict["title"] else {
                    continue
            }
            
            //创建button
            let btn = WBComposeTypeBtn.composeTypeBtn(imageName: imageName, title: title)
            
            //添加到父视图
            v.addSubview(btn)
            
            //添加action
            if let actionName = dict["actionName"] {
                //通过字符串创建Selector 方法
                //在oc 中使用 NSSelectorFromString(actionName) 实现
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(composeTypeAction), for: .touchUpInside)
            }
            
            // 设置要展现的类名
            btn.clsName = dict["clsName"]
        }
        
        //添加btn frame
        for (i,btn) in v.subviews.enumerated() {
            
            let btnSize = CGSize(width: 100, height: 100)
            let margin = (v.bounds.width - 3 * btnSize.width) / 4
            
            let col = i % 3
            
            let x = CGFloat((col + 1)) * margin + CGFloat(col) * btnSize.width
            let y = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)

        }
        
    }
    
    
    //设置底部bar样式
    func resetBottomBar() {
        returnBtn.isHidden = true
        closeBtnConstraintX.constant = 0
        
        UIView.animate(withDuration: 0.3) {
           self.layoutIfNeeded()
        }
    }
    
    func adjustBottomBar() {
        returnBtnConstraintY.constant = 200
        closeBtnConstraintX.constant = 200
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (success) in
            self.returnBtn.isHidden = false
        }

    }
    
    
    @objc private func composeTypeAction(sender: WBComposeTypeBtn) {
        
        //获取当前视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //遍历视图
        //-- 选中的btn放大
        // -- 未选中的btn缩小
        
        for (i,btn) in v.subviews.enumerated() {
        
            //创建缩放动画
            let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
            //放大两倍 ,scale在动画中放大，需要NSValue包装,且以CGPoint形式,
            let scale = (btn == sender) ? 2 : 0.2
            scaleAnim?.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim?.duration = 0.5
            //设置的layer层动画，一定加载layer上面
            btn.layer.pop_add(scaleAnim, forKey: nil)
            
            //创建渐变动画
            let alphaAnim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim?.toValue = 0.2
            alphaAnim?.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            //随便监听一个动画完成
            if i == 0 {
                alphaAnim?.completionBlock = {[weak self] (_, _) -> () in
                    print("跳转控制器")
                    self?.completionBlock?(sender.clsName)
                }
            }
            
        }
        
    }
    
    /// 点击更多
    @objc private func clickMore() {
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        //调整底部bar
        adjustBottomBar()
    }
    
}


// MARK: - public 方法
extension WBComposeTypeView {
    
    func show(completion: @escaping (_ clsName: String?) -> ()) {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        completionBlock = completion
        vc.view.addSubview(self)
        // 动画展示view透明度
        animationShowCurrentView()
        //弹力展示btn
        animationShowButton()
    }
}


// MARK: - 动画方法
private extension WBComposeTypeView {
    
    /// 动画展示当前view
    func animationShowCurrentView() {
        //pop框架主要三个动画
        //POPDecayAnimation -- 使用在衰减动画  POPSpringAnimation--弹力动画  POPBasicAnimation-- 基本动画
        //创建基本动画
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        animation.fromValue = 0
        animation.toValue = 1
        //持续时间
        animation.duration = 0.25
        
        //添加动画
        self.pop_add(animation, forKey: nil)
        
    }
    
    
    /// 动画展示btn
    func animationShowButton() {
        //只需要展示第一个子视图中的button动画
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
            
            //创建弹力动画
            //没有duration 属性 通过弹力速度控制
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = btn.center.y + kButtonPositionY
            anim?.toValue = btn.center.y
            
            //弹力系数
            anim?.springBounciness = 8
            //弹力速度
            anim?.springSpeed = 8
            
            
            
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
        }
        
    }
    
    /// 动画dissmiss当前view
    func animationDissmissCurrentView() {
        //pop框架主要三个动画
        //POPDecayAnimation -- 使用在衰减动画  POPSpringAnimation--弹力动画  POPBasicAnimation-- 基本动画
        //创建基本动画
        let animation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        animation.fromValue = 1
        animation.toValue = 0
        //持续时间
        animation.duration = 0.8
        
        //添加动画
        self.pop_add(animation, forKey: nil)
        
        //执行完，移除self
        animation.completionBlock = {[weak self] (_, _) -> () in
            self?.removeFromSuperview()
        }
        
    }
    
    // dissmiss按钮动画
    func animationDissmissButton() {
        
        //获取当前view
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v: UIView = scrollView.subviews[page]
        
        //倒叙获取btn，最后一个btn开始动画
        for (i, btn) in v.subviews.enumerated().reversed() {
            //创建弹力动画
            //没有duration 属性 通过弹力速度控制
            let anim = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = btn.center.y
            anim?.toValue = btn.center.y + kButtonPositionY
            
            //不需要设置弹力系数，下落过程不需要看，否则耗时太长
//            //弹力系数
//            anim?.springBounciness = 8
//            //弹力速度
//            anim?.springSpeed = 13
//
            //i 是从最后一个下标开始
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            //设置的layer层动画，一定加载layer上面
            btn.layer.pop_add(anim, forKey: nil)
            
            //监听最后一个btn
            if i == 0 {
                //最后一个执行完，改变view的透明度
                anim?.completionBlock = {[weak self] (_,_) -> () in
//                    self?.animationDissmissCurrentView()
                    self?.removeFromSuperview()

                }
                animationDissmissCurrentView()

            }
           
        }
        
    }
    
}

