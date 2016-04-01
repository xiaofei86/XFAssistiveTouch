//
//  LPDebug.h
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/15.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPAssistiveTouch.h"

@class LPDebug;

@protocol LPTransformDelegate <NSObject>

- (UIViewController *)debugViewControllerByUser:(NSInteger)user
                                        atIndex:(NSInteger)index;

@end

@interface LPDebug : NSObject

@property (nonatomic, weak) id<LPTransformDelegate> transformDelegate;

+ (instancetype)sharedInstance;
+ (instancetype)run;

void LPDebugLog(NSString *format, ...);

@end
