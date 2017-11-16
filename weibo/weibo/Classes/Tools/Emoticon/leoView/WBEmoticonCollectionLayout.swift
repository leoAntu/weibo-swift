

//
//  WBEmoticonCollectionLayout.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/15.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBEmoticonCollectionLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        //设置cell大小
        
        itemSize = collectionView.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //设定滚动方向 水平方向布局
        scrollDirection = .horizontal
    }
    
}
