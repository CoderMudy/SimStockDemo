//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
#import "Globle.h"
#import "SquarePageControl.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, assign) NSInteger totalPageCount;
@property(nonatomic, strong) NSMutableArray *contentViews;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) SquarePageControl *pageControl;

@property(nonatomic, strong) NSTimer *animationTimer;
@property(nonatomic, assign) NSTimeInterval animationDuration;
//页数
@property(nonatomic, assign) NSInteger Pages;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount {
  _totalPageCount = totalPagesCount();
  if (_totalPageCount > 0) {
    [self configContentViews];
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
  }
}

- (void)recyleResource {
  if (self.animationTimer) {
    [self.animationTimer invalidate];
    self.animationTimer = nil;
  }
  self.fetchContentViewAtIndex = nil;
  NSLog(@"recyleResource CycleScrollView %@", self);
}

- (void)dealloc {
  NSLog(@"dealloc CycleScrollView %@", self);
}

- (id)initWithFrame:(CGRect)frame
        pageInteger:(NSInteger)pageInt
  animationDuration:(NSTimeInterval)animationDuration {

  if (self = [self initWithFrame:frame pageInteger:pageInt]) {
    _Pages = pageInt;
    self.animationDuration = animationDuration;
    if (animationDuration > 0.0) {
      self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                                             target:self
                                                           selector:@selector(animationTimerDidFired:)
                                                           userInfo:nil
                                                            repeats:YES];
      [self.animationTimer pauseTimer];
    }
  };

  return self;
}
- (void)greateScrollViewPageInteger:(NSInteger)pageInt
                  animationDuration:(NSTimeInterval)animationDuration {
}
- (id)initWithFrame:(CGRect)frame pageInteger:(NSInteger)pageInt {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.autoresizesSubviews = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.autoresizingMask = 0xFF;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize =
        CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    [self addSubview:self.scrollView];
    self.currentPageIndex = 0;

    // UIPageControl
    self.pageControl = [[SquarePageControl alloc] initWithType:DDPageControlTypeOnFullOffFull];
    [self.pageControl setNumberOfPages:pageInt];
    [self.pageControl setCurrentPage:0];
    [self.pageControl addTarget:self
                         action:@selector(pageControlClicked:)
               forControlEvents:UIControlEventValueChanged];
    [self.pageControl setDefersCurrentPageDisplay:YES];
    [self.pageControl setOnColor:[Globle colorFromHexRGB:@"f3f3f3"]];
    [self.pageControl setOffColor:[Globle colorFromHexRGB:@"f3f3f3" alpha:0.4]];
    [self.pageControl setIndicatorDiameter:3.0f];
    [self.pageControl setIndicatorSpace:7.0f];
    //设置 中心点
    [self.pageControl setCenter:CGPointMake(0, 0)];
    [self addSubview:self.pageControl];
  }
  return self;
}

- (void)pageControlClicked:(DDPageControl *)page {
  [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * page.currentPage, self.scrollView.contentOffset.y)
                           animated:YES];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.pageControl setCenter:CGPointMake(self.width - CGRectGetWidth(self.pageControl.bounds) * 0.5,
                                          self.height - CGRectGetHeight(self.pageControl.bounds) * 0.5)];
}

///修改scrollview的总长度
- (void)ResetScrollviewContentSzie:(NSInteger)row {
  if (row >= 3) {
    self.scrollView.contentSize =
        CGSizeMake(row * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));

    self.pageControl.numberOfPages = row;
  }
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews {
  [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self setScrollViewContentDataSource];
  NSInteger counter = 0;
  for (UIView *contentView in self.contentViews) {
    if (contentView.gestureRecognizers.count <= 0) {
      contentView.userInteractionEnabled = YES;
      UITapGestureRecognizer *tapGesture =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(contentViewTapAction:)];
      [contentView addGestureRecognizer:tapGesture];
    }

    CGRect rightRect = contentView.frame;
    rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter++), 0);
    contentView.frame = rightRect;
    [self.scrollView addSubview:contentView];
  }
  [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource {
  NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
  NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
  if (self.contentViews == nil) {
    self.contentViews = [@[] mutableCopy];
  }
  [self.contentViews removeAllObjects];

  if (self.fetchContentViewAtIndex) {
    [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
    [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
    [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
  }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex {
  if (currentPageIndex == -1) {
    return self.totalPageCount - 1;
  } else if (currentPageIndex == self.totalPageCount) {
    return 0;
  } else {
    return currentPageIndex;
  }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int contentOffsetX = scrollView.contentOffset.x;
  if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
    self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (_Pages == 2) {
      if (self.currentPageIndex == 0 || self.currentPageIndex == _Pages) {
        self.pageControl.currentPage = 0;
      } else if (self.currentPageIndex == (_Pages - 1) || self.currentPageIndex == 1) {
        self.pageControl.currentPage = _Pages - 1;
      } else {
        self.pageControl.currentPage = self.currentPageIndex;
      }
    } else {
      self.pageControl.currentPage = self.currentPageIndex;
    }
    [self.pageControl updateCurrentPageDisplay];
    [self configContentViews];
  }

  if (contentOffsetX <= 0) {
    self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    if (_Pages == 2) {
      if (self.currentPageIndex == 0 || self.currentPageIndex == _Pages) {
        self.pageControl.currentPage = 0;
      } else if (self.currentPageIndex == (_Pages - 1) || self.currentPageIndex == 1) {
        self.pageControl.currentPage = _Pages - 1;
      } else {
        self.pageControl.currentPage = self.currentPageIndex;
      }
    } else {
      self.pageControl.currentPage = self.currentPageIndex;
    }
    [self.pageControl updateCurrentPageDisplay];
    [self configContentViews];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer {
  if (self.animationTimer == nil) {
    return;
  }
  NSInteger contentOffsetX =
      (NSInteger)(self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame)) + 1;

  CGPoint newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * contentOffsetX,
                                  self.scrollView.contentOffset.y);
  [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
  if (self.TapActionBlock) {
    self.TapActionBlock(self.currentPageIndex);
  }
}

@end
