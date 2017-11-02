

//
//  WBOAuthViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/1.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    lazy private var webView: UIWebView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
       
    }

    @objc private func closeWeb() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        
        let js = "document.getElementById('userId').value = '18681569329';" + "document.getElementById('passwd').value = 'liweiwei0414'"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print(self)
    }

}

extension WBOAuthViewController {
    func setupUI() {
        title = "登录"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(closeWeb))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))

        view = webView
        view.backgroundColor = UIColor.white
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectUri)"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
}

extension WBOAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
//       如果包含 WBRedirectUri 链接 ，再查找链接中是否含有code
        
        if (request.url?.absoluteString.hasPrefix("\(WBRedirectUri)"))! == true {
            
            if request.url?.query?.hasPrefix("code=") == true {
                let code =  request.url?.query?.substring(from: "code=".endIndex) ?? ""
                
                weak var weakSelf = self
                WBNetworkManager.shared.requestAccessToken(code: code, complete: { (isSuccess) in
                    
                    if isSuccess == false {
                        SVProgressHUD.showError(withStatus: "登录失败")
                    } else {
                        SVProgressHUD.showInfo(withStatus: "登录成功")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                
                        weakSelf?.closeWeb()
                    }
                })
                
                return false
            }
            
        
            closeWeb()
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

