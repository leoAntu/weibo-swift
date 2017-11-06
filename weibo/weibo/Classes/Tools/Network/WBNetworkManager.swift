//
//  WBNetworkManager.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import AFNetworking

enum WBNetWorkMethod {
    case GET
    case POST
}


let access_token = "2.00RAPh5Goi6xEDa8735df4dcHtLvjB"

class WBNetworkManager: AFHTTPSessionManager {
    
    lazy var userAccount:WBUserAccount = WBUserAccount()
    
    static let shared:WBNetworkManager = { ()->WBNetworkManager in
        
        let instance = WBNetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    func tokenRequest(method: WBNetWorkMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion:  @escaping ( _ json: Any?,  _ isSuccess:Bool) -> ()) {
        
        guard userAccount.access_token != nil else {
            print("缺少token")
            completion(nil, false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)

            return
        }
        
        var parameter = parameters
        
        if parameter == nil {
            parameter = [String: AnyObject]()
        }
        
        parameter!["access_token"] = userAccount.access_token as AnyObject
        
        request(URLString: URLString, parameters: parameter, completion: completion)
        
    }
    
    func request(method: WBNetWorkMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion:  @escaping ( _ json: Any?,  _ isSuccess:Bool) -> ()) {
        
        let success = { (dataTask: URLSessionDataTask, json: Any?) -> () in
            print(json as? AnyObject ?? nil)
            completion(json, true)
        }

        let failure = { (dataTask: URLSessionDataTask?, error: Error) -> () in
//            处理过期token
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                print("token 过期了")
                //发送登录通知，要mianViewController执行登录
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            }
            
            print(error)
            completion(nil, false)
        }
        
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
        
    }
}
