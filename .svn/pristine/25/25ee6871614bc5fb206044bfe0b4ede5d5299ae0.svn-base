//
//  WFAccountInterface.m
//  SimuStock
//
//  Created by Jhss on 15/4/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFAccountInterface.h"

#pragma mark
/** 1.1查询优顾账户的资产 */
@implementation WFAccountBalance

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *account = resultDic[@"account"];
  self.yid = [account[@"id"] intValue];
  self.uid = [account[@"uid"] intValue];
  self.amount = [@([account[@"amount"] integerValue]) stringValue];
  self.BankFee = [@([account[@"extra"][@"withdrawFee"] intValue]) stringValue];
}
@end

#pragma mark
/** 1.2资金明细流水 */
@implementation WFCapitalSubsidiary

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *accountDic = resultDic[@"account"];
  self.yid = [accountDic[@"id"] intValue];
  self.uid = [accountDic[@"uid"] intValue];
  self.amount = [accountDic[@"amount"] stringValue];

  self.cash_flow_list = [NSMutableArray array];
  NSMutableArray *cashFlowArr = [NSMutableArray array];
  [resultDic[@"cash_flow_list"] enumerateObjectsUsingBlock:^(NSDictionary *obj,
                                                             NSUInteger idx,
                                                             BOOL *stop) {
    WFCashFlowList *cashFlow = [WFCashFlowList cashFlowListWithDictionary:obj];
    [cashFlowArr addObject:cashFlow];
  }];
  self.cash_flow_list = cashFlowArr;
}
- (NSArray *)getArray {
  return _cash_flow_list;
}

@end

@implementation WFCashFlowList

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  if (self = [super init]) {
    self.youguuId = [dic[@"youguuId"] intValue];
    self.flowType = dic[@"flowType"];
    self.flowDesc = dic[@"flowDesc"];
    self.flowDatetime = [dic[@"flowDatetime"] stringValue];
    self.flowAmount = [dic[@"flowAmount"] stringValue];
    self.accountBalance = [dic[@"accountBalance"] stringValue];
    self.NumberId = dic[@"id"];
  }
  return self;
}

+ (instancetype)cashFlowListWithDictionary:(NSDictionary *)dic {
  return [[[self class] alloc] initWithDictionary:dic];
}

@end

#pragma mark
/** 1.3账户充值  给优顾账户充值 */
@implementation WFPayAccountResult

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  self.order_no = resultDic[@"order_no"];
}

@end
#pragma mark 1.4 查询用户绑定的银行卡出参
/** 1.4.1 优顾渠道：查询用户绑定的银行卡出参解析 */
@implementation WFBindedBankcardYouGuuResult
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *bankCardDic = resultDic[@"bank_card"];
  if (bankCardDic == nil) {
    self.isbind = NO;
    return;
  }
  self.isbind = YES;
  self.bank_logo = bankCardDic[@"bank_logo"];
  self.bank_name = bankCardDic[@"bank_name"];
  self.cardNo = bankCardDic[@"cardNo"];

  self.acctName = bankCardDic[@"acctName"];
  self.bankId = [@([bankCardDic[@"bankId"] intValue]) stringValue];
  self.cardStatus = [@([bankCardDic[@"cardStatus"] intValue]) stringValue];
  self.channel = [@([bankCardDic[@"channel"] intValue]) stringValue];
  self.idNo = [@([bankCardDic[@"idNo"] intValue]) stringValue];
  self.uid = [@([bankCardDic[@"uid"] intValue]) stringValue];
}
@end

