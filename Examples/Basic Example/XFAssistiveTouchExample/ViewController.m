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

@property (nonatomic, strong) XFAssistiveTouch *assistiveTouch;
@property (nonatomic, strong) XFATRootViewController *rootViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.view.layer.frame;
    layer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,
                     (__bridge id)[UIColor yellowColor].CGColor];
    [self.view.layer insertSublayer:layer below:0];
    
    _assistiveTouch = [XFAssistiveTouch sharedInstance];
    [_assistiveTouch showAssistiveTouch];
    _rootViewController = (XFATRootViewController *)_assistiveTouch.navigationController.viewControllers.firstObject;
    _rootViewController.delegate = self;
}

#pragma mark - XFATRootViewControllerDelegate

- (NSInteger)numberOfItemsInViewController:(XFATRootViewController *)viewController {
    return 8;
}

- (XFATItemView *)viewController:(XFATRootViewController *)viewController itemViewAtPosition:(XFATPosition *)position {
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
        case 3:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 4:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 5:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 6:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        case 7:
            return [XFATItemView itemWithType:XFATItemViewTypeStar];
            break;
        default:
            return [XFATItemView itemWithType:XFATItemViewTypeNone];
            break;
    }
}

- (void)viewController:(XFATRootViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < position.index + 1; i++) {
        XFATItemView *itemView = [XFATItemView itemWithType:XFATItemViewTypeCount + 5 + i];
        [array addObject:itemView];
    }
    XFATViewController *vc = [[XFATViewController alloc] initWithItems:[array copy]];
    [_rootViewController.navigationController pushViewController:vc
                                                      atPisition:position];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
