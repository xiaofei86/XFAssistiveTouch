//
//  LPATViewController.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 16/1/8.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPATItemView.h"

@class LPATNavigationController;

@interface LPATViewController : UIResponder

- (instancetype)initWithItems:(NSArray<LPATItemView *> *)items;

- (void)loadView;
- (void)viewDidLoad;

@property (nonatomic, strong) LPATItemView *backItem;
@property (nonatomic, strong) NSArray<LPATItemView *> *items;
@property (nonatomic, assign) LPATNavigationController *navgationController;

@end
