//
//  ViewController.swift
//  FMDBDemo
//
//  Created by 叮咚钱包富银 on 2017/11/16.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(WBSQLiteManager.shared)
        
        let arr: [[String: AnyObject]] = [["idstr": "107" as AnyObject, "text": "微博-01说服力结束了东方丽景拉开距离框架" as AnyObject],
                                          ["idstr": "108" as AnyObject, "text": "微博-02" as AnyObject],
                                          ["idstr": "109" as AnyObject, "text": "微博-03" as AnyObject],
                                          ["idstr": "110" as AnyObject, "text": "微博-04" as AnyObject],
                                          ["idstr": "111" as AnyObject, "text": "微博-05" as AnyObject],
                                          ["idstr": "112" as AnyObject, "text": "微博-01说服力结束了东方丽景拉开距离框架" as AnyObject],
                                          ["idstr": "113" as AnyObject, "text": "微博-02" as AnyObject],
                                          ["idstr": "114" as AnyObject, "text": "微博-03" as AnyObject],
                                          ["idstr": "115" as AnyObject, "text": "微博-04" as AnyObject],
                                          ["idstr": "116" as AnyObject, "text": "微博-05" as AnyObject],
                                          ["idstr": "117" as AnyObject, "text": "微博-01说服力结束了东方丽景拉开距离框架" as AnyObject],
                                          ["idstr": "118" as AnyObject, "text": "微博-02" as AnyObject],
                                          ["idstr": "119" as AnyObject, "text": "微博-03" as AnyObject],
                                          ["idstr": "120" as AnyObject, "text": "微博-04" as AnyObject],
                                          ["idstr": "121" as AnyObject, "text": "微博-05" as AnyObject],
                                         ["idstr": "122" as AnyObject, "text": "微博-04" as AnyObject],
                                         ["idstr": "123" as AnyObject, "text": "微博-05" as AnyObject]

                                      ]
        
        WBSQLiteManager.shared.updateStatus(userId: "1", array: arr)
       let a = WBSQLiteManager.shared.loadStatus(userId: "1", since_id: 0, max_id: 0)
        
        print(a)
        print("````````````````````````````````````")
        guard let max_id = (a.last?["idstr"] as? String) else {
            return
        }
        let b = WBSQLiteManager.shared.loadStatus(userId: "1", since_id: 0, max_id: Int64(Int(max_id) ?? 0))
        print(b)
        print("````````````````````````````````````")

        let c = WBSQLiteManager.shared.loadStatus(userId: "1", since_id: 123, max_id: 0)
        print(c)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

