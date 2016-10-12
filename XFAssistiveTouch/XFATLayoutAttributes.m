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

+ (CGRect)contentViewSpreadFrame {
    CGFloat spreadWidth = IS_IPAD_IDIOM? 390: 295;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake((CGRectGetWidth(screenFrame) - spreadWidth) / 2,
                              (CGRectGetHeight(screenFrame) - spreadWidth) / 2,
                              spreadWidth, spreadWidth);
    return frame;
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
    return CGRectGetWidth([self contentViewSpreadFrame]) / 3.0;
}

+ (CGFloat)itemImageWidth {
    return IS_IPAD_IDIOM? 76: 60;
}

+ (CGFloat)cornerRadius {
    return 14;
}

+ (CGFloat)margin {
    return 2;
}

+ (NSUInteger)maxCount {
    return 8;
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
