//
//  XFATPosition.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATLayoutAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface XFATPosition : NSObject

+ (instancetype)positionWithCount:(NSInteger)count index:(NSInteger)index;
- (instancetype)initWithCount:(NSInteger)count index:(NSInteger)index NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect frame;

@end

NS_ASSUME_NONNULL_END
