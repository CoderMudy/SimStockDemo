//
//  BaseFundNetValueVC.m
//  SimuStock
//
//  Created by Mac on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseFundNetValueVC.h"
#import "CacheUtil+kline.h"

static CGFloat AdviseWidthFloatWindowViewForFund = 92.f;
static CGFloat AdviseHeightFloatWindowViewForFund = 34.f;
static CGFloat CommonMarginFloatWindowViewForFund = 10.f;

@implementation FloatWindowViewForFund

- (void)setFloatWindowStyle {
  self.layer.cornerRadius = 5.f;
  // A thin border.
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.layer.borderWidth = 0.3;

  // Drop shadow.
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.5;
  self.layer.shadowRadius = 3;
  self.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void)bindFundNav:(FundNav *)fundNav {
  _dateLabel.text = fundNav.dateWindow;
  _netvalueLabel.text = fundNav.fundUnitNavStr;
}

@end

@implementation BaseFundNetValueVC

- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSString *fundCode = self.securitiesInfo.securitiesCode();
  if (![self dataBinded]) {
    // load cache
    FundNetWorthList *cachedData =
        [CacheUtil loadFundNetWorthListWithFundCode:fundCode];
    if (cachedData) {
      [self.fundNetValueView bindFundNetWorthList:cachedData];
    }
  }

  NSDictionary *dic = @{
    @"code" : fundCode,
    @"pageindex" : @"1",
    @"pagesize" : @"201"
  };
  [FundNetWorthList requestFundCurStatusWithParameters:dic
                                          withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  FundNetWorthList *fundNetWorthList = (FundNetWorthList *)latestData;
  [self.fundNetValueView bindFundNetWorthList:fundNetWorthList];
  self.dataArray.dataBinded = YES;

  // save to cache
  NSString *fundCode = self.securitiesInfo.securitiesCode();
  [CacheUtil saveFundNetWorthList:fundNetWorthList withFundCode:fundCode];
}

@end

@implementation PortaitFundNetValueVC

- (void)viewDidLoad {
  [super viewDidLoad];

  ///添加净值趋势图
  self.fundNetValueView =
      [[FundNetValueView alloc] initWithFrame:self.view.bounds];
  self.fundNetValueView.securitiesInfo = self.securitiesInfo;
  self.fundNetValueView.tag = 1;
  self.fundNetValueView.isHorizontalMode = NO;
  self.fundNetValueView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.fundNetValueView];

  ///添加浮窗
  NSString *nibName = NSStringFromClass([FloatWindowViewForFund class]);
  self.floatWindowView = [[[NSBundle mainBundle] loadNibNamed:nibName
                                                        owner:nil
                                                      options:nil] firstObject];
  self.floatWindowView.hidden = YES;
  [self.floatWindowView setFloatWindowStyle];
  [self.view addSubview:self.floatWindowView];

  __weak PortaitFundNetValueVC *weakSelf = self;
  self.fundNetValueView.onFundNavSelected =
      ^(FundNav *fundNav, NSInteger selectIndex, NSInteger range) {
        if (fundNav) {
          if (selectIndex > range / 2) {
            weakSelf.floatWindowView.frame =
                CGRectMake(CommonMarginFloatWindowViewForFund,
                           CommonMarginFloatWindowViewForFund,
                           AdviseWidthFloatWindowViewForFund,
                           AdviseHeightFloatWindowViewForFund);
          } else {
            weakSelf.floatWindowView.frame =
                CGRectMake(weakSelf.view.bounds.size.width -
                               CommonMarginFloatWindowViewForFund -
                               AdviseWidthFloatWindowViewForFund,
                           CommonMarginFloatWindowViewForFund,
                           AdviseWidthFloatWindowViewForFund,
                           AdviseHeightFloatWindowViewForFund);
          }
          weakSelf.floatWindowView.hidden = NO;
          [weakSelf.floatWindowView bindFundNav:fundNav];
        } else {
          weakSelf.floatWindowView.hidden = YES;
        }
      };
}

@end

static CGFloat FundInfoViewHeight = 37.f;

@implementation HorizontalFundNetValueVC

- (void)viewDidLoad {
  [super viewDidLoad];

  ///添加分时趋势图
  [self createNetValueView];
}

- (void)createNetValueView {
  @try {
    self.floatWindowView =
        [[[NSBundle mainBundle] loadNibNamed:@"HorizontalFundInfoView"
                                       owner:nil
                                     options:nil] firstObject];
  } @catch (NSException *exception) {
    NSLog(@"%@", exception);
  }

  self.floatWindowView.frame =
      CGRectMake(0, 0, self.view.bounds.size.width, FundInfoViewHeight);
  self.floatWindowView.hidden = YES;
  self.floatWindowView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:self.floatWindowView];

  ///添加净值趋势图
  self.fundNetValueView = [[FundNetValueView alloc]
      initWithFrame:CGRectMake(
                        0, FundInfoViewHeight, self.view.bounds.size.width,
                        self.view.bounds.size.height - FundInfoViewHeight)];
  self.fundNetValueView.securitiesInfo = self.securitiesInfo;
  self.fundNetValueView.isHorizontalMode = YES;
  self.fundNetValueView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.fundNetValueView];

  __weak HorizontalFundNetValueVC *weakSelf = self;
  self.fundNetValueView.onFundNavSelected =
      ^(FundNav *fundNav, NSInteger selectIndex, NSInteger range) {
        if (fundNav) {
          weakSelf.floatWindowView.hidden = NO;
          [weakSelf.floatWindowView bindFundNav:fundNav];
        } else {
          weakSelf.floatWindowView.hidden = YES;
        }
        [[NSNotificationCenter defaultCenter]
            postNotificationName:LandscapeSegmentShouldHideNotification
                          object:@(fundNav != nil)];
      };
}

@end
