//
//  LPATRootViewController.m
//  LPDebugDemo
//
//  Created by XuYafei on 16/1/10.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATRootViewController.h"
#import "LPATNavigationController.h"

static const NSInteger itemTag = 1994;

@implementation LPATRootViewController

- (void)loadView {
    NSMutableArray<LPATItemView *> *itemsArray = [NSMutableArray array];
    for (int i = 0; i < maxCount; i++) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        LPATItemView *item = [LPATItemView itemWithType:LPATItemViewTypeStar];
        item.tag = itemTag + i;
        [item addGestureRecognizer:tapGestureRecognizer];
        [itemsArray addObject:item];
    }
    self.items = itemsArray;
}

#pragma mark - Action

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    LPATItemView *item = (LPATItemView *)tapGestureRecognizer.view;
    NSMutableArray *itemsArray = [NSMutableArray array];
    for (int i = 0; i < item.position.index + 1; i++) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction2:)];
        LPATItemView *item = [LPATItemView itemWithType:LPATItemViewTypeNone];
        [item addGestureRecognizer:tapGestureRecognizer];
        [itemsArray addObject:item];
    }
    LPATViewController *viewController = [[LPATViewController alloc] initWithItems:itemsArray];
    [self.navigationController pushViewController:viewController atPisition:item.position];
}

- (void)tapGestureAction2:(UITapGestureRecognizer *)tapGestureRecognizer {
    LPATItemView *item = (LPATItemView *)tapGestureRecognizer.view;
    LPATViewController *viewController = [[LPATViewController alloc] init];
    [self.navigationController pushViewController:viewController atPisition:item.position];
}

@end
