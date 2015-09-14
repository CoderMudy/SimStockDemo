//
//  WFInquireProductInfo.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFInquireProductInfo.h"
@implementation WFProductButtonStateData

@end

@implementation WFProductListInfo

- (void)addObject:(NSString *)obj toArray:(NSMutableArray *)array {
  if ([array containsObject:obj]) {
    return;
  }

  __block BOOL inserted = NO;
  [array
      enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] < [item integerValue]) {
          inserted = YES;
          [array insertObject:obj atIndex:idx];
          *stop = YES;
        }
      }];
  if (!inserted) {
    [array addObject:obj];
  }
}

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  self.defaultAmount = [@([resultDic[@"defaultMoney"] intValue]) stringValue];
  self.defaultDay = [@([resultDic[@"defaultDay"] intValue]) stringValue];
  self.ygBalance = [@([resultDic[@"ygBalance"] intValue]) stringValue];

  NSMutableArray *productListM = [NSMutableArray array];
  [(NSArray *)(resultDic[@"productJsonList"])
      enumerateObjectsUsingBlock:^(NSDictionary *productListDic, NSUInteger idx,
                                   BOOL *stop) {
        WFOneProductInfo *productList =
            [WFOneProductInfo oneProductInfoWithDictionary:productListDic];
        [productListM addObject:productList];
      }];
  self.productJsonList = [productListM copy];

  _days = [[NSMutableArray alloc] init];
  _amounts = [[NSMutableArray alloc] init];
  __block NSMutableDictionary *warnlineDicM = [NSMutableDictionary dictionary];
  __block NSMutableDictionary *flatlineDicM = [NSMutableDictionary dictionary];

  //{{"500000":[2,3,5]},{@"200000":[5,20]}}
  _amountToDays = [[NSMutableDictionary alloc] init];
  [_productJsonList enumerateObjectsUsingBlock:^(WFOneProductInfo *obj,
                                                 NSUInteger idx, BOOL *stop) {
    [self addObject:obj.financingPrice toArray:_amounts];
    NSMutableArray *daysOfAmount = _amountToDays[obj.financingPrice];
    [self addObject:obj.prodTerm toArray:_days];
    if (daysOfAmount == nil) {
      _amountToDays[obj.financingPrice] = [[NSMutableArray alloc] init];
      daysOfAmount = _amountToDays[obj.financingPrice];
    }
    [self addObject:obj.prodTerm toArray:daysOfAmount];
    [warnlineDicM setObject:obj.warningLine forKey:obj.financingPrice];
    [flatlineDicM setObject:obj.flatLine forKey:obj.financingPrice];
  }];
  self.warnlineDic = warnlineDicM;
  self.flatlineDic = flatlineDicM;
  _amountStatusA = resultDic[@"moneyStatusArray"];
  if (!_amountStatusA) {
    _amountStatusA = [NSMutableArray array];
  }
  if ([self.defaultAmount isEqualToString:@"0"]) {
    _amountStatusA = [_amountStatusA mutableCopy];
    [_amountStatusA
        enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          _amountStatusA[idx] = @1;
        }];
  }
}

- (WFOneProductInfo *)getOneProductInfoWithAmount:(NSString *)moneyAmountString
                                           andDay:(NSString *)day {
  int moneyAmount = [moneyAmountString intValue];
  int prodTerm = [day intValue];
  for (WFOneProductInfo *oneProductInfo in self.productJsonList) {
    if (moneyAmount == [oneProductInfo.financingPrice intValue] &&
        prodTerm == [oneProductInfo.prodTerm intValue]) {
      return oneProductInfo;
    }
  }
  return nil;
}

@end

@implementation WFOneProductInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  if (self = [super init]) {
    if (dic == nil) {
      return nil;
    }
    self.prodId = dic[@"prodId"];
    self.prodTerm = dic[@"prodTerm"];
    self.financingPrice = dic[@"financingPrice"];
    self.startDay = dic[@"startDay"];
    self.endDay = dic[@"endDay"];
    self.cashAmount = dic[@"cashAmount"];
    self.mgrAmount = dic[@"mgrAmount"];
    self.totalAmount = dic[@"totalAmount"];
    self.warningLine = dic[@"warningLine"];
    self.flatLine = dic[@"flatLine"];
  }
  return self;
}

+ (instancetype)oneProductInfoWithDictionary:(NSDictionary *)dic {
  return [[WFOneProductInfo alloc] initWithDictionary:dic];
}

@end

#pragma mark
#pragma mark 配置产品查询接口调用

@implementation WFInquireProductInfo

+ (void)inquireWFProductInfoWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@stockFinWeb/product/findNewProductList",
                                 With_Capital_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFProductListInfo class]
             withHttpRequestCallBack:callback];
}

@end
