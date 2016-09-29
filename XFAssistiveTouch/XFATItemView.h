//
//  XFATView.h
//  XFAssistiveTouchExample
//
//  Created by 徐亚非 on 2016/9/24.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFATPosition.h"

typedef NS_ENUM(NSInteger, XFATItemViewType) {
    XFATItemViewTypeNone,
    XFATItemViewTypeSystem,
    XFATItemViewTypeBack,
    XFATItemViewTypeStar
};

@interface XFATItemView : UIView

+ (instancetype)itemWithType:(XFATItemViewType)type;
+ (instancetype)itemWithLayer:(CALayer *)layer;

@property (nonatomic, strong) XFATPosition *position;

@end