/** 1.4.2 连连支付渠道：查询用户绑定的银行卡出参解析 */
@implementation WFBindedBankcardLianLianPayResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *bankCardDic = resultDic[@"bank_card"];
  if (bankCardDic == nil) {
    self.isbind = NO;
    return;
  }
  self.isbind = YES;
  self.bank_logo = bankCardDic[@"bank_logo"];
  self.bank_name = bankCardDic[@"bank_name"];
  self.bind_mobile = bankCardDic[@"bind_mobile"];
  self.card_no = bankCardDic[@"cardNo"];
  self.card_type = bankCardDic[@"cardStatus"];
  self.no_agree = bankCardDic[@"no_agree"];

  self.acctName = bankCardDic[@"acctName"];
  self.bankId = [@([bankCardDic[@"bankId"] intValue]) stringValue];
  self.cardStatus = [@([bankCardDic[@"cardStatus"] intValue]) stringValue];
  self.channel = [@([bankCardDic[@"channel"] intValue]) stringValue];
  self.idNo = [@([bankCardDic[@"idNo"] intValue]) stringValue];
  self.uid = [@([bankCardDic[@"uid"] intValue]) stringValue];
}
@end

/** 1.4.3 易宝支付渠道：查询用户绑定的银行卡出参 */
@implementation WFBindedBankcardYeePayResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *bankCardDic = resultDic[@"bank_card"];
  if (bankCardDic == nil) {
    self.isbind = NO;
    return;
  }
  self.isbind = YES;
  self.bank_logo = bankCardDic[@"bank_logo"];
  self.bank_name = bankCardDic[@"bank_name"];
  self.card_last = bankCardDic[@"card_last"];
  self.card_top = bankCardDic[@"card_top"];
  self.phone = bankCardDic[@"phone"];
}
@end

#pragma mark 1.7 申请提现
@implementation WFWithdrawResult

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end

#pragma mark 1.8查询提现明细
@implementation WFWithdrawListResult

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }

  NSDictionary *resultDic = dic[@"result"];
  NSArray *userinfo = resultDic[@"withdraw_list"];
  NSMutableArray *resultArrayM = [NSMutableArray array];
  [userinfo enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx,
                                         BOOL *stop) {
    [resultArrayM
        addObject:[WFWithdrawDetailInfo withdrawDetailInfoWithDictionary:dic]];
  }];
  self.withdraw_list = resultArrayM;
}

- (NSArray *)getArray {
  return _withdraw_list;
}

@end

@implementation WFWithdrawDetailInfo

+ (instancetype)withdrawDetailInfoWithDictionary:(NSDictionary *)dic {
  return [[WFWithdrawDetailInfo alloc] initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  if (self = [super init]) {
    self.withdrawNo = dic[@"withdrawNo"];
    self.withdrawDatetime = @([dic[@"withdrawDatetime"] longLongValue]);
    self.withdrawAmount = [@([dic[@"withdrawAmount"] intValue]) stringValue];
    self.withdrawStatus = dic[@"withdrawStatusDesc"];
    self.accountBankId = [@([dic[@"accountBankId"] intValue]) stringValue];
    self.youguuId = [@([dic[@"youguuId"] intValue]) stringValue];
    self.NumberId = [dic[@"id"] intValue];
  }
  return self;
}

@end

#pragma mark
/** 1.10 获取订单支付参数 */

/** 1.10.1 获取通联支付订单支付参数 */

@implementation WFAllInPaymentPayData
- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *payDataDic = resultDic[@"pay_data"];

  self.inputCharset = [payDataDic[@"inputCharset"] stringValue];
  self.issuerId = payDataDic[@"issuerId"];
  self.language = [payDataDic[@"language"] stringValue];
  self.merchantId = payDataDic[@"merchantId"];
  self.orderAmount = [payDataDic[@"orderAmount"] stringValue];
  self.orderCurrency = payDataDic[@"orderCurrency"];
  self.orderDatetime = payDataDic[@"orderDatetime"];
  self.orderNo = payDataDic[@"orderNo"];
  self.payType = [payDataDic[@"payType"] stringValue];
  self.pickupUrl = payDataDic[@"pickupUrl"];
  self.productName = payDataDic[@"productName"];
  self.receiveUrl = payDataDic[@"receiveUrl"];
  self.signMsg = payDataDic[@"signMsg"];
  self.signType = [payDataDic[@"signType"] stringValue];
  self.version = payDataDic[@"version"];
}
@end

