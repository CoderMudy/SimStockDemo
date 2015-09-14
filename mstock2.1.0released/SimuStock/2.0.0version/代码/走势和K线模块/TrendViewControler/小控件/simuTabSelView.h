//
//  simuTabSelView.h
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/// tab选中的回调通知，通知观察者
typedef void (^TabSeclectedAction)(NSInteger index);

/*
 *类说明：上方的TabSel小控件
 */
@interface simuTabSelView : UIView {

  ///标题内容
  NSMutableArray *_tabTitleArray;

  ///标题内容
  NSMutableArray *_seperateLineArray;

  ///当前选中项目
  NSInteger _selectedTabIndex;

  ///低细线
  UIView *_bottomLineView;

//  /** 按钮下面的蓝色条 */
//  UIView *_blueLineView;

  /// tab按钮的宽度
  CGFloat tabButtonWidth;
}

/** 粗线 */
@property(nonatomic, strong) UIView *blueLineView;
/// tab选中的回调通知，通知观察者
@property(nonatomic, copy) TabSeclectedAction tabSelectedAtIndex;

/** 按钮内容，方便外面取得具体个数从而精确计算滑动块移动 */
@property(nonatomic, strong) NSMutableArray *tabButtonArray;

/** 初始化*/
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;

/** 重置tab按钮数组及选中按钮位置 */
- (void)resetTabTitleArray:(NSArray *)titleArray
          andSelectedIndex:(NSInteger)index;

- (void)createIndicatorLine;

/** 点击指定位置的按钮*/
- (void)buttonSelectedAtIndex:(NSInteger)index animation:(BOOL)animation;

@end

/*
 *类说明：上方的TabSel小控件
 */
@interface SimuBottomTabView : simuTabSelView

@end
