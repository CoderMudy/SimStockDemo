//
//  UserBpushInformationNum.m
//  SimuStock
//
//  Created by Mac on 15/3/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserBpushInformationNum.h"
#import "RealTradeRequester.h"
#import "FileStoreUtil.h"

@implementation UserBpushInformationNum

- (instancetype)init {
  if (self = [super init]) {
    self.unReadCountDic = [@{} mutableCopy];
    for (NSInteger i = UserBpushAllCount; i <= UserVipCount; i++) {
      _unReadCountDic[@(i)] = @0;
    }
  }
  return self;
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  NSDictionary *result = dic[@"result"];
  NSInteger count = [result[@"count"] integerValue];
  NSInteger commentCount = [result[@"commentCount"] integerValue];
  NSInteger mentionCount = [result[@"mentionCount"] integerValue];
  NSInteger followCount = [result[@"followCount"] integerValue];
  NSInteger praiseCount = [result[@"praiseCount"] integerValue];

  _unReadCountDic[@(UserBpushAllCount)] = @(count);
  _unReadCountDic[@(UsercommentCount)] = @(commentCount);
  _unReadCountDic[@(UsermentionCount)] = @(mentionCount);
  _unReadCountDic[@(UserfollowCount)] = @(followCount);
  _unReadCountDic[@(UserpreiseCount)] = @(praiseCount);

  ///服务端无法返回此三类提醒的未读数
  _unReadCountDic[@(UserSystemMessageCount)] = @(0);
  _unReadCountDic[@(UserStockWarning)] = @(0);
  _unReadCountDic[@(UserVipCount)] = @(0);
//  _unReadCountDic[@(UserTraceMessage)] = @(0);
}

- (NSDictionary *)mappingDictionary {
  return @{
    @"unReadCountDic" : @{
      NSStringFromClass([NSNumber class]) : NSStringFromClass([NSNumber class])
    }
  };
}

- (void)computeUnReadSum {
  NSInteger sum = 0;
  for (NSInteger i = UsercommentCount; i <= UserVipCount; i++) {
    if (i != UserfollowCount) {
      sum += [_unReadCountDic[@(i)] integerValue];
    }
  }
  _unReadCountDic[@(UserBpushAllCount)] = @(sum);
}

+ (void)requestUnReadStaticDataWithCallBack:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:@"/istock/newTalkStock/getUserMsgCount"];

  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[UserBpushInformationNum class]
               withHttpRequestCallBack:callback];
}

///如果点击应用启动,需要请求一下当前用户的所收到的应用信息
+ (void)requestUnReadStaticData {
  if (![SimuUtil isExistNetwork] || ![SimuUtil isLogined]) {
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {

    UserBpushInformationNum *userCount = (UserBpushInformationNum *)obj;
    UserBpushInformationNum *savedCount =
        [UserBpushInformationNum getUnReadObject];

    NSArray *array = @[
      @(UsercommentCount),
      @(UsermentionCount),
      @(UserfollowCount),
      @(UserpreiseCount)
    ];
    [array enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx,
                                        BOOL *stop) {
      NSInteger sum = [savedCount.unReadCountDic[number] integerValue] +
                      [userCount.unReadCountDic[number] integerValue];
      savedCount.unReadCountDic[number] = @(sum);
    }];

    [savedCount computeUnReadSum];
    [FileStoreUtil saveUserBpushInformationNum:savedCount];
  };
  [UserBpushInformationNum requestUnReadStaticDataWithCallBack:callback];
}

+ (void)resetUnReadAllCount {
  UserBpushInformationNum *savedCount =
      [UserBpushInformationNum getUnReadObject];
  [savedCount computeUnReadSum];
  [FileStoreUtil saveUserBpushInformationNum:savedCount];
}

- (NSInteger)getCount:(YLBpushType)type {
  NSNumber *unRead = _unReadCountDic[@(type)];
  return unRead ? [unRead integerValue] : 0;
}

+ (void)clearUnReadCountWithMessageType:(YLBpushType)bpushType {
  UserBpushInformationNum *savedCount =
      [UserBpushInformationNum getUnReadObject];
  savedCount.unReadCountDic[@(bpushType)] = @(0);
  [savedCount computeUnReadSum];
  [FileStoreUtil saveUserBpushInformationNum:savedCount];
}

+ (void)increaseUnReadCountWithMessageType:(YLBpushType)bpushType {
  if (bpushType == UsercommentCount || bpushType == UsermentionCount ||
      bpushType == UserfollowCount || bpushType == UserpreiseCount) {
    //此4种类型不直接增加，通过请求服务端未读数据+1
    [UserBpushInformationNum requestUnReadStaticData];
    return;
  }
  UserBpushInformationNum *savedCount =
      [UserBpushInformationNum getUnReadObject];
  NSInteger sum = [savedCount getCount:bpushType] + 1;
  savedCount.unReadCountDic[@(bpushType)] = @(sum);
  [savedCount computeUnReadSum];
  [FileStoreUtil saveUserBpushInformationNum:savedCount];
}

///获取未读的统计数据
+ (UserBpushInformationNum *)getUnReadObject {
  UserBpushInformationNum *savedCount =
      [FileStoreUtil loadUserBpushInformationNum];
  if (savedCount == nil) {
    savedCount = [[UserBpushInformationNum alloc] init];
  }
  return savedCount;
}

@end
