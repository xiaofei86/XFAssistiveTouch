//
//  XFATViewController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATViewController.h"
#import "XFATNavigationController.h"

@implementation XFATViewController

@synthesize items = _items;

#pragma mark - Initialization

- (instancetype)initWithItems:(NSArray<XFATItemView *> *)items {
    self = [self init];
    self.items = items;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _backItem = [XFATItemView itemWithType:XFATItemViewTypeBack];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_backItem addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Accessor

- (NSArray<XFATItemView *> *)items {
    if (!_items) {
        [self loadView];
        [self viewDidLoad];
    }
    return _items;
}

- (void)setItems:(NSArray<XFATItemView *> *)items {
    _items = items;
    for (int i = 0; i < _items.count; i++) {
        XFATItemView *item = _items[i];
        item.position = [XFATPosition positionWithCount:_items.count index:i];
    }
}

#pragma mark - LoadView

- (void)loadView {
    _items = @[[XFATItemView new], [XFATItemView new],
               [XFATItemView new], [XFATItemView new],
               [XFATItemView new], [XFATItemView new],
               [XFATItemView new], [XFATItemView new]];
}

- (void)viewDidLoad {
    
}

#pragma mark - Action

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewController];
}

@end
