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
    // FIXME:
    NSInteger count = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(controller:didSelectedAtPosition:)]) {
        count = [_delegate numberOfItemsInController:self];
        count < 0? count = 0: count;
        count > [XFATLayoutAttributes maxCount]? count = [XFATLayoutAttributes maxCount]: count;
    }
    for (int i = 0; i < count; i++) {
        XFATItemView *item;
        if (_delegate && [_delegate respondsToSelector:@selector(controller:itemViewAtPosition:)]) {
            item = [_delegate controller:self itemViewAtPosition:[XFATPosition positionWithCount:count index:i]];
        }
        !item? item = [XFATItemView new]: item;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [item addGestureRecognizer:tapGestureRecognizer];
        [itemsArray addObject:item];
    }
    self.items = itemsArray;
}

#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(controller:didSelectedAtPosition:)]) {
        XFATItemView *item = (XFATItemView *)tapGestureRecognizer.view;
        [_delegate controller:self didSelectedAtPosition:item.position];
    }
}

@end
