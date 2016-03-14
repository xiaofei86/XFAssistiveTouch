//
//  LPAssistiveTouchView.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATPosition.h"

typedef NS_ENUM(NSInteger, LPATItemViewType) {
    LPATItemViewTypeNone,
    LPATItemViewTypeSystem,
    LPATItemViewTypeBack,
    LPATItemViewTypeStar,
    LPATItemViewTypeNSLog,
    LPATItemViewTypeAPNS,
    LPATItemViewTypeTransform
};

@interface LPATItemView : UIView

+ (instancetype)itemWithType:(LPATItemViewType)type;
+ (instancetype)itemWithLayer:(CALayer *)layer;

@property (nonatomic, strong) LPATPosition *position;

@end
