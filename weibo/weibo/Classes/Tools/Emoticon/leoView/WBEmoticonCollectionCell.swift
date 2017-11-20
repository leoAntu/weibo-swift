//
//  WBEmoticonCollectionCell.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/15.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

@objc protocol WBEmoticonCollectionCellDelegate: NSObjectProtocol {
    
    //选中表情模型
    @objc optional func emoticonCellDidSelectedEmoticon(em: CZEmoticon?)
}

class WBEmoticonCollectionCell: UICollectionViewCell {

    weak var delegate: WBEmoticonCollectionCellDelegate?
    
    lazy var tipView = WBEmoticonTipView()
    
    var emoticons: [CZEmoticon]? {
        didSet{
            //隐藏所有的按钮
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            //显示删除按钮
            let removeBtn = contentView.subviews.last as! UIButton
            removeBtn.isHidden = false
            
            //遍历表情模型
            for (i,em) in (emoticons ?? []).enumerated() {
                if let btn = contentView.subviews[i] as? UIButton {
                    
                    btn.setImage(em.image, for: .normal)
                    //设置emoji 字符串
                    btn.setTitle(em.emoji, for: .normal)
                    btn.isHidden = false
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //当视图从界面上删除，同样会调用此方法，newwindow = nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let window = newWindow else {
            return
        }
        
        //将提示框 添加到window上，才能不被裁剪，如果在view上，超出部分会被裁剪
        window.addSubview(tipView)
        tipView.isHidden = true
        
    }
    
    //选中按钮事件
    @objc private func selectedEmodiconBtnAction(btn: UIButton) {
        //取tag 0 - 19  20对应的是删除按钮
        let tag = btn.tag
        
        //判断是否是删除按钮
        var em: CZEmoticon?
        if tag < emoticons?.count ?? 0 {
            //取出CZEmoticon
            em = emoticons?[tag]
        }
        
        //如果em为nil，就是删除按钮
        delegate?.emoticonCellDidSelectedEmoticon?(em: em)
        
    }
    
    @objc private func longPressGes(gesture: UILongPressGestureRecognizer) {
        
        //获取触摸位置
        let location = gesture.location(in: self)
        
        guard let btn = buttonWithLocation(location: location) else {
            return
        }
        
        //处理手势状态
        switch gesture.state {
        case .began, .changed:
            tipView.isHidden = false
            
            //坐标系的转换。tip的参照是window,直接转换到 window
            let center = self.convert(btn.center, to: window)
            
            tipView.center = center
        default:
            return
        }
        
        print(btn)
    }
    
    private func buttonWithLocation(location: CGPoint) -> UIButton? {
        
        //遍历contentview 的子视图，如果可见，同时在location 确认是btn
        
        for  btn in contentView.subviews {
            if btn.frame.contains(location) && !btn.isHidden  && (btn != contentView.subviews.last){
                return btn as? UIButton
            }
        }
        
        return nil
    }
}

private extension WBEmoticonCollectionCell {
    //从xib中加载，bounds就是xib中的大小， 不是size的大小
    //从纯代码创建，bounds 就是布局属性中设置的大小
   func setupUI() {
        let rowCount = 3
        let colCount = 7
    
        let leftMargin = 8 //屏幕两边间距
        let BottomMargin = 16 //距离下边间距
    
        //按钮间不留间距,算出按钮宽高
        let w = (bounds.width - CGFloat(leftMargin * 2)) / CGFloat(colCount)
        let h = (bounds.height - CGFloat(BottomMargin)) / CGFloat(rowCount)
    
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton(type: .custom)
            
            let x = CGFloat(leftMargin) + w * CGFloat(col)
            let y = CGFloat(row) * h
            
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            contentView.addSubview(btn)
            //设置字体大小，让emoji显示的更大
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            //设置tag
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmodiconBtnAction), for: .touchUpInside)
            
        }
    
        //设置最后一个按钮为删除按钮
        let removeBtn = contentView.subviews.last as! UIButton
        let img = UIImage(named: "compose_emotion_delete", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        let imgHL = UIImage(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        removeBtn.setImage(img, for: .normal)
        removeBtn.setImage(imgHL, for: .highlighted)
    
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGes))
//        longPress.minimumPressDuration = 0.1
        addGestureRecognizer(longPress)
   }
}
