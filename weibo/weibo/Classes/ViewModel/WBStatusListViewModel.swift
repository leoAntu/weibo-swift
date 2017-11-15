

//
//  WBStatusListViewModel.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/27.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit
import SDWebImage

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
            
            for dict in list ?? [] {
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
            
            //先缓存，在回掉
            weakSelf?.cacheSingleImg(arr: arr, finished: completion)

        }
    }
    
    
    /// 缓存weibo单张图片方法
    ///
    /// - Parameter arr:
    private func cacheSingleImg(arr: [WBStatusViewModel], finished: @escaping (_ isSuccess: Bool) ->()) {
    
        //创建调度组
        let group = DispatchGroup()
        
        //记录图片大小，防止下载图片过大，导致内存紧张
        var length: Int = 0
        //遍历数组
        for model in arr {
            //如果图片数量
            if model.picUrls?.count != 1 {
                continue
            }
            
            //获取url
            guard let urlStr = model.picUrls?[0].thumbnail_pic,
                let url =  URL(string: urlStr) else {
                continue
            }
            //进组
            group.enter()
            
            //下载单张图片
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: { (image, data, _, _, _, _) in
                //累加图片长度
                length = length + (data?.count ?? 0)
                //更新单张图片的size
                model.updateSingleImageSize(image: image)
                
                print(" que \(Thread.isMainThread)")
                
                //出组
                group.leave()
            })
        
        }
        
        //所有图片下载完就接受notify
        group.notify(queue: DispatchQueue.main) {
            print("长度\(length / 1024)k")
            //最后完成回掉
            finished(true)
        }
        
    }
}