/** 1.10.2 获取订连连支付单支付参数 */
@implementation WFLianLianPaymentPayData
- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *payDataDic = resultDic[@"pay_data"];

  self.name_goods = payDataDic[@"name_goods"];
  self.acct_name = payDataDic[@"acct_name"];
  self.busi_partner = payDataDic[@"busi_partner"];
  self.dt_order = payDataDic[@"dt_order"];
  self.money_order = payDataDic[@"money_order"];
  self.no_order = payDataDic[@"no_order"];
  self.notify_url = payDataDic[@"notify_url"];
  self.oid_partner = payDataDic[@"oid_partner"];
  self.risk_item = payDataDic[@"risk_item"];
  self.sign = payDataDic[@"sign"];
  self.sign_type = payDataDic[@"sign_type"];
  self.id_no = payDataDic[@"id_no"];
  self.user_id = payDataDic[@"user_id"];
  self.no_agree = payDataDic[@"no_agree"];
  self.card_no = payDataDic[@"card_no"];
  self.id_type = payDataDic[@"id_type"];
}
@end

/** 1.10.4 获取微信支付订单支付参数 */
@implementation WFWeiXinPaymentPayData
- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *payDataDic = resultDic[@"pay_data"];

  self.appid = payDataDic[@"appId"];
  self.noncestr = payDataDic[@"nonceStr"];
  self.packageValue = payDataDic[@"packageValue"];
  self.prepayId = payDataDic[@"prepayId"];
  self.partnerid = payDataDic[@"partnerId"];
  self.sign = payDataDic[@"sign"];
  self.timestamp = payDataDic[@"timeStamp"];
}
@end

#pragma mark
/** 1.11获取账户总额以及明细接口 */
@implementation WFAccountAmountAndDetails

- (void)jsonToObject:(NSDictionary *)dic {
  if (dic[@"result"] == nil) {
    return;
  }
  NSDictionary *resultDic = dic[@"result"];
  NSDictionary *stockAccountDic = resultDic[@"stock_account"];
  self.totalAsset = [stockAccountDic[@"totalAsset"] stringValue];
  self.peiziAmount = [stockAccountDic[@"peiziAmount"] stringValue];
  self.cashAmount = [stockAccountDic[@"cashAmount"] stringValue];
  self.totalProfit = [stockAccountDic[@"totalProfit"] stringValue];
  NSDictionary *youguuDic = resultDic[@"youguu_account"];
  self.amount = [youguuDic[@"amount"] stringValue];
  self.totalAmount = [resultDic[@"totalAmount"] stringValue];
}

@end

//#pragma mark
///** 1.12 判断是否绑定银行卡 */
//@implementation WFIsBindBankCardRequest
//- (void)jsonToObject:(NSDictionary *)dic {
//  NSDictionary *resultDic = dic[@"result"];
//  NSDictionary *bankCardDic = resultDic[@"bank_card"];
//  if (bankCardDic == nil) {
//    self.isbind = NO;
//    return;
//  }
//  self.isbind = YES;
//  self.bank_logo = bankCardDic[@"bank_logo"];
//  self.bank_name = bankCardDic[@"bank_name"];
//  self.bind_mobile = bankCardDic[@"bind_mobile"];
//  self.card_no = bankCardDic[@"cardNo"];
//  self.card_type = bankCardDic[@"cardStatus"];
//  self.no_agree = bankCardDic[@"no_agree"];
//
//  self.acctName = bankCardDic[@"acctName"];
//  self.bankId = [@([bankCardDic[@"bankId"] intValue]) stringValue];
//  self.cardStatus = [@([bankCardDic[@"cardStatus"] intValue]) stringValue];
//  self.channel = [@([bankCardDic[@"channel"] intValue]) stringValue];
//  self.idNo = [@([bankCardDic[@"idNo"] intValue]) stringValue];
//  self.uid = [@([bankCardDic[@"uid"] intValue]) stringValue];
//}
//
//@end

#pragma mark 易宝支付相关结果解析
/** 1.13 易宝支付绑定银行卡请求结果解析 */
@implementation WFYeePayBindCardRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.yb_req_id = resultDic[@"yb_req_id"];
}
@end

@implementation WFYeePayBindCardRequest

@end

