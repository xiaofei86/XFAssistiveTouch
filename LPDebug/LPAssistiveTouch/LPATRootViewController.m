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
static CGFloat ATEdge = 2.5;

@implementation LPATRootViewController {
    UITableView *_tableView;
    NSTimer *_timer;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _assistiveViewRect = CGRectMake(size.width - imageViewWidth - ATEdge, size.height / 2 - imageViewWidth / 2, imageViewWidth, imageViewWidth);
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - LoadView

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

- (void)touchesBegan {
    if (!self.isShow) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchBegan)]) {
            [_delegate touchBegan];
        }
    }
}

- (void)spreadGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    [self touchesBegan];
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
        [self touchesBegan];
        [self stopTimer];
        [UIView animateWithDuration:duration animations:^{
            self.contentItem.alpha = ATShowAlpha;
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.shrinkPoint = CGPointMake(point.x + imageViewWidth / 2 - pointOffset.x, point.y  + imageViewWidth / 2 - pointOffset.y);
        _assistiveViewRect = self.contentItem.frame;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
        || gestureRecognizer.state == UIGestureRecognizerStateCancelled
        || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:duration animations:^{
            self.shrinkPoint = [self stickToPointByHorizontal];
        } completion:^(BOOL finished) {
            if (_delegate && [_delegate respondsToSelector:@selector(shrinkToRect:)]) {
                [_delegate shrinkToRect:_assistiveViewRect];
            }
            onceToken = NO;
            [self beginTimer];
        }];
    }
}

#pragma mark - StickToPoint

- (CGPoint)stickToPointByHorizontal {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGPoint center = self.contentItem.center;
    if (center.y < center.x && center.y < -center.x + rect.size.width) {
        _assistiveViewRect = self.contentItem.frame;
        CGRect temp = _assistiveViewRect;
        temp.origin.y = ATEdge;
        _assistiveViewRect = [self makeRectValid:temp];
        CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                    CGRectGetMidY(_assistiveViewRect));
        return point;
    } else if (center.y > center.x + rect.size.height - rect.size.width
               && center.y > -center.x + rect.size.height) {
        _assistiveViewRect = self.contentItem.frame;
        CGRect temp = _assistiveViewRect;
        temp.origin.y = rect.size.height - imageViewWidth - ATEdge;
        _assistiveViewRect = [self makeRectValid:temp];
        CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                    CGRectGetMidY(_assistiveViewRect));
        return point;
    } else {
        if (center.x < rect.size.width / 2) {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.x = ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        } else {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.x = rect.size.width - imageViewWidth - ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        }
    }
}

- (CGPoint)stickToPointByVertical {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGPoint center = self.contentItem.center;
    CGFloat k = rect.size.height / rect.size.width;
    if (center.y < k * center.x) {
        if (center.y < -k * center.x + rect.size.height) {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.y = ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        } else {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.x = rect.size.width - imageViewWidth - ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        }
    } else {
        if (center.y < -k * center.x + rect.size.height) {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.x = ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        } else {
            _assistiveViewRect = self.contentItem.frame;
            CGRect temp = _assistiveViewRect;
            temp.origin.y = rect.size.height - imageViewWidth - ATEdge;
            _assistiveViewRect = [self makeRectValid:temp];
            CGPoint point = CGPointMake(CGRectGetMidX(_assistiveViewRect),
                                        CGRectGetMidY(_assistiveViewRect));
            return point;
        }
    }
}

- (CGRect)makeRectValid:(CGRect)rect {
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (rect.origin.x < ATEdge) {
        rect.origin.x = ATEdge;
    }
    if (rect.origin.x > screen.size.width - rect.size.width - ATEdge) {
        rect.origin.x = screen.size.width - rect.size.width - ATEdge;
    }
    if (rect.origin.y < ATEdge) {
        rect.origin.y = ATEdge;
    }
    if (rect.origin.y > screen.size.height - rect.size.height - ATEdge) {
        rect.origin.y = screen.size.height - rect.size.height - ATEdge;
    }
    return rect;
}

@end
