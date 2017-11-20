
//
//  WBHomeViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

//原创微博
private let cellId = "cellId"
//转发cell
private let retweetedId = "retweetedId"


class WBHomeViewController: WBBaseViewController {

    private lazy var dataList = [String]()
    private lazy var viewModel = WBStatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(photoBrowserNotification), name: NSNotification.Name(rawValue: WBStatusCellBrowserPhotoNotification), object: nil)
    }
    
    @objc private func photoBrowserNotification(notifi: Notification) {
        
        guard let userInfo = notifi.userInfo,
            let selectedIndex = userInfo[WBStatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = userInfo[WBStatusCellBrowserPhotoUrlsKey] as? [String],
            let imageViews = userInfo[WBStatusCellBrowserPhotoImageViewsKey] as? [UIImageView]
        else {
            return
        }
        
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViews)
        present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        tableView?.register(UINib(nibName: "WBStatuRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedId)

//        //预估行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 300;
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
        let model: WBStatusViewModel = viewModel.dataList[indexPath.row]

        let identifier = (model.isRetweeted == true) ? retweetedId : cellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! WBStatuCell
        cell.delegate = self
        cell.displayWithModel(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model: WBStatusViewModel = viewModel.dataList[indexPath.row]

        return model.rowHeight  ?? 0.1
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

extension WBHomeViewController: WBStatuCellDelegate {
    func statuCellClickUrlString(cell: WBStatuCell, text: String) {
        print(cell, text)
        let vc = WBWebViewController()
//        vc.urlString = "http://www.baidu.com"
        vc.urlString = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func statuCellClickNameString(cell: WBStatuCell, text: String) {
        print(cell, text)
    }
}
