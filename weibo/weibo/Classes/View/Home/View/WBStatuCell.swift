//
//  WBStatuCell.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBStatuCell: UITableViewCell {

    //头像
    @IBOutlet weak var aveterIconView: UIImageView!
    //名称
    @IBOutlet weak var nameLab: UILabel!
    //会员标志
    @IBOutlet weak var memberIconView: UIImageView!
    //时间
    @IBOutlet weak var timeLab: UILabel!
    //来源
    @IBOutlet weak var resourceLab: UILabel!
    //vip认证
    @IBOutlet weak var vipIconView: UIImageView!
    //内容
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var retweetedBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    @IBOutlet weak var jumpBtnAction: UIButton!
    
    @IBAction func jumpBtnAction(_ sender: Any) {
        print("被转发微博跳转")
    }
    
    @IBOutlet weak var retweetedLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        //离屏渲染  -- 异步绘制  能够使cell浏览流畅，但是增加cpu的功耗 如果cell性能已经很好，就不需要离屏渲染，会耗电比较厉害
        self.layer.drawsAsynchronously = true
        
        //栅格化 -- 异步绘制后，生成一张独立图片，cell在屏幕上滚动的时候，本质是图片在滚动
        // cell 优化。要尽量减少图层的数量。相当于就只有一层，性能会比较好
        self.layer.shouldRasterize = true
        //使用栅格化，必须注意指定分辨率，要不然会感觉字体模糊
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }

    func displayWithModel(model: WBStatusViewModel?) {
        
        //会员图标
        memberIconView.image = model?.memberIcon
        vipIconView.image = model?.vipIcon
        
        aveterIconView.cz_setImage(urlString: model!.status!.user.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
       
        nameLab.text = model?.status?.user.screen_name
        contentLab.text = model?.status?.text
        
      
        
// MARK: - 设置按钮标题
        retweetedBtn .setTitle(model?.retweetedBtnTitle, for: .normal)
        commentBtn .setTitle(model?.commentBtnTitle, for: .normal)
        likeBtn .setTitle(model?.likeBtnTitle, for: .normal)
        
// MARK: - 设置图片view
        pictureView.urls = model?.picUrls
        pictureView.viewModel = model

        // 设置默认picView的背景颜色
        pictureView.backgroundColor = backgroundColor

// MARK: - 设置被转发微博信息
        if model?.isRetweeted ?? false {
            retweetedLab.text = model?.retweetedLabStr
            pictureView.backgroundColor = jumpBtnAction.backgroundColor
        }
        
    }
}


// MARK: - Action
extension WBStatuCell {

    @IBAction func retweetedBtnAction(_ sender: UIButton) {
        print(sender)
    }
    
    @IBAction func commentBtnAction(_ sender: UIButton) {
        print(sender)
        
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        print(sender)
        
    }
}
