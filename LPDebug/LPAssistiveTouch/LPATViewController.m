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

@synthesize items = _items;

#pragma mark - Initialization

- (instancetype)initWithItems:(NSArray<LPATItemView *> *)items {
    self = [self init];
    if (self) {
        self.items = items;
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

#pragma mark - Accessor

- (NSArray<LPATItemView *> *)items {
    if (!_items) {
        [self loadView];
        [self viewDidLoad];
    }
    return _items;
}

- (void)setItems:(NSArray<LPATItemView *> *)items {
    _items = items;
    for (int i = 0; i < _items.count; i++) {
        LPATItemView *item = _items[i];
        item.position = [LPATPosition positionWithCount:_items.count index:i];
    }
}

#pragma mark - LoadView

- (void)loadView {
    _items = @[[LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new],
               [LPATItemView new], [LPATItemView new]];
}

- (void)viewDidLoad {
    
}

#pragma mark - Action

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self.navgationController popViewController];
}

@end
