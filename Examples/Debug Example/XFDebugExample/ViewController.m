//
//  ViewController.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "ViewController.h"
#import "XFDebug.h"

@implementation ViewController

- (void)loadView {
    [super loadView];
    CAGradientLayer *layer = [CAGradientLayer layer];
    CGFloat layerWidth = fmax(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    layer.frame = CGRectMake(0, 0, layerWidth, layerWidth);
    layer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,
                     (__bridge id)[UIColor yellowColor].CGColor];
    [self.view.layer insertSublayer:layer below:0];
    
    //XFDebugLog(@"%@", [[UIApplication sharedApplication].keyWindow valueForKey:@"recursiveDescription"]);
    XFDebugLog(@"%@", [NSDate date]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
