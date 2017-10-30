
//
//  WBHomeViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

private let cellId = "cellId"


class WBHomeViewController: WBBaseViewController {

    private lazy var dataList = [String]()
    private lazy var viewModel = WBStatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc override func loadData() {
        
        weak var weakSelf = self
        viewModel.loadStatus(pullup: self.isPullup) { (isSuccess) in
            weakSelf?.refreshControl?.endRefreshing()
            weakSelf?.isPullup = false
            weakSelf?.tableView?.reloadData()
        }
    }
    
    @objc private func rightButtomAction() {
        let vc = WBDemoViewController();
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //重写父类方法
    override func createTableView() {
        super.createTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(rightButtomAction))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        automaticallyAdjustsScrollViewInsets = false
        
    }
}

extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let model: WBStatus = viewModel.dataList[indexPath.row]
        cell?.textLabel?.text = "\(model.text ?? "")"
        return cell!
    }
}

extension WBHomeViewController {
    
}
