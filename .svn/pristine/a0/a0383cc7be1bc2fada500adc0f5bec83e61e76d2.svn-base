//
//  SimuGainsView.h
//  SimuStock
//
//  Created by Mac on 13-8-17.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuSMonyPageData.h"
#import "UserAccountPageData.h"
/*
 *类说明：盈亏展示小控件
 */
@interface SimuGainsView : UIView {
  //浮动盈亏
  UILabel *sgv_floatProfitLable;
  //浮动盈亏数值
  UILabel *sgv_floatValuesLable;
  //持股市值
  UILabel *sgv_stockLable;
  //持股市值的数量
  UILabel *sgv_stockValuesLable;
  //资金余额
  UILabel *sgv_foundTitleLable;
  //资金余额数值
  UILabel *sgv_fonundValueLable;
  //总资产
  UILabel *sgv_totolAssetLable;
  //总资产数值
  UILabel *sgv_totolAssetValuesLable;
  //背景图片
  UIImageView *sgv_backImageView;
  //数据页面
  UserAccountPageData *__weak sgv_pagedata;
  //背景区域
  CGRect sgv_backimageRect;
}

- (void)setPagedata:(MatchUserAccountData *)pagedata;

@end
