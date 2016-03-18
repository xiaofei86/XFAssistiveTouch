//
//  LPDebug.h
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/15.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPAssistiveTouch.h"

@class LPDebug;

typedef NS_ENUM(NSInteger, LPDebugUser) {
    LPDebugUserHanShuai,
    LPDebugUserRaoZhizhen,
    LPDebugUserZouZhigang,
    LPDebugUserZhaoWanda,
    LPDebugUserXuYafei,
    LPDebugUserDengJiebin,
    LPDebugUserLongXiaowen,
    LPDebugUserUnkonwn,
};

@protocol LPTransformDelegate <NSObject>

- (UIViewController *)debugViewControllerByUser:(LPDebugUser)user
                                        atIndex:(NSInteger)index;

@end

@interface LPDebug : NSObject

@property (nonatomic, weak) id<LPTransformDelegate> transformDelegate;

void LPDebugLog(NSString *format, ...);

+ (instancetype)sharedInstance;
+ (instancetype)run;

@end
