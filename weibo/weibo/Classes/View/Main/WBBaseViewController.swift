//
//  WBBaseViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit


class WBBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    var tableView: UITableView?
    
    /// 刷新控件
    var refreshControl: WBRefreshControl?
    
    /// 上拉刷新标记
    var isPullup = false
    
    //访客信息
    var visitorInfo: [String: String]?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        WBNetworkManager.shared.userLogon ? loadData() : ()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue:WBUserLoginSuccessedNotification), object: nil)
    }
    
    @objc private func loginSuccess() {
        view = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:WBUserLoginSuccessedNotification), object: nil)
    }
    
    @objc func loadData() {
        
        //子类不重写方法，默认关闭
        refreshControl?.endRefreshing()
    }
    
     @objc private func loginAction() {
        print("登录")
        //发送登录通知，要mianViewController执行登录
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    @objc private func registerAction() {
        print("注册")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController != nil) && self.navigationController?.viewControllers.count == 1{
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            weak var weakSelf = self
            navigationController?.interactivePopGestureRecognizer?.delegate = weakSelf
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    func createTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.tableFooterView = UIView()
        view.insertSubview(tableView!, belowSubview: (self.navigationController?.navigationBar)!)
        //设置滚动条的位置，和tableView对齐
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        tableView?.delegate = self
        tableView?.dataSource = self
        
        refreshControl = WBRefreshControl()
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
   
}

extension WBBaseViewController {
   
   private func setUI() {
        automaticallyAdjustsScrollViewInsets = false
        WBNetworkManager.shared.userLogon ? createTableView() : setVisitorView()
    }
    
    
    private func setVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        view.addSubview(visitorView)
        visitorView.visitorInfo = visitorInfo
        visitorView.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        setNoLoginNavBarItems()
    }
    
    private func setNoLoginNavBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", target: self, action: #selector(loginAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: #selector(registerAction))
    }
}

extension WBBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //获取当前row
        let row = indexPath.row
        
        //获取最后的section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        // 获取最后section 中最后的row
        let count = tableView.numberOfRows(inSection: section)
        //如果是最后一个cell 就下拉刷新
        if row == (count - 1) && !isPullup  {
            print("上拉刷新")
            isPullup = true
            loadData()
        }
        
    }
}


