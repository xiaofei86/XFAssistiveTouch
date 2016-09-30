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
        default: {
            if (type >= XFATItemViewTypeCount) {
                NSInteger count = type - XFATItemViewTypeCount;
                layer = [self createLayerWithCount:count];
            }
            break;
        }
    }
    XFATItemView *item = [[self alloc] initWithLayer:layer];
    if (type == XFATItemViewTypeSystem) {
        item.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
        item.layer.zPosition = FLT_MAX;
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
    return layer;
}

+ (CALayer *)createLayerStarType {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGSize size = CGSizeMake([XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
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
    return layer;
}

+ (CALayer *)createLayerWithCount:(NSInteger)count {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGRect bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectInset(bounds, 5, 5)] bezierPathByReversingPath]];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.bounds = bounds;
    
    CATextLayer *textLayer = [CATextLayer layer];
    if (count >= 10 || count < 0) {
        textLayer.string = @"!";
    } else {
        textLayer.string = [NSString stringWithFormat:@"%ld", count];
    }
    textLayer.fontSize = 48;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.bounds = bounds;
    textLayer.position = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:textLayer];
    
    return layer;
}

+ (CAShapeLayer *)createInnerCircle:(XFATInnerCircle)circleType {
    
    // iPad   width 390 itemWidth 76 margin 2 corner:14  48-41-33
    // iPhone width 295 itemWidth 60 margin 2 corner:14  44-38-30
    
    CGFloat circleAlpha = 0;
    CGFloat radius = 0;
    CGFloat borderAlpha = 0;
    switch (circleType) {
        case XFATInnerCircleSmall: {
            circleAlpha = 1;
            radius = IS_IPAD_IDIOM? 16: 14.5;
            borderAlpha = 0.3;
            break;
        } case XFATInnerCircleMiddle: {
            circleAlpha = 0.4;
            radius = IS_IPAD_IDIOM? 20: 18.5;
            borderAlpha = 0.15;
            break;
        } case XFATInnerCircleLarge: {
            circleAlpha = 0.2;
            radius = IS_IPAD_IDIOM? 24: 22;
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
    layer.lineWidth = 1;
    layer.fillColor = [UIColor colorWithWhite:1 alpha:circleAlpha].CGColor;
    layer.strokeColor = [UIColor colorWithWhite:0 alpha:borderAlpha].CGColor;
    layer.bounds = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    layer.position = CGPointMake(position.x, position.y);
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

@end
