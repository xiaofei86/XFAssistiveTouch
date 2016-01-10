//
//  LPAssistiveTouchView.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATItemView.h"

@implementation LPATItemView {
    CALayer *_noneLayer;
}

#pragma mark - Initialization

+ (instancetype)itemWithType:(LPATItemViewType)type {
    LPATItemView *item = [[LPATItemView alloc] initWithFrame:CGRectZero];
    switch (type) {
        case LPATItemViewTypeSystem:
            [item initWithSystemType];
            break;
        case LPATItemViewTypeNone:
            [item initWithNoneType];
            break;
        case LPATItemViewTypeBack:
            [item initWithBackType];
            break;
        case LPATItemViewTypeStar:
            [item initWithStarType];
            break;
        default:
            break;
    }
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    if (self) {
        [self initWithNoneType];
    }
    return self;
}

- (void)initWithSystemType {
    [_noneLayer removeFromSuperlayer];
    self.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
    [self.layer addSublayer:[self createCircle:22 alpha:0.2]];
    [self.layer addSublayer:[self createCircle:18 alpha:0.5]];
    [self.layer addSublayer:[self createCircle:14 alpha:0.8]];
}

- (void)initWithNoneType {
    _noneLayer = [self createCircle:22 alpha:1.0];
    [self.layer addSublayer:_noneLayer];
}

- (void)initWithBackType {
    [_noneLayer removeFromSuperlayer];
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(11, 4.5)];
    [path addLineToPoint:CGPointMake(11, 1.5)];
    [path addLineToPoint:CGPointMake(22, 1.5)];
    [path addLineToPoint:CGPointMake(22, -1.5)];
    [path addLineToPoint:CGPointMake(11, -1.5)];
    [path addLineToPoint:CGPointMake(11, -4.5)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.strokeColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    layer.position = self.layer.position;
    [self.layer addSublayer:layer];
}

- (void)initWithStarType {
    [_noneLayer removeFromSuperlayer];
    [self.layer addSublayer:[self createCircle:10 alpha:0.2]];
}

#pragma mark - Private

- (CAShapeLayer *)createCircle:(CGFloat)radius alpha:(CGFloat)alpha {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor colorWithWhite:1 alpha:alpha].CGColor;
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor colorWithWhite:0 alpha:0.3 * alpha].CGColor;
    return layer;
}

@end
