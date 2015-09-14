//
//  MarketHomeTableData.h
//  SimuStock
//
//  Created by Mac on 14-11-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "Globle.h"
#import "NSStringCategory.h"
#import "NSDataCategory.h"

@class HttpRequestCallBack;
/**
 *类说明：行情表格解析
 */
@interface MarketHomeTableData : BaseRequestObject <ParseCompressPointPacket>
//数据
@property(strong, nonatomic) NSMutableArray *dataList;
//取得行情数据
+ (void)getmarketRequestLinks:(NSString *)urlstr
                        start:(NSInteger)start
                       reqnum:(NSInteger)reqnum
                        order:(NSInteger)order
                 withCallback:(HttpRequestCallBack *)callback;
//大盘数据
+ (void)getmarketIndexRequestList:(NSString *)urlstr
                     withCallback:(HttpRequestCallBack *)callback;
//取得类型为2的接口
+ (void)getmarketRequestLinks:(NSString *)urlstr
                         code:(NSString *)code
                        start:(NSInteger)start
                       reqnum:(NSInteger)reqnum
                        order:(NSInteger)order
                 withCallback:(HttpRequestCallBack *)callback;

@end
