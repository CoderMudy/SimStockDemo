//
//  SimuProfitLinePageData.h
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuPageData.h"
/*
 *类说明：盈利曲线点数据
 */
@interface SimuPointData:NSObject
{
    //时间
    NSString * spd_Date;
    //用户盈利率
    CGFloat spd_MyProfit;
    //平均盈利率
    CGFloat spd_AvgProfit;
}

@property (strong,nonatomic) NSString * Date;
@property (assign) CGFloat MyProfit;
@property (assign) CGFloat AvgProfit;


@end

/*
 *类说明：盈利曲线数据
 */
@interface SimuProfitLinePageData : SimuPageData
{
    //盈利曲线数据
    NSMutableArray * splpd_DataArray;
}

@property (strong,nonatomic) NSMutableArray * DataArray;

@end