/** 1.14 易宝支付token获取请求结果解析 */
@implementation WFYeePayGetTokenRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.token = resultDic[@"token"];
}
@end

/** 1.15 易宝支付请求结果解析 */
@implementation WFYeePaymentRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
@end

/** 1.16 易宝支付请求结果解析 */
@implementation WFYeePaymentSMSPayRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.order_no = resultDic[@"order_no"];
}
@end

@implementation WFYeePaymentSMSPayRequest

@end

/** 1.17 短信支付验证码发送结果解析 */
@implementation WFYeePaymentSMSSendRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.send_more = [resultDic[@"send_more"] boolValue];
}
@end

/** 1.18 短信支付短信确认结果解析 */
@implementation WFYeePaymentSMSPayConfirmRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
@end

/** 1.19 查询cardBin接口结果解析 */
@implementation WFYeePaymentCardBinRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  NSDictionary *cardInfoDic = resultDic[@"card_bin"];
  if (cardInfoDic == nil) {
    return;
  }
  self.bankname = cardInfoDic[@"bankname"];
  self.bank_logo = cardInfoDic[@"bank_logo"];
  self.cardtype = [cardInfoDic[@"cardtype"] integerValue];
  self.isvalid = [cardInfoDic[@"isvalid"] integerValue];
  self.support = [cardInfoDic[@"support"] boolValue];
}

@end

/** 1.20 易宝首次支付 */
@implementation WFYeePaymentBindPayRequestResult
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
@end

@implementation WFYeePaymentBindPayRequest
@end

/** 1.21 查询支付渠道列表 */
@implementation WFInquirePayChannelList
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  if (dic[@"result"] == nil) {
    return;
  }
  __block NSMutableArray *channelListArrayM = [[NSMutableArray alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *channgeListArray = resultDic[@"channel_list"];
  [channgeListArray enumerateObjectsUsingBlock:^(NSDictionary *subDict,
                                                 NSUInteger idx, BOOL *stop) {
    WFInquirePayChannel *payChannel = [[WFInquirePayChannel alloc] init];
    payChannel.channel = [subDict[@"channel"] integerValue];
    payChannel.feeRate = [subDict[@"feeRate"] integerValue];
    payChannel.isRecommend = [subDict[@"isRecommend"] boolValue];
    payChannel.payTips = subDict[@"payTips"];
    payChannel.type = [subDict[@"type"] integerValue];
    payChannel.weight = [subDict[@"weight"] integerValue];
    payChannel.openLink = subDict[@"openLink"];
    __block BOOL insterded = NO;
    [channelListArrayM
        enumerateObjectsUsingBlock:^(WFInquirePayChannel *obj, NSUInteger idx,
                                     BOOL *stop) {
          if (payChannel.weight > obj.weight) {
            [channelListArrayM insertObject:payChannel atIndex:idx];
            *stop = YES;
            insterded = YES;
          }
        }];
    if (!insterded) {
      [channelListArrayM addObject:payChannel];
    }
  }];
  self.channelListArray = channelListArrayM;
}
@end

@implementation WFInquirePayChannel
@end

@implementation WFInquirePayChannelListRequest
@end

#pragma mark
#pragma mark

@implementation WFAccountInterface

#pragma mark 1.1查询优顾账户的资产
+ (void)WFCheckAccountBalanceWithCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"account/asset_stat"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFAccountBalance class]
             withHttpRequestCallBack:callback];
}

/** 1.2资金明细流水*/
+ (void)capitalDetailRunningWaterWithInput:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [WF_Payment_Address
      stringByAppendingFormat:
          @"account/cash_flow?fromId={fromId}&pageSize={pageSize}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFCapitalSubsidiary class]
             withHttpRequestCallBack:callback];
}

