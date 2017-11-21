

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

    var pictureSize = CGSize()
    
    var picUrls: [WBStatusPictureModel]?
    
    var retweetedLabStr: String?
    
    var rowHeight: CGFloat?
    
    var sourceStr: String?
    
    var sourceLinkStr: String?
    //正文富文本
    var statusAttrText: NSAttributedString?
    //转发文字
    var retweetedAttrText: NSAttributedString?
    
    
    var createdDate: Date?

    var isRetweeted:Bool? {
        return (status?.retweeted_ != nil) ? true : false
    }
    
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
        
        //设置 创建时间
        createdDate = Date.cz_sinaDate(string: status.created_at)
        //设置按钮标题
        // == 0 显示默认标题，超过10000，显示1万，小于10000,显示实际数值
        retweetedBtnTitle = countString(count: status.reposts_count, defaultStr: "转发")
        commentBtnTitle = countString(count: status.comments_count, defaultStr: "评论")
        likeBtnTitle = countString(count: status.attitudes_count, defaultStr: "点赞")
        
      //获取 pic 包括转发或者自己发的， 被转发微博的text
        if status.retweeted_ != nil {
            picUrls = status.retweeted_.pic_urls
            retweetedLabStr =  "@\(status.retweeted_.user.screen_name!): " + status.retweeted_.text
        } else {
            picUrls = status.pic_urls
            retweetedLabStr = ""
        }
        
        //设置pic size
        pictureSize = calcPictureSize(count: picUrls?.count ?? 0)
        
        //获取微博来源
        let result = status.source.cz_href()
        sourceLinkStr = result?.link
        sourceStr = result?.text
        
        //属性文本
        retweetedAttrText = CZEmoticonManager.shared.emoticonString(string: retweetedLabStr ?? "", font: UIFont.systemFont(ofSize: 13))
        statusAttrText = CZEmoticonManager.shared.emoticonString(string: status.text, font: UIFont.systemFont(ofSize: 13))
        
        //计算缓存行高
        calcRowHeight()
    }
    
    var description: String {
        return status?.description ?? ""
    }
}


// MARK: - 公开方法
extension WBStatusViewModel {
    
    
    /// 更新单张视图的size
    ///
    /// - Parameter image: 
    func updateSingleImageSize(image: UIImage?) {
        
        if image == nil {
            return
        }
        
        var size = image!.size
        
        //真对单张图片过大情况处理
        let maxWidth: CGFloat = 200
        if size.width > maxWidth {
            size.width = maxWidth
            size.height  =  image!.size.height / image!.size.width * size.width
        }
        
        //真对单张图片过小处理
        let minWidth: CGFloat = 30
        if size.width < minWidth {
            size.width = minWidth
            
            //高度要特殊处理，用户体验不好，高度缩小4倍
            size.height  =  image!.size.height / image!.size.width * size.width / 4
        }
        
        if size.height > 200 {
            size.height = 200
        }
        
        size.height = size.height + CGFloat(WBPictureViewOutMargin)
        
        //更新缓存行高计算,先减去picView高度
        rowHeight = rowHeight!  - pictureSize.height
        
        pictureSize = size
        
        //重新更新pic高度
        rowHeight = rowHeight! + pictureSize.height
    }
}

// MARK: - 私有方法
extension WBStatusViewModel {
    private func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return "\(count)"
        }
        return String(format: "%.2f万", Double(count) / 10000)
    }
 
    private func calcPictureSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize()
        }
        
        //计算行数
        let row = (count! - 1) / 3 + 1
        
        let height = WBPictureViewOutMargin + WBPictureViewItemWidth * Float(row) + Float(row - 1) * WBPictureViewItemMargin
        
        return CGSize(width: CGFloat(WBPictureViewWidth), height: CGFloat(height))
    }
    
    private func calcRowHeight() {
        //字体都是13
        //正常微博高度计算
        //顶部隔离视图（8）+ 间距（11）+ 头像高度（34） + 间距（12）+ 正文（计算）+ picview(计算) +
        // 间距（12）+ 底部视图（28）
        
        
        //转发微博高度计算
        //顶部隔离视图（8）+ 间距（11）+ 头像高度（34） + 间距（12）+ 正文（计算）+ 间距（11）+ 转发正文（计算）+ picview(计算) + 间距（12）+ 底部视图（28）
        
        let topMargin: CGFloat = 8
        let marginA: CGFloat = 11
        let marginB: CGFloat = 12
        let iconHeight: CGFloat = 34
        let bottomHeight: CGFloat = 28
        
        //先计算正文以上顶部间距
        var height: CGFloat = topMargin + marginA  + iconHeight + marginB
        
//        let font = UIFont.systemFont(ofSize: 13)
        
        let size: CGSize = CGSize(width: CGFloat(UIScreen.wb_screenWidth()) - CGFloat(2 * marginA), height: 1000)
        
        //计算正文高度
        if let text = statusAttrText {
            height = height + text.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).height

        }
        
        //计算转发微博高度
        if status?.retweeted_ != nil {
            height = height + marginA
            
            if let text = retweetedAttrText {
                height = height + text.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).height

            }
        }
        
        //加上picView及后面数值
        height = height + pictureSize.height + marginB + bottomHeight
        
        //使用属性记录
        rowHeight = height + 3
    }
}
