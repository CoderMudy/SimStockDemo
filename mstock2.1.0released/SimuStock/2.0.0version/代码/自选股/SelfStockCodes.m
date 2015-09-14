//
//  SelfStockCodes.m
//  SimuStock
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation SelfStockCodesUploadResult

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSNumber *number = dic[@"ver"];
  self.version = [NSString stringWithFormat:@"%d", [number intValue]];
}

/**
 更新自选股信息
 */
+ (void)uploadSelfStocks {
  if ([@"-1" isEqualToString:[SimuUtil getUserID]]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *object) {
    //刷新version
    SelfStockCodesUploadResult *result = (SelfStockCodesUploadResult *)object;
    [SimuUtil setSelfStockVer:result.version];
  };
  callback.onFailed = ^() {
    //什么也不做
  };

  NSMutableDictionary *dicionary = [[NSMutableDictionary alloc] init];

  dicionary[@"userid"] = [SimuUtil getUserID];
  dicionary[@"ver"] = [SimuUtil getSelfStockVer];
  dicionary[@"portfolio"] = [SimuUtil getSelfStock];
  dicionary[@"isForce"] = @"0";
  NSString *url =
      [user_address stringByAppendingString:@"jhss/portfolio/modify"];

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"POST"
                 withRequestParameters:dicionary
                withRequestObjectClass:[SelfStockCodesUploadResult class]
               withHttpRequestCallBack:callback];
}
@end

@implementation SelfStockCodes

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.portfolio = dic[@"portfolio"];
  NSNumber *number = dic[@"ver"];
  if (number) {
    self.version = [NSString stringWithFormat:@"%d", [number intValue]];
  }
}

/**
 获取最新的自选股信息
 */
+ (void)requestSelfStocksWithOnEndUpdate:
    (OnEndUpdateSelfStockAction)onEndUpdata {
  if ([@"-1" isEqualToString:[SimuUtil getUserID]]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *object) {
    //刷新数据
    SelfStockCodes *selfstockCodes = (SelfStockCodes *)object;

    NSString *localSelfStockVersion = [SimuUtil getSelfStockVer];

    void (^appendLocalSelfStocks)() = ^{
//      NSString *notLoginUserSelfStocks = [SimuUtil getSelfStockByUserId:@"-1"];
//      if (![@"" isEqualToString:notLoginUserSelfStocks]) {
//        [SimuUtil addSelfStock:notLoginUserSelfStocks appendAtHeader:NO];
//      }
//      [SimuUtil setEmptySelfStockByUserId:@"-1"];
//
//      
//      if ([localSelfStockVersion isEqualToString:@"0"] &&
//          !selfstockCodes.version &&
//          ![[SimuUtil getSelfStock] isEqualToString:@""]) {
//        //自选股为空
//        [SimuUtil addSelfStock:@"10000001,20399001" appendAtHeader:NO];
//      }
      if (onEndUpdata) {
        onEndUpdata();
      }
    };

    //服务端没有返回版本号，则与本地相同，不需要更新，直接返回
    if (!selfstockCodes.version) {
      appendLocalSelfStocks();
      return;
    }

    //服务端版本号与本地相同，不需要更新，直接返回
    if ([selfstockCodes.version isEqualToString:localSelfStockVersion]) {
      appendLocalSelfStocks();
      return;
    }

    //异常处理，本地版本号不为0，而服务端为0
    if ([selfstockCodes.version isEqualToString:@"0"] &&
        localSelfStockVersion &&
        ![localSelfStockVersion isEqualToString:@"0"]) {
      appendLocalSelfStocks();
      return;
    }

    //更新本地自选股数据
    [SimuUtil setSelfStock:selfstockCodes.portfolio];
    [SimuUtil setSelfStockVer:selfstockCodes.version];

    appendLocalSelfStocks();
  };
  callback.onFailed = ^() {
    //什么也不做
  };
  NSString *URL = [NSString stringWithFormat:@"%@jhss/portfolio/query/%@?v=%@",
                                             user_address, [SimuUtil getUserID],
                                             [SimuUtil getSelfStockVer]];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:URL
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SelfStockCodes class]
             withHttpRequestCallBack:callback];
}
@end
