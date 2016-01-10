//
//  LPAssistiveTouchViewController.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATNavigationController.h"

@protocol LPATViewControllerDelegate <NSObject>

- (void)touchBegan;

- (void)shrinkToRect:(CGRect)rect;

@end

@interface LPATRootViewController : LPATNavigationController

@property (nonatomic, assign) CGRect assistiveViewRect;

@property (nonatomic, assign) id<LPATViewControllerDelegate> delegate;

@end
