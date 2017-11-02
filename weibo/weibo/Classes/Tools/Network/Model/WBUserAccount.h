//
//  WBUserAccount.h
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/1.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface WBUserAccount : NSObject

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *avatar_large;


- (void)saveAccount;
- (void)readFile;
@end
