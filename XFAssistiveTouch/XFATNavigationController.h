//
//  XFATNavigationController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATViewController.h"

NS_ASSUME_NONNULL_BEGIN

static const NSTimeInterval duration = 0.25;

@interface XFATNavigationController : UIViewController

- (instancetype)initWithRootViewController:(XFATViewController *)viewController;

- (void)spread;
- (void)shrink;
- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position;
- (void)popViewController;

- (void)spreadBegin;
- (void)shrinkEnd;

// TODO: Remove readonly
@property (nonatomic, strong, readonly) NSMutableArray<XFATViewController *> *viewControllers;
@property (nonatomic, strong) XFATViewController *rootViewController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XFATItemView *contentItem;
@property (nonatomic, assign) CGPoint contentPoint;
@property (nonatomic, assign) CGFloat contentAlpha;
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;

@end

@interface XFATViewController (XFATNavigationControllerItem)

@property (nonatomic, assign) XFATNavigationController *navigationController;

@end

NS_ASSUME_NONNULL_END
