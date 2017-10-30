

//
//  WBStatusListViewModel.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import YYModel

class WBStatusListViewModel: NSObject {

    lazy var dataList = [WBStatus]()
    
    func loadStatus(pullup: Bool, completion:@escaping (_ isSuccess: Bool) ->()) {
        
        let since_id = pullup ? 0 : (dataList.first?.id ?? 0)
        let max_id = pullup ? (dataList.last?.id ?? 0) : 0
        
        weak var weakSelf = self
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            guard list != nil else {
                completion(isSuccess)
                return
            }
            print(list?.count ?? 0)
            var arr = [WBStatus]()
            for dic in list! {
                let model = WBStatus()
                model.id = dic["id"] as! Int64
                model.text = dic["text"] as? String
                arr.append(model)
            }
            
            if pullup {
                weakSelf?.dataList =  (weakSelf?.dataList)! + arr 
            } else {
                weakSelf?.dataList = arr + (weakSelf?.dataList)!
            }
            
            completion(isSuccess)
        }
      
    }
}
