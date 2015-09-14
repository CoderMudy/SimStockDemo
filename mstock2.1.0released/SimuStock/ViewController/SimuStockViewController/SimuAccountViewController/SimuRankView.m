//
//  SimuRankView.m
//  SimuStock
//
//  Created by Yuemeng on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuRankView.h"
#import "SimuRankPageData.h"
//#import "SimuUtil.h"
#import "StockUtil.h"

@implementation SimuRankView

- (void)layoutSubviews
{
  [super layoutSubviews];
  _spaceViewWidth.constant = self.width / 32.f * 2;
}

- (void)setPagedata:(SimuRankPageData *)pagedata {

  //周、月、总盈利
  _wProfitLabel.text = pagedata.wProfit;
  _wProfitLabel.textColor = [StockUtil getColorByProfit:pagedata.wProfit];

  _mProfitLabel.text = pagedata.mProfit;
  _mProfitLabel.textColor = [StockUtil getColorByProfit:pagedata.mProfit];

  _tProfitLabel.text = pagedata.tProfit;
  _tProfitLabel.textColor = [StockUtil getColorByProfit:pagedata.tProfit];

  //周、月、总排名
  _wRankLabel.text = pagedata.wRank;
  _mRankLabel.text = pagedata.mRank;
  _tRankLabel.text = pagedata.tRank;

  //周、月、总箭头
  _wArrow.image = ([pagedata.wRise intValue] >= 0)
                      ? [UIImage imageNamed:@"SST_Rank_uparrow.png"]
                      : [UIImage imageNamed:@"SST_Rank_downarrow.png"];
  _mArrow.image = ([pagedata.mRise intValue] >= 0)
                      ? [UIImage imageNamed:@"SST_Rank_uparrow.png"]
                      : [UIImage imageNamed:@"SST_Rank_downarrow.png"];
  _tArrow.image = ([pagedata.tRise intValue] >= 0)
                      ? [UIImage imageNamed:@"SST_Rank_uparrow.png"]
                      : [UIImage imageNamed:@"SST_Rank_downarrow.png"];

  //周、月、总上升、下降名次
  _wRise.text = [pagedata.wRise hasPrefix:@"-"] ? [pagedata.wRise substringFromIndex:1] : pagedata.wRise;
  _mRise.text = [pagedata.mRise hasPrefix:@"-"] ? [pagedata.mRise substringFromIndex:1] : pagedata.mRise;
  _tRise.text = [pagedata.tRise hasPrefix:@"-"] ? [pagedata.tRise substringFromIndex:1] : pagedata.tRise;
}

@end
