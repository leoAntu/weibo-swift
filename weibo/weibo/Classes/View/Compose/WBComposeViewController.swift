

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
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}
