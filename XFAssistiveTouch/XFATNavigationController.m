//
//  XFATNavigationController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATNavigationController.h"
#import <objc/runtime.h>

@interface XFATNavigationController ()

@property (nonatomic, strong) NSMutableArray<XFATPosition *> *pushPosition;
@property (nonatomic, strong) XFATItemView *contentItem;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) CGPoint contentPoint;
@property (nonatomic, assign) CGFloat contentAlpha;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL show;

@end

@implementation XFATNavigationController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRootViewController:nil];//[XFATRootViewController new]
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithRootViewController:nil];
}

- (instancetype)initWithRootViewController:(XFATViewController *)viewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!viewController) {
            viewController = [XFATViewController new];
        }
        XFATViewController *rootViewController = viewController;
        rootViewController.navigationController = self;
        _viewControllers = [NSMutableArray arrayWithObject:rootViewController];
        _pushPosition = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    _contentPoint = [XFATLayoutAttributes cotentViewDefaultPoint];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth])];
    _contentView.center = _contentPoint;
    _contentView.layer.cornerRadius = 14;
    [self.view addSubview:_contentView];
    
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _effectView.frame = _contentView.bounds;
    _effectView.layer.cornerRadius = [XFATLayoutAttributes cornerRadius];
    _effectView.layer.masksToBounds = YES;
    [_contentView addSubview:_effectView];
    
    _contentItem = [XFATItemView itemWithType:XFATItemViewTypeSystem];
    _contentItem.center = _contentPoint;
    [self.view addSubview:_contentItem];
    
    self.view.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    self.contentAlpha = [XFATLayoutAttributes inactiveAlpha];
    self.contentPoint = CGPointMake([XFATLayoutAttributes itemImageWidth] / 2, [XFATLayoutAttributes itemImageWidth] / 2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *spreadGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spread)];
    UITapGestureRecognizer *shrinkGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shrink)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.contentItem addGestureRecognizer:spreadGestureRecognizer];
    [self.view addGestureRecognizer:shrinkGestureRecognizer];
    [self.contentItem addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Accessor

- (void)moveContentViewToPoint:(CGPoint)point {
    self.contentPoint = point;
}

- (void)setContentPoint:(CGPoint)contentPoint {
    if (!self.isShow) {
        _contentPoint = contentPoint;
        _contentView.center = _contentPoint;
        _contentItem.center = _contentPoint;
    }
}

- (void)setContentAlpha:(CGFloat)contentAlpha {
    if (!self.isShow) {
        _contentAlpha = contentAlpha;
        _contentView.alpha = _contentAlpha;
        _contentItem.alpha = _contentAlpha;
    }
}

- (void)setViewControllers:(NSMutableArray<XFATViewController *> *)viewControllers {
    _viewControllers = viewControllers;
}

#pragma mark - Animition

- (void)spread {
    if (self.isShow) {
        return;
    }
    [self stopTimer];
    [self invokeActionBeginDelegate];
    [self setShow:YES];
    NSUInteger count = _viewControllers.firstObject.items.count;
    for (int i = 0; i < count; i++) {
        XFATItemView *item = _viewControllers.firstObject.items[i];
        item.alpha = 0;
        item.center = _contentPoint;
        [self.view addSubview:item];
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            item.center = [XFATPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        _contentView.frame = [XFATLayoutAttributes contentViewSpreadFrame];
        _effectView.frame = _contentView.bounds;
        _contentView.alpha = 1;
        _contentItem.center = [XFATPosition positionWithCount:count index:count - 1].center;
        _contentItem.alpha = 0;
    }];
}

- (void)shrink {
    if (!self.isShow) {
        return;
    }
    [self beginTimer];
    [self setShow:NO];
    for (XFATItemView *item in _viewControllers.lastObject.items) {
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            item.center = _contentPoint;
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        _viewControllers.lastObject.backItem.center = _contentPoint;
        _viewControllers.lastObject.backItem.alpha = 0;
    }];
    
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        _contentView.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
        _contentView.center = _contentPoint;
        _effectView.frame = _contentView.bounds;
        _contentItem.alpha = 1;
        _contentItem.center = _contentPoint;
    } completion:^(BOOL finished) {
        for (XFATViewController *viewController in _viewControllers) {
            [viewController.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [viewController.backItem removeFromSuperview];
        }
        _viewControllers = [NSMutableArray arrayWithObject:_viewControllers.firstObject];
        [self invokeActionEndDelegate];
    }];
}

- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position {
    XFATViewController *oldViewController = _viewControllers.lastObject;
    for (XFATItemView *item in oldViewController.items) {
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        oldViewController.backItem.alpha = 0;
    }];
    
    NSUInteger count = viewController.items.count;
    for (int i = 0; i < count; i++) {
        XFATItemView *item = viewController.items[i];
        item.alpha = 0;
        item.center = position.center;
        [self.view addSubview:item];
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            item.center = [XFATPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    viewController.backItem.alpha = 0;
    viewController.backItem.center = position.center;
    [self.view addSubview:viewController.backItem];
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        viewController.backItem.center = self.view.center;
        viewController.backItem.alpha = 1;
    }];
    
    viewController.navigationController = self;
    [_viewControllers addObject:viewController];
    [_pushPosition addObject:position];
}

- (void)popViewController {
    if (_pushPosition.count > 0) {
        XFATPosition *position = _pushPosition.lastObject;
        for (XFATItemView *item in _viewControllers.lastObject.items) {
            [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
                item.center = position.center;
                item.alpha = 0;
            }];
        }
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            _viewControllers.lastObject.backItem.center = position.center;
            _viewControllers.lastObject.backItem.alpha = 0;
        } completion:^(BOOL finished) {
            [_viewControllers.lastObject.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_viewControllers.lastObject.backItem removeFromSuperview];
            [_viewControllers removeLastObject];
            for (XFATItemView *item in _viewControllers.lastObject.items) {
                [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
                    item.alpha = 1;
                }];
            }
            [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
                _viewControllers.lastObject.backItem.alpha = 1;
            }];
        }];
    }
}

#pragma mark - Timer

- (void)beginTimer {
    _timer = [NSTimer timerWithTimeInterval:[XFATLayoutAttributes activeDuration] target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFired {
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        self.contentAlpha = [XFATLayoutAttributes inactiveAlpha];
    }];
    [self stopTimer];
}

#pragma mark - Action

- (void)panGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    
    static CGPoint pointOffset;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointOffset = [gestureRecognizer locationInView:self.contentItem];
    });
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self invokeActionBeginDelegate];
        [self stopTimer];
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            self.contentAlpha = 1;
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentPoint = CGPointMake(point.x + [XFATLayoutAttributes itemImageWidth] / 2 - pointOffset.x, point.y  + [XFATLayoutAttributes itemImageWidth] / 2 - pointOffset.y);
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded
               || gestureRecognizer.state == UIGestureRecognizerStateCancelled
               || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            self.contentPoint = [self stickToPointByHorizontal];
        } completion:^(BOOL finished) {
            [self invokeActionEndDelegate];
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

#pragma mark - Private

- (void)invokeActionBeginDelegate {
    if (!self.isShow && _delegate && [_delegate respondsToSelector:@selector(navigationController:actionBeginAtPoint:)]) {
        [_delegate navigationController:self actionBeginAtPoint:self.contentPoint];
    }
}

- (void)invokeActionEndDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(navigationController:actionEndAtPoint:)]) {
        [_delegate navigationController:self actionEndAtPoint:self.contentPoint];
    }
}

@end

static const void *navigationControllerKey = &navigationControllerKey;

@implementation XFATViewController (XFATNavigationControllerItem)

@dynamic navigationController;

- (XFATNavigationController *)navigationController {
    return objc_getAssociatedObject(self, navigationControllerKey);
}

- (void)setNavigationController:(XFATNavigationController *)navigationController {
    objc_setAssociatedObject(self, navigationControllerKey, navigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
