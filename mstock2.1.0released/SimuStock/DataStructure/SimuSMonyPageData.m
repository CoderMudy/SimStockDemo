//
//  SimuSMonyPageData.m
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuSMonyPageData.h"

@implementation SimuSMonyPageData

@synthesize StockValue=sspd_StockValue;
@synthesize ProfitMoney=sspd_ProfitMoney;
@synthesize Rank=sspd_Rank;
@synthesize isResetTip=sspd_isResetTip;
@synthesize VipState=sspd_VipState;
@synthesize VipValuesDays=sspd_VipValuesDays;
@synthesize FundBalance=sspd_FundBalance;
@synthesize PerOfProfit=sspd_PerOfProfit;
@synthesize TotalAssets=sspd_TotalAssets;

- (id) init
{
	self = [super init];
	if (self)
	{
        self.pagetype=DataPageType_Simu_Account_Asset;
        self.StockValue=nil;
        self.ProfitMoney=nil;
        self.Rank=nil;
        self.isResetTip=NO;
        self.VipState=nil;
        self.VipValuesDays=nil;
        self.FundBalance=nil;
        self.PerOfProfit=nil;
        self.TotalAssets=nil;
    }
    return self;
}

-(void)dealloc
{
    self.isResetTip=NO;
    
}

@end
