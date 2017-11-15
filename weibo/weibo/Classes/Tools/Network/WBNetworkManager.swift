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
    
    func tokenRequest(method: WBNetWorkMethod = .GET, URLString: String, parameters: [String: AnyObject]?, name: String? = nil, data: Data? = nil, completion:  @escaping ( _ json: Any?,  _ isSuccess:Bool) -> ()) {
        
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
        
        if let name = name, let data = data {
            upload(URLString: URLString, parameters: parameter, name: name, data: data, completion: completion)
        } else {
            request(method: method, URLString: URLString, parameters: parameter, completion: completion)

        }
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
    
    // MARK: - 封装 AFN 方法
    /// 上传文件必须是 POST 方法，GET 只能获取数据
    /// 封装 AFN 的上传文件方法
    ///
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       接收上传数据的服务器字段(name - 要咨询公司的后台) `pic`
    /// - parameter data:       要上传的二进制数据
    /// - parameter completion: 完成回调
    func upload(URLString: String, parameters: [String: AnyObject]?, name: String, data: Data, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            
            // 创建 formData
            /**
             1. data: 要上传的二进制数据
             2. name: 服务器接收数据的字段名
             3. fileName: 保存在服务器的文件名，大多数服务器，现在可以乱写
             很多服务器，上传图片完成后，会生成缩略图，中图，大图...
             4. mimeType: 告诉服务器上传文件的类型，如果不想告诉，可以使用 application/octet-stream
             image/png image/jpg image/gif
             */
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, json) in
            
            completion(json as AnyObject, true)
        }) { (task, error) in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                
                // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                    object: "bad token")
            }
            
            print("网络请求错误 \(error)")
            
            completion(nil, false)
        }
    }
}

