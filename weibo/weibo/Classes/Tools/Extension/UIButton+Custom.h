//
//  UIButton+Custom.h
//  BigFan
//
//  Created by MaxWellPro on 16/6/6.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图片在文字的位置
 */
typedef NS_ENUM(NSInteger,BFButtonImagePosition) {
    /**
     *  图片在上
     */
    BFButtonImagePositionTop = 0,
    /**
     *  图片在左
     */
    BFButtonImagePositionLeft = 1,
    /**
     *  图片在下
     */
    BFButtonImagePositionBottom = 2,
    /**
     *  图片在右
     */
    BFButtonImagePositionRight = 3,
};

@interface UIButton (Custom)

- (void)imageWithPosition:(BFButtonImagePosition)position space:(CGFloat)space;

@end
