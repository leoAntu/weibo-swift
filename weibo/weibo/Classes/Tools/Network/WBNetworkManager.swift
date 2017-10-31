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

    private  var accessToken: String?

    static let shared = WBNetworkManager()
    var userLogon: Bool {
        return accessToken != nil
    }
    
    func tokenRequest(method: WBNetWorkMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion:  @escaping ( _ json: Any?,  _ isSuccess:Bool) -> ()) {
        
        guard accessToken != nil else {
            print("缺少token")
            completion(nil, false)
            return
        }
        
        var parameter = parameters
        
        if parameter == nil {
            parameter = [String: AnyObject]()
        }
        
        parameter!["access_token"] = accessToken as AnyObject
        
        request(URLString: URLString, parameters: parameter, completion: completion)
        
    }
    
    func request(method: WBNetWorkMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion:  @escaping ( _ json: Any?,  _ isSuccess:Bool) -> ()) {
        
        let success = { (dataTask: URLSessionDataTask, json: Any?) -> () in
            completion(json, true)
        }

        let failure = { (dataTask: URLSessionDataTask?, error: Error) -> () in
//            处理过期token
            if (dataTask?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                print("token 过期了")
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
