//
//  XFATRootViewController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATViewController.h"

@class XFATRootViewController;

@protocol XFATRootViewControllerDelegate <NSObject>

- (NSInteger)numberOfItemsInController:(XFATRootViewController *)atViewController;

- (XFATItemView *)controller:(XFATRootViewController *)controller itemViewAtPosition:(XFATPosition *)position;

- (void)controller:(XFATRootViewController *)controller didSelectedAtPosition:(XFATPosition *)position;

@end


@interface XFATRootViewController : XFATViewController

@property (nonatomic, weak) id<XFATRootViewControllerDelegate> delegate;

@end
