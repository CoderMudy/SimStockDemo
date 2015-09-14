//
//  BaseS5B5VC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseS5B5VC.h"
#import "SimuTradeStatus.h"
#import "FundCurStatus.h"

@implementation BaseS5B5VC

- (void)dealloc {
  [timerUtil stopTimer];
}

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (self = [super initWithFrame:frame withSecuritiesInfo:securitiesInfo]) {

    __weak BaseS5B5VC *weakSelf = self;
    NSInteger refreshTime = [SimuUtil getCorRefreshTime];
    timerUtil = [[TimerUtil alloc]
        initWithTimeInterval:refreshTime
            withTimeCallBack:^{
              //如果无网络，则什么也不做；
              if (![SimuUtil isExistNetwork]) {
                return;
              }
              //如果当前交易所状态为闭市，则什么也不做
              if ([[SimuTradeStatus instance] getExchangeStatus] ==
                  TradeClosed) {
                return;
              }

              [weakSelf requestResponseWithRefreshType:RefreshTypeTimerRefresh];
            }];
  }
  return self;
}

- (NSString *)priceFormat {
  return [StockUtil
      getPriceFormatWithFirstType:self.securitiesInfo.securitiesFirstType()];
}

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if ([StockUtil isFund:self.securitiesInfo.securitiesFirstType()]) {
    [FundCurStatusWrapper requestFundCurStatusWithParameters:@{
      @"code" : self.securitiesInfo.securitiesCode()
    } withCallback:callback];
  } else {
    [StockQuotationInfo
        getStockQuotaWithFivePriceInfo:self.securitiesInfo.securitiesCode()
                          withCallback:callback];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createSB5View];
}

- (void)createSB5View {
}

- (BOOL)isIndex {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  return [StockUtil isMarketIndex:firstType];
}

@end

@implementation PortaitS5B5VC

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  self.dataArray.dataBinded = YES;
  if ([StockUtil isFund:self.securitiesInfo.securitiesFirstType()]) {
    FundCurStatusWrapper *data = (FundCurStatusWrapper *)latestData;
    [self.s5b5View setPageDate:data.stockQuotationInfo
                   priceFormat:self.priceFormat];
    if (self.stockQuotationInfoReady) {
      self.stockQuotationInfoReady(data);
    }
  } else {
    StockQuotationInfo *stockQuotationInfo = (StockQuotationInfo *)latestData;
    if (![StockUtil isMarketIndex:self.securitiesInfo.securitiesFirstType()]) {
      [self.s5b5View setPageDate:stockQuotationInfo
                     priceFormat:self.priceFormat];
    }
    if (self.stockQuotationInfoReady) {
      self.stockQuotationInfoReady(latestData);
    }
  }
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  self.s5b5View.frame = self.view.bounds;
  [self createSB5View];
}

- (void)createSB5View {
  if (self.s5b5View) {
    [self.s5b5View removeFromSuperview];
  }
  self.s5b5View = [[S5B5View alloc] initWithFrame:self.view.bounds
                                     isIndexStock:self.isIndex];
  [self.view addSubview:self.s5b5View];
}

- (void)clearView {
  [self.s5b5View clearAllData];
}

@end

@implementation HorizontalS5B5VC

- (void)createSB5View {
  if (self.s5b5View) {
    [self.s5b5View removeFromSuperview];
  }
  _s5b5View = [[[NSBundle mainBundle] loadNibNamed:@"HorizontalS5B5View"
                                             owner:nil
                                           options:nil] firstObject];
  //
//  _s5b5View = [[UIView alloc] initWithFrame:self.view.bounds];
//  _s5b5View.backgroundColor = [UIColor greenColor];
  //
  _s5b5View.frame = self.view.bounds;
  [_s5b5View initViews];
  [self.view addSubview:self.s5b5View];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  self.dataArray.dataBinded = YES;
  if ([StockUtil isFund:self.securitiesInfo.securitiesFirstType()]) {
    FundCurStatusWrapper *data = (FundCurStatusWrapper *)latestData;
    [self.s5b5View bindS5B5Data:data.stockQuotationInfo
                    priceFormat:self.priceFormat];
    if (self.stockQuotationInfoReady) {
      self.stockQuotationInfoReady(data);
    }
  } else {
    StockQuotationInfo *stockQuotationInfo = (StockQuotationInfo *)latestData;
    if (![StockUtil isMarketIndex:self.securitiesInfo.securitiesFirstType()]) {
      [self.s5b5View bindS5B5Data:stockQuotationInfo
                      priceFormat:self.priceFormat];
    }
    if (self.stockQuotationInfoReady) {
      self.stockQuotationInfoReady(latestData);
    }
  }
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  self.s5b5View.frame = self.view.bounds;
  [self createSB5View];
}

- (void)clearView {
  [self.s5b5View initViews];
}

@end
