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
    NSInteger tag = item.tag - itemTag;
    NSMutableArray *itemsArray = [NSMutableArray array];
    for (int i = 0; i < tag + 1; i++) {
        LPATItemView *item = [LPATItemView itemWithType:LPATItemViewTypeNone];
        [itemsArray addObject:item];
    }
    LPATViewController *viewController = [[LPATViewController alloc] initWithItems:itemsArray];
    LPATPosition *position = [LPATPosition positionWithCount:maxCount index:tag];
    [self.navgationController pushViewController:viewController atPisition:position];
//    switch (tag) {
//        case 0: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 1: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 2: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 3: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 4: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 5: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 6: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } case 7: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        } default: {
//            [self.navgationController pushViewController:[LPATViewController new] atPisition:position];
//            break;
//        }
//    }
}

@end
