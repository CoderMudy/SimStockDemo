//
//  GameAdvertisingData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GameAdvertisingData.h"
#import "JsonFormatRequester.h"

@implementation GameAdvertisingData

- (NSDictionary *)mappingDictionary{
  return @{@"dataArray": NSStringFromClass([GameAdvertisingData class])};
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];
  //广告 比赛banner广告位
  NSArray *array = dic[@"result"];
  if (array) { //有数组则是 AdWall
    for (NSDictionary *obj in array) {
      GameAdvertisingData *gameAdData = [[GameAdvertisingData alloc] init];
      //广告ID
      gameAdData.ADid =
          [NSString stringWithFormat:@"%ld", (long)[obj[@"id"] integerValue]];
      //广告标题
      NSString *sad_title = obj[@"title"];
      gameAdData.title = [SimuUtil changeIDtoStr:sad_title];
      //广告图地址
      NSString *sad_adImage = obj[@"adImage"];
      gameAdData.adImage = [SimuUtil changeIDtoStr:sad_adImage];
      //广告类型，2501：图片广告，2502：文字广告
      NSString *sad_type = obj[@"type"];
      gameAdData.type = [SimuUtil changeIDtoStr:sad_type];
      //点击广告图的跳转地址
      NSString *sad_forwardUrl = obj[@"forwardUrl"];
      gameAdData.forwardUrl = [SimuUtil changeIDtoStr:sad_forwardUrl];

      //如果type=2502，需显示的广告内容
      NSString *sad_content = obj[@"content"];
      gameAdData.content = [SimuUtil changeIDtoStr:sad_content];
      //排序
      gameAdData.rank =
          [NSString stringWithFormat:@"%ld", (long)[obj[@"rank"] integerValue]];
      [self.dataArray addObject:gameAdData];
    }
  } else { //没有数组则是popWindow
    //首页弹窗
    GameAdvertisingData *gameAdData = [[GameAdvertisingData alloc] init];
    //广告ID
    gameAdData.ADid =
        [NSString stringWithFormat:@"%ld", (long)[dic[@"id"] integerValue]];
    //广告标题
    NSString *sad_title = dic[@"title"];
    gameAdData.title = [SimuUtil changeIDtoStr:sad_title];
    //广告图地址
    NSString *sad_adImage = dic[@"adImage"];
    gameAdData.adImage = [SimuUtil changeIDtoStr:sad_adImage];
    //广告类型，2501：图片广告，2502：文字广告
    NSString *sad_type = dic[@"type"];
    gameAdData.type = [SimuUtil changeIDtoStr:sad_type];
    //点击广告图的跳转地址
    NSString *sad_forwardUrl = dic[@"forwardUrl"];
    gameAdData.forwardUrl = [SimuUtil changeIDtoStr:sad_forwardUrl];
    //如果type=2502，需显示的广告内容
    NSString *sad_content = dic[@"content"];
    gameAdData.content = [SimuUtil changeIDtoStr:sad_content];
    //排序
    gameAdData.rank =
        [NSString stringWithFormat:@"%ld", (long)[dic[@"rank"] integerValue]];
    [self.dataArray addObject:gameAdData];
  }
}
+ (void)requestNormalAdvertisingDataAdWallWithUrl:(NSString *)url
                                     withCallBack:(HttpRequestCallBack *)callback{
  JsonFormatRequester *request = [[JsonFormatRequester alloc]init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}
+ (void)requestGameAdvertisingDataAdWallWithCallback:
            (HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/assist/ad/adWall"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}
+ (void)requestOpenAccountAdvDataWithCallback:(HttpRequestCallBack *)callback
{
  NSString *url =
  [data_address stringByAppendingString:@"youguu/assist/ad/adWall"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}
//聊股吧广告图片请求
+ (void)requeststockBarAdvertisingDataAdWallWithCallback:
(HttpRequestCallBack *)callback {
  NSString *url =
  [adData_address stringByAppendingString:@"asteroid/ad/adPageList?type=2406"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}
/** 追踪牛人广告图片请求*/
+ (void)requestFollowMasterBannerDataAdWallWithCallback:
(HttpRequestCallBack *)callback {
  NSString *url =
  [adData_address stringByAppendingString:@"asteroid/ad/adPageList?type=2407"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}

//高级VIP专区图片请求
+ (void)requestAdvanceVIPAdvertisingDataAdWallWithCallback:
(HttpRequestCallBack *)callback {
  NSString *url =
  [adData_address stringByAppendingString:@"asteroid/ad/adPageList?type=2404"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestGameAdvertisingDataPopWindowWithCallback:
            (HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/assist/ad/popWindow"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}

//引导页广告
+ (void)requestGameAdvertisingDataLoadingPageWithCallback:
(HttpRequestCallBack *)callback {
  NSString *url =
  [data_address stringByAppendingString:@"youguu/assist/ad/loadingPage"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GameAdvertisingData class]
             withHttpRequestCallBack:callback];
}
@end
