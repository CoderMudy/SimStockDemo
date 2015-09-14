//
//  SimuChechBoxView.h
//  SimuStock
//
//  Created by Mac on 13-8-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

/**
 选中或取消选中的回调函数
 */
typedef void (^onSelected)(BOOL isSecected);

/**
 选中或取消选中的回调函数
 */
typedef void (^onTableRowSelected)(NSInteger rowIndex, BOOL isSecected);

/*
 *类说明：复选框控件
 */
#import <UIKit/UIKit.h>
#import "YRBorderView.h"

@interface SimuChechBoxView : YRBorderView {

  //选中时候的图片
  UIImageView *checkMarkImageView;

  //当前的状态 yes 选中 no 未选中
  BOOL scb_isDown;
  //当前行标记
  NSInteger scb_row;
  //当前列标记
  NSInteger scb_col;
}

@property(assign) NSInteger row;
@property(assign) NSInteger col;
@property(assign) BOOL isDown;
/**
 选中或取消选中的回调函数
 */
@property(copy, atomic) onSelected onSelectedCallback;

- (void)setSelected:(BOOL)isSelected;

@end
