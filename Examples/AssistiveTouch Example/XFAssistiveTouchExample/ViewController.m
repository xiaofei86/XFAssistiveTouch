//
//  ViewController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "ViewController.h"
#import "XFAssistiveTouch.h"

@interface ViewController () <XFXFAssistiveTouchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *layer = [CAGradientLayer layer];
    CGFloat layerWidth = fmax(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    layer.frame = CGRectMake(0, 0, layerWidth, layerWidth);
    layer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,
                     (__bridge id)[UIColor yellowColor].CGColor];
    [self.view.layer insertSublayer:layer below:0];
    
    XFAssistiveTouch *assistiveTouch = [XFAssistiveTouch sharedInstance];
    assistiveTouch.delegate = self;
    [assistiveTouch showAssistiveTouch];
}

#pragma mark - XFXFAssistiveTouchDelegate

- (NSInteger)numberOfItemsInViewController:(XFATViewController *)viewController {
    return 8;
}

- (XFATItemView *)viewController:(XFATViewController *)viewController itemViewAtPosition:(XFATPosition *)position {
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

- (void)viewController:(XFATViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < position.index + 1; i++) {
        XFATItemView *itemView = [XFATItemView itemWithType:XFATItemViewTypeCount + i];
        [array addObject:itemView];
    }
    XFATViewController *vc = [[XFATViewController alloc] initWithItems:[array copy]];
    [[XFAssistiveTouch sharedInstance].navigationController pushViewController:vc atPisition:position];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
