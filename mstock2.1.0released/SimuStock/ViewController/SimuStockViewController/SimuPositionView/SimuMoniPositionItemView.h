//
//  SimuMoniPositionItemView.h
//  SimuStock
//
//  Created by Mac on 13-12-13.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *类说明：模拟持仓表格单项
 */
@interface SimuMoniPositionItemView : UIView {
  //承载视图
  UIView *smpi_BaseView;
  //右侧滚动视图
  UIScrollView *smpi_RightScrollView;
  //纪录所有item指针
  NSMutableArray *smpi_ViewArray;
}
@property(readonly, nonatomic) UIView *baseview;
- (id)initWithFrame:(CGRect)frame
          HeadWidth:(int)headwidth
       ContentWidth:(int)contentwidth;
//加入持仓的股票代码头
- (void)addheadView:(UIView *)headView;
//加入持仓的股票代码各项目
- (void)addRightView:(UIView *)contentView;
- (void)addOpratinView:(UIView *)oprationView;
//设定滑动情况
- (void)resetScrolPos:(CGPoint)scrol_pos;

@end
