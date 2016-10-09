//
//  XFQuickAccessViewController.h
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XFQuickAccessViewController : UIViewController

@property (nonatomic, assign) NSInteger user;

@property (nonatomic, strong) NSMutableArray<NSArray *> *transformArray;

@end

NS_ASSUME_NONNULL_END
