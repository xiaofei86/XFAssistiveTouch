//
//  XFAssistiveTouch.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/26.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFAssistiveTouch.h"
#import "XFATRootViewController.h"

@interface XFAssistiveTouch () <XFATNavigationControllerDelegate, XFATRootViewControllerDelegate>

@property (nonatomic, assign) CGPoint assistiveWindowPoint;
@property (nonatomic, assign) CGPoint coverWindowPoint;

@end

@implementation XFAssistiveTouch

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        XFATRootViewController *rootViewController = [XFATRootViewController new];
        rootViewController.delegate = self;
        _navigationController = [[XFATNavigationController alloc] initWithRootViewController:rootViewController];
        _navigationController.delegate = self;
        _assistiveWindowPoint = [XFATLayoutAttributes cotentViewDefaultPoint];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showAssistiveTouch {
    _assistiveWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth])];
    _assistiveWindow.center = _assistiveWindowPoint;
    _assistiveWindow.windowLevel = CGFLOAT_MAX;
    _assistiveWindow.backgroundColor = [UIColor clearColor];
    _assistiveWindow.rootViewController = _navigationController;
    [self makeVisibleWindow];
}

- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [_assistiveWindow makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}

#pragma mark - XFATRootViewControllerDelegate

- (NSInteger)numberOfItemsInViewController:(XFATViewController *)viewController {
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfItemsInViewController:)]) {
        return [_delegate numberOfItemsInViewController:viewController];
    } else {
        return 0;
    }
}

- (XFATItemView *)viewController:(XFATViewController *)viewController itemViewAtPosition:(XFATPosition *)position {
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:itemViewAtPosition:)]) {
        return [_delegate viewController:viewController itemViewAtPosition:position];
    } else {
        return nil;
    }
}

- (void)viewController:(XFATViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfItemsInViewController:)]) {
        [_delegate viewController:viewController didSelectedAtPosition:position];
    }
}

#pragma mark - XFATNavigationControllerDelegate

- (void)navigationController:(XFATNavigationController *)navigationController actionBeginAtPoint:(CGPoint)point {
    _coverWindowPoint = CGPointZero;
    _assistiveWindow.frame = [UIScreen mainScreen].bounds;
    _navigationController.view.frame = [UIScreen mainScreen].bounds;
    [_navigationController moveContentViewToPoint:_assistiveWindowPoint];
}

- (void)navigationController:(XFATNavigationController *)navigationController actionEndAtPoint:(CGPoint)point {
    _assistiveWindowPoint = point;
    _assistiveWindow.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
    _assistiveWindow.center = _assistiveWindowPoint;
    CGPoint contentPoint = CGPointMake([XFATLayoutAttributes itemImageWidth] / 2, [XFATLayoutAttributes itemImageWidth] / 2);
    [_navigationController moveContentViewToPoint:contentPoint];
}

#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {
        return;
    }
    
    /*因为动画过程中不能实时修改_assistiveWindowRect,
     *所以如果执行点击操作的话,_assistiveTouchView位置会以动画之前的位置为准.
     *如果执行拖动操作则会有跳动效果.所以需要禁止用户操作.*/
    _assistiveWindow.userInteractionEnabled = NO;
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    //根据实时位置计算于键盘的间距
    CGFloat yOffset = endKeyboardRect.origin.y - CGRectGetMaxY(_assistiveWindow.frame);

    //如果键盘弹起给_coverWindowPoint赋值
    if (endKeyboardRect.origin.y < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        _coverWindowPoint = _assistiveWindowPoint;
    }

    //根据间距计算移动后的位置viewPoint
    CGPoint viewPoint = _assistiveWindow.center;
    viewPoint.y += yOffset;
    //如果viewPoint在原位置之下,将viewPoint变为原位置
    if (viewPoint.y > _coverWindowPoint.y) {
        viewPoint.y = _coverWindowPoint.y;
    }
    //如果_assistiveWindow被移动,将viewPoint变为移动后的位置
    if (CGPointEqualToPoint(_coverWindowPoint, CGPointZero)) {
        viewPoint.y = _assistiveWindow.center.y;
    }

    //根据计算好的位置执行动画
    [UIView animateWithDuration:duration animations:^{
        _assistiveWindow.center = viewPoint;
    } completion:^(BOOL finished) {
        //将_assistiveWindowRect变为移动后的位置并恢复用户操作
        _assistiveWindowPoint = _assistiveWindow.center;
        _assistiveWindow.userInteractionEnabled = YES;
        //使其遮盖键盘
        [self makeVisibleWindow];
    }];
}

#pragma mark - PushViewController

- (void)pushViewController:(UIViewController *)viewController atViewController:(nonnull UIViewController *)targetViewcontroller {
    if ([targetViewcontroller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)targetViewcontroller pushViewController:viewController animated:YES];
    } else {
        [targetViewcontroller presentViewController:viewController animated:YES completion:^{}];
    }
    [_navigationController shrink];
}

- (void)pushViewController:(UIViewController *)viewController {
    UIViewController *topvc = [self p_topViewController];
    if ([topvc isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topvc pushViewController:viewController animated:YES];
    } else {
        [topvc presentViewController:viewController animated:YES completion:^{}];
    }
    [_navigationController shrink];
    
}

- (UIViewController *)p_topViewController{
    return [self p_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)p_topViewController:(UIViewController *)rootvc {
    if ([rootvc isKindOfClass:[UITabBarController class]]) {
        UIViewController *tabvc = ((UITabBarController *)rootvc).selectedViewController;
        return [self p_topViewController:tabvc];
    } else {
        UIViewController *topvc = rootvc;
        while (topvc.presentedViewController) {
            topvc = topvc.presentedViewController;
        }
        return topvc;
    }
}

@end
