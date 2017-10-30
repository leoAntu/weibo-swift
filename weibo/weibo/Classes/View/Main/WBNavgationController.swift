
//
//  WBNavgationController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBNavgationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setPopGes()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        var title = "返回";
        if childViewControllers.count == 1 {
            title = childViewControllers.first?.title ?? "返回"
        }
        
        if let vc = viewController as? WBBaseViewController {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent), isBack: true)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popToParent() {
        popViewController(animated: true)
    }
}


extension WBNavgationController {
    
    func setPopGes() {
        guard let systemGes = interactivePopGestureRecognizer else { return }
        guard let gesView = systemGes.view else { return }
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        guard let target = targetObjc.value(forKey: "target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        let panGes = UIPanGestureRecognizer()
        panGes.addTarget(target, action: action)
        gesView.addGestureRecognizer(panGes)
    }
    
    func setupUI() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]

    }
}
