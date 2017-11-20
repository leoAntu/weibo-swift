
//
//  WBSQLiteManager.swift
//  FMDBDemo
//
//  Created by 叮咚钱包富银 on 2017/11/16.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

import Foundation
import FMDB


class WBSQLiteManager: NSObject {

    static let shared = WBSQLiteManager()
    
    var fmdbQueue:FMDatabaseQueue?
    
    //构造函数
    private override init() {
      super.init()
        //数据库名
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        print(path)
        
        fmdbQueue = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    
}


// MARK: - 微博数据操作
extension WBSQLiteManager {
    
    
    /// 从数据库中加载数据，分页数据
    ///
    /// - Parameters:
    ///   - userId: 当前用户id
    ///   - since_id:
    ///   - max_id:
    /// - Returns: 数组
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: AnyObject]] {
        
        //准备sql 翻页，及升序排列，每次限制20条
        var sql = "SELECT statusId, userId, status FROM t_status \n"
        sql = sql + "WHERE userId = \(userId) \n"
        
        //上啦/下拉。都是针对同一个id 进行判断
        
        //下拉刷新,since_id 比d当前id大
        if since_id > 0 {
            sql = sql + "AND statusId > \(since_id) \n"
        } else if (max_id > 0) { //上拉加载
            sql = sql + "AND statusId < \(max_id) \n"
        }
        
        //DESC 降序，ASC升序
        sql = sql + "ORDER BY statusId DESC LIMIT 20;"
        
        ///执行sql
        let arr = execRecordSet(sql: sql)
        
        var result = [[String: AnyObject]]()
        
        //遍历数组，将 status的值进行反序列化
        for dict in arr {
            guard let jsonData = dict["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject]  else {
                continue
            }
            result.append(json ?? [:])
        }
        
        return result
    }
    
    /// 新增或者修改数据
    ///
    /// - Parameters:
    ///   - userId: userId
    ///   - array: 用网络上获取的数组
    func updateStatus(userId: String, array: [[String: AnyObject]]) {
        //statusId, 要保存的微博代号
        //userId, 当前登录用户的id
        //status 完成微博字典的json 二进制数据
        let sql = "INSERT OR REPLACE INTO t_status(statusId,userId,status) VALUES (?, ?, ?);"
        
        //插入更新，需要更新数据库，所以需要开启事务功能，减少性能开销，使用inTransaction ，而不是inDatabase
        fmdbQueue?.inTransaction({ (db, rollBack) in
            
            //遍历数组
            for dic in array {
                
                
               // 将字典序列化二进制数据
                
                guard let statusId = dic["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: []) else {
                        continue
                }
                if db.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    print("更新语句执行失败")
                    //FIXME: 需要回滚
                    //swift 3.0 以上，指针写法, 回滚一定要加break，否则会影响性能
                    rollBack.pointee = true
                    break
                }
           
            }
        })
    }
}

private extension WBSQLiteManager {
    
    /// 执行查询sql
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典的数组
    func execRecordSet(sql: String) -> [[String: AnyObject]] {
        
        var result = [[String: AnyObject]]()
        
        fmdbQueue?.inDatabase({ (db) in
            
            guard let rs = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            //遍历返回结果集合
            while rs.next() {
                //所有的列
                let colCount = rs.columnCount
                //遍历所有列
                for col in 0..<colCount {
                    //列名,字段
                    //值
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col) else {
                            continue
                    }
                    
                    result.append([name: value as AnyObject])
                }
            }
        })
        return result
    }
    
    
    /// 创建表
    func createTable() {
        
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
                let sql = try? String(contentsOfFile: path) else {
            return
        }
        
        //执行sql  FMDB是同步执行的
        //可以保证同一时刻，只有一个任务操作数据，从而保证数据库的读写安全
        fmdbQueue?.inDatabase { (db) in
            
            if db.executeStatements(sql) == true {
                print("创建成功")
            } else {
                print("创建失败")
            }
        }
    }
}
