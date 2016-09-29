//
//  ViewController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "ViewController.h"
#import "XFAssistiveTouch.h"

@interface ViewController () <XFATRootViewControllerDelegate>

@end

@implementation ViewController {
    XFAssistiveTouch *_assistiveTouch;
    XFATRootViewController *_rootViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.view.layer.frame;
    layer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,
                     (__bridge id)[UIColor yellowColor].CGColor];
    [self.view.layer addSublayer:layer];
    
    _assistiveTouch = [XFAssistiveTouch shareInstance];
    [_assistiveTouch showAssistiveTouch];
    _rootViewController = (XFATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
    _rootViewController.delegate = self;
}

#pragma mark - XFATRootViewControllerDelegate

- (NSInteger)numberOfItemsInController:(XFATRootViewController *)atViewController {
    return 3;
}

- (XFATItemView *)controller:(XFATRootViewController *)controller itemViewAtPosition:(XFATPosition *)position {
    switch (position.index) {
        case 0:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 1:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 2:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        default:
            return [XFATItemView itemWithType:XFATItemViewTypeNone];
            break;
    }
}

- (void)controller:(XFATRootViewController *)controller didSelectedAtPosition:(XFATPosition *)position {
    switch (position.index) {
        case 0: {
            break;
        } case 1: {
            break;
        } case 2: {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < 8; i++) {
                NSString *imageName = [NSString stringWithFormat:@"Transform%d.png", i + 1];
                CALayer *layer = [CALayer layer];
                layer.contentsScale = [UIScreen mainScreen].scale;
                layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
                XFATItemView *itemView = [XFATItemView itemWithLayer:layer];
                [array addObject:itemView];
            }
            XFATViewController *viewController = [[XFATViewController alloc] initWithItems:[array copy]];
            [_rootViewController.navigationController pushViewController:viewController
                                                              atPisition:position];
            break;
        } default: {
            break;
        }
    }
}

@end
