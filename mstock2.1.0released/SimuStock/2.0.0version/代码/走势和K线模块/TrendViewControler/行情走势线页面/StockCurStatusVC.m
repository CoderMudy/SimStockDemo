//
//  StockCurStatusVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockCurStatusVC.h"

static CGFloat StockInfoViewHeight = 137.f;

@interface StockCurStatusAdapter ()

@property(nonatomic, weak) StockCurStatusVC *owner;

@end

@implementation StockCurStatusAdapter

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return _owner.topStockInfoView;
  } else {
    return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return StockInfoViewHeight;
  } else {
    return 0.f;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return _owner.securitiesTrendVC.view;
  } else {
    return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return 240.f;
  } else {
    return 0.f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return 0;
}

@end

@implementation StockCurStatusVC

- (void)resetWithFrame:(CGRect)frame withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if ([securitiesInfo.securitiesCode() isEqualToString:self.securitiesInfo.securitiesCode()]) {
    return;
  }
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  [self clearView];

  [_tableView reloadData];
}

- (void)refreshSecuritesData {
  [self refreshView];
}

- (void)refreshView {
  [_securitiesTrendVC refreshView];
  [self getFundsFlowDataFromNet:self.securitiesInfo.securitiesCode()];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTableView];

  _topStockInfoView = [[TopStockInfoView alloc]
      initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10, StockInfoViewHeight)
             IsDapa:NO];

  _securitiesTrendVC = [[SecuritiesTrendVC alloc]
           initWithFrame:CGRectMake(0, StockInfoViewHeight, self.view.bounds.size.width, 223.f)
      withSecuritiesInfo:self.securitiesInfo];
  __weak StockCurStatusVC *weakSelf = self;
  _securitiesTrendVC.stockQuotationInfoReady = ^(NSObject *obj) {
    [weakSelf bindSecuritiesCurStatus:(StockQuotationInfo *)obj];
  };
  _securitiesTrendVC.beginRefreshCallBack = self.beginRefreshCallBack;
  _securitiesTrendVC.endRefreshCallBack = self.endRefreshCallBack;

  [self addChildViewController:_securitiesTrendVC];
  [self.view addSubview:_securitiesTrendVC.view];

  _fundFlowView = [[SimuFundFlowView alloc] initWithFrame:CGRectMake(0, 345, WIDTH_OF_SCREEN, 700)];
  [_tableView setTableFooterView:_fundFlowView];

  [SimuUtil performBlockOnMainThread:^{
    [weakSelf refreshSecuritesData];
  } withDelaySeconds:0.1];
}

- (void)bindSecuritiesCurStatus:(StockQuotationInfo *)data {
  self.stockQuotationInfo = data;
  [self.topStockInfoView setHeadStcokInfo:data IsDapan:NO];
  if (self.onDataReadyCallBack) {
    self.onDataReadyCallBack();
  }
}

#pragma mark
#pragma mark 创建控件

- (StockCurStatusAdapter *)tableAdapter {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockCurStatusAdapter alloc] initWithTableViewController:nil
                                                                 withDataArray:self.dataArray];
  }
  _tableAdapter.owner = self;
  return _tableAdapter;
}

//创建滚动页面
- (void)createTableView {
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
  _tableView.delegate = [self tableAdapter];
  _tableView.dataSource = [self tableAdapter];
  _tableView.bounces = YES;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:_tableView];
}

/**
 * 设置无网络小牛
 */
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

- (void)getFundsFlowDataFromNet:(NSString *)stockCode {
  [self startRefreshLoading];
  if (![SimuUtil isExistNetwork]) {
    [self endRefreshCallBack];
    [self setNoNetwork];
    return;
  }
  __weak StockCurStatusVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    StockCurStatusVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endRefreshCallBack];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    StockCurStatusVC *strongSelf = weakSelf;
    if (strongSelf) {
      FundsFlowData *data = (FundsFlowData *)object;
      if (_fundFlowView) {
        [_fundFlowView setPageData:data];
      }
    }
  };

  callback.onFailed = ^() {
    [weakSelf setNoNetwork];
  };

  [FundsFlowData getFundsFlowInfo:stockCode withCallback:callback];
}

#pragma mark
#pragma mark 对外接口

//清理当前数据
- (void)clearSecuritesData {
  [_tableView reloadData];
  [_securitiesTrendVC clearView];
}

- (UIView *)curStatusViewForShare {
  if (_tableView) {
    return _tableView;
  }
  return nil;
}

- (NSString *)curPrice {
  if (_stockQuotationInfo == nil) {
    return @"--";
  } else {
    //个股信息
    __block NSString *curPrice = nil;

    [_stockQuotationInfo.dataArray
        enumerateObjectsUsingBlock:^(PacketTableData *packetTable, NSUInteger idx, BOOL *stop) {
          if ([packetTable.tableName isEqualToString:@"CurStatus"]) {
            NSDictionary *dic = packetTable.tableItemDataArray[0];
            CGFloat newprice = [dic[@"curPrice"] floatValue];
            curPrice = [NSString stringWithFormat:@"%.2f", newprice];
          }
        }];
    return curPrice ? curPrice : @"--";
  }
}

- (NSString *)riseRate {
  if (_stockQuotationInfo == nil) {
    return @"--";
  } else {
    //个股信息
    __block NSString *curPrice = nil;

    [_stockQuotationInfo.dataArray
        enumerateObjectsUsingBlock:^(PacketTableData *packetTable, NSUInteger idx, BOOL *stop) {
          if ([packetTable.tableName isEqualToString:@"CurStatus"]) {
            NSDictionary *dic = packetTable.tableItemDataArray[0];
            CGFloat riseRate = [dic[@"changePer"] floatValue];
            curPrice = [NSString stringWithFormat:@"%.2f%%", riseRate];
          }
        }];
    return curPrice ? curPrice : @"--";
  }
}

@end
