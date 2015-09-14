//
//  InterfaceTest.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "InterfaceTest.h"
#import "BaseRequester.h"


#import "RealTradeRequester.h"
#import "RealTradeSecuritiesCompanyList.h"
#import "RealTradeTodayEntrust.h"
#import "SecuritiesBankInfo.h"


@implementation InterfaceTest

/** 测试加载银行卡信息 */
+(void) testLoadSecuritiesBankInfo{
  HttpRequestCallBack* callback=[[HttpRequestCallBack alloc] init];
  callback.onSuccess=^(NSObject* obj){
    SecuritiesBankInfo* bankInfoes=(SecuritiesBankInfo*) obj;
    
    RealTradeBankItem* bankItem= bankInfoes.banks[0];
    
//    转出
//    HttpRequestCallBack* callback2=[[HttpRequestCallBack alloc] init];
//    callback2.onSuccess=^(NSObject* obj){
//      RealTradeFundTransferResult* result=(RealTradeFundTransferResult*) obj;
//       NSLog(@"SUCCESS");
//    };
//    
//    [RealTradeFundTransferResult transferOutWithMoneyAmount:@"1" withPassword:@"123456" WitBankInfo:bankItem WithCallback:callback2];
    
//    转入
//    HttpRequestCallBack* callback3=[[HttpRequestCallBack alloc] init];
//    callback3.onSuccess=^(NSObject* obj){
//      RealTradeFundTransferResult* result=(RealTradeFundTransferResult*) obj;
//      NSLog(@"SUCCESS");
//    };
//    
//    [RealTradeFundTransferResult transferInWithMoneyAmount:@"1" withPassword:@"123456" WitBankInfo:bankItem WithCallback:callback3];
    
//       转入转出历史查询
//       HttpRequestCallBack* callback3=[[HttpRequestCallBack alloc] init];
//       callback3.onSuccess=^(NSObject* obj){
//         RealTradeFundTransferHistory* result=(RealTradeFundTransferHistory*) obj;
//         NSLog(@"SUCCESS");
//       };
//   
//       [RealTradeFundTransferHistory loadFundTransferHistoryWithCallback:callback3];
    
//    今日成交查询
//    HttpRequestCallBack* callback4=[[HttpRequestCallBack alloc] init];
//    callback4.onSuccess=^(NSObject* obj){
//      RealTradeDealList* result=(RealTradeDealList*) obj;
//      NSLog(@"SUCCESS");
//    };
//    [RealTradeDealList loadTodayDealListWithCallback:callback4];
    
    //    历史成交查询
//    HttpRequestCallBack* callback5=[[HttpRequestCallBack alloc] init];
//    callback5.onSuccess=^(NSObject* obj){
//      RealTradeDealList* result=(RealTradeDealList*) obj;
//      NSLog(@"SUCCESS");
//    };
//    [RealTradeDealList loadHistoryDealListWithStartDate:@"20140714" withEndData:@"20140821" withPageSize:@"20" withSeq:@"" WithCallback:callback5];
    
    //指定交易查询
//    HttpRequestCallBack* callback6=[[HttpRequestCallBack alloc] init];
//    callback6.onSuccess=^(NSObject* obj){
//      RealTradeSpecifiedTransaction* result=(RealTradeSpecifiedTransaction*) obj;
//      NSLog(@"SUCCESS");
//    };
//    [RealTradeSpecifiedTransaction loadSpecifiedTransactionWithCallback:callback6];
    
    //发起指定交易
//    HttpRequestCallBack* callback7=[[HttpRequestCallBack alloc] init];
//    callback7.onSuccess=^(NSObject* obj){
//      RealTradeDoSpecifiedTransaction* result=(RealTradeDoSpecifiedTransaction*) obj;
//      NSLog(@"SUCCESS");
//    };
//    [RealTradeDoSpecifiedTransaction doSpecifiedTransactionWithCallback:callback7];
    
    NSLog(@"SUCCESS:%@", bankItem);
  };
  NSString* url=[[[RealTradeAuthInfo singleInstance] urlFactory] getBankSecuInfo];
  [SecuritiesBankInfo loadSecuritiesBankInfoWithUrl:url WithCallback:callback];
}

/** 测试撤单 */
+(void) testRevoke{
  HttpRequestCallBack* callback=[[HttpRequestCallBack alloc] init];
  callback.onSuccess=^(NSObject* obj){
    RealTradeTodayEntrust* entrustList=(RealTradeTodayEntrust*) obj;
    
    RealTradeTodayEntrustItem* item=entrustList.result[0];
    
    
    HttpRequestCallBack* callback2=[[HttpRequestCallBack alloc] init];
    callback2.onSuccess=^(NSObject* obj){
      NSLog(@"SUCCESS");
    };
    [RealTradeTodayEntrust revokeTodayEntrusts:item.commissionId withCallBack:callback2];
  };
  [RealTradeTodayEntrust loadTodayEntruestList:callback];

};

+ (void)testCaptchaImage {
  NSString *url = @"https://192.168.1.9:8443/web/img.jsp";
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) { NSLog(@" success to get image"); };
  RealTradeCaptchaImageRequester *requester =
  [[RealTradeCaptchaImageRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[UIImage class]
               withHttpRequestCallBack:callback];
}

+(void) testSecuritiesCompanyList{
  HttpRequestCallBack* callback=[[HttpRequestCallBack alloc] init];
  callback.onSuccess=^(NSObject* obj){
    RealTradeSecuritiesCompanyList* list=(RealTradeSecuritiesCompanyList*)obj;
    NSLog(@"%@", list);
  };
//  [RealTradeSecuritiesCompanyList loadSecuritiesCompanyListWithCallback:callback];
}





@end
