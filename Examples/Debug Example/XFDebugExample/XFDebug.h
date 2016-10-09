//
//  XFDebug.h
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFAssistiveTouch.h"

NS_ASSUME_NONNULL_BEGIN

@class XFDebug;

@protocol XFTransformDelegate <NSObject>

- (UIViewController *)debugViewControllerByUser:(NSInteger)user
                                        atIndex:(NSInteger)index;

@end

@interface XFDebug : NSObject

@property (nonatomic, weak) id<XFTransformDelegate> transformDelegate;

+ (instancetype)sharedInstance;
+ (instancetype)run;

void XFDebugLog(NSString *format, ...);

@end

NS_ASSUME_NONNULL_END