#pragma mark 1.3账户充值  给优顾账户充值
+ (void)accountsPrepaidWithAmount:(NSString *)amount
                       andChannel:(NSString *)channel
                      andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingString:@"account/recharge"];

  NSDictionary *orderDic = @{
    @"amount" : amount,
    @"channel" : channel,
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:orderDic
              withRequestObjectClass:[WFPayAccountResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 1.4 查询用户绑定的银行卡调用
+ (void)inquireWFBindedBankcardWithChannel:(NSString *)channel
                              WithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Payment_Address
      stringByAppendingFormat:@"account/bank_card?channel={channel}"];
  NSDictionary *dic = @{ @"channel" : channel };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  Class objClass;
  if ([channel isEqualToString:@"1"]) {
    objClass = [WFBindedBankcardYouGuuResult class];
  } else if ([channel isEqualToString:@"2"]) {
    objClass = [WFBindedBankcardLianLianPayResult class];
  } else if ([channel isEqualToString:@"3"]) {
    objClass = [WFBindedBankcardYeePayResult class];
  } else {
    NSLog(@"查" @"询" @"用" @"户"
                               @"绑定的银行卡没有进行网络访问，不支持传入的渠"
                               @"道，ch" @"annel" @"=" @"%" @"@",
          channel);
    return;
  }
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:objClass
             withHttpRequestCallBack:callback];
}

#pragma mark 1.7 申请提现
+ (void)applyForWFWithdrawWithAmount:(NSString *)amount
                         WithChannel:(NSString *)channel
                         andCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"account/withdraw"];

  NSDictionary *parametersDictionary = @{
    @"amount" : amount,
    @"channel" : channel,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:parametersDictionary
              withRequestObjectClass:[WFWithdrawResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 1.8 查询提现明细
+ (void)getWFWithdrawWithInput:(NSDictionary *)dic
                  withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Payment_Address
      stringByAppendingFormat:
          @"account/withdraw_flow?fromId={fromId}&pageSize={pageSize}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFWithdrawListResult class]
             withHttpRequestCallBack:callback];
}

#pragma mark 1.10获取订单支付参数
/** 1.10 获取订单支付参数 */
+ (void)getPayOrderParametersWithOrder_no:(NSString *)order_no
                                withId_no:(NSString *)id_no
                             withAgree_no:(NSString *)agree_no
                            withAcct_name:(NSString *)acct_name
                              withCard_no:(NSString *)card_no
                              withChannel:(NSString *)channel
                             withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"order/pay_data"];
  NSDictionary *dic = @{
    @"order_no" : order_no,
    @"id_no" : id_no,
    @"agree_no" : agree_no,
    @"acct_name" : acct_name,
    @"card_no" : card_no,
    @"channel" : channel,
  };

  Class requestObjectClass;
  if ([channel isEqualToString:@"1"]) {
    requestObjectClass = [WFAllInPaymentPayData class];
  } else if ([channel isEqualToString:@"2"]) {
    requestObjectClass = [WFLianLianPaymentPayData class];
  } else if ([channel isEqualToString:@"4"]) {
    requestObjectClass = [WFWeiXinPaymentPayData class];
  } else {
    NSLog(@"获" @"取" @"订" @"单"
                               @"支付参数没有进行网络访问，不支持传入的渠道，c"
                               @"hanne" @"l=" @"%" @"@",
          channel);
    return;
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:requestObjectClass
             withHttpRequestCallBack:callback];
}

#pragma mark
/** 1.11获取账户总额以及明细接口 */
+ (void)WFGainAccountAmountAndDetailsWithCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"account/asset_total"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFAccountAmountAndDetails class]
             withHttpRequestCallBack:callback];
}

//#pragma mark
///** 1.12 判断是否绑定银行卡 */
//+ (void)WFLinLianPayIsBindBankCardWithChannel:(NSString *)channel
//                                 WithCallBack:(HttpRequestCallBack *)callback
//                                 {
//  NSString *url = [WF_Payment_Address
//      stringByAppendingFormat:@"account/bank_card?channel={channel}"];
//  NSDictionary *dic = @{ @"channel" : channel };
//
//  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
//  [request asynExecuteWithRequestUrl:url
//                   WithRequestMethod:@"GET"
//               withRequestParameters:dic
//              withRequestObjectClass:[WFIsBindBankCardRequest class]
//             withHttpRequestCallBack:callback];
//}

