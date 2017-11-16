

//
//  WBComposeViewController.swift
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/10/18.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class WBComposeViewController: WBBaseViewController {
    @IBOutlet weak var textView: WBComposeTextView!

    @IBOutlet var titleLab: UILabel!
    
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //纯字符串，传给后台使用
    var textViewString: String? {
        
        //获取属性文本
        guard let attrStr = textView.attributedText else {
            return ""
        }
        
        //定义变量接受字符串
        var resultStr = String()
        //遍历属性文本
        attrStr.enumerateAttributes(in:NSRange(location: 0, length: attrStr.length), options: [], using: { (dict, range, _) in
            
            if let attachment = dict[NSAttributedStringKey.attachment] as? CZEmoticonAttachment  {
                resultStr = resultStr + (attachment.chs ?? "")
            } else {
                resultStr = resultStr + (attrStr.string as NSString).substring(with: range)
            }
            
        })
        
        return resultStr
    }
    
    lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("发送", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)

        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        return btn
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //添加键盘监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChanged), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //收起键盘
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //激活键盘
        textView.becomeFirstResponder()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

private extension WBComposeViewController {
    func setupUI() {
        self.tableView?.removeFromSuperview()
        //设置代理
        textView.delegate = self
        
        setNavigationBar()
        setToolBarItem()
    }
    
    
    /// 创建toolbar btn
    func setToolBarItem() {
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        
        for dic in itemSettings {
            guard let imageName = dic["imageName"] else {
                continue
            }
            
            let img = UIImage(named: imageName)
            let imgHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton(type: .custom)
            btn.setImage(img, for: .normal)
            btn.setImage(imgHL, for: .highlighted)
            
            if let actionName = dic["actionName"] {
                
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            
            items.append(UIBarButtonItem(customView: btn))
            
            //增加一个弹簧，所有item均匀布局
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        //删除最后一个弹簧
        items.removeLast()

        toolBar.items = items
    }
    
    /// 创建navigationBar btn
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(rightButtomAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        sendBtn.addTarget(self, action: #selector(sendBtnAction), for: .touchUpInside)
        sendBtn.isEnabled = false
        //设置titleview
        navigationItem.titleView = titleLab
        
    }
    
    @objc func emoticonKeyboard() {
      
        if textView.inputView != nil {
            //收起键盘
            textView.resignFirstResponder()
            textView.inputView = nil
            return
        }
        
        //宽度随便设置
        let keyboardView = WBEmoticonInputView.inputView { [weak self] (em) in
            self?.insertEmoticon(em: em)
        }
        
        //设置键盘视图
        textView.inputView = keyboardView
        //刷新键盘视图
        textView.reloadInputViews()
        //调起键盘
        textView.becomeFirstResponder()
        
    }
    
    @objc func rightButtomAction() {
      
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendBtnAction() {
        textView.resignFirstResponder()

        guard let text = textView.text else {
            return
        }
        
        WBNetworkManager.shared.postStatus(text: text) { (json, isSuceess) in
            print(json)
        }
    }
    
    
    /// 键盘监听事件
    ///
    /// - Parameter n: <#n description#>
    @objc func keyBoardChanged(n: Notification) {
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        //改变toolbar底部约束
        toolBarBottomConstraint.constant = offset
        
        //添加动画
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.view.layoutIfNeeded()
        }
        print(offset)
    }
}


// MARK: - textView 代理方法
extension WBComposeViewController:  UITextViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //收起键盘
        textView.resignFirstResponder()
        textView.inputView = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}


// MARK: - 向文本视图中插入表情符号/图文混排
private extension WBComposeViewController {
    func insertEmoticon(em: CZEmoticon?) {

        guard let em = em else {
            //删除文本
            textView.deleteBackward()
            return
        }
        
        //2 emoji 字符串
        if let emoji = em.emoji, let textRange = textView.selectedTextRange {
            textView.replace(textRange, withText: emoji)
            return
        }
        
        //解决bug, 当text没有文字的时候插入图片，不会隐藏placeholder
        if textView.hasText == false {
            textView.placeholderLab.isHidden = true
        }
        
        //所有排版的文字系统中，几乎都有一个共同的特点，插入的字符的显示，跟随前一个字符的属性，但是本身没有属性 所以imageText 要设置font属性
        //3 获取图片属性文本
        let imageText = em.imageText(font: textView.font!)
        
        //获取当前属性文本
        let attrStrM = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //将图像属性文本插入到当前光标位置
        attrStrM.replaceCharacters(in: textView.selectedRange, with: imageText)
        
        //记录变化之前的光标位置
        let range = textView.selectedRange
        
        //重新设置属性文本，光标位置发生变化
        textView.attributedText = attrStrM
        
        //恢复光标位置
        textView.selectedRange = NSRange(location: range.location + 1, length: 0)
                
    }
}
