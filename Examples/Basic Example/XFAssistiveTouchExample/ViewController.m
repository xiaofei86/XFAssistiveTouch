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
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)];
    _textField.layer.borderColor = [UIColor whiteColor].CGColor;
    _textField.layer.borderWidth = 1;
    [self.view addSubview:_textField];
}

#pragma mark - XFATRootViewControllerDelegate

- (NSInteger)numberOfItemsInController:(XFATRootViewController *)atViewController {
    return 8;
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

- (void)controller:(XFATRootViewController *)controller didSelectedAtPosition:(XFATPosition *)position {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < position.index + 1; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Transform%d.png", i + 1];
        CALayer *layer = [CALayer layer];
        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
        XFATItemView *itemView = [XFATItemView itemWithLayer:layer];
        [array addObject:itemView];
    }
    XFATViewController *viewController = [[XFATViewController alloc] initWithItems:[array copy]];
    [_rootViewController.navigationController pushViewController:viewController
                                                      atPisition:position];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

@end
