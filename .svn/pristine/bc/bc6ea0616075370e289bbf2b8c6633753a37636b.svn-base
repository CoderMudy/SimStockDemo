//
//  SimuTableView.h
//  SimuStock
//
//  Created by Mac on 13-8-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：封装多列表格
 */
#import <UIKit/UIKit.h>
#import "SimuTableDataResouce.h"
#import "SimuMoniPositionItemView.h"

@protocol SimuTableViewDelegate <NSObject>

- (void)SimuTableItemDidSelected:(NSInteger)selected_index;

@end

@interface SimuTableView : UIView <UIScrollViewDelegate> {
  //左边滚动视图
  UIScrollView *_leftScrollView;
  //右边滚动视图
  UIScrollView *_rightScrollView;
  //头标题左边视图
  UIImageView *_leftHeadView;
  //头标题右边视图
  UIImageView *_rightHeadView;
  //左边滚动视图上的cell内容承载视图
  UIView *_letfContentView;
  //右边滚动视图上的cell内容承载视图
  UIView *_rightContentView;
  //移动距离
  float _heightMoveHeight;
  //上次点击位置
  CGPoint _lastpos;
  //上次抬起位置
  CGPoint _lastUpPos;
  //选中效果视图
  UIView *_selectedView;
  NSInteger _index;
  //是否持仓页面
  BOOL _isPositon;
  //如果是持仓，则从外部得到持仓页面工具栏控件
  UIView *_interstingView;
  SimuMoniPositionItemView *_moniItemView;
  //
  UIView *teiew;
}

@property(strong, nonatomic) SimuTableDataResouce *dataResource;
@property(weak, nonatomic) id delegate;
//重新设置表格数据
- (void)resetTable;
- (void)clearTableContent;
- (void)resetTableForSelfStock;

//得到刷新用的滚动视图
- (UIScrollView *)getUpdateScrollView;

//设定表格是否可以滑动
- (void)setScrollVisible:(BOOL)isVisible;
//重新设置表格视图大小
- (void)resetTableSize;
//为自选股表格重新设置内容清除上次设置的内容
- (void)clearTableContentForSelfStock;
@end
