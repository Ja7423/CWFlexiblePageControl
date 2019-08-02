//
//  CWFlexPageControl.h
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWFlexPageConfig.h"
#import "CWFlexPageItemView.h"

NS_ASSUME_NONNULL_BEGIN


/**
 Dot move direction

 - DirectionToRight: dot move to right
 - DirectionToLeft: dot move to left
 - DirectionStay: stay
 */
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionToRight,
    DirectionToLeft,
    DirectionStay,
};

@interface CWFlexPageControl : UIView

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) CWFlexPageConfig *config;

@end

NS_ASSUME_NONNULL_END
