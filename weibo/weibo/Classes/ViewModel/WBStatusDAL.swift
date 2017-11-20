

//
//  WBStatusDAL.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/17.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import Foundation


/// DAL --- Data Access Layer 数据访问层
/// 使命，负责处理数据和网络数据，给ListViewModel 返回微博的 list
class WBStatusDAL {
    
    class func loadStatus(since_id:Int64 = 0 , max_id:Int64 = 0, completion: @escaping (_ list:[[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        //检查本地数据库，如果有，直接返回数据
        let arr = WBSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        if arr.count > 0 {
            completion(arr, true)
            return
        }
        
        
        //加载网络数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            //判断是否成功
            if !isSuccess {
                completion(nil, false)
            }
            
            //加载完之后，将网络数据写入数据库
            WBSQLiteManager.shared.updateStatus(userId: userId, array: list ?? [])
            
            //返回网络数据
            completion(list, isSuccess)
            
        }
        
    }
    
}
