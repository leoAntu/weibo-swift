
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
    
    @IBOutlet weak var pageControl: UIPageControl!
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
        
        bottomToolBar.delegate = self
        
        //设置分页图片
        let bundle = CZEmoticonManager.shared.bundle
        
        guard let normol = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selected = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) else {
                return
        }
        //使用填充图片设置颜色，效果不好
        pageControl.pageIndicatorTintColor = UIColor(patternImage: normol)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selected)
        
        //使用kvc设置私有成员属性 ,通过运行时查看UIPageControl的成员变量
        pageControl.setValue(normol, forKey: "_pageImage")
        pageControl.setValue(selected, forKey: "_currentPageImage")
        
    }
}

extension WBEmoticonInputView: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 将collectionView在控制器view的中心点转化成collectionView上的坐标
//        //方法1
        var point = scrollView.center
        point.x = point.x + scrollView.contentOffset.x
        //方法2
//        let point = self.convert(collectionView.center, to: collectionView)
        // 获取这一点的indexPath
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        //设置toolBar btn 的选中状态
        bottomToolBar.currentSection = indexPath.section
        
        //更新pageControl
        // 总页数，不同的分组，页数不一样
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: indexPath.section)
        pageControl.currentPage = indexPath.item
        
    }

}

extension WBEmoticonInputView: WBEmoticonCollectionCellDelegate {
    func emoticonCellDidSelectedEmoticon(em: CZEmoticon?) {
        // em 为空就是删除键
        selectedEmoticonCallBack?(em)
        
        guard let em = em else {
            return
        }
        
        //如果collectionview 就是显示在当前section，就不添加，直接退出
       let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        //添加最近表情
        CZEmoticonManager.shared.recentEmoticon(em: em)
    
        
        //刷新数据
        var set = IndexSet()
        set.insert(0)
        collectionView.reloadSections(set)
    }
}

extension WBEmoticonInputView: WBEmoticonTooBarDelegate {
    func emoticonToolBarSelectedIndex(btn: UIButton, index: Int) {
        print(btn,index)
        
        let path = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: path, at: .right, animated: true)
    }
}
