//
//  LPATRootViewController.m
//  LPDebugDemo
//
//  Created by XuYafei on 16/1/10.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATRootViewController.h"
#import "LPATNavigationController.h"

@implementation LPATRootViewController

- (void)loadView {
    NSMutableArray<LPATItemView *> *itemsArray = [NSMutableArray array];
    // FIXME:
    NSInteger count = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(controller:didSelectedAtPosition:)]) {
        count = [_delegate numberOfItemsInController:self];
        count < 0? count = 0: count;
        count > maxCount? count = maxCount: count;
    }
    for (int i = 0; i < count; i++) {
        LPATItemView *item;
        if (_delegate && [_delegate respondsToSelector:@selector(controller:itemViewAtPosition:)]) {
            item = [_delegate controller:self itemViewAtPosition:[LPATPosition positionWithCount:count index:i]];
        }
        !item? item = [LPATItemView new]: item;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [item addGestureRecognizer:tapGestureRecognizer];
        [itemsArray addObject:item];
    }
    self.items = itemsArray;
}

#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(controller:didSelectedAtPosition:)]) {
        LPATItemView *item = (LPATItemView *)tapGestureRecognizer.view;
        [_delegate controller:self didSelectedAtPosition:item.position];
    }
}

@end
