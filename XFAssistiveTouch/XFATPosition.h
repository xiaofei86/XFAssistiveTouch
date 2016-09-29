//
//  XFATPosition.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATLayoutAttributes.h"

@interface XFATPosition : NSObject

+ (instancetype)positionWithCount:(NSInteger)count index:(NSInteger)index;

@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect frame;

@end
