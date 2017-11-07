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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        pictureView.heightConstant.constant = 100
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
