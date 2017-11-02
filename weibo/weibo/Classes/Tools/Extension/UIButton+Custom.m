//
//  UIButton+Custom.m
//  BigFan
//
//  Created by MaxWellPro on 16/6/6.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

- (void)imageWithPosition:(BFButtonImagePosition)position space:(CGFloat)space {
    switch (position) {
        case BFButtonImagePositionTop: {
            [self resetEdgeInsets];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            CGRect contentRect = [self contentRectForBounds:self.bounds];
            CGSize titleSize = [self titleRectForContentRect:contentRect].size;
            CGSize imageSize = [self imageRectForContentRect:contentRect].size;
            
            float halfWidth = (titleSize.width + imageSize.width)/2;
            float halfHeight = (titleSize.height + imageSize.height)/2;
            
            float topInset = MIN(halfHeight, titleSize.height);
            float leftInset = (titleSize.width - imageSize.width)>0?(titleSize.width - imageSize.width)/2:0;
            float bottomInset = (titleSize.height - imageSize.height)>0?(titleSize.height - imageSize.height)/2:0;
            float rightInset = MIN(halfWidth, titleSize.width);
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-titleSize.height-space, - halfWidth, imageSize.height+space, halfWidth)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)];
        }
            break;
        case BFButtonImagePositionBottom: {
            [self resetEdgeInsets];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            CGRect contentRect = [self contentRectForBounds:self.bounds];
            CGSize titleSize = [self titleRectForContentRect:contentRect].size;
            CGSize imageSize = [self imageRectForContentRect:contentRect].size;
            
            float halfWidth = (titleSize.width + imageSize.width)/2;
            float halfHeight = (titleSize.height + imageSize.height)/2;
            
            float topInset = MIN(halfHeight, titleSize.height);
            float leftInset = (titleSize.width - imageSize.width)>0?(titleSize.width - imageSize.width)/2:0;
            float bottomInset = (titleSize.height - imageSize.height)>0?(titleSize.height - imageSize.height)/2:0;
            float rightInset = MIN(halfWidth, titleSize.width);
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height+space, - halfWidth, -titleSize.height-space, halfWidth)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)];
        }
            break;
        case BFButtonImagePositionLeft: {
            [self resetEdgeInsets];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
        }
            break;
        case BFButtonImagePositionRight: {
            [self resetEdgeInsets];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            CGRect contentRect = [self contentRectForBounds:self.bounds];
            CGSize titleSize = [self titleRectForContentRect:contentRect].size;
            CGSize imageSize = [self imageRectForContentRect:contentRect].size;
            
//            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width + space, 0, -titleSize.width - space)];
        }
            break;
        default:
            break;
    }
}

/**
 *  重置内边距
 */
- (void)resetEdgeInsets {
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
}


@end
