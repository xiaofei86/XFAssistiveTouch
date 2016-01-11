//
//  LPATNavigationController.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATNavigationController.h"

@interface LPATNavigationController ()

@end

@implementation LPATNavigationController {
    NSMutableArray<LPATPosition *> *_pushPosition;
    UIVisualEffectView *_effectView;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRootViewController:[LPATViewController new]];
}

- (instancetype)initWithRootViewController:(LPATViewController *)viewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewControllers = [NSMutableArray arrayWithObject:viewController];
        viewController.navgationController = self;
        _pushPosition = [NSMutableArray array];
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    _contentPoint = [LPATPosition cotentViewDefaultPointInRect:self.view.frame];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewWidth)];
    _contentView.center = _contentPoint;
    _contentView.layer.cornerRadius = 14;
    [self.view addSubview:_contentView];
    
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _effectView.frame = _contentView.bounds;
    _effectView.layer.cornerRadius = cornerRadius;
    _effectView.layer.masksToBounds = YES;
    [_contentView addSubview:_effectView];
    
    _contentItem = [LPATItemView itemWithType:LPATItemViewTypeSystem];
    _contentItem.center = _contentPoint;
    [self.view addSubview:_contentItem];
}

#pragma mark - Accessor

- (void)setContentPoint:(CGPoint)contentPoint {
    if (!_show) {
        _contentPoint = contentPoint;
        _contentView.center = _contentPoint;
        _contentItem.center = _contentPoint;
    }
}

- (void)setContentAlpha:(CGFloat)contentAlpha {
    if (!_show) {
        _contentAlpha = contentAlpha;
        _contentView.alpha = _contentAlpha;
        _contentItem.alpha = _contentAlpha;
    }
}

#pragma mark - Animition

- (void)spreadBegin {
    
}

- (void)shrinkEnd {
    
}

- (void)spread {
    [self spreadBegin];
    _show = YES;
    NSUInteger count = _viewControllers.firstObject.items.count;
    for (int i = 0; i < count; i++) {
        LPATItemView *item = _viewControllers.firstObject.items[i];
        item.alpha = 0;
        item.center = _contentPoint;
        [self.view addSubview:item];
        [UIView animateWithDuration:duration animations:^{
            item.center = [LPATPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = [LPATPosition contentViewSpreadFrame];
        _effectView.frame = _contentView.bounds;
        _contentView.alpha = 1;
        _contentItem.center = [LPATPosition positionWithCount:count index:count - 1].center;
        _contentItem.alpha = 0;
    }];
}

- (void)shrink {
    _show = NO;
    for (LPATItemView *item in _viewControllers.lastObject.items) {
        [UIView animateWithDuration:duration animations:^{
            item.center = _contentPoint;
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:duration animations:^{
        _viewControllers.lastObject.backItem.center = _contentPoint;
        _viewControllers.lastObject.backItem.alpha = 0;
    }];
    
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
        _contentView.center = _contentPoint;
        _effectView.frame = _contentView.bounds;
        _contentItem.alpha = 1;
        _contentItem.center = _contentPoint;
    } completion:^(BOOL finished) {
        for (LPATViewController *viewController in _viewControllers) {
            [viewController.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [viewController.backItem removeFromSuperview];
        }
        _viewControllers = [NSMutableArray arrayWithObject:_viewControllers.firstObject];
        [self shrinkEnd];
    }];
}

- (void)pushViewController:(LPATViewController *)viewController atPisition:(LPATPosition *)position {
    LPATViewController *oldViewController = _viewControllers.lastObject;
    for (LPATItemView *item in oldViewController.items) {
        [UIView animateWithDuration:duration animations:^{
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:duration animations:^{
        oldViewController.backItem.alpha = 0;
    }];
    
    NSUInteger count = viewController.items.count;
    for (int i = 0; i < count; i++) {
        LPATItemView *item = viewController.items[i];
        item.alpha = 0;
        item.center = position.center;
        [self.view addSubview:item];
        [UIView animateWithDuration:duration animations:^{
            item.center = [LPATPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    viewController.backItem.alpha = 0;
    viewController.backItem.center = position.center;
    [self.view addSubview:viewController.backItem];
    [UIView animateWithDuration:duration animations:^{
        viewController.backItem.center = self.view.center;
        viewController.backItem.alpha = 1;
    }];
    
    viewController.navgationController = self;
    [_viewControllers addObject:viewController];
    [_pushPosition addObject:position];
}

- (void)popViewController {
    if (_pushPosition.count > 0) {
        LPATPosition *position = _pushPosition.lastObject;
        for (LPATItemView *item in _viewControllers.lastObject.items) {
            [UIView animateWithDuration:duration animations:^{
                item.center = position.center;
                item.alpha = 0;
            }];
        }
        [UIView animateWithDuration:duration animations:^{
            _viewControllers.lastObject.backItem.center = position.center;
            _viewControllers.lastObject.backItem.alpha = 0;
        } completion:^(BOOL finished) {
            [_viewControllers.lastObject.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_viewControllers.lastObject.backItem removeFromSuperview];
            [_viewControllers removeLastObject];
            for (LPATItemView *item in _viewControllers.lastObject.items) {
                [UIView animateWithDuration:duration animations:^{
                    item.alpha = 1;
                }];
            }
            [UIView animateWithDuration:duration animations:^{
                _viewControllers.lastObject.backItem.alpha = 1;
            }];
        }];
    }
}

@end
