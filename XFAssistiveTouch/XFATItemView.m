//
//  XFATItemView.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATItemView.h"

@implementation XFATItemView

typedef NS_ENUM(NSInteger, XFATInnerCircle) {
    XFATInnerCircleSmall,
    XFATInnerCircleMiddle,
    XFATInnerCircleLarge
};

+ (instancetype)itemWithType:(XFATItemViewType)type {
    XFATItemView *item = [[XFATItemView alloc] initWithFrame:CGRectZero];
    switch (type) {
        case XFATItemViewTypeSystem:
            [item initWithSystemType];
            break;
        case XFATItemViewTypeNone:
            [item initWithNoneType];
            break;
        case XFATItemViewTypeBack:
            [item initWithBackType];
            break;
        case XFATItemViewTypeStar:
            [item initWithStarType];
            break;
        default:
            break;
    }
    return item;
}

+ (instancetype)itemWithLayer:(CALayer *)layer {
    XFATItemView *item = [[XFATItemView alloc] initWithFrame:CGRectZero];
    item.layer.contents = layer.contents;
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, [XFATLayoutAttributes itemWidth], [XFATLayoutAttributes itemWidth])];
    if (self) {
        [self initWithNoneType];
    }
    return self;
}

#pragma mark - NativeType

- (void)initWithNoneType {
    CGFloat itemScale = [XFATLayoutAttributes itemWidth] / [XFATLayoutAttributes itemImageWidth];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.contentsRect = CGRectMake((1 - itemScale) / 2, (1 - itemScale) / 2, itemScale, itemScale);
}

- (void)initWithSystemType {
    self.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    [self.layer addSublayer:[self createInnerCircle:XFATInnerCircleLarge]];
    [self.layer addSublayer:[self createInnerCircle:XFATInnerCircleMiddle]];
    [self.layer addSublayer:[self createInnerCircle:XFATInnerCircleSmall]];
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

#pragma mark - Private

- (CAShapeLayer *)createInnerCircle:(XFATInnerCircle)circleType {
    CGFloat circleAlpha = 0;
    CGFloat radius = 0;
    CGFloat borderAlpha = 0;
    switch (circleType) {
        case XFATInnerCircleSmall: {
            circleAlpha = 1;
            radius = 14.5;
            borderAlpha = 0.3;
            break;
        } case XFATInnerCircleMiddle: {
            circleAlpha = 0.4;
            radius = 18.5;
            borderAlpha = 0.15;
            break;
        } case XFATInnerCircleLarge: {
            circleAlpha = 0.2;
            radius = 22;
            borderAlpha = 0;
            break;
        } default: {
            break;
        }
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.fillColor = [UIColor colorWithWhite:1 alpha:circleAlpha].CGColor;
    layer.strokeColor = [UIColor colorWithWhite:0 alpha:borderAlpha].CGColor;
    return layer;
}

@end
