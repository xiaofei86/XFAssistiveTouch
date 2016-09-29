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
    CALayer *layer = nil;
    switch (type) {
        case XFATItemViewTypeSystem:
            layer = [self createLayerSystemType];
            break;
        case XFATItemViewTypeNone:
            layer = [self createLayerWithNoneType];
            break;
        case XFATItemViewTypeBack:
            layer = [self createLayerBackType];
            break;
        case XFATItemViewTypeStar:
            layer = [self createLayerStarType];
            break;
        default:
            break;
    }
    XFATItemView *item = [[self alloc] initWithLayer:layer];
    if (type == XFATItemViewTypeSystem) {
        item.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
        item.layer.zPosition = CGFLOAT_MAX;
    }
    return item;
}

+ (instancetype)itemWithLayer:(CALayer *)layer {
    return [[self alloc] initWithLayer:layer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithLayer:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithLayer:nil];
}

- (instancetype)initWithLayer:(nullable CALayer *)layer {
    self = [super initWithFrame:CGRectMake(0, 0, [XFATLayoutAttributes itemWidth], [XFATLayoutAttributes itemWidth])];
    if (self) {
        if (layer) {
            layer.contentsScale = [UIScreen mainScreen].scale;
            if (CGRectEqualToRect(layer.bounds, CGRectZero)) {
                layer.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
            }
            if (CGPointEqualToPoint(layer.position, CGPointZero)) {
                layer.position = CGPointMake([XFATLayoutAttributes itemWidth] / 2,
                                             [XFATLayoutAttributes itemWidth] / 2);
            }
            [self.layer addSublayer:layer];
        }
    }
    return self;
}

#pragma mark - CreateLayer

+ (CALayer *)createLayerWithNoneType {
    return [CALayer layer];
}

+ (CALayer *)createLayerSystemType {
    CALayer *layer = [CALayer layer];
    [layer addSublayer:[[self class] createInnerCircle:XFATInnerCircleLarge]];
    [layer addSublayer:[[self class] createInnerCircle:XFATInnerCircleMiddle]];
    [layer addSublayer:[[self class] createInnerCircle:XFATInnerCircleSmall]];
    layer.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    layer.position = CGPointMake([XFATLayoutAttributes itemImageWidth] / 2, [XFATLayoutAttributes itemImageWidth] / 2);
    return layer;
}

+ (CALayer *)createLayerBackType {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGSize size = CGSizeMake(22, 22);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, 8.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, 3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width, 3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width, -3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, -3.5 + size.height / 2)];
    [path addLineToPoint:CGPointMake(size.width / 2, -8.5 + size.height / 2)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.bounds = CGRectMake(0, 0, size.width, size.height);
    layer.position = CGPointMake([XFATLayoutAttributes itemWidth] / 2,
                                 [XFATLayoutAttributes itemWidth] / 2);
    return layer;
}

+ (CALayer *)createLayerStarType {
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
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.bounds = CGRectMake(0, 0, size.width, size.height);
    layer.position = CGPointMake([XFATLayoutAttributes itemWidth] / 2,
                                 [XFATLayoutAttributes itemWidth] / 2);
    return layer;
}

+ (CAShapeLayer *)createInnerCircle:(XFATInnerCircle)circleType {
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
    CGPoint position = CGPointMake([XFATLayoutAttributes itemImageWidth] / 2, [XFATLayoutAttributes itemImageWidth] / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:position radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = 1;
    layer.fillColor = [UIColor colorWithWhite:1 alpha:circleAlpha].CGColor;
    layer.strokeColor = [UIColor colorWithWhite:0 alpha:borderAlpha].CGColor;
    layer.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    layer.position = CGPointMake(position.x, position.y);
    return layer;
}

@end
