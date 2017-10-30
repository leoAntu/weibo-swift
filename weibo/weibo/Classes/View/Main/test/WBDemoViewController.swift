//
//  WBDemoViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/19.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "第\(((navigationController?.childViewControllers.count)! - 1) ) 个"
        // Do any additional setup after loading the view.
        setupUI()
    }

    @objc private func rightItemAction() {
        let vc = WBDemoViewController();
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func createTableView() {
        super.createTableView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(rightItemAction))
        
    }
    
}

extension WBDemoViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.red;
    }
    
   
}
