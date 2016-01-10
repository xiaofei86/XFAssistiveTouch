//
//  LPATPosition.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat itemWidth = 100;
static const NSUInteger itemSideCount = 3;
static const CGFloat imageViewWidth = 60;
static const CGFloat imageWidth = 44;
static const CGFloat cornerRadius = 14;

@interface LPATPosition : NSObject

+ (instancetype)positionWithCount:(NSUInteger)count index:(NSUInteger)index;
+ (CGRect)contentViewFrame;

@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect frame;

@end
