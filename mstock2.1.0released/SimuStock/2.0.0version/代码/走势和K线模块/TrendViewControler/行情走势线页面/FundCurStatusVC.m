//
//  FundCurStatusVC.m
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundCurStatusVC.h"
#import "FundHoldStockTableViewCell.h"
#import "FundHoldStockHeaderCell.h"

@interface RTFundHoldStocksAdapter ()

@property(nonatomic, weak) FundCurStatusVC *owner;

@end

@implementation RTFundHoldStocksAdapter

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return _owner.fundBaseInfoView;
  } else {
    return nil;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return FundBaseInfoViewSuggestHeight;
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
  if (indexPath.section == 1) {
    if (indexPath.row == 0) { // header
      return 59.f;
    } else if (self.dataArray.array.count == 0 && indexPath.row == 1) {
      return 150.f; // cow
    } else {
      return 45.0f; // stock info
    }
  }

  return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 1) {
    NSInteger count = self.dataArray.array.count;
    return count == 0 ? 2 : (count + 1);
  }

  return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      NSString *headCell = NSStringFromClass([FundHoldStockHeaderCell class]);
      FundHoldStockHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headCell];

      if (_fundHoldStockList) {
        NSString *date = _fundHoldStockList.updateDateList[0];
        [cell bindUpdateDate:date
                withFundCode:_fundHoldStockList.fundCode
                withFundName:_fundHoldStockList.fundName];
      }

      cell.selectionStyle = UITableViewCellSelectionStyleNone;

      return cell;
    } else {
      if (self.dataArray.array.count == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (self.dataArray.dataComplete) {
          CGRect frame = CGRectMake(0.f, 0.f, WIDTH_OF_SCREEN, 150.f);
          LittleCattleView *littleCattleView =
          [[LittleCattleView alloc] initWithFrame:frame information:@"暂无持股明细"];
          littleCattleView.hidden = NO;
          [cell addSubview:littleCattleView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
      }
      FundHoldStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
      cell.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
      cell.selectionStyle = UITableViewCellSelectionStyleGray;

      FundHoldStock *stock = self.dataArray.array[indexPath.row - 1];
      [cell bindFundHoldStock:stock];
      return cell;
    }
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
  if (indexPath.section == 1 && self.dataArray.array.count > 0 && indexPath.row > 0) {
    FundHoldStock *stock = self.dataArray.array[indexPath.row - 1];
    [stock.fund showDetail];
  }
}

@end

@implementation FundCurStatusVC

- (void)resetWithFrame:(CGRect)frame withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if ([securitiesInfo.securitiesCode() isEqualToString:self.securitiesInfo.securitiesCode()]) {
    return;
  }
  [super resetWithFrame:frame withSecuritiesInfo:securitiesInfo];
  [self clearSecuritesData];

  [self.dataArray reset];
  [_tableView reloadData];
}

- (void)refreshSecuritesData {
  [_securitiesTrendVC refreshView];
  [self getFundHoldStockWithFundCode:self.securitiesInfo.securitiesCode()];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTableView];

  _fundBaseInfoView =
      [[FundBaseInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, FundBaseInfoViewSuggestHeight)];
  [self.view addSubview:_fundBaseInfoView];

  _securitiesTrendVC =
      [[SecuritiesTrendVC alloc] initWithFrame:CGRectMake(0, FundBaseInfoViewSuggestHeight, self.view.bounds.size.width, 223.f)
                            withSecuritiesInfo:self.securitiesInfo];
  __weak FundCurStatusVC *weakSelf = self;
  _securitiesTrendVC.stockQuotationInfoReady = ^(NSObject *obj) {
    [weakSelf bindFundCurStatus:(FundCurStatusWrapper *)obj];
  };
  _securitiesTrendVC.beginRefreshCallBack = self.beginRefreshCallBack;
  _securitiesTrendVC.endRefreshCallBack = self.endRefreshCallBack;

  [self addChildViewController:_securitiesTrendVC];
  [self.view addSubview:_securitiesTrendVC.view];

  [SimuUtil performBlockOnMainThread:^{
    [weakSelf refreshSecuritesData];
  } withDelaySeconds:0.1];
}

- (void)bindFundCurStatus:(FundCurStatusWrapper *)fundCurStatusWrapper {
  self.fundCurStatus = fundCurStatusWrapper.fundInfoList[0];
  [self.fundBaseInfoView bindFundCurStatus:self.fundCurStatus];
  if (self.onDataReadyCallBack) {
    self.onDataReadyCallBack();
  }
}

#pragma mark
#pragma mark 创建控件

- (RTFundHoldStocksAdapter *)tableAdapter {
  if (_tableAdapter == nil) {
    _tableAdapter = [[RTFundHoldStocksAdapter alloc] initWithTableViewController:nil
                                                                   withDataArray:self.dataArray];
    [self.tableView registerNib:[UINib nibWithNibName:_tableAdapter.nibName bundle:nil]
         forCellReuseIdentifier:_tableAdapter.nibName];

    NSString *headCell = NSStringFromClass([FundHoldStockHeaderCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:headCell bundle:nil]
         forCellReuseIdentifier:headCell];
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

#pragma mark
#pragma mark 网络函数

#pragma mark
#pragma mark 使用新的联网构架的所有网络访问函数

- (void)getFundHoldStockWithFundCode:(NSString *)fundCode {
  [self startRefreshLoading];
  if (![SimuUtil isExistNetwork]) {
    [self endRefreshLoading];
    [self setNoNetwork];
    return;
  }
  __weak FundCurStatusVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    FundCurStatusVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endRefreshLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    FundCurStatusVC *strongSelf = weakSelf;
    if (strongSelf) {
      FundHoldStockList *data = (FundHoldStockList *)object;
      [strongSelf bindFundHoldStockList:data withFundCode:fundCode];
    }
  };

  [FundHoldStockList requestHoldStocksWithParameters:@{
    @"code" : fundCode,
    @"start" : @"1",
    @"reqnum" : @"20"
  } withCallback:callback];
}

- (void)bindFundHoldStockList:(FundHoldStockList *)data withFundCode:(NSString *)fundCode {
  //基金数据返回时，如果当前已经切换至股票数据，忽略
  if (![self.securitiesInfo.securitiesCode() isEqualToString:fundCode]) {
    return;
  }
  data.fundCode = self.securitiesInfo.securitiesCode();
  data.fundName = self.securitiesInfo.securitiesName();
  _tableAdapter.fundHoldStockList = data;

  [self.dataArray.array removeAllObjects];
  [self.dataArray.array addObjectsFromArray:data.getArray];
  self.dataArray.dataComplete = YES;
  [_tableView reloadData];
}

#pragma mark
#pragma mark 对外接口

//清理当前数据
- (void)clearSecuritesData {
  [self.dataArray reset];
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
  if (_fundCurStatus == nil) {
    return @"--";
  } else {
    return [NSString stringWithFormat:@"%.3f", _fundCurStatus.curPrice];
  }
}

- (NSString *)riseRate {
  if (_fundCurStatus == nil) {
    return @"--";
  } else {
    return [NSString stringWithFormat:@"%.3f", _fundCurStatus.changePer];
  }
}

@end
