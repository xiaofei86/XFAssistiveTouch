//
//  LPATRootNavigationController.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATNavigationController.h"

@protocol LPATRootNavigationControllerDelegate <NSObject>

- (void)touchBegan;

- (void)shrinkToPoint:(CGPoint)point;

@end

@interface LPATRootNavigationController : LPATNavigationController

@property (nonatomic, assign) id<LPATRootNavigationControllerDelegate> delegate;

@end
