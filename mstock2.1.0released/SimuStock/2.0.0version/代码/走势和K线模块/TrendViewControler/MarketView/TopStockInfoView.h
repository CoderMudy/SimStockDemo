//
//  topStockInfoView.h
//  SimuStock
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuStockInfoData.h"
#import "TrendKLineModel.h"
typedef enum {
  //大盘类股票
  sit_Dapa_Mode,
  //个股类股票
  sit_Gegu_Mode,
} stockInfnType;

/**
 *类说明：行情页面上方的股票信息
 */
@interface TopStockInfoView : UIView {
  //背景
  UIImageView *tsiv_backgroundImageView;
  //当前价格
  UILabel *tsiv_stockPriceLable;
  //当前涨跌价格
  UILabel *tsiv_changePriceLable;
  //当前涨跌幅度
  UILabel *tsiv_profitPriceLable;
  //分割线
  UIView *tsiv_sepLineView;
  //左一名称
  UILabel *tsiv_LeftOneNameLable;
  //左一数值
  UILabel *tsiv_LeftOneValueLable;
  //左二名称
  UILabel *tsiv_LeftTowNameLable;
  //左二数值
  UILabel *tsiv_LeftTowValueLable;
  //右一名称
  UILabel *tsiv_rightOneNameLable;
  //右一数值
  UILabel *tsiv_rightOneValueLable;
  //右二名称
  UILabel *tsiv_rightTwoNameLable;
  //右二数值
  UILabel *tsiv_rightTwoValueLable;

  //上方第一行第一列名称
  UILabel *tsiv_TopOneNameLable;
  //上方第一行第一列数值
  UILabel *tsiv_TopOneValueLable;
  //上方第一行第二列名称
  UILabel *tsiv_TopTowNameLable;
  //上方第一行第二列数值
  UILabel *tsiv_TopTowValueLable;
  //上方第一行第三列名称
  UILabel *tsiv_TopthreeNameLable;
  //上方第一行第三列数值
  UILabel *tsiv_TopthreeValueLable;

  //上方第二行第一列名称
  UILabel *tsiv_CenterOneNameLable;
  //上方第二行第一列数值
  UILabel *__weak tsiv_CenterOneValueLable;
  //上方第一行第二列名称
  UILabel *tsiv_CenterTowNameLable;
  //上方第一行第二列数值
  UILabel *__weak tsiv_CenterTowValueLable;
  //上方第一行第三列名称
  UILabel *tsiv_CenterthreeNameLable;
  //上方第一行第三列数值
  UILabel *__weak tsiv_CenterthreeValueLable;
  //第三行第一列名称
  UILabel *__weak tsiv_bottomOneNameLable;
  UILabel *__weak tsiv_bottomOneValueLable;
  //第三行第二列名称
  UILabel *__weak tsiv_bottomTowNameLable;
  UILabel *__weak tsiv_bottomTowValueLable;
  //第三行第二列名称
  UILabel *__weak tsiv_bottomThreeNameLable;
  UILabel *__weak tsiv_bottomThreeValueLable;

  //当前是否大盘
  BOOL tsiv_CorIsTrend;
}
@property(weak, nonatomic) UILabel *CenterOneValueLable;
@property(weak, nonatomic) UILabel *CenterTowValueLable;
@property(weak, nonatomic) UILabel *CenterthreeValueLable;

- (id)initWithFrame:(CGRect)frame IsDapa:(BOOL)isdapan;
- (void)setHeadStcokInfo:(StockQuotationInfo *)Item IsDapan:(BOOL)isdapan;
//取得最新价格
- (NSString *)getNewPrice;
//取得涨跌幅
- (NSString *)getProfit;
//取得涨跌额
- (NSString *)getUpDownPrice;
//清除数据
- (void)clearallData;

@end
