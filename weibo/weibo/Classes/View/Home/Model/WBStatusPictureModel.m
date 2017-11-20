//
//  WBStatusPictureModel.m
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/7.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import "WBStatusPictureModel.h"

@implementation WBStatusPictureModel

- (void)setThumbnail_pic:(NSString *)thumbnail_pic {
    _largePic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/large/"];
    _thumbnail_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/wap360/"];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
