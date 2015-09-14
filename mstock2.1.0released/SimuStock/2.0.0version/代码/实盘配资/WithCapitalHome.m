//
//  WithCapitalHome.m
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WithCapitalHome.h"
#import "SingleUserApplyDetail.h"

#pragma mark 1.1累积收益&跑马灯查询接口
@implementation WithCapitalAvailable

- (void)jsonToObject:(NSDictionary *)dic {

  NSDictionary *resultdic = [dic objectForKey:@"result"];

  self.income = [[NSString
      stringWithFormat:@"%@",
                       [resultdic objectForKey:@"income"]] longLongValue];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultdic[@"userlist"];
  [userListWrapper jsonToMap:userLists];

  /**tmcList节点解析*/
  self.userArray = [[NSMutableArray alloc] init];

  NSArray *array = resultdic[@"marquee"];
  for (NSDictionary *marqueeDic in array) {
    SingleUserApplyDetail *item = [[SingleUserApplyDetail alloc] init];
    item.userMarqueeItem = [[UserMarqueeItem alloc] init];
    item.userMarqueeItem.Userid = [marqueeDic[@"uid"] stringValue];
    item.userMarqueeItem.status = [marqueeDic[@"type"] integerValue];
    item.userMarqueeItem.amout = [marqueeDic[@"amount"] doubleValue];

    //找到userList的uid
    NSString *uid = [marqueeDic[@"uid"] stringValue];
    item.userListItem = [userListWrapper getUserById:uid];

    [self.userArray addObject:item];
  }
}

- (NSDictionary *)mappingDictionary {
  return @{ @"userArray" : NSStringFromClass([SingleUserApplyDetail class]) };
}

@end
#pragma mark 1.2 配资资金池开关
@implementation WithCapitalIsClose

- (void)jsonToObject:(NSDictionary *)dic {
  self.message = dic[@"message"];
  self.status =dic[@"status"];
  self.isClose = [[dic objectForKey:@"result"] boolValue];
}
@end

#pragma mark 1.4添加大额配资相关
@implementation WFAddLargeAmountResult
@end

@implementation WFAddLargeAmountParameter
@end

@implementation WithCapitalHome
#pragma mark
#pragma mark 用户配资首页相关的调用
+ (void)checkWFAccountWithLimit:(NSString *)limit
                   withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@stockFinWeb/financing/incomeMarquee?limit=%@",
                       With_Capital_address, limit];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WithCapitalAvailable class]
             withHttpRequestCallBack:callback];
}

#pragma mark 资金池是否还有资金申请
+ (void)checkWFISClosewithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [With_Capital_address
      stringByAppendingString:@"stockFinWeb/financing/isClose"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WithCapitalIsClose class]
             withHttpRequestCallBack:callback];
}

#pragma mark
#pragma mark 添加大额配资
+ (void)addWFLargeAccountWithFinancingMoney:(NSString *)financingMoney
                               withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [With_Capital_address
      stringByAppendingFormat:
          @"stockFinWeb/financing/add?financingMoney={financingMoney}"];
  NSDictionary *dic = @{ @"financingMoney" : financingMoney };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[WFAddLargeAmountResult class]
             withHttpRequestCallBack:callback];
}

@end
