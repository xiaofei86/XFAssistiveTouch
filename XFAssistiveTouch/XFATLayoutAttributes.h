//
//  XFATLayoutAttributes.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/29.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IS_IPAD_IDIOM (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_IDIOM (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

@interface XFATLayoutAttributes : NSObject

+ (CGRect)contentViewSpreadFrame;
+ (CGPoint)cotentViewDefaultPoint;
+ (CGFloat)itemWidth;
+ (CGFloat)itemImageWidth;
+ (CGFloat)cornerRadius;
+ (CGFloat)margin;
+ (NSUInteger)maxCount;

+ (CGFloat)inactiveAlpha;
+ (CGFloat)animationDuration;
+ (CGFloat)activeDuration;

@end

NS_ASSUME_NONNULL_END
