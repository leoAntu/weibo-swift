

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
