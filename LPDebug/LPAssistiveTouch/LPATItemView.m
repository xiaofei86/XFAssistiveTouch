//
//  LPAssistiveTouchView.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATItemView.h"

@implementation LPATItemView

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
        case LPATItemViewTypeNSLog:
            [item initWithNSLogType];
            break;
        case LPATItemViewTypeAPNS:
            [item initWithAPNSType];
            break;
        case LPATItemViewTypeTransform:
            [item initWithTransformType];
            break;
        default:
            break;
    }
    return item;
}

+ (instancetype)itemWithLayer:(CALayer *)layer {
    LPATItemView *item = [[LPATItemView alloc] initWithFrame:CGRectZero];
    item.layer.contents = layer.contents;
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    if (self) {
        [self initWithNoneType];
    }
    return self;
}

#pragma mark - NativeType

- (void)initWithNoneType {
    CGFloat itemScale = itemWidth / imageViewWidth;
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.contentsRect = CGRectMake((1 - itemScale) / 2, (1 - itemScale) / 2, itemScale, itemScale);
}

- (void)initWithSystemType {
    self.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
    [self.layer addSublayer:[self createCircle:22 alpha:0.2]];
    [self.layer addSublayer:[self createCircle:18 alpha:0.5]];
    [self.layer addSublayer:[self createCircle:14 alpha:0.8]];
}

- (void)initWithBackType {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(11, 8.5)];
    [path addLineToPoint:CGPointMake(11, 3.5)];
    [path addLineToPoint:CGPointMake(22, 3.5)];
    [path addLineToPoint:CGPointMake(22, -3.5)];
    [path addLineToPoint:CGPointMake(11, -3.5)];
    [path addLineToPoint:CGPointMake(11, -8.5)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.position = CGPointMake(self.layer.position.x - 11, self.layer.position.y);
    [self.layer addSublayer:layer];
}

- (void)initWithStarType {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGSize size = CGSizeMake(44, 44);
    CGFloat numberOfPoints = 5;
    CGFloat starRatio = 0.5;
    CGFloat steps = numberOfPoints * 2;
    CGFloat outerRadius = MIN(size.height, size.width) / 2;
    CGFloat innerRadius = outerRadius * starRatio;
    CGFloat stepAngle = 2 * M_PI / steps;
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < steps; i++) {
        CGFloat radius = i % 2 == 0 ? outerRadius : innerRadius;
        CGFloat angle = i * stepAngle - M_PI_2;
        CGFloat x = radius * cos(angle) + center.x;
        CGFloat y = radius * sin(angle) + center.y;
        if (i == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        } else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.position = CGPointMake(self.layer.position.x - 22, self.layer.position.y - 22);
    [self.layer addSublayer:layer];
}

- (void)initWithNSLogType {
    self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"NSLog"].CGImage);
}

- (void)initWithAPNSType {
    self.layer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"APNS"].CGImage;
}

- (void)initWithTransformType {
    self.layer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"Transform"].CGImage;
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
