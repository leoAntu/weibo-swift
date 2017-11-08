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
#import "WBStatusPictureModel.h"

@interface WBStatus : NSObject

@property (nonatomic, assign) NSInteger id;
//微博信息
@property (nonatomic, copy) NSString * text;
//用户信息
@property (nonatomic, strong) WBUser * user;
//转发数
@property (nonatomic, assign) NSInteger reposts_count;
//评论数
@property (nonatomic, assign) NSInteger comments_count;
//点赞数
@property (nonatomic, assign) NSInteger attitudes_count;

@property (nonatomic, strong) NSArray<WBStatusPictureModel *> *pic_urls;

@property (nonatomic, strong) WBStatus *retweeted_status;


// YYmodel中遇到数组，数组中包含model，需要实现此方法
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
