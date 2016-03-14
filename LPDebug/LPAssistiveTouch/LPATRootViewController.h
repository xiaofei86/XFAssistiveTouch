//
//  LPATRootViewController.h
//  LPDebugDemo
//
//  Created by XuYafei on 16/1/10.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATViewController.h"

@class LPATRootViewController;

@protocol LPATRootViewControllerDelegate <NSObject>

- (NSInteger)numberOfItemsInController:(LPATRootViewController *)atViewController;

- (LPATItemView *)controller:(LPATRootViewController *)controller itemViewAtPosition:(LPATPosition *)position;

- (void)controller:(LPATRootViewController *)controller didSelectedAtPosition:(LPATPosition *)position;

@end

@interface LPATRootViewController : LPATViewController

@property (nonatomic, weak) id<LPATRootViewControllerDelegate> delegate;

@end
