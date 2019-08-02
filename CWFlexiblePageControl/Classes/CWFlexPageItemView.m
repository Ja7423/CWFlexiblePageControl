//
//  CWFlexPageItemView.m
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import "CWFlexPageItemView.h"

@interface CWFlexPageItemView ()

@property (nonatomic, strong) FlexPageItemConfig *itemConfig;

@property (nonatomic, strong) UIView *dotView;

@end

@implementation CWFlexPageItemView

- (instancetype)initWithItemConfig:(FlexPageItemConfig *)itemConfig index:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.itemConfig = itemConfig;
        self.index = index;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _dotColor = [UIColor lightGrayColor];
    
    self.dotView = [[UIView alloc] init];
    self.dotView.frame = CGRectMake(0, 0, self.itemConfig.dotSize, self.itemConfig.dotSize);
    self.dotView.center = CGPointMake(self.itemConfig.itemSize / 2, self.itemConfig.itemSize / 2);
    self.dotView.backgroundColor = self.dotColor;
    self.dotView.layer.cornerRadius = self.itemConfig.dotSize / 2;
    self.dotView.layer.masksToBounds = YES;
    [self addSubview:self.dotView];
}

- (void)setState:(DotState)state
{
    _state = state;
    [self updateSizeFromState:state withAnimation:self.animateDuration];
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    
    self.dotView.backgroundColor = dotColor;
}

- (void)updateSizeFromState:(DotState)state withAnimation:(CGFloat)duration
{
    CGSize dotSize = CGSizeZero;
    switch (state) {
        case DotStateNormal:
            dotSize = CGSizeMake(self.itemConfig.dotSize,
                                 self.itemConfig.dotSize);
            break;
        case DotStateNone:
            dotSize = CGSizeZero;
            break;
        case DotStateSmall:
            dotSize = CGSizeMake(self.itemConfig.dotSize * self.itemConfig.smallDotSizeRatio,
                                 self.itemConfig.dotSize * self.itemConfig.smallDotSizeRatio);
            break;
        case DotStateMedium:
            dotSize = CGSizeMake(self.itemConfig.dotSize * self.itemConfig.mediumDotSizeRatio,
                                 self.itemConfig.dotSize * self.itemConfig.mediumDotSizeRatio);
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.dotView.layer.cornerRadius = dotSize.height / 2;
        
        CGRect bounds = weakSelf.dotView.layer.bounds;
        bounds.size = dotSize;
        weakSelf.dotView.layer.bounds = bounds;
    }];
}

@end
