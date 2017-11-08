
//
//  WBStatus.m
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/6.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import "WBStatus.h"

@implementation WBStatus

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pic_urls" : [WBStatusPictureModel class]
             
             };
}

- (NSString *)description {
    return self.yy_modelDescription;
}
@end
