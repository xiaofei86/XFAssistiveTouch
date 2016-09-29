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
@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation XFATNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRootViewController:nil];
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
        _rootViewController = viewController;
        _rootViewController.navigationController = self;
        _viewControllers = [NSMutableArray arrayWithObject:_rootViewController];
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
        XFATItemView *item = _viewControllers.firstObject.items[i];
        item.alpha = 0;
        item.center = _contentPoint;
        [self.view addSubview:item];
        [UIView animateWithDuration:duration animations:^{
            item.center = [XFATPosition positionWithCount:count index:i].center;
            item.alpha = 1;
        }];
    }
    
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = [XFATLayoutAttributes contentViewSpreadFrame];
        _effectView.frame = _contentView.bounds;
        _contentView.alpha = 1;
        _contentItem.center = [XFATPosition positionWithCount:count index:count - 1].center;
        _contentItem.alpha = 0;
    }];
}

- (void)shrink {
    _show = NO;
    for (XFATItemView *item in _viewControllers.lastObject.items) {
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
        [self shrinkEnd];
    }];
}

- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position {
    XFATViewController *oldViewController = _viewControllers.lastObject;
    for (XFATItemView *item in oldViewController.items) {
        [UIView animateWithDuration:duration animations:^{
            item.alpha = 0;
        }];
    }
    [UIView animateWithDuration:duration animations:^{
        oldViewController.backItem.alpha = 0;
    }];
    
    NSUInteger count = viewController.items.count;
    for (int i = 0; i < count; i++) {
        XFATItemView *item = viewController.items[i];
        item.alpha = 0;
        item.center = position.center;
        [self.view addSubview:item];
        [UIView animateWithDuration:duration animations:^{
            item.center = [XFATPosition positionWithCount:count index:i].center;
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
    
    viewController.navigationController = self;
    [_viewControllers addObject:viewController];
    [_pushPosition addObject:position];
}

- (void)popViewController {
    if (_pushPosition.count > 0) {
        XFATPosition *position = _pushPosition.lastObject;
        for (XFATItemView *item in _viewControllers.lastObject.items) {
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
            for (XFATItemView *item in _viewControllers.lastObject.items) {
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
