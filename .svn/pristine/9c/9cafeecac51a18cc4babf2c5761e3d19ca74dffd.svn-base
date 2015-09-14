//
//  BaseTrendVC.m
//  SimuStock
//
//  Created by Mac on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "BaseTrendVC.h"

@implementation BaseTrendVC

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (self = [super initWithFrame:frame]) {
    _dataArray = [[DataArray alloc] init];
    self.securitiesInfo = securitiesInfo;
  }
  return self;
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  self.securitiesInfo = securitiesInfo;
  self.view.frame = frame;
}

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSException *ex =
      [NSException exceptionWithName:@"not implement method"
                              reason:@"[requestWithRefreshType:withDataArray:] "
                              @"method is not implemented"
                            userInfo:nil];
  [ex raise];
}

- (void)refreshView {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

- (BOOL)dataBinded {
  return self.dataArray.dataBinded;
}

- (void)setNoNetWork {
  [NewShowLabel showNoNetworkTip];
}

- (void)startRefreshLoading {
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
}

- (void)endRefreshLoading {
  if (self.endRefreshCallBack) {
    self.endRefreshCallBack();
  }
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  return nil;
}

///刷新或者加载下一页数据
- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  [self startRefreshLoading];
  if (![SimuUtil isExistNetwork]) {
    [self endRefreshLoading];
    [self setNoNetWork];
    return;
  }

  NSDictionary *requestParamerts =
      [self getRequestParamertsWithRefreshType:refreshType];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BaseTrendVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BaseTrendVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endRefreshLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    BaseTrendVC *strongSelf = weakSelf;
    if (strongSelf) {
      if ([obj conformsToProtocol:@protocol(Collectionable)]) {
        NSObject<Collectionable> *latestData = (NSObject<Collectionable> *)obj;
        [strongSelf bindRequestObject:latestData
                withRequestParameters:requestParamerts
                      withRefreshType:refreshType];
      } else {
        NSException *ex = [NSException
            exceptionWithName:@"not implement protocol"
                       reason:@"Collectionable Protocol is not implemented"
                     userInfo:nil];
        [ex raise];
      }
    }
  };

  callback.onFailed = ^() {
    [weakSelf setNoNetWork];
  };

  [self requestDataListWithRefreshType:refreshType
                         withDataArray:_dataArray
                          withCallBack:callback];
}

- (void)clearView {
}

//绑定数据
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {

  if (refreshType == RefreshTypeRefresh ||
      refreshType == RefreshTypeTimerRefresh) {
    [_dataArray.array removeAllObjects];
  }

  NSArray *array = [latestData getArray];
  [_dataArray.array addObjectsFromArray:array];

  // DataArray绑定数据
  _dataArray.dataBinded = YES;

  if ([array count] > 0) {
    _dataArray.dataComplete = NO;
  } else { //最后一段数据或空
    _dataArray.dataComplete = YES;
  }

  if (self.onDataReadyCallBack) {
    self.onDataReadyCallBack();
  }
}

@end
