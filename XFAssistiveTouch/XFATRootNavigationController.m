//
//  XFATRootNavigationController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATRootNavigationController.h"

static NSTimeInterval hideDuration = 4;
static const NSTimeInterval hideAlpha = 0.4;

@interface XFATRootNavigationController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XFATRootNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithRootViewController:[XFATRootViewController new]];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)loadView {
    [super loadView];
    self.view.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    self.contentPoint = CGPointMake([XFATLayoutAttributes itemImageWidth] / 2, [XFATLayoutAttributes itemImageWidth] / 2);
    self.contentAlpha = hideAlpha;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *spreadGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spreadGestureAction:)];
    UITapGestureRecognizer *shrinkGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shrinkGestureAction:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.contentItem addGestureRecognizer:spreadGestureRecognizer];
    [self.view addGestureRecognizer:shrinkGestureRecognizer];
    [self.contentItem addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Timer

- (void)beginTimer {
    _timer = [NSTimer timerWithTimeInterval:hideDuration target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFired {
    [UIView animateWithDuration:duration animations:^{
        self.contentAlpha = hideAlpha;
    }];
    [self stopTimer];
}

#pragma mark - Action

- (void)spreadBegin {
    if (!self.isShow) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchBegan)]) {
            [_delegate touchBegan];
        }
    }
}

- (void)shrinkEnd {
    if (!self.isShow) {
        if (_delegate && [_delegate respondsToSelector:@selector(shrinkToPoint:)]) {
            [_delegate shrinkToPoint:self.contentPoint];
        }
    }
}

- (void)spreadGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.isShow) {
        [self stopTimer];
        [self spread];
    }
}

- (void)shrinkGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    if (self.isShow) {
        [self beginTimer];
        [self shrink];
    }
}

- (void)panGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    static CGPoint pointOffset;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointOffset = [gestureRecognizer locationInView:self.contentItem];
    });
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self spreadBegin];
        [self stopTimer];
        [UIView animateWithDuration:duration animations:^{
            self.contentAlpha = 1;
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentPoint = CGPointMake(point.x + [XFATLayoutAttributes itemImageWidth] / 2 - pointOffset.x, point.y  + [XFATLayoutAttributes itemImageWidth] / 2 - pointOffset.y);
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
               || gestureRecognizer.state == UIGestureRecognizerStateCancelled
               || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:duration animations:^{
            self.contentPoint = [self stickToPointByHorizontal];
        } completion:^(BOOL finished) {
            if (_delegate && [_delegate respondsToSelector:@selector(shrinkToPoint:)]) {
                [_delegate shrinkToPoint:self.contentPoint];
            }
            onceToken = NO;
            [self beginTimer];
        }];
    }
}

#pragma mark - StickToPoint

- (CGPoint)stickToPointByHorizontal {
    CGRect screen = [UIScreen mainScreen].bounds;
    CGPoint center = self.contentPoint;
    if (center.y < center.x && center.y < -center.x + screen.size.width) {
        CGPoint point = CGPointMake(center.x, [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2);
        point = [self makePointValid:point];
        return point;
    } else if (center.y > center.x + screen.size.height - screen.size.width
               && center.y > -center.x + screen.size.height) {
        CGPoint point = CGPointMake(center.x, CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin]);
        point = [self makePointValid:point];
        return point;
    } else {
        if (center.x < screen.size.width / 2) {
            CGPoint point = CGPointMake([XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2, center.y);
            point = [self makePointValid:point];
            return point;
        } else {
            CGPoint point = CGPointMake(CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin], center.y);
            point = [self makePointValid:point];
            return point;
        }
    }
}

- (CGPoint)stickToPointByVertical {
    CGRect screen = [UIScreen mainScreen].bounds;
    CGPoint center = self.contentPoint;
    CGFloat k = screen.size.height / screen.size.width;
    if (center.y < k * center.x) {
        if (center.y < - k * center.x + screen.size.height) {
            CGPoint point = CGPointMake(center.x, [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2);
            point = [self makePointValid:point];
            return point;
        } else {
            CGPoint point = CGPointMake(center.x, CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin]);
            point = [self makePointValid:point];
            return point;
        }
    } else {
        if (center.y < - k * center.x + screen.size.height) {
            CGPoint point = CGPointMake([XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2, center.y);
            point = [self makePointValid:point];
            return point;
        } else {
            CGPoint point = CGPointMake(CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin], center.y);
            point = [self makePointValid:point];
            return point;
        }
    }
}

- (CGPoint)makePointValid:(CGPoint)point {
    CGRect screen = [UIScreen mainScreen].bounds;
    if (point.x < [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2) {
        point.x = [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2;
    }
    if (point.x > CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin]) {
        point.x = CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin];
    }
    if (point.y < [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2) {
        point.y = [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2;
    }
    if (point.y > CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin]) {
        point.y = CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin];
    }
    return point;
}

@end
