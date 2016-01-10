//
//  LPAssistiveTouchViewController.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATRootViewController.h"

static NSTimeInterval ATHideAlpha = 0.2;
static NSTimeInterval ATShowAlpha = 0.7;
static NSTimeInterval hideDuration = 5;

@implementation LPATRootViewController {
    NSTimer *_timer;
}

#pragma mark - Initialization

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    self.view.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
    self.shrinkPoint = CGPointMake(imageViewWidth / 2, imageViewWidth / 2);
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

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
}

#pragma mark - Timer

- (void)beginTimer {
    _timer = [NSTimer timerWithTimeInterval:hideDuration target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFired {
    [UIView animateWithDuration:duration animations:^{
        self.contentItem.alpha = ATHideAlpha;
        self.contentView.alpha = ATHideAlpha;
    }];
    [self stopTimer];
}

#pragma mark - GestureAction

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
            [_delegate shrinkToPoint:self.shrinkPoint];
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
            self.contentItem.alpha = ATShowAlpha;
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.shrinkPoint = CGPointMake(point.x + imageViewWidth / 2 - pointOffset.x, point.y  + imageViewWidth / 2 - pointOffset.y);
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
        || gestureRecognizer.state == UIGestureRecognizerStateCancelled
        || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:duration animations:^{
            self.shrinkPoint = [self stickToPointByHorizontal];
        } completion:^(BOOL finished) {
            if (_delegate && [_delegate respondsToSelector:@selector(shrinkToPoint:)]) {
                [_delegate shrinkToPoint:self.shrinkPoint];
            }
            onceToken = NO;
            [self beginTimer];
        }];
    }
}

#pragma mark - StickToPoint

- (CGPoint)stickToPointByHorizontal {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGPoint center = self.shrinkPoint;
    if (center.y < center.x && center.y < -center.x + screen.size.width) {
        CGPoint point = CGPointMake(center.x, contentViewEdge + imageViewWidth / 2);
        point = [self makePointValid:point];
        return point;
    } else if (center.y > center.x + screen.size.height - screen.size.width
               && center.y > -center.x + screen.size.height) {
        CGPoint point = CGPointMake(center.x, CGRectGetHeight(screen) - imageViewWidth / 2 - contentViewEdge);
        point = [self makePointValid:point];
        return point;
    } else {
        if (center.x < screen.size.width / 2) {
            CGPoint point = CGPointMake(contentViewEdge + imageViewWidth / 2, center.y);
            point = [self makePointValid:point];
            return point;
        } else {
            CGPoint point = CGPointMake(CGRectGetWidth(screen) - imageViewWidth / 2 - contentViewEdge, center.y);
            point = [self makePointValid:point];
            return point;
        }
    }
}

//- (CGPoint)stickToPointByVertical {
//    CGRect screen = [[UIScreen mainScreen] bounds];
//    CGPoint center = self.contentItem.center;
//    CGFloat k = screen.size.height / screen.size.width;
//    if (center.y < k * center.x) {
//        if (center.y < -k * center.x + screen.size.height) {
//            _assistiveViewRect = self.contentItem.frame;
//            CGRect temp = _assistiveViewRect;
//            temp.origin.y = contentViewEdge;
//            _assistiveViewRect = [self makePointValid:temp];
//            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
//                                        CGRectGetMidY(_assistiveViewRect));
//            return point;
//        } else {
//            _assistiveViewRect = self.contentItem.frame;
//            CGRect temp = _assistiveViewRect;
//            temp.origin.x = screen.size.width - imageViewWidth - contentViewEdge;
//            _assistiveViewRect = [self makePointValid:temp];
//            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
//                                        CGRectGetMidY(_assistiveViewRect));
//            return point;
//        }
//    } else {
//        if (center.y < -k * center.x + screen.size.height) {
//            _assistiveViewRect = self.contentItem.frame;
//            CGRect temp = _assistiveViewRect;
//            temp.origin.x = contentViewEdge;
//            _assistiveViewRect = [self makePointValid:temp];
//            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
//                                        CGRectGetMidY(_assistiveViewRect));
//            return point;
//        } else {
//            _assistiveViewRect = self.contentItem.frame;
//            CGRect temp = _assistiveViewRect;
//            temp.origin.y = screen.size.height - imageViewWidth - contentViewEdge;
//            _assistiveViewRect = [self makePointValid:temp];
//            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
//                                        CGRectGetMidY(_assistiveViewRect));
//            return point;
//        }
//    }
//}

- (CGPoint)makePointValid:(CGPoint)point {
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (point.x < contentViewEdge + imageViewWidth / 2) {
        point.x = contentViewEdge + imageViewWidth / 2;
    }
    if (point.x > CGRectGetWidth(screen) - imageViewWidth / 2 - contentViewEdge) {
        point.x = CGRectGetWidth(screen) - imageViewWidth / 2 - contentViewEdge;
    }
    if (point.y < contentViewEdge + imageViewWidth / 2) {
        point.y = contentViewEdge + imageViewWidth / 2;
    }
    if (point.y > CGRectGetHeight(screen) - imageViewWidth / 2 - contentViewEdge) {
        point.y = CGRectGetHeight(screen) - imageViewWidth / 2 - contentViewEdge;
    }
    return point;
}

@end
