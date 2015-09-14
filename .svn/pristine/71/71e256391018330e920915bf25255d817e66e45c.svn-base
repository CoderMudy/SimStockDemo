//
//  SimuProfitLinePageData.m
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuProfitLinePageData.h"

@implementation SimuPointData

@synthesize Date=spd_Date;
@synthesize MyProfit=spd_MyProfit;
@synthesize AvgProfit=spd_AvgProfit;


- (id) init
{
	self = [super init];
	if (self)
	{
        self.Date=nil;
        self.MyProfit=0;
        self.AvgProfit=0;
    }
    return self;
}

-(void)dealloc
{
    
    self.MyProfit=0;
    self.AvgProfit=0;
    
}

@end


/************************************************************
 ************************* new class ************************
 ************************************************************
 */
@implementation SimuProfitLinePageData

@synthesize DataArray=splpd_DataArray;

- (id) init
{
	self = [super init];
	if (self)
	{
        self.pagetype=DataPageType_Simu_Account_ProfitLine;
        splpd_DataArray=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    
    [self.DataArray removeAllObjects];
    
}



@end
