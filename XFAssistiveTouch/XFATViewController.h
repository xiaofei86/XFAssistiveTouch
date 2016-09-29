//
//  XFATViewController.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XFATViewController : UIResponder

- (instancetype)initWithItems:(nullable NSArray<XFATItemView *> *)items NS_DESIGNATED_INITIALIZER;

- (void)loadView;
- (void)viewDidLoad;

@property (nonatomic, strong) XFATItemView *backItem;
@property (nonatomic, strong) NSArray<XFATItemView *> *items;

@end

NS_ASSUME_NONNULL_END
