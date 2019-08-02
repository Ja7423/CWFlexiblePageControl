//
//  CWFlexPageControl.m
//  FlexiblePageControl-Objc
//
//  Created by 家瑋 on 2019/7/31.
//  Copyright © 2019 家瑋. All rights reserved.
//

#import "CWFlexPageControl.h"

@interface CWFlexPageControl ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<CWFlexPageItemView *> *itemViews;

//
@property (nonatomic, assign) NSInteger displayCount;

@property (nonatomic, assign) CGFloat itemSize;

@property (nonatomic, assign) CGFloat animationDuration;

@end

@implementation CWFlexPageControl

#pragma mark -
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setup
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.userInteractionEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    
    self.currentPageIndicatorTintColor = [UIColor colorWithRed:0.32 green:0.59 blue:0.91 alpha:1.0];
    self.pageIndicatorTintColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
    
    [self setupPrivateProperty];
}

- (void)setupPrivateProperty
{
    self.animationDuration = 0.3;
    
    self.config = [CWFlexPageConfig new];
    
    self.itemViews = [NSMutableArray array];
}

#pragma mark Size
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.itemSize * self.displayCount, self.itemSize);
}

- (CGFloat)itemSize
{
    return self.config.dotSize + self.config.dotSpace;
}

#pragma mark - Public setter
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    self.scrollView.hidden = (self.numberOfPages <= 1);
    
    self.displayCount = MIN(self.config.displayCount, self.numberOfPages);
    
    [self updatePageControl:self.config currentPage:self.currentPage];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage >= self.numberOfPages || currentPage < 0) return;
    if (_currentPage == currentPage) return;
    
    _currentPage = currentPage;
    
    [self.scrollView.layer removeAllAnimations];
    
    [self updateDotAtCurrentPage:self.currentPage animation:YES];
}

- (void)setConfig:(CWFlexPageConfig *)config
{
    _config = config;
    
    [self invalidateIntrinsicContentSize];
    
    [self updatePageControl:self.config currentPage:self.currentPage];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self updateDotColorAtCurrentPage:self.currentPage];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self updateDotColorAtCurrentPage:self.currentPage];
}

#pragma mark - Private setter
- (void)setDisplayCount:(NSInteger)displayCount
{
    _displayCount = displayCount;
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Update
- (void)updatePageControl:(CWFlexPageConfig *)config currentPage:(NSInteger)currentPage
{
    if (currentPage < self.displayCount) {
        [self.itemViews removeAllObjects];
        for (NSInteger index = -2; index < self.displayCount + 2; index ++) {
            FlexPageItemConfig *itemConfig = [[FlexPageItemConfig alloc] initWithPageConfig:self.config];
            CWFlexPageItemView *itemView = [[CWFlexPageItemView alloc] initWithItemConfig:itemConfig index:index];
            
            CGFloat x = itemConfig.itemSize * index;
            itemView.frame = CGRectMake(x, 0, itemConfig.itemSize, itemConfig.itemSize);
            [self.itemViews addObject:itemView];
        }
    } else {
        CWFlexPageItemView *firstItemView = self.itemViews.firstObject;
        CWFlexPageItemView *lastItemView = self.itemViews.lastObject;
        if (!firstItemView || !lastItemView) return;
        
        [self.itemViews removeAllObjects];
        for (NSInteger index = firstItemView.index; index <= lastItemView.index; index ++) {
            FlexPageItemConfig *itemConfig = [[FlexPageItemConfig alloc] initWithPageConfig:self.config];
            CWFlexPageItemView *itemView = [[CWFlexPageItemView alloc] initWithItemConfig:itemConfig index:index];
            
            CGFloat x = itemConfig.itemSize * index;
            itemView.frame = CGRectMake(x, 0, itemConfig.itemSize, itemConfig.itemSize);
            [self.itemViews addObject:itemView];
        }
    }
    
    [self updateScrollView];
    
    if (self.displayCount < self.numberOfPages) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, self.itemSize * 2, 0, self.itemSize * 2);
    }
    else {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
    
    [self updateDotAtCurrentPage:currentPage animation:NO];
}

- (void)updateScrollView
{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.itemSize * self.numberOfPages, self.itemSize);
    
    CGRect bounds = self.scrollView.bounds;
    bounds.size = self.intrinsicContentSize;
    self.scrollView.bounds = bounds;
    
    for (CWFlexPageItemView *itemView in self.itemViews) {
        [self.scrollView addSubview:itemView];
    }
}

- (void)updateDotAtCurrentPage:(NSInteger)currentPage animation:(BOOL)animation
{
    // update dot indicator color
    [self updateDotColorAtCurrentPage:currentPage];
    
    if (self.numberOfPages > self.displayCount) {
        [self updateDotPositionAtCurrentPage:currentPage animation:animation];
        [self updateDotSizeAtCurrentPage:currentPage animation:animation];
    }
}

