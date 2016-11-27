//
//  XFATLayoutAttributes.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/29.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATLayoutAttributes.h"

@implementation XFATLayoutAttributes

// iPad   width 390 itemWidth 76 margin 2 corner:14  48-41-33
// iPhone width 295 itemWidth 60 margin 2 corner:14  44-38-30

+ (CGRect)contentViewSpreadFrame:(CGRect)frame {
    NSInteger count = [self maxCount];
    CGFloat width = count * [self itemImageWidth];
    CGRect bounds = CGRectZero;
    
    CGFloat leftMargin = CGRectGetMinX(frame) - width;
    CGFloat rightMargin = CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(frame) - width;
    CGRect leftBounds = CGRectMake(CGRectGetMinX(frame) - width, CGRectGetMinY(frame), CGRectGetWidth(frame) + width, CGRectGetHeight(frame));
    CGRect rightBounds = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) + width, CGRectGetHeight(frame));
    if (leftMargin >= 0) {
        bounds = leftBounds;
    } else if (rightMargin >= 0) {
        bounds = rightBounds;
    } else if (leftMargin > rightMargin) {
        bounds = leftBounds;
    } else {
        bounds = rightBounds;
    }
    return bounds;
}

+ (CGPoint)cotentViewDefaultPoint {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGPoint point = CGPointMake(CGRectGetWidth(screenFrame)
                                - [self itemImageWidth] / 2
                                - [self margin],
                                CGRectGetMidY(screenFrame));
    return point;
}

+ (CGFloat)itemWidth {
    return IS_IPAD_IDIOM? 76: 60;
}

+ (CGFloat)itemImageWidth {
    return IS_IPAD_IDIOM? 76: 60;
}

+ (CGFloat)cornerRadius {
    return [self itemImageWidth] / 2.0;
}

+ (CGFloat)margin {
    return 2;
}

+ (NSUInteger)maxCount {
    return 3;
}

+ (CGFloat)inactiveAlpha {
    return 0.4;
}

+ (CGFloat)animationDuration {
    return 0.25;
}

+ (CGFloat)activeDuration {
    return 4;
}

@end
