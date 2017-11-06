//
//  WBStatus.h
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "WBUser.h"
@interface WBStatus : NSObject


//var id:Int64 = 0
//
//var text: String?
//
//var user:WBUser?
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, strong) WBUser * user;

@end
