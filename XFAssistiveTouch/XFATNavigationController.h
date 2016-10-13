//
//  XFATNavigationController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XFATNavigationController;

@protocol XFATNavigationControllerDelegate <NSObject>

- (void)navigationController:(XFATNavigationController *)navigationController actionBeginAtPoint:(CGPoint)point;
- (void)navigationController:(XFATNavigationController *)navigationController actionEndAtPoint:(CGPoint)point;

@end

@interface XFATNavigationController : UIViewController

- (instancetype)initWithRootViewController:(nullable XFATViewController *)viewController NS_DESIGNATED_INITIALIZER;

- (void)spread;
- (void)shrink;
- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position;
- (void)popViewController;

- (void)moveContentViewToPoint:(CGPoint)point;

@property (nonatomic, strong) NSMutableArray<XFATViewController *> *viewControllers;
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;
@property (nonatomic, assign) id<XFATNavigationControllerDelegate> delegate;

@end

@interface XFATViewController (XFATNavigationControllerItem)

@property (nonatomic, assign) XFATNavigationController *navigationController;

@end

NS_ASSUME_NONNULL_END