- (void)updateDotColorAtCurrentPage:(NSInteger)currentPage
{
    for (CWFlexPageItemView *itemView in self.itemViews) {
        itemView.dotColor = (itemView.index == currentPage) ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
    }
}

- (void)updateDotPositionAtCurrentPage:(NSInteger)currentPage animation:(BOOL)animation
{
    CGFloat duration = (animation) ? self.animationDuration : 0.0;
    
    if (currentPage == 0) {
        CGFloat x = -self.scrollView.contentInset.left;
        [self moveScrollViewToX:x duration:duration];
    }
    else if (currentPage == self.numberOfPages - 1) {
        CGFloat x = self.scrollView.contentSize.width - self.scrollView.bounds.size.width + self.scrollView.contentInset.right;
        [self moveScrollViewToX:x duration:duration];
    }
    else if (currentPage * self.itemSize <= self.scrollView.contentOffset.x + self.itemSize) {
        CGFloat x = self.scrollView.contentOffset.x - self.itemSize;
        [self moveScrollViewToX:x duration:duration];
    }
    else if (currentPage * self.itemSize + self.itemSize >= self.scrollView.contentOffset.x + self.scrollView.bounds.size.width - self.itemSize) {
        CGFloat x = self.scrollView.contentOffset.x + self.itemSize;
        [self moveScrollViewToX:x duration:duration];
    }
}

- (void)updateDotSizeAtCurrentPage:(NSInteger)currentPage animation:(BOOL)animation
{
    CGFloat duration = (animation) ? self.animationDuration : 0.0;
    
    for (CWFlexPageItemView *itemView in self.itemViews) {
        itemView.animateDuration = duration;
        
        if (itemView.index == currentPage) {
            itemView.state = DotStateNormal;
        }
        else if (itemView.index < 0) {
            // outside of left
            itemView.state = DotStateNone;
        }
        else if (itemView.index > self.numberOfPages - 1) {
            // outside of right
            itemView.state = DotStateNone;
        }
        else if (CGRectGetMinX(itemView.frame) <= self.scrollView.contentOffset.x) {
            // first dot from left
            itemView.state = DotStateSmall;
        }
        else if (CGRectGetMaxX(itemView.frame) >= self.scrollView.contentOffset.x + self.scrollView.bounds.size.width) {
            //  first dot from right
            itemView.state = DotStateSmall;
        }
        else if (CGRectGetMinX(itemView.frame) <= self.scrollView.contentOffset.x + self.itemSize) {
            // second dot from left
            itemView.state = DotStateMedium;
        }
        else if (CGRectGetMaxX(itemView.frame) >= self.scrollView.contentOffset.x + self.scrollView.bounds.size.width - self.itemSize) {
            // second dot from right
            itemView.state = DotStateMedium;
        }
        else {
            itemView.state = DotStateNormal;
        }
    }
}

#pragma mark - Move ScrollView
- (void)moveScrollViewToX:(CGFloat)xPosition duration:(CGFloat)duration
{
    Direction direction = [self directionTo:xPosition];
    [self reloadItemViews:direction];
    
    [UIView animateWithDuration:duration animations:^{
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.x = xPosition;
        self.scrollView.contentOffset = contentOffset;
    }];
}

- (Direction)directionTo:(CGFloat)x
{
    if (x > self.scrollView.contentOffset.x) {
        return DirectionToRight;
    }
    else if (x < self.scrollView.contentOffset.x) {
        return DirectionToLeft;
    }
    else {
        return DirectionStay;
    }
}

- (void)reloadItemViews:(Direction)direction
{
    CWFlexPageItemView *firstItemView = self.itemViews.firstObject;
    CWFlexPageItemView *lastItemView = self.itemViews.lastObject;
    
    if (!firstItemView || !lastItemView) return;
    
    switch (direction) {
        case DirectionToRight:
            firstItemView.index = lastItemView.index + 1;
            firstItemView.frame = CGRectMake(firstItemView.index * self.itemSize, 0, self.itemSize, self.itemSize);
            [self.itemViews addObject:firstItemView];
            [self.itemViews removeObjectAtIndex:0];
            break;
        case DirectionToLeft:
            lastItemView.index = firstItemView.index - 1;
            lastItemView.frame = CGRectMake(lastItemView.index * self.itemSize, 0, self.itemSize, self.itemSize);
            [self.itemViews insertObject:lastItemView atIndex:0];
            [self.itemViews removeLastObject];
            break;
        case DirectionStay:
            break;
    }
}

@end
