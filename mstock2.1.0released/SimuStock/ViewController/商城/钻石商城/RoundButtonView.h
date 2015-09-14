//
//  RoundButtonView.h
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundButtonViewDelegate <NSObject>

- (void)roundSelectedChange:(NSInteger)index;

@end
/*
 *类说明：凹陷按钮选择工具栏
 */
@interface RoundButtonView : UIView {
  //上方按钮选中背景图区域
  CGRect sqv_buttonselbackRect[10];
  //按钮数组
  NSMutableArray *sqv_buttonArray;
  //当前按钮序列号
  NSInteger sqv_corTopButtonindex;
  //按钮动画是否开启
  BOOL sqv_isButtonAnimateRun;
  //按钮选中背景
  UIImageView *sqv_butselImageView;
}
@property(nonatomic, weak) id<RoundButtonViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
              DataArray:(NSArray *)dataArray
    withInitButtonIndex:(int)buttonIndex;
- (void)resetTabIndex:(NSInteger)index;
@end
