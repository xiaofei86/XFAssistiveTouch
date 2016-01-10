//
//  LPATPosition.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATPosition.h"

@implementation LPATPosition {
    CGRect _contentViewFrame;
}

+ (instancetype)positionWithCount:(NSUInteger)count index:(NSUInteger)index {
    return [[LPATPosition alloc] initWithCount:count index:index];
}

+ (CGRect)contentViewFrame {
    return [[LPATPosition alloc] init]->_contentViewFrame;
}

- (instancetype)init {
    return [self initWithCount:0 index:0];
}

- (instancetype)initWithCount:(NSUInteger)count index:(NSUInteger)index {
    self = [super init];
    if (self) {
        _count = count;
        _index = index;
        _center = [self getCenter];
        _frame = [self getFrame];
        
        CGFloat width = itemWidth * itemSideCount;
        CGRect rect = [UIScreen mainScreen].bounds;
        _contentViewFrame = CGRectMake((CGRectGetWidth(rect) - width) / 2,
                                       (CGRectGetHeight(rect) - width) / 2,
                                       width, width);
    }
    return self;
}

- (CGPoint)getCenter {
    CGFloat angle = 5 * M_PI_2 - M_PI * 2 / _count * _index;
    CGFloat k = tan(angle);
    CGFloat x;
    CGFloat y;
    if (M_PI_4 * 9 < angle || angle <= M_PI_4 * 3) {
        y = itemWidth;
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 7 < angle && angle <= M_PI_4 * 9) {
        x = itemWidth;
        y = k * x;
    } else if (M_PI_4 * 5 < angle && angle <= M_PI_4 * 7) {
        y = -itemWidth;
        if (angle == M_PI_2 * 5 || angle == M_PI_2 * 3) {
            x = 0;
        } else {
            x = y / k;
        }
    } else if (M_PI_4 * 3 < angle && angle <= M_PI_4 * 5) {
        x = -itemWidth;
        y = k * x;
    }
    CGPoint center = [self coordinatesTransform:CGPointMake(x, y)];
    return center;
}

- (CGRect)getFrame {
    CGPoint center = self.center;
    CGRect frame = CGRectMake(center.x - itemWidth / 2,
                              center.y - itemWidth / 2,
                              itemWidth,
                              itemWidth);
    return frame;
}

- (CGPoint)coordinatesTransform:(CGPoint)point {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGPoint screenCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    point.y = -point.y;
    CGPoint transformPoint = CGPointMake(screenCenter.x + point.x,
                                         screenCenter.y + point.y);
    return transformPoint;
}

@end
