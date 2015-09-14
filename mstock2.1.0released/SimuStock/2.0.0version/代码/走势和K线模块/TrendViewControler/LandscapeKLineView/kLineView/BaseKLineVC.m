//
//  BaseKLineVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseKLineVC.h"
#import "CacheUtil+kline.h"

@implementation BaseKLineVC

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (![self dataBinded]) {
   KLineDataItemInfo *kLineDataInfo = [CacheUtil
        loadKLineDataWithStockCode:self.securitiesInfo.securitiesCode()
                         firstType:self.securitiesInfo.securitiesFirstType()
                              type:self.type
                          xrdrType:@"0"];
    if (kLineDataInfo) {
      [self.kLineView setPageData:kLineDataInfo
                withSecuritiesInfo:self.securitiesInfo];
    }
  }
  [KLineDataItemInfo getKLineTypesInfo:self.securitiesInfo.securitiesCode()
                                  type:self.type
                              xrdrType:@"0"
                          withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  self.dataArray.dataBinded = YES;
  KLineDataItemInfo *data = (KLineDataItemInfo *)latestData;
  data.stockcode = self.securitiesInfo.securitiesCode();
  data.type = self.type;
  data.xrdrType = @"0";
  [CacheUtil saveKLineData:data
                 firstType:self.securitiesInfo.securitiesFirstType()];
  [self.kLineView setPageData:data withSecuritiesInfo:self.securitiesInfo];
}

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo
      withKLineType:(NSString *)type {
  if (self = [super initWithFrame:frame withSecuritiesInfo:securitiesInfo]) {
    self.type = type;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.kLineView = [[LandscapeKLineView alloc] initWithFrame:self.view.bounds
                                                 isLandscape:NO];
  [self.view addSubview:self.kLineView];
}

- (void)clearView {
  [self.kLineView clearAllData];
}

@end
