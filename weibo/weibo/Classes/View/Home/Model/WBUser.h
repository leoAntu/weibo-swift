//
//  WBUser.h
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface WBUser : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString * screen_name;
@property (nonatomic, copy) NSString * profile_image_url;
@property (nonatomic, assign) NSInteger verified_type;
@property (nonatomic, assign) NSInteger mbrank; //会员等级

@end
