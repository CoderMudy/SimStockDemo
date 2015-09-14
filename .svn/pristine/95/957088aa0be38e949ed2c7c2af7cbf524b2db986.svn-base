//
//  StockUpdateItem.h
//  SimuStock
//
//  Created by Mac on 15/1/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StockFunds.h"
#import "PacketCompressPointFormatRequester.h"

@interface StockFunds (Update) <ParseJson>

@end

/** 类说明：股票元数据 */
@interface StockUpdateItemListWrapper
    : BaseRequestObject <ParseCompressPointPacket>

/** 更新股票数据数组*/
@property(strong, nonatomic) NSMutableArray *updateStocks;
/** 更新股票数据数组*/
@property(strong, nonatomic) NSMutableArray *updateStockIds;

/** 删除股票数据数组*/
@property(strong, nonatomic) NSMutableArray *deleteStockIds;

/** 更新股票信息*/
+ (void)incrementUpdateStockInfo;

@end
