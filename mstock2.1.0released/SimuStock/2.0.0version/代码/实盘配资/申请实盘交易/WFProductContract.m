//
//  WFApplyForWFProduct.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFProductContract.h"

#pragma mark 申请配资产品合约出参及入参
@implementation WFMakeNewContractResult

@end

@implementation WFMakeNewContractParameter

@end

#pragma mark 配资产品合约展期出参及入参
@implementation WFExtendContractResult

@end

@implementation WFExtendContractParameter

@end

#pragma mark 追保出参及入参
@implementation WFAddBailContractResult

@end

@implementation WFAddBailContractParameter

@end

#pragma mark 查询当前借款合约列表及总资产情况
@implementation WFCurrentContractQueryOrderInfoList

- (void)jsonToObject:(NSDictionary *)dic {
  NSArray *resultArray = dic[@"result"];
  if (!resultArray) {
    self.isExist = NO;
    return;
  }
  self.isExist = YES;
  NSMutableArray *resultArrayM = [NSMutableArray array];
  [resultArray enumerateObjectsUsingBlock:^(NSDictionary *resultDic,
                                            NSUInteger idx, BOOL *stop) {
    WFContractInfo *info = [[WFContractInfo alloc] init];
    info.verifyStatus = [resultDic[@"verifyStatus"] integerValue];
    info.curAmount = @"审核中";
    info.totalAsset = [@([resultDic[@"cashAmount"] intValue]) stringValue];
    info.contractEndDate =
        [@([resultDic[@"orderAmount"] intValue]) stringValue];
    info.contractNo = [@([resultDic[@"orderNo"] intValue]) stringValue];
    info.totalProfit = [@([resultDic[@"pzPrice"] intValue]) stringValue];
    info.Amount = @"待审配资";
    [resultArrayM addObject:info];
  }];
  self.list = resultArrayM;
}
- (NSDictionary *)mappingDictionary {
  return @{ @"list" : NSStringFromClass([WFContractInfo class]) };
}

- (NSArray *)getArray {
  return _list;
}

@end

#pragma mark 查询当前借款合约列表及总资产情况
@implementation WFCurrentContractList

- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }

  self.openAccountStatus = [resultDic[@"openAccountStatus"] integerValue];
  self.totalAsset = resultDic[@"totalAsset"];
  self.totalMarketValue = resultDic[@"totalMarketValue"];
  self.totalProfit = resultDic[@"totalProfit"];
  self.enableWithdraw = resultDic[@"enableWithdraw"];
  self.curAmount = resultDic[@"curAmount"];
  self.beginAmount = resultDic[@"beginAmount"];
  self.cashAmount = resultDic[@"cashAmount"];
  NSArray *listArray = resultDic[@"contracts"];
  self.list = [[NSMutableArray alloc] init];
  [listArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx,
                                          BOOL *stop) {
    [_list addObject:[WFContractInfo contractInfoWithDictionary:dic]];
  }];
}

- (NSDictionary *)mappingDictionary {
  return @{ @"list" : NSStringFromClass([WFContractInfo class]) };
}

- (BOOL)hasWFAccount {
  return self.openAccountStatus == 0;
}

@end

@implementation WFContractInfo

+ (instancetype)contractInfoWithDictionary:(NSDictionary *)dic {
  WFContractInfo *info = [[WFContractInfo alloc] init];
  info.verifyStatus = 1; //审核通过的
  info.hsUserId = dic[@"hsUserId"];
  info.contractNo = [dic objectForKey:@"contractNo"];
  info.homsFundAccount = [dic objectForKey:@"homsFundAccount"];
  info.homsCombineId = [dic objectForKey:@"homsCombineId"];
  info.operatorNo = [dic objectForKey:@"operatorNo"];
  info.Amount = [dic objectForKey:@"amount"];
  info.prodId = dic[@"prodId"];
  info.prodTerm = [dic objectForKey:@"prodTerm"];
  info.contractEndDate = [dic objectForKey:@"contractEndDate"];
  info.totalProfit = [dic objectForKey:@"profit"];
  info.totalAsset = [dic objectForKey:@"assets"];
  info.curAmount = [dic objectForKey:@"curAmount"];
  return info;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  if (self = [super init]) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}

@end

@implementation WFInquireCurrentContractParameter

@end

#pragma mark 获取展期信息
@implementation WFGetPostponeInfoResult

- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }

  self.contractNo = resultDic[@"contractNo"];
  self.ygBalance = resultDic[@"ygBalance"];

  NSArray *dayArray = resultDic[@"dayArray"];
  NSMutableArray *dayArrayM = [NSMutableArray array];
  [dayArray
      enumerateObjectsUsingBlock:^(NSNumber *day, NSUInteger idx, BOOL *stop) {
        [dayArrayM addObject:[day stringValue]];
      }];
  self.dayArray = dayArrayM;

  NSArray *postponeJsonList = resultDic[@"postponeJsonList"];
  NSMutableArray *postponeJsonListM = [NSMutableArray array];
  [postponeJsonList enumerateObjectsUsingBlock:^(NSDictionary *dic,
                                                 NSUInteger idx, BOOL *stop) {
    [postponeJsonListM addObject:[WFGetPostponeDetailInfo
                                     getPostponeDetailInfoWithDictionary:dic]];
  }];
  self.postponeJsonList = postponeJsonListM;
}

