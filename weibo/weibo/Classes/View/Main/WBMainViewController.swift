//
//  WBMainViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import Foundation

class WBMainViewController: UITabBarController {

    private var timer: Timer?
    private  var composeButton: UIButton? = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupChildController()
        setupComposeButton()
        setupTimer()
        
        //设置代理
        delegate = self
        
        //注册登录通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    /// 主界面只支持竖屏
    // portrait  竖屏
    //landscape  横屏
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc private func composeStatus() {
        print("撰写微博")
    }
    
    @objc private func userLogin() {
        print("执行登录")
    }

}

extension WBMainViewController: UITabBarControllerDelegate {

    
    /// 将要选择tabBaItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = (childViewControllers as NSArray).index(of: viewController)
        
        if selectedIndex == 0 && index == selectedIndex {
            print("两次点击刷新首页")
            
            //获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
//            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            let  av = IndexPath(row: 0, section: 0)

            vc.tableView?.scrollToRow(at: av, at: .top, animated: true)
            
            //延迟加载数据，要不然不执行刷新操作
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
        }
        
        //判断控制器是否是UIviewcontroller,如果是就不跳转
        return !viewController.isMember(of: UIViewController.self)
    }
}

//定时器相关代码
extension WBMainViewController {
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateUnreadAPI), userInfo: nil, repeats: true)
    }
    
    @objc private func updateUnreadAPI() {
        
        guard WBNetworkManager.shared.userLogon != false else {
            print("必须要登录才能定时刷新")
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            print("有\(count)未读信息")
            self.tabBar.items![0].badgeValue = count > 0 ? "\(count)" : nil
            
            //未读信息在桌面app中显示未读信息，这个需要用户授权才能显示。
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - 设置界面
extension WBMainViewController {

    /// 设置所有子控制器
    private func setupChildController() {
        
        var arrM:[ UIViewController] = [UIViewController]()
     
        let homeVC = WBHomeViewController();
        homeVC.visitorInfo = ["imageName":"","message":"关注一些人，回这里看看有什么惊喜"]
        arrM.append(controller(vc: homeVC, title: "首页", imageName: "home"))

        let messageVC = WBMessageViewController();
        messageVC.visitorInfo = ["imageName":"visitordiscover_image_message","message":"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"]
        arrM.append(controller(vc: messageVC, title: "消息", imageName: "message_center"))

        let emptyVC = UIViewController();
        arrM.append(controller(vc: emptyVC, title: "", imageName: ""))
        
        let discoverVC = WBDiscoverViewController();
        discoverVC.visitorInfo = ["imageName":"visitordiscover_image_message","message":"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"]
        arrM.append(controller(vc: discoverVC, title: "发现", imageName: "discover"))
        
        let profileVC = WBProfileViewController();
        profileVC.visitorInfo = ["imageName":"visitordiscover_image_profile","message":"登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]
        arrM.append(controller(vc: profileVC, title: "我", imageName: "profile"))

        viewControllers = arrM;
    }
    
    private func controller(vc: UIViewController, title: String, imageName: String) -> UIViewController {
    
        vc.title = title;

        let img = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.image = img

        let imgSelected = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal);
        vc.tabBarItem.selectedImage = imgSelected;

        let nv = WBNavgationController(rootViewController: vc);
        // 4. 设置 tabbar 的标题字体（大小）
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.foregroundColor: UIColor.orange],
            for: .highlighted)
        // 系统默认是 12 号字，修改字体大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)],
            for: UIControlState(rawValue: 0))
        return nv
    }
    
    private func setupComposeButton() {

        let img = UIImage(named: "tabbar_compose_icon_add")
        composeButton?.setImage(img, for: UIControlState(rawValue: 0))

        let highlightedImg = UIImage(named: "tabbar_compose_icon_add_highlighted")
        composeButton?.setImage(highlightedImg, for: .highlighted)

        let backImg = UIImage(named: "tabbar_compose_button")
        composeButton?.setBackgroundImage(backImg, for: UIControlState(rawValue: 0))

        composeButton?.sizeToFit()

        tabBar.addSubview(composeButton!)
        
        let w = tabBar.bounds.width / 5 - 1
        composeButton?.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        composeButton?.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
}
