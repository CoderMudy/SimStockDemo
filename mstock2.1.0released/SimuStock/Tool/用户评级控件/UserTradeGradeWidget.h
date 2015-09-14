//
//  UserTradeGradeWidget.h
//  SimuStock
//
//  Created by Yuemeng on 15/3/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserTradeGradeItem;
@class Flowers;
@class ArcAndNumberView;

/** 用户交易评级控件 */
@interface UserTradeGradeWidget : UIView
{
  // 1.3名称
  UILabel *titleLabel;
    ///大花
  Flowers *_flowers;
    ///评级等级
  UILabel *_gradeLabel;
    ///盈利性
  ArcAndNumberView *_profitView;
    ///稳定性
  ArcAndNumberView *_stableView;
    ///准确性
  ArcAndNumberView *_accurateView;
}

/** 刷新数据 */
- (void)refreshData:(UserTradeGradeItem *)item;

@end
