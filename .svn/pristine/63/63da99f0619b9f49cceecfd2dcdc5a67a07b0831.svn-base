//
//  HomeUserInformationData.m
//  SimuStock
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HomeUserInformationData.h"
#import "JsonFormatRequester.h"
#import "UserListItem.h"

/*******************************************************************
 *******   主页 查询用户账户信息显示数据     ****************************
 */
@implementation HomeUserInformationData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  // NSLog(@"主页 查询用户账户信息显示数据 ：%@",dic);
  self.isShowSuper = [dic[@"isShowSuper"] boolValue];
  self.accountId = [SimuUtil changeIDtoStr:dic[@"accountId"]];
  self.userid = [SimuUtil changeIDtoStr:dic[@"userId"]];
  //用户昵称
  NSString *sad_nickName = dic[@"nickName"];
  self.nickName = [SimuUtil changeIDtoStr:sad_nickName];
  //持仓数
  NSString *sad_positionNum = dic[@"positionNum"];
  self.positionNum = [SimuUtil changeIDtoStr:sad_positionNum];
  //关注数
  NSString *sad_followNum = dic[@"followNum"];
  self.followNum = [SimuUtil changeIDtoStr:sad_followNum];
  //粉丝数
  NSString *sad_fansNum = dic[@"fansNum"];
  self.fansNum = [SimuUtil changeIDtoStr:sad_fansNum];
  //追踪数
  NSString *sad_traceNum = dic[@"traceNum"];
  self.traceNum = [SimuUtil changeIDtoStr:sad_traceNum];
  //用户头像
  NSString *sad_headPic = dic[@"headPic"];
  self.headPic = [SimuUtil changeIDtoStr:sad_headPic];
  //个人签名
  NSString *sad_signature = dic[@"signature"];
  self.signature = [SimuUtil changeIDtoStr:sad_signature];
  //优顾认证签名
  self.certifySignature = [SimuUtil changeIDtoStr:dic[@"certifySignature"]];
  //浮动盈亏
  NSString *sad_fdyk = dic[@"fdyk"];
  self.fdyk = [SimuUtil changeIDtoStr:sad_fdyk];
  //持股市值
  NSString *sad_cgsz = dic[@"cgsz"];
  self.cgsz = [SimuUtil changeIDtoStr:sad_cgsz];
  //总盈利率
  NSString *sad_profitRate = dic[@"profitRate"];
  self.profitRate = [SimuUtil changeIDtoStr:sad_profitRate];
  //资余额
  NSString *sad_balance = dic[@"balance"];
  self.balance = [SimuUtil changeIDtoStr:sad_balance];
  //总资产
  NSString *sad_totalAssets = dic[@"totalAssets"];
  self.totalAssets = [SimuUtil changeIDtoStr:sad_totalAssets];
  //总盈利(资金)
  NSString *sad_totalProfit = dic[@"totalProfit"];
  self.totalProfit = [SimuUtil changeIDtoStr:sad_totalProfit];
  //是否关注0-否, 1-是
  self.attention = [dic[@"attention"] boolValue];
  //交易数
  self.tradeNum = [dic[@"tradeNum"] boolValue];
  //聊股数
  NSString *sad_stockNum = dic[@"istockNum"];
  self.stockNum = [SimuUtil changeIDtoStr:sad_stockNum];
  //用户类型
  NSString *vipType = dic[@"vipType"];
  self.vipType = [SimuUtil changeIDtoStr:vipType];
  //优顾认证，用length>0判断
  self.vType = [SimuUtil changeIDtoStr:dic[@"vType"]];

  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.nickName = _nickName;
  self.userListItem.userId = @([_userid longLongValue]);
  self.userListItem.rating = dic[@"rating"];
  self.userListItem.vipType = [dic[@"vipType"] intValue];
  self.userListItem.stockFirmFlag =
      [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
}

+ (void)requestUserInfoWithUid:(NSString *)uid
                  withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address
      stringByAppendingString:@"youguu/simtrade/showuseracountinfo/{ak}/"
      @"{userid}/{queryuid}/{querymid}"];

  NSString *userId = [[SimuUtil getUserID] isEqualToString:@"-1"]
                         ? @"-1"
                         : [SimuUtil getUserID];

  NSDictionary *dic = @{
    @"userid" : userId,
    @"queryuid" : uid,
    @"querymid" : @"1"
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[HomeUserInformationData class]
             withHttpRequestCallBack:callback];
}

@end
