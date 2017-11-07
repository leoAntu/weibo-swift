

//
//  WBStatusViewModel.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import Foundation

/// 如果想要打印调式信息，必须遵守CustomStringConvertible 协议，
/// 在实现协议方法description
class WBStatusViewModel : CustomStringConvertible{

    var status: WBStatus?
    
    var memberIcon: UIImage?
    
    var vipIcon: UIImage?  // -1 没认证 0 认证用户 2，3，5企业认证 220达人

    var retweetedBtnTitle: String?
    
    var commentBtnTitle: String?

    var likeBtnTitle: String?

    
    init(status: WBStatus) {
        self.status = status
        
        //会员等级 0 - 6
        if status.user.mbrank > 0 && status.user.mbrank < 7 {
            let imgName = "common_icon_membership_level\(status.user.mbrank)"
            memberIcon = UIImage(named: imgName)
        }
        
        switch status.user.verified_type {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            vipIcon = nil
        }
        
        //设置按钮标题
        
        // == 0 显示默认标题，超过10000，显示1万，小于10000,显示实际数值
    
        retweetedBtnTitle = countString(count: status.reposts_count, defaultStr: "转发")
        commentBtnTitle = countString(count: status.comments_count, defaultStr: "评论")
        likeBtnTitle = countString(count: status.attitudes_count, defaultStr: "点赞")
    }
    
    private func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return "\(count)"
        }
    
        return String(format: "%.2f万", count / 10000)
    }
    
    var description: String {
        return status?.description ?? ""
    }
    
}
