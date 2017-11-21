//
//  WBStatuCell.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

@objc protocol WBStatuCellDelegate: NSObjectProtocol {
    @objc optional  func statuCellClickNameString(cell: WBStatuCell, text: String)
    @objc optional  func statuCellClickUrlString(cell: WBStatuCell, text: String)

}

class WBStatuCell: UITableViewCell {

    weak var delegate: WBStatuCellDelegate?
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
    @IBOutlet weak var contentLab: FFLabel!
    //转发文本内容
    @IBOutlet weak var retweetedLab: FFLabel?

    @IBOutlet weak var retweetedBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    @IBOutlet weak var jumpBtnAction: UIButton!
    
    @IBAction func jumpBtnAction(_ sender: Any) {
        print("被转发微博跳转")
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()

        //离屏渲染  -- 异步绘制  能够使cell浏览流畅，但是增加cpu的功耗 如果cell性能已经很好，就不需要离屏渲染，会耗电比较厉害
        self.layer.drawsAsynchronously = true
        
        //栅格化 -- 异步绘制后，生成一张独立图片，cell在屏幕上滚动的时候，本质是图片在滚动
        // cell 优化。要尽量减少图层的数量。相当于就只有一层，性能会比较好
        self.layer.shouldRasterize = true
        //使用栅格化，必须注意指定分辨率，要不然会感觉字体模糊
        self.layer.rasterizationScale = UIScreen.main.scale
        
        //设置文本代理
        contentLab.delegate = self
        retweetedLab?.delegate = self
        
    }

    func displayWithModel(model: WBStatusViewModel?) {
        
        //设置日期时间
        timeLab.text = model?.createdDate?.cz_dateDescription
        //会员图标
        memberIconView.image = model?.memberIcon
        vipIconView.image = model?.vipIcon
        
        aveterIconView.cz_setImage(urlString: model!.status!.user.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
       
        nameLab.text = model?.status?.user.screen_name
        resourceLab.text = model?.sourceStr
      
        //设置正文文本属性
        contentLab.font = UIFont.systemFont(ofSize: 13)
        contentLab.attributedText = model?.statusAttrText

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
            retweetedLab?.font = UIFont.systemFont(ofSize: 13)
            retweetedLab?.attributedText = model?.retweetedAttrText
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


// MARK: - FFLabel 代理
extension WBStatuCell: FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        if text.hasPrefix("@") {
            delegate?.statuCellClickNameString?(cell: self, text: text)
        }
        if text.hasPrefix("http") {
            delegate?.statuCellClickUrlString?(cell: self, text: text)
        }
    }
}
