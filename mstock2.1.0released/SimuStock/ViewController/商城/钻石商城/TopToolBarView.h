//
//  TopToolBarView.h
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopToolBarViewDelegate <NSObject>

//点击标签回调
- (void)changeToIndex:(NSInteger)index;

@end

/*
 *类说明：上选择工具栏
 */
@interface TopToolBarView : UIView {
  //低细线
  UIView *_bottomLineView;
  //当前选中
  NSInteger _currentSelectedIndex;
  //按钮数组
  NSMutableArray *_buttonArray;
  //按钮区域数组
  CGRect _rectArray[10];
  //是否在动画显示中
  BOOL _isAnimationStarting;
}

/** 粗线 */
@property(nonatomic, strong) UIView *maxlineView;

@property(weak, nonatomic) id<TopToolBarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
              DataArray:(NSArray *)dataArray
    withInitButtonIndex:(int)buttonIndex;

- (void)changTapToIndex:(NSInteger)index;
@end
