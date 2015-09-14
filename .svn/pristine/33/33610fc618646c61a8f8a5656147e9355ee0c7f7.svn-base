//
//  Stocks.h
//  SimuStock
//
//  Created by Mac on 14-8-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@interface klineDataItem2 : NSObject <ParseJson> {
  //收盘价
  float kldi_closeprice;
  //最高价
  float kldi_highprice;
  //最低价
  float kldi_lowprice;
  //开盘价
  float kldi_openprice;
  //昨收价
  float kldi_yestodaycloseprice;
  //日期
  long kldi_data;
  //结束如期
  long kldi_enddata;
  //成交量
  int64_t kldi_volume;
  //成交额
  int64_t kldi_turnover;
}
@property(assign, nonatomic) float closeprice;
@property(assign, nonatomic) float highprice;
@property(assign, nonatomic) float lowprice;
@property(assign, nonatomic) float openprice;
@property(assign, nonatomic) float yestodaycloseprice;
@property(assign, nonatomic) long data;
@property(assign, nonatomic) long enddata;
@property(assign, nonatomic) int64_t volume;
@property(assign, nonatomic) int64_t turnover;
@end

@interface Stocks : BaseRequestObject
@property(nonatomic, strong) NSMutableArray *stockTable;

+ (void)test;
@end
