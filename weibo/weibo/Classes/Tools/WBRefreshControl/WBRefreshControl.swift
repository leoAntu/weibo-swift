
//
//  WBRefreshControl.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/8.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBRefreshControl: UIControl {

    private weak var scrollView: UIScrollView?
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
  
    
    /// 即将添加到父视图
    ///
    // - 当添加到父视图的时候，newSuperview 是父视图
    // -- 当父视图被移除的时候， newSuperview 是nil
    /// - Parameter newSuperview: newSuperview
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
}

extension WBRefreshControl {
    
    private func setupUI() {
        
    }
    
    
    
    /// 开始刷新
    func beginRefreshing() {
        
    }
    
    /// 结束刷新
    func endRefreshing() {
        
    }

}
