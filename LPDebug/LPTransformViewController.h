//
//  LPTransformViewController.h
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPTransformViewController : UIViewController

@property (nonatomic, assign) NSInteger user;

@property (nonatomic, strong) NSMutableArray<NSArray *> *transformArray;

@end

NS_ASSUME_NONNULL_END