//
//  XFATLayoutAttributes.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/29.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XFATLayoutAttributes : NSObject

+ (CGRect)contentViewSpreadFrame;
+ (CGPoint)cotentViewDefaultPoint;
+ (CGFloat)itemWidth;
+ (CGFloat)itemImageWidth;
+ (CGFloat)cornerRadius;
+ (CGFloat)margin;
+ (NSUInteger)maxCount;

@end

NS_ASSUME_NONNULL_END
