//
//  WBWebViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/14.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {

    private lazy var webView = UIWebView()
    var urlString: String? {
        didSet {
            guard  let urlStr = urlString,
                   let url = URL(string: urlStr) else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
   
}

private extension WBWebViewController {
    func setupUI() {
        self.tableView = nil
        webView.frame = CGRect(x: 0, y: 64, width: CGFloat(UIScreen.wb_screenWidth()), height: CGFloat(UIScreen.wb_screenHeight() - 64))
        view.addSubview(webView)
    
        webView.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}
