//
//  testViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "testViewController.h"
#import "FundNetValueView.h"
#import "BasePartTimeVC.h"
#import "IndexCurStatusVC.h"
#import "StockCurStatusVC.h"

@implementation testViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];

  securitiesInfo.securitiesCode = ^{
    return @"21150001"; //@"10000001"; //
  };
  securitiesInfo.securitiesFirstType = ^{
    return @"4"; //@"1"; //
  };
  SecuritiesInfo *securitiesInfo2 = [[SecuritiesInfo alloc] init];

  securitiesInfo2.securitiesCode = ^{
    return @"10000001"; //
  };
  securitiesInfo2.securitiesFirstType = ^{
    return @"1"; //
  };

  SecuritiesInfo *securitiesInfo3 = [[SecuritiesInfo alloc] init];

  securitiesInfo3.securitiesCode = ^{
    return @"21002314"; //
  };
  securitiesInfo3.securitiesFirstType = ^{
    return @"2"; //
  };

  //  StockDetailTableViewController *vc =
  //      [[StockDetailTableViewController alloc] initWithFrame:CGRectMake(0,
  //      10, 104, 100) withStockCode:@"21002314"];

  HorizontalPartTimeVC *vc =
      [[HorizontalPartTimeVC alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 300)
                               withSecuritiesInfo:securitiesInfo3];

  [self.clientView addSubview:vc.view];
  [self addChildViewController:vc];

  if (!vc.dataBinded) {
    [vc refreshView];
  }
}

///基金净值测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  FundNetValueView *netWorthView =
//      [[FundNetValueView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)];
//  netWorthView.securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  netWorthView.securitiesInfo.securitiesCode = ^{
//    return @"21150001";
//  };
//  //  netWorthView.backgroundColor = [UIColor colorWithRed:.3f green:.3f
//  //  blue:.3f alpha:0.2];
//  netWorthView.backgroundColor = [UIColor clearColor];
//  [self.clientView addSubview:netWorthView];
//  [netWorthView requestFundNetWorthList];
//}

///分时竖屏测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo.securitiesCode = ^{
//    return @"10000001";
//    //    return @"21150001";
//  };
//  securitiesInfo.securitiesFirstType = ^{
//    return @"1";
//    //    return @"4";
//  };
//
//  PartTimeHorizontalView *netWorthView =
//      [[PartTimeHorizontalView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN,
//      400)
//                                 withSecuritiesInfo:securitiesInfo];
//
//  [self.clientView addSubview:netWorthView];
//
//  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
//
//  callback.onSuccess = ^(NSObject *object) {
//
//    TrendData *data = (TrendData *)object;
//
//    //分时数据绑定
//    [netWorthView.partTimeView setTrendData:(TrendData *)data
//                             securitiesInfo:securitiesInfo];
//
//  };
//
//  [TrendData getStockTrendInfo:securitiesInfo.securitiesCode()
//                withStartIndex:@"1"
//                  withCallback:callback];
//}

///多Tab趋势图测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo.securitiesCode = ^{
//    return @"21150001"; //@"10000001"; //
//  };
//  securitiesInfo.securitiesFirstType = ^{
//    return @"4"; //@"1"; //
//  };
//
//  SecuritiesInfo *securitiesInfo2 = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo2.securitiesCode = ^{
//    return @"10000001"; //
//  };
//  securitiesInfo2.securitiesFirstType = ^{
//    return @"1"; //
//  };
//
//  ComposePartTimeVC *vc =
//      [[ComposePartTimeVC alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)
//                            withSecuritiesInfo:securitiesInfo];
//
//  [self.clientView addSubview:vc.view];
//  [self addChildViewController:vc];
//
//  if (!vc.dataBinded) {
//    [vc refreshView];
//  }
//
////  [vc resetWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)
////      withSecuritiesInfo:securitiesInfo2];
//}

///多Tab趋势图测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo.securitiesCode = ^{
//    return @"21150001"; //@"10000001"; //
//  };
//  securitiesInfo.securitiesFirstType = ^{
//    return @"4"; //@"1"; //
//  };
//  SecuritiesInfo *securitiesInfo2 = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo2.securitiesCode = ^{
//    return @"10000001"; //
//  };
//  securitiesInfo2.securitiesFirstType = ^{
//    return @"1"; //
//  };
//
//  SecuritiesTrendVC *vc =
//      [[SecuritiesTrendVC alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)
//                            withSecuritiesInfo:securitiesInfo2];
//
//  [self.clientView addSubview:vc.view];
//  [self addChildViewController:vc];
//
//  if (!vc.dataBinded) {
//    [vc refreshView];
//  }
//}

///分时竖屏测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo.securitiesCode = ^{
//    return @"21150001"; //@"10000001"; //
//  };
//  securitiesInfo.securitiesFirstType = ^{
//    return @"4"; //@"1"; //
//  };
//
//  PortaitPartTimeVC *vc =
//  [[PortaitPartTimeVC alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)
//                        withSecuritiesInfo:securitiesInfo];
//
//  [self.clientView addSubview:vc.view];
//  [self addChildViewController:vc];
//
//  if (!vc.dataBinded) {
//    [vc refreshView];
//  }
//}

///分时横竖屏测试
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  PartTimeView2 *netWorthView =
//  [[PartTimeView2 alloc] initWithFrame:CGRectMake(0, 10, WIDTH_OF_SCREEN, 200)];
//  SecuritiesInfo *securitiesInfo = [[SecuritiesInfo alloc] init];
//
//  securitiesInfo.securitiesCode = ^{
//    return @"21150001";
//  };
//  securitiesInfo.securitiesFirstType = ^{
//    return @"4";
//  };
//  netWorthView.isHorizontalMode = YES;
//
//  netWorthView.backgroundColor = [UIColor clearColor];
//  [self.clientView addSubview:netWorthView];
//
//  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
//
//  callback.onSuccess = ^(NSObject *object) {
//
//    TrendData *data = (TrendData *)object;
//
//    //分时数据绑定
//    [netWorthView setTrendData:(TrendData *)data
//    securitiesInfo:securitiesInfo];
//
//  };
//
//  [TrendData getStockTrendInfo:securitiesInfo.securitiesCode()
//                withStartIndex:@"1"
//                  withCallback:callback];
//}

@end
