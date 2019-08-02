//
//  CWFlexPageConfig.m
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import "CWFlexPageConfig.h"

@interface CWFlexPageConfig ()

@end

@implementation CWFlexPageConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig
{
    self.displayCount = 7;
    self.dotSize = 6.0;
    self.dotSpace = 4.0;
    self.smallDotSizeRatio = 0.5;
    self.mediumDotSizeRatio = 0.7;
}

@end


@implementation FlexPageItemConfig

- (instancetype)initWithPageConfig:(CWFlexPageConfig *)pageConfig
{
    self = [super init];
    if (self) {
        self.dotSize = pageConfig.dotSize;
        self.itemSize = pageConfig.dotSpace + pageConfig.dotSize;
        self.smallDotSizeRatio = pageConfig.smallDotSizeRatio;
        self.mediumDotSizeRatio = pageConfig.mediumDotSizeRatio;
    }
    return self;
}

@end
