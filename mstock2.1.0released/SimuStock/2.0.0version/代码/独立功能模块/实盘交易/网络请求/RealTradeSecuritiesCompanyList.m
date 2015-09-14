//
//  RealTradeSecuritiesCompanyList.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeSecuritiesCompanyList.h"
#import "BaseRequester.h"
#import "JsonFormatRequester.h"
#import "GameAdvertisingViewController.h"

@implementation RealTradeSecuritiesAccountType
//券商类型 
- (void)jsonToObject:(NSDictionary *)dic {
 
  self.name = dic[@"name"];
  self.type = [dic[@"type"] integerValue];
  self.des = dic[@"des"];
  if (self.type == 4 || self.type == 6) {
    self.brokerMain = dic[@"main"];
  }
}
@end

@implementation RealTradeSecuritiesCompanyHelp
//帮助链接
- (void)jsonToObject:(NSDictionary *)dic {
  self.des = dic[@"des"];
  self.title = dic[@"title"];
}
@end
@implementation RealTradeSecuritiesCompanyPhone
//客服电话
- (void)jsonToObject:(NSDictionary *)dic {
  self.des = dic[@"des"];
  self.title = dic[@"title"];
}
@end

@implementation RealTradeSecuritiesCompanyDes
//客服电话简介 和 电话标题
- (void)jsonToObject:(NSDictionary *)dic {
  self.content = dic[@"content"];
  self.title = dic[@"title"];
}
@end

@implementation RealTradeSecuritiesOpenType
//开户方式
- (void)jsonToObject:(NSDictionary *)dic {
  self.des = dic[@"des"];
  self.type = dic[@"type"];
}
@end

@implementation BrokerDownloadPackage

-(void)jsonToObject:(NSDictionary *)dic
{
  self.appID = dic[@"appid"];
  self.customurl = dic[@"customurl"];
  self.download = dic[@"download"];
}

@end

@implementation RealTradeSecuritiesCompany

- (void)jsonToObject:(NSDictionary *)dict {
  //获取开户方式
  NSArray *desArray = dict[@"des"]; //des 属于开户 特有的 内容简介
  self.openAccountArr = [[NSMutableArray alloc]init];
  for (NSDictionary *openDes in desArray) {
    //保存券商信息简介的 类
    RealTradeSecuritiesCompanyDes *openCompanyDes = [[RealTradeSecuritiesCompanyDes alloc]init];
    [openCompanyDes jsonToObject:openDes];
    //保存用户名 Content Title
    [self.openAccountArr addObject:openCompanyDes];
  }
  /** 获取广告 */
  NSArray *advArray = dict[@"banner"];
  self.advArray = [[NSMutableArray alloc]init];
  for (NSDictionary *advDict in advArray) {
    GameAdvertisingData *adv = [[GameAdvertisingData alloc]init];
    adv.adImage = advDict[@"img"];
    adv.forwardUrl = advDict[@"url"];
    //图片
    adv.type = @"2501";
    [self.advArray addObject:adv];
  }
  self.name = dict[@"name"];
  self.num = dict[@"num"];
  NSLog(@"%@",self.num);
  self.logo = dict[@"logo"];
  self.openHelp = [[RealTradeSecuritiesCompanyHelp alloc]init];
  self.openPhone = [[RealTradeSecuritiesCompanyPhone alloc]init];
  self.openType = [[RealTradeSecuritiesAccountType alloc]init];
  self.downloadIOS = [[BrokerDownloadPackage alloc] init];
  [self.downloadIOS jsonToObject:dict[@"ios"]];
  [self.openHelp jsonToObject:dict[@"help"]];
  [self.openPhone jsonToObject:dict[@"phone"]];
  if (desArray || !self.num) {
    [self.openType jsonToObject:dict[@"type"]];
    self.secNo = [dict[@"secNo"] integerValue];
  }else{
    self.oldNewTypeLogin = [dict[@"type"] integerValue];
  }
  
  //数组 sub 属于登录 特有的
  NSArray *subArray = dict[@"sub"];
  for (NSDictionary *accounDict in subArray) {
    self.accountTypes = [[NSMutableArray alloc] init];
    NSArray *securitiesCompanies = accounDict[@"account"];
    for (NSDictionary *accountTypeDic in securitiesCompanies) {
      RealTradeSecuritiesAccountType *accountType =
      [[RealTradeSecuritiesAccountType alloc] init];
      [accountType jsonToObject:accountTypeDic];
      [self.accountTypes addObject:accountType];
    }
    self.ak = accounDict[@"ak"];
    self.funcs = accounDict[@"funcs"];
    self.help = [[RealTradeSecuritiesCompanyHelp alloc]init];
    [self.help jsonToObject:accounDict[@"help"]];
    
    //获取返回请求的数据类型 POST/GET
    NSString *tempMethod = accounDict[@"method"];
    self.method = [tempMethod uppercaseString];
    self.phone = [[RealTradeSecuritiesCompanyPhone alloc]init];
    [self.phone jsonToObject:accounDict[@"phone"]];
    
    self.randUrl = accounDict[@"randUrl"];
    self.url = accounDict[@"url"];
    self.type = [accounDict[@"type"] integerValue];
    self.title = accounDict[@"title"];
  }
}


- (NSDictionary *)mappingDictionary{
  //广告数组 开户简介数组 账户类型数组
  return @{
           @"advArray": NSStringFromClass([GameAdvertisingData class]),
           @"accountTypes": NSStringFromClass([RealTradeSecuritiesAccountType class]),
           @"openAccountArr" : NSStringFromClass([RealTradeSecuritiesCompanyDes class])
           };
}


@end

@implementation RealTradeSecuritiesCompanyList

- (NSDictionary *)mappingDictionary {
  return @{
    @"result" : NSStringFromClass([RealTradeSecuritiesCompany class])
  };
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.result = [[NSMutableArray alloc] init];
  NSArray *securitiesCompanies = dic[@"result"];
  for (NSDictionary *securitiesCompany in securitiesCompanies) {
    //数据解析模块 -- 券商数据
    RealTradeSecuritiesCompany *company =
        [[RealTradeSecuritiesCompany alloc] init];
    [company jsonToObject:securitiesCompany];
    [self.result addObject:company];
  }
}

/** 新增券商列表 国联证券 财富证券 */
+(void)loadNewBrokerageOpenAccountWithCallback:(HttpRequestCallBack *)callback
{
  NSString *url = [brokerage_Account_List
                   stringByAppendingString:@"asteroid/sec/getSecAccount?ostype={ostype}"];
  NSDictionary *dic = @{@"ostype" : @"2"};
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[RealTradeSecuritiesCompanyList class]
             withHttpRequestCallBack:callback];
}


/** 新券商交易登录接口 */
+(void)stockLoginList:(HttpRequestCallBack *)callback
{
  NSString *url = [brokerage_Account_List stringByAppendingString:@"asteroid/sec/getSecTrade?ostype={ostype}"];
  NSDictionary *dic = @{@"ostype" : @"2"};
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[RealTradeSecuritiesCompanyList class]
             withHttpRequestCallBack:callback];
  
}



@end
