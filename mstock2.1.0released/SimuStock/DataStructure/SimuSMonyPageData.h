//
//  SimuSMonyPageData.h
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：用户资产查询数据页面
 *
 */
#import "SimuPageData.h"

@interface SimuSMonyPageData : SimuPageData
{
    //持股市值
    NSString * sspd_StockValue;
    //浮动盈亏
    NSString * sspd_ProfitMoney;
    //排名
    NSString * sspd_Rank;
    //是否提示重置
    BOOL sspd_isResetTip;
    //vip状态显示 -1 (vip冻结) 0 （vip不重置）  1（vip 重置）
    NSString * sspd_VipState;
    //vip 有效天数
    NSString * sspd_VipValuesDays;
    //资金余额
    NSString * sspd_FundBalance;
    //总盈利
    NSString * sspd_PerOfProfit;
    //总资产
    NSString * sspd_TotalAssets;
    
}

@property (copy,nonatomic)NSString * StockValue;
@property (copy,nonatomic)NSString * ProfitMoney;
@property (copy,nonatomic)NSString * Rank;
@property (assign)BOOL isResetTip;
@property (copy,nonatomic)NSString * VipState;
@property (copy,nonatomic)NSString * VipValuesDays;
@property (copy,nonatomic)NSString * FundBalance;
@property (copy,nonatomic)NSString * PerOfProfit;
@property (copy,nonatomic)NSString * TotalAssets;

@end
