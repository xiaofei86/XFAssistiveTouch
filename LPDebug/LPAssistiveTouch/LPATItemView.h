//
//  LPAssistiveTouchView.h
//  LPAssistiveTouchDemo
//
//  Created by XuYafei on 15/10/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPATPosition.h"

typedef NS_ENUM(NSInteger, LPATItemViewType) {
    LPATItemViewTypeSystem,
    LPATItemViewTypeNone,
    LPATItemViewTypeBack,
    LPATItemViewTypeStar,
};

@interface LPATItemView : UIView

+ (instancetype)itemWithType:(LPATItemViewType)type;

@end
