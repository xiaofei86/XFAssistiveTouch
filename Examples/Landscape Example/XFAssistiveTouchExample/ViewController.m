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
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m2"]];
            break;
        case 1:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m3"]];
            break;
        case 2:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m4"]];
            break;
        case 3:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m5"]];
            break;
        case 4:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m6"]];
            break;
        case 5:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m7"]];
            break;
        case 6:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m8"]];
            break;
        case 7:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m9"]];
            break;
        default:
            return [XFATItemView itemWithImage:[UIImage imageNamed:@"m10"]];
            break;
    }
}

- (void)viewController:(XFATViewController *)viewController didSelectedAtPosition:(XFATPosition *)position {
    /*NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < position.index + 1; i++) {
        XFATItemView *itemView = [XFATItemView itemWithType:XFATItemViewTypeCount + i];
        [array addObject:itemView];
    }
    XFATViewController *vc = [[XFATViewController alloc] initWithItems:[array copy]];
    [[XFAssistiveTouch sharedInstance].navigationController pushViewController:vc atPisition:position];*/
    NSLog(@"%@", position);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
