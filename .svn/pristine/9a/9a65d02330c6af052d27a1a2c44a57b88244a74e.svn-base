//
//  MyAttentionInfo.m
//  SimuStock
//
//  Created by jhss on 13-12-16.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MyAttentionInfo.h"
#import "SimuUtil.h"

#import "BaseRequester.h"
#import "CacheUtil.h"
#import "AttentionEventObserver.h"

@implementation MyAttentionInfo

+ (MyAttentionInfo *)sharedInstance {
  static MyAttentionInfo *sharedInstance = nil;

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    sharedInstance = [[self alloc] init];
  });

  if (![[SimuUtil getUserID]
          isEqualToString:sharedInstance.myAttentionsArray.myUserId]) {
    [sharedInstance startGetAttentionInfo];
  }

  return sharedInstance;
}

#pragma mark-------读取关注列表------
- (void)startGetAttentionInfo {
  if (![SimuUtil isLogined]) {
    return;
  }
  MyAttentionList *myAttentionList = [CacheUtil loadMyAttentionList];
  if (myAttentionList) {
    [self bindAttionList:myAttentionList saveToCache:NO];
  }
  //下载我的关注信息
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyAttentionInfo *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    MyAttentionInfo *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindAttionList:(MyAttentionList *)obj saveToCache:YES];
    }
  };
  callback.onFailed = ^{
  };

  NSDictionary *dic = @{
    @"uid" : [SimuUtil getUserID],
    @"startnum" : @"1",
    @"endnum" : @"-1"
  };
  [MyAttentionList requestPositionDataWithParams:dic withCallback:callback];
}

- (void)bindAttionList:(MyAttentionList *)obj saveToCache:(BOOL)saveToCache {
  if (saveToCache) {
    obj.myUserId = [SimuUtil getUserID];
    [CacheUtil saveMyAttentionList:obj];
  }
  //获得最新关注信息
  _myAttentionsArray = obj;
}
///  通过用户的名称获取，用户的userID
- (NSString *)isKindOfMyContactWithuserID:(NSString *)nickName {
  for (MyAttentionInfoItem *item in _myAttentionsArray.dataArray) {
    if ([item.userListItem.nickName isEqualToString:nickName])
      return [item.userListItem.userId stringValue];
  }
  return nil;
}

- (NSMutableArray *)getAttentionArray {
  return _myAttentionsArray.dataArray;
}
//取消关注
- (void)deleteItemFromAttentionArray:(NSString *)userId {
  if (userId == nil) {
    return;
  }
  if ([userId length] == 0) {
    return;
  }
  MyAttentionInfoItem *tempItem = nil;
  int i = 0;
  for (MyAttentionInfoItem *item in _myAttentionsArray.dataArray) {
    if ([item.userListItem.userId integerValue] == [userId integerValue]) {
      tempItem = item;
      break;
    }
    i++;
  }
  //最好不要在数组遍历的时候改变它
  if (tempItem) {
    [_myAttentionsArray.dataArray removeObjectAtIndex:i];
  }
  [AttentionEventObserver postCancelAttentionEvent];
}
//关注
- (void)addItemToAttentionArray:(MyAttentionInfoItem *)item {
  for (MyAttentionInfoItem *obj in _myAttentionsArray.dataArray) {
    // nsnumber类型与nsstring类型比较
    if ([obj.userListItem.userId integerValue] ==
        [item.userListItem.userId integerValue])
      return;
  }
  [_myAttentionsArray.dataArray addObject:item];

  [AttentionEventObserver postAttentionEvent];
}

- (BOOL)isAttentionWithUserId:(NSString *)userId {
  for (MyAttentionInfoItem *savedItem in _myAttentionsArray.dataArray) {
    //遍历
    if ([userId integerValue] == [savedItem.userListItem.userId integerValue]) {
      return YES;
    }
  }
  return NO;
}

@end
