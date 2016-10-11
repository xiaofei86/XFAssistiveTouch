//
//  XFATNavigationController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATViewController.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, XFATStatus) {
//    XFATStatusTouchBegin,
//    XFATStatusTouchMove,
//    XFATStatusStickBegin,
//    XFATStatusStickEnd,
//    XFATStatusSpreadBegin,
//    XFATStatusSpreadEnd,
//    XFATStatusShrinkBegin,
//    XFATStatusShrinkEnd,
//};

@protocol XFATRootNavigationControllerDelegate <NSObject>

- (void)touchBegan;
- (void)shrinkToPoint:(CGPoint)point;

@end

@interface XFATNavigationController : UIViewController

- (instancetype)initWithRootViewController:(nullable XFATViewController *)viewController NS_DESIGNATED_INITIALIZER;

- (void)spread;
- (void)shrink;
- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position;
- (void)popViewController;

//- (void)spreadBegin;
//- (void)shrinkEnd;

- (void)moveContentViewToPoint:(CGPoint)point;

@property (nonatomic, strong) NSMutableArray<XFATViewController *> *viewControllers;
@property (nonatomic, strong) XFATViewController *rootViewController;
@property (nonatomic, assign, readonly, getter=isShow) BOOL show;
@property (nonatomic, assign) id<XFATRootNavigationControllerDelegate> delegate;

@end

@interface XFATViewController (XFATNavigationControllerItem)

@property (nonatomic, assign) XFATNavigationController *navigationController;

@end

NS_ASSUME_NONNULL_END
