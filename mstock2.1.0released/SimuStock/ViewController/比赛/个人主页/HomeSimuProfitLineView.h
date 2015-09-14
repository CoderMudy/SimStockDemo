//
//  HomeSimuProfitLineView.h
//  SimuStock
//
//  Created by moulin wang on 14-5-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuProfitLinePageData.h"

//定义走势每一个数据得宽度
#define WIDTH_X 8
/*
 *类说明：盈利曲线控件
 */

@interface HomeSimuProfitLineView : UIView {
  //利率曲线上部分区域
  CGRect spflv_topRect;
  //利率曲线划线部分区域
  CGRect spflv_centerRect;
  //利率曲线下部分区域
  CGRect spflv_bottomRect;
  //总利率曲线名称
  UILabel *spflv_tProfitNameLable;
  //个人曲线颜色说明
  UIView *spflv_myCorlorView;
  //个人昵称
  UILabel *spflv_myNickNameLable;
  //平均盈利颜色说明
  UIView *spflv_arvCorlorView;
  //平均颜色名称
  UILabel *spflv_arvNameLable;
  //纵坐标刻度(自上而下)
  UILabel *spflv_verScaleLable1;
  UILabel *spflv_verScaleLable2;
  UILabel *spflv_verScaleLable3;
  UILabel *spflv_verScaleLable4;
  UILabel *spflv_verScaleLable5;

  //横坐标刻度（自左而右）
  UILabel *spflv_horScaleLable1;
  UILabel *spflv_horScaleLable2;
  UILabel *spflv_horScaleLable3;
  UILabel *spflv_horScaleLable4;
  //数据页面
  SimuProfitLinePageData *spflv_pagedata;
  //开始位置
  NSInteger spflv_startIndex;
  //画图结束位置
  NSInteger spflv_endIndex;
  //纵坐标刻度
  CGFloat spflv_scarl[5];
  //是否可移动
  BOOL spflv_isMove;
  //我的盈利曲线点
  NSMutableArray *spflv_MyProArray;
  //均线盈利曲线点
  NSMutableArray *spflv_ArgProArray;
  //纪录上次鼠标点击位置
  CGPoint spflv_lastPos;
  //最大显示天数
  NSInteger spflv_showDays;
}

@property(strong, nonatomic) SimuProfitLinePageData *pagedata;
- (void)setPagedata:(SimuProfitLinePageData *)pagedata;
@end
