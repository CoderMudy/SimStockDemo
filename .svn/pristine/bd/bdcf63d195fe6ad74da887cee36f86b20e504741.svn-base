//
//  UniversityInfoData.m
//  SimuStock
//
//  Created by Jhss on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UniversityInfoData.h"
#import "PinYinForObjc.h"
#import "NSString+validate.h"
@implementation UniversityInfoItem

- (void)jsonToObject:(NSDictionary *)dic {
  _orderId = [dic[@"id"] stringValue];
  _schoolName = dic[@"schoolName"];
  _schoolCode = dic[@"schoolCode"];
  //判断是否是中文
  BOOL isChinese = [NSString validataInputIsChinese:_schoolName];
  if (isChinese) {
    //如果是汉字先转换为字母
    _pinyinName = [[PinYinForObjc chineseConvertToPinYinHead:_schoolName] uppercaseString];
  } else {
    _pinyinName = [_schoolName uppercaseString];
  }
  _indexLetter = [[_pinyinName substringToIndex:1] uppercaseString];
}

@end

#pragma mark-------------版本号
@implementation UniversityListVersion

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  self.version = [resultDic[@"version"] integerValue];
}

/** 返回列表版本号 */
+ (void)requestMatchUniversityListVersionWithCallback:(HttpRequestCallBack *)callback {

  NSString *url = [NSString stringWithFormat:@"http://img.youguu.com/trade_web/school/version"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[UniversityListVersion class]
             withHttpRequestCallBack:callback];
}

@end

@implementation UniversityInfoData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  self.codeDic = [[NSMutableDictionary alloc] init];
  NSArray *resultArr = dic[@"result"];
  //地区列表数组
  [resultArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
    UniversityInfoItem *item = [[UniversityInfoItem alloc] init];
    [item jsonToObject:obj];
    [self.dataArray addObject:item];
    self.codeDic[item.schoolCode] = item.schoolCode;
  }];
  UniversityInfoItem *item = [self.dataArray lastObject];
  if (item) {
    self.maxSortId = item.orderId;
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

- (NSDictionary *)mappingDictionary {
  return @{
    @"dataArray" : NSStringFromClass([UniversityInfoItem class]),
    @"codeDic" : @{NSStringFromClass([NSString class]) : NSStringFromClass([NSString class])}
  };
}

/** 请求高校列表 */
+ (void)requetMathSelectUniversityNameWithFromId:(NSString *)fromId
                                      withReqNum:(NSString *)reqNum
                                    withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address
      stringByAppendingString:@"youguu/match/query_school_list?fromId={fromId}&reqNum={reqNum}"];
  NSDictionary *dic = @{ @"fromId" : fromId, @"reqNum" : reqNum };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[UniversityInfoData class]
             withHttpRequestCallBack:callback];
}

@end
