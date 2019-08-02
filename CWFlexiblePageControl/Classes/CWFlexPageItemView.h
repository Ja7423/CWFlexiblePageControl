//
//  CWFlexPageItemView.h
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWFlexPageConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DotState) {
    DotStateNone,
    DotStateNormal,
    DotStateSmall,
    DotStateMedium,
};

@interface CWFlexPageItemView : UIView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIColor *dotColor;

@property (nonatomic, assign) CGFloat animateDuration;

@property (nonatomic, assign) DotState state;

- (instancetype)initWithItemConfig:(FlexPageItemConfig *)itemConfig index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
