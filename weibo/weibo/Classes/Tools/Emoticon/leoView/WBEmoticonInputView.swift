
//
//  WBEmoticonInputView.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/15.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class WBEmoticonInputView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomToolBar: WBEmoticonTooBar!
    
    //选中表情回调闭包
    private var selectedEmoticonCallBack: ((_ em: CZEmoticon?) -> ())?
    
    class func inputView(selectedEmoticon: @escaping (_ em: CZEmoticon?) -> ()) -> WBEmoticonInputView {
        let nb = UINib(nibName: "WBEmoticonInputView", bundle: nil)
        let v = nb.instantiate(withOwner: nil, options: nil)[0] as! WBEmoticonInputView
        //记录闭包
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {
        //注册cell
    
        collectionView.register(WBEmoticonCollectionCell.self, forCellWithReuseIdentifier: cellId)
        
    }
}

extension WBEmoticonInputView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WBEmoticonCollectionCell
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.row)
        cell.delegate = self
        return cell
    }
    
}

extension WBEmoticonInputView: WBEmoticonCollectionCellDelegate {
    func emoticonCellDidSelectedEmoticon(em: CZEmoticon?) {
        // em 为空就是删除键
        selectedEmoticonCallBack?(em)
    }
}
