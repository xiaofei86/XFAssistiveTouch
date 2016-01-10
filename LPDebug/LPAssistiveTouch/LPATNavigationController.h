//
//  LPATNavigationController.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATViewController.h"

static const NSTimeInterval duration = 0.25;

@interface LPATNavigationController : UIViewController

- (instancetype)initWithRootViewController:(LPATViewController *)viewController;

- (void)spread;
- (void)shrink;
- (void)pushViewController:(LPATViewController *)viewController atPisition:(LPATPosition *)position;
- (void)popViewController;

@property (nonatomic, strong) NSMutableArray<LPATViewController *> *viewControllers;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) LPATItemView *contentItem;
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;
@property (nonatomic, assign) CGPoint shrinkPoint;

@end
