

//
//  WBNetworkManager+Extension.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import Foundation

extension WBNetworkManager {

    func statusList(since_id:Int64 = 0 , max_id:Int64 = 0, completion: @escaping (_ list:[[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["since_id":"\(since_id)",
            "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        tokenRequest(URLString: url, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            let obj = json as AnyObject
            let statuses = obj["statuses"] as? [[String: AnyObject]]
            completion(statuses, isSuccess)
        }
        
    }
    
    //检查未读微博数量
    func unreadCount(complete:@escaping (_ count: Int) -> ()) {
        let urlString = "https://api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": ""]
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            print(json as Any)
            
            let dic = json as? [String: AnyObject]
            let count = dic?["status"] as? Int
            complete(count ?? 0)
        }
    }
    
}


// MARK: - OAuth 相关请求
extension WBNetworkManager {
    
    func requestAccessToken(code: String, complete: @escaping (_ isSuccess: Bool)->()) {
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBRedirectUri]
        
        weak var weakSelf = self
        request(method: .POST, URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            weakSelf?.userAccount.yy_modelSet(with: json as! [AnyHashable : Any])
            print(weakSelf?.userAccount ?? nil)
            //缓存到沙盒
            
            //登录成功，获取用户信息，
            weakSelf?.requestUserInfo(complete: { (dict) in
                weakSelf?.userAccount.yy_modelSet(with: dict as [AnyHashable : Any])
                print(weakSelf?.userAccount ?? nil)
                weakSelf?.userAccount.save()
                complete(isSuccess)
            })
            
        }
    }
}

//获取用户名和头像
extension WBNetworkManager {
    func requestUserInfo(complete: @escaping (_ dic: [String: AnyObject])->()) {
        let urlStr = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": self.userAccount.uid]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            complete((json as? [String: AnyObject]) ?? [:])
        }
    }
}

// MARK: - 发布微博
extension WBNetworkManager {
    
    /// 发布微博
    ///
    /// - parameter text:       要发布的文本
    /// - parameter image:      要上传的图像，为 nil 时，发布纯文本微博
    /// - parameter completion: 完成回调
    func postStatus(text: String, image: UIImage? = nil, completion: @escaping (_ result: [String: AnyObject]?, _ isSuccess: Bool)->()) -> () {
        
        // 1. url
        let urlString: String
        
        // 根据是否有图像，选择不同的接口地址
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        } else {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        // 2. 参数字典
        let params = ["status": text]
        
        // 3. 如果图像不为空，需要设置 name 和 data
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        // 4. 发起网络请求
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String : AnyObject], name: name, data: data) { (json, isSuccess) in
            completion(json as? [String: AnyObject], isSuccess)
        }
    }
}

