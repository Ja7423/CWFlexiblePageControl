//
//  CWFlexPageConfig.h
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWFlexPageConfig : NSObject

@property (nonatomic, assign) NSInteger displayCount;

@property (nonatomic, assign) CGFloat dotSize;

@property (nonatomic, assign) CGFloat dotSpace;

@property (nonatomic, assign) CGFloat smallDotSizeRatio;

@property (nonatomic, assign) CGFloat mediumDotSizeRatio;

@end


@interface FlexPageItemConfig : NSObject

@property (nonatomic, assign) CGFloat dotSize;

@property (nonatomic, assign) CGFloat itemSize;

@property (nonatomic, assign) CGFloat smallDotSizeRatio;

@property (nonatomic, assign) CGFloat mediumDotSizeRatio;

- (instancetype)initWithPageConfig:(CWFlexPageConfig *)pageConfig;

@end

NS_ASSUME_NONNULL_END
