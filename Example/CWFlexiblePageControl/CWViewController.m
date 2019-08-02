//
//  CWViewController.m
//  CWFlexiblePageControl
//
//  Created by Ja7423 on 08/02/2019.
//  Copyright (c) 2019 Ja7423. All rights reserved.
//

#import "CWViewController.h"
#import <CWFlexiblePageControl/CWFlexPageControl.h>

@interface CWViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat scrollViewWidth;

@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) CWFlexPageControl *pageControl;

@end

@implementation CWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollViewWidth = self.view.frame.size.width;
    
    [self setImageContent:10];
}

- (void)setImageContent:(NSInteger)count
{
    NSInteger demoImageCount = 5;
    CGFloat height = self.imageScrollView.frame.size.height;
    self.imageScrollView.contentSize = CGSizeMake(count * self.scrollViewWidth, height);
    
    for (NSInteger i = 0; i < count; i ++) {
        NSInteger imageIndex = (i % demoImageCount) + 1;
        
        UIImageView *demoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollViewWidth, 0, self.scrollViewWidth, height)];
        demoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", imageIndex]];
        [self.imageScrollView addSubview:demoImageView];
    }
    
    self.pageControl.center = CGPointMake(self.imageScrollView.center.x, CGRectGetMaxY(self.imageScrollView.frame) + 20);
    self.pageControl.numberOfPages = count;
}

- (UIScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViewWidth, 300)];
        _imageScrollView.center = self.view.center;
        _imageScrollView.delegate = self;
        _imageScrollView.pagingEnabled = YES;
        [self.view addSubview:_imageScrollView];
    }
    
    return _imageScrollView;
}

- (CWFlexPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[CWFlexPageControl alloc] init];
        [self.view addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

@end
