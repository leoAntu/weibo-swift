

//
//  WBStatusListViewModel.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBStatusListViewModel: NSObject {

    lazy var dataList = [WBStatusViewModel]()
    
    func loadStatus(pullup: Bool, completion:@escaping (_ isSuccess: Bool) ->()) {
        
        let since_id = pullup ? 0 : (dataList.first?.status?.id ?? 0)
        let max_id = pullup ? (dataList.last?.status?.id ?? 0) : 0
        
        weak var weakSelf = self
        WBNetworkManager.shared.statusList(since_id: Int64(since_id), max_id: Int64(max_id)) { (list, isSuccess) in
            
            guard list != nil else {
                completion(isSuccess)
                return
            }
            
            if !isSuccess {
                completion(isSuccess)
                return
            }
            
            var arr = [WBStatusViewModel]()
            
            for dict in list ?? []{
                guard let model = WBStatus.yy_model(withJSON: dict) else {
                    continue
                }
                
                let status = WBStatusViewModel(status: model)
            
                arr.append(status)
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
