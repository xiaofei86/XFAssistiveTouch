//
//  LPPushController.h
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPushController : UIViewController

@property (nonatomic, strong) UITextField *tagInputTextField;

@property (nonatomic, strong) UITextView *outputTextView;

- (void)addLogString:(NSString *)logStr;

@end

NS_ASSUME_NONNULL_END