//
//  LPATViewController.m
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATViewController.h"
#import "LPATNavigationController.h"

@interface LPATViewController ()

@end

@implementation LPATViewController

- (instancetype)initWithItems:(NSArray<LPATItemView *> *)items {
    self = [super init];
    if (self) {
        _items = items;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _backItem = [LPATItemView itemWithType:LPATItemViewTypeBack];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_backItem addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (NSArray<UIView *> *)items {
    if (!_items) {
        [self loadView];
        [self viewDidLoad];
    }
    return _items;
}

- (void)loadView {
    _items = @[[LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new]];
}

- (void)viewDidLoad {
    
}

#pragma mark - Actino

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self.navgationController popViewController];
}

@end