#pragma mark 易宝支付相关请求
/** 1.13 易宝支付绑定银行卡请求 */
+ (void)WFYeePayBindCardWithRequest:(WFYeePayBindCardRequest *)bindCardrequest
                       WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/bind_card_req"];
  NSDictionary *dic = @{
    @"card_no" : bindCardrequest.card_no,
    @"id_no" : bindCardrequest.id_no,
    @"acct_name" : bindCardrequest.acct_name,
    @"phone" : bindCardrequest.phone,
    @"user_ip" : bindCardrequest.user_ip,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePayBindCardRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.14 易宝支付token获取请求 */
+ (void)WFYeePayGetTokenWithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/pay_token"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFYeePayGetTokenRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.15 易宝支付请求 */
+ (void)WFYeePaymentWithToken:(NSString *)token
                  WithContent:(NSString *)content
                 WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Payment_Address stringByAppendingFormat:@"yeepay/pay"];
  NSDictionary *dic = @{
    @"token" : token,
    @"content" : content,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePaymentRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.16 易宝支付（短信验证模式） */
+ (void)WFYeePaySMSPayWithRequest:(WFYeePaymentSMSPayRequest *)bindCardrequest
                     WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/sms_pay"];
  NSDictionary *dic = @{
    @"order_no" : bindCardrequest.order_no,
    @"card_top" : bindCardrequest.card_top,
    @"card_last" : bindCardrequest.card_last,
    @"user_ip" : bindCardrequest.user_ip,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePaymentSMSPayRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.17 短信支付验证码发送 */
+ (void)WFYeePaymentSMSSendWithOrderNo:(NSString *)orderNo
                          WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/sms_send"];
  NSDictionary *dic = @{
    @"order_no" : orderNo,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePaymentSMSSendRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.18 短信支付短信确认 */
+ (void)WFYeePaymentSMSPayConfirmWithOrderNo:(NSString *)orderNo
                              WithVerifyCode:(NSString *)verifyCode
                                WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/sms_pay_confirm"];
  NSDictionary *dic = @{
    @"order_no" : orderNo,
    @"verify_code" : verifyCode,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request
      asynExecuteWithRequestUrl:url
              WithRequestMethod:@"POST"
          withRequestParameters:dic
         withRequestObjectClass:[WFYeePaymentSMSPayConfirmRequestResult class]
        withHttpRequestCallBack:callback];
}

/** 1.19 查询cardBin接口 */
+ (void)WFYeePaymentCardBinWithCardNo:(NSString *)cardNo
                         WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Payment_Address
      stringByAppendingFormat:@"yeepay/card_bin?card_no={card_no}"];
  NSDictionary *dic = @{
    @"card_no" : cardNo,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePaymentCardBinRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.20 易宝首次支付接口 */
+ (void)WFYeePaymentBindPayWithPayParameter:
            (WFYeePaymentBindPayRequest *)payContent
                               WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"yeepay/bind_pay"];
  NSDictionary *content = @{
    @"token" : payContent.token,
    @"orderNo" : payContent.orderNo,
    @"cardLast" : payContent.cardLast,
    @"cardTop" : payContent.cardTop,
    @"userIp" : payContent.userIp,
    @"ybReqId" : payContent.ybReqId,
    @"verifyCode" : payContent.verifyCode,
    @"sign" : payContent.sign,
  };
  NSString *jsonString = [content JSONString];
  NSDictionary *dic = @{
    @"content" : jsonString,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFYeePaymentBindPayRequestResult class]
             withHttpRequestCallBack:callback];
}

/** 1.21 查询支付渠道列表接口 */
+ (void)inquirePaychannelsListWithParameter:
            (WFInquirePayChannelListRequest *)payChannelListRequest
                               WithCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Payment_Address
      stringByAppendingFormat:
          @"assist/channel_list?os_type={os_type}&type={type}"];
  NSDictionary *dic = @{
    @"os_type" : payChannelListRequest.os_type,
    @"type" : payChannelListRequest.type,
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFInquirePayChannelList class]
             withHttpRequestCallBack:callback];
}

@end
