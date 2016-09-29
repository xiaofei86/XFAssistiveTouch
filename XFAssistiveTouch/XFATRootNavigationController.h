//
//  XFATRootNavigationController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATNavigationController.h"
#import "XFATRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XFATRootNavigationControllerDelegate <NSObject>

- (void)touchBegan;
- (void)shrinkToPoint:(CGPoint)point;

@end

@interface XFATRootNavigationController : XFATNavigationController

@property (nonatomic, assign) id<XFATRootNavigationControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