- (WFGetPostponeDetailInfo *)getPostponeDetailInfoWithProdterm:
    (NSString *)prodTerm {
  for (WFGetPostponeDetailInfo *detaileInfo in self.postponeJsonList) {
    if ([detaileInfo.prodTerm isEqualToString:prodTerm]) {
      return detaileInfo;
    }
  }
  return nil;
}

@end

@implementation WFGetPostponeDetailInfo

+ (instancetype)getPostponeDetailInfoWithDictionary:(NSDictionary *)dic {
  WFGetPostponeDetailInfo *info = [[WFGetPostponeDetailInfo alloc] init];
  info.dayMgrAmount = [dic objectForKey:@"dayMgrAmount"];
  info.endDay = [dic objectForKey:@"endDay"];
  info.mgrAmount = [dic objectForKey:@"mgrAmount"];
  info.prodTerm = [dic objectForKey:@"prodTerm"];
  info.startDay = [dic objectForKey:@"startDay"];
  info.prodId = [dic objectForKey:@"prodId"];
  return info;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  if (self = [super init]) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}

@end

#pragma mark 获取追保信息
@implementation WFGetCashAmountInfoResult

- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.contractNo = resultDic[@"contractNo"];
  self.cashAmount = resultDic[@"cashAmount"];
  self.flatLine = resultDic[@"flatLine"];
  self.warningLine = resultDic[@"warningLine"];
  self.totalAsset = resultDic[@"totalAsset"];
  self.czFlag = [resultDic[@"czFlag"] boolValue];
  self.addBigPrice = resultDic[@"addBigPrice"];
  self.addLittlePrice = resultDic[@"addLittlePrice"];
  self.ygBalance = resultDic[@"ygBalance"];
}

@end

#pragma mark 申请配资产品合约调用
@implementation WFProductContract

+ (void)makeWFContractWithProductInfo:(WFMakeNewContractParameter *)product
                          andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/makeNewContract"];

  NSDictionary *parametersDictionary = @{
    @"cashAmount" : product.cashAmount,
    @"loanAmount" : product.loanAmount,
    @"prodId" : product.prodId,
    @"prodTerm" : product.prodTerm,
    @"totalAmount" : product.totalAmount,
    @"mgrAmount" : product.mgrAmount,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFMakeNewContractResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 配资产品合约展期调用
+ (void)extendWFProductContractWithContractNo:(NSString *)contractNo
                                    andProdId:(NSString *)prodId
                                  andProdTerm:(NSString *)prodTerm
                             andOrderAbstract:(NSString *)orderAbstract
                               andTotalAmount:(NSString *)totalAmount
                                  andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/extendContract"];

  NSDictionary *parametersDictionary = @{
    @"contractNo" : contractNo,
    @"prodId" : prodId,
    @"prodTerm" : prodTerm,
    @"orderAbstract" : orderAbstract,
    @"totalAmount" : totalAmount,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFExtendContractResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 追保调用
+ (void)addWFProductBailContractWithContractNo:(NSString *)contractNo
                                andTransAmount:(NSString *)transAmount
                                     andRemark:(NSString *)remark
                                   andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/addBailContract"];

  NSDictionary *parametersDictionary = @{
    @"contractNo" : contractNo,
    @"transAmount" : transAmount,
    @"remark" : remark,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFExtendContractResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 查询当前借款合约列表及总资产情况调用
+ (void)inquireWFProductCurrentContractandCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/queryContract"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:nil
              withRequestObjectClass:[WFCurrentContractList class]
             withHttpRequestCallBack:callback];
}

/** 查询当前是否有带审核中得合约*/
+ (void)inquireWFProductCurrentContractQueryOrderInfoCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/queryOrderInfo"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:nil
              withRequestObjectClass:[WFCurrentContractQueryOrderInfoList class]
             withHttpRequestCallBack:callback];
}

#pragma mark 获取展期信息
+ (void)getPostponeInfoWithContractNo:(NSString *)contractNo
                          andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/getPostponeInfo"];

  NSDictionary *parametersDictionary = @{
    @"contractNo" : contractNo,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFGetPostponeInfoResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 获取追保信息
+ (void)getCashAmountInfoWithContractNo:(NSString *)contractNo
                            andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Contract_Address stringByAppendingFormat:@"/getCashAmountInfo"];
  
  NSDictionary *parametersDictionary = @{
    @"contractNo" : contractNo,
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFGetCashAmountInfoResult class]
             withHttpRequestCallBack:callback];
}

@end
