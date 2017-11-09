
//
//  WBRefreshControl.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/8.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

// 刷新状态的临界值
private let WBRefreshOffset: CGFloat = 60


/// 刷新状态
///
/// - Normol: 普通
/// - Pulling: 超过临界点，放手开始刷新
/// - willRefresh: 超过临界点，并且放手
enum WBRefreshState {
    case Normol
    case Pulling
    case willRefresh
}

class WBRefreshControl: UIControl {

    /// 需要弱引用，防止循环引用，当WBRefreshControl添加到父视图，已经强引用WBRefreshControl
    private weak var scrollView: UIScrollView?
    
    lazy var refreshView = WBRefreshView.refreshView()
    
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
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    
    //本视图从父视图上移除
    /// 移除kvo
    override func removeFromSuperview() {
        //superView还存在 scrollView是weak，已经不存在了。
        
        //必须房子啊super 前面，在后面superview已经为空
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    /// kvo监听回调
    ///
    /// - Parameters:
    ///   - keyPath:
    ///   - object:
    ///   - change:
    ///   - context:
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        //刷新控件的初始化高度为 0
        var height: CGFloat = 0
        
        //contentoffset的Y值  和contentInset相关 adjustedContentInset 相关
        if #available(iOS 11.0, *) {
            height = -(sv.contentInset.top + sv.contentOffset.y + sv.adjustedContentInset.top)
        } else {
            // Fallback on earlier versions
            height = -(sv.contentInset.top + sv.contentOffset.y)
        }
        
        if height < 0 {
            return
        }
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)

        if sv.isDragging {
            
            if refreshView.refreshState == .willRefresh {
                return
            }
            
            if height > WBRefreshOffset {
                refreshView.refreshState = .Pulling
            } else {
                refreshView.refreshState = .Normol
            }
        } else {
            
            if refreshView.refreshState == .Pulling {
                beginRefreshing()
                
                //发送刷新数据事件
                sendActions(for: .valueChanged)
            }
        }
        
    }
}

extension WBRefreshControl {
    /// 开始刷新
    func beginRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .willRefresh {
            return
        }
        
        refreshView.refreshState = .willRefresh
        //让整个刷新视图更够显示出来,设置contentInset
        var inset = sv.contentInset
        inset.top = inset.top + WBRefreshOffset
        
        UIView.animate(withDuration: 0.3) {
            sv.contentInset = inset
        }
        
        //发送刷新数据事件, 不能放在这里执行，如果用户执行 beginRefreshing， 会发送两次事件
//        sendActions(for: .valueChanged)
    }
    
    /// 结束刷新
    func endRefreshing() {
        
        if refreshView.refreshState != .willRefresh {
            return
        }
        
        guard let sv = scrollView else {
            return
        }
        
        //恢复刷新状态
        refreshView.refreshState = .Normol
        //恢复contentInset
        var inset = sv.contentInset
        inset.top = inset.top - WBRefreshOffset
        sv.contentInset = inset
        
    }
    
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        //添加刷新视图
        addSubview(refreshView)
        
        //清除自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        
        //目前xib还是有高度的
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: 0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .height,
                                         multiplier: 0,
                                         constant: refreshView.bounds.height))
        
    }
    

}
