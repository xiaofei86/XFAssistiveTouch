//
//  LPAssistiveTouch.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATRootNavigationController.h"

@interface LPAssistiveTouch : NSObject 

+ (instancetype)shareInstance;

- (void)showAssistiveTouch;

@property (nonatomic, strong) UIWindow *assistiveWindow;

@property (nonatomic, strong) LPATRootNavigationController *rootNavigationController;

@end
