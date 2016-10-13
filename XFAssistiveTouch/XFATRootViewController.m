//
//  XFATRootViewController.m
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATRootViewController.h"
#import "XFATNavigationController.h"

@implementation XFATRootViewController

- (void)loadView {
    NSMutableArray<XFATItemView *> *itemsArray = [NSMutableArray array];
    NSInteger count = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfItemsInViewController:)]) {
        count = [_delegate numberOfItemsInViewController:self];
        count = MIN(MAX(0, count), [XFATLayoutAttributes maxCount]);
    }
    for (int i = 0; i < count; i++) {
        XFATItemView *item;
        if (_delegate && [_delegate respondsToSelector:@selector(viewController:itemViewAtPosition:)]) {
            item = [_delegate viewController:self itemViewAtPosition:[XFATPosition positionWithCount:count index:i]];
        }
        item = item? item: [XFATItemView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [item addGestureRecognizer:tapGestureRecognizer];
        [itemsArray addObject:item];
    }
    self.items = itemsArray;
}

#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didSelectedAtPosition:)]) {
        XFATItemView *item = (XFATItemView *)tapGestureRecognizer.view;
        [_delegate viewController:self didSelectedAtPosition:item.position];
    }
}

@end
