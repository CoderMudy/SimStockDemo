//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *  自动滚动，且可重复滑动的scrollView
 */
@interface CycleScrollView : UIView <UIScrollViewDelegate>

@property(nonatomic, readonly) UIScrollView *scrollView;

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame
        pageInteger:(NSInteger)pageInt
  animationDuration:(NSTimeInterval)animationDuration;
- (void)greateScrollViewPageInteger:(NSInteger)pageInt
                  animationDuration:(NSTimeInterval)animationDuration;

/** 回收资源，停止定时器 */
- (void)recyleResource;
/**
 数据源：获取总的page个数
 **/
@property(nonatomic, copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property(nonatomic, copy) UIView * (^fetchContentViewAtIndex)
    (NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property(nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);

@end