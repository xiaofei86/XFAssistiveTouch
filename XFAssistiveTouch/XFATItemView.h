//
//  XFATView.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATPosition.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XFATItemViewType) {
    XFATItemViewTypeNone,
    XFATItemViewTypeSystem,
    XFATItemViewTypeBack,
    XFATItemViewTypeStar
};

@interface XFATItemView : UIView

- (instancetype)initWithLayer:(nullable CALayer *)layer NS_DESIGNATED_INITIALIZER;
+ (instancetype)itemWithType:(XFATItemViewType)type;
+ (instancetype)itemWithLayer:(CALayer *)layer;

@property (nonatomic, strong) XFATPosition *position;

@end

NS_ASSUME_NONNULL_END
