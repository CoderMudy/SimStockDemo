//
//  SelfStockTableModel.h
//  SimuStock
//
//  Created by Mac on 14-10-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globle.h"
#import "BaseRequestObject.h"
#import "NSStringCategory.h"

@class HttpRequestCallBack;

/*
 *类说明：表格数据结构
 */

@interface SelfStockItem : NSString <ParseJson>

///8位股票代码
@property(nonatomic, strong) NSString *code;
///6位股票代码
@property(nonatomic, strong) NSString *stockCode;

@property(nonatomic, strong) NSString *stockName;
@property(nonatomic, strong) NSString *firstType;
@property(nonatomic, assign) float curPrice;
@property(nonatomic, assign) float dataPer;
@property(nonatomic, assign) float change;

- (NSString *)objectForKey:(NSString *)key;

@end

@interface StockTableData : BaseRequestObject <ParseCompressPointPacket,Collectionable>

/** 多条自选股*/
@property(strong, nonatomic) NSMutableArray *stocks;

/**
 *下载自选股信息
 */
+ (void)getSelfStockInfo:(NSString *)stringStock
            withCallback:(HttpRequestCallBack *)callback;

@end
