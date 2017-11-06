
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
        //注册cell
        tableView?.register(UINib(nibName: "WBStatuCell", bundle: nil), forCellReuseIdentifier: cellId)
        //预估行高
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300;
        //取消分割线
        tableView?.separatorStyle = .none
        automaticallyAdjustsScrollViewInsets = false
        setupTitileBtn()
    }
}

extension WBHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! WBStatuCell
        let model: WBStatusViewModel = viewModel.dataList[indexPath.row]
        cell.displayWithModel(model: model)
        return cell
    }
}


// MARK: - 设置UI
extension WBHomeViewController {
    private func setupTitileBtn() {
        let btn: UIButton = UIButton.cz_textButton(WBNetworkManager.shared.userAccount.screen_name, fontSize: 17, normalColor: UIColor.darkGray, highlightedColor: UIColor.black)
        
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn.image(with: .right, space: 15)
        navigationItem.titleView = btn
    }
    
    @objc private func btnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}
