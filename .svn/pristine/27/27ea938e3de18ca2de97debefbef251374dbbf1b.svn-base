//
//  FundHoldStocksViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundHoldStocksTableViewController.h"
#import "FundHoldStockTableViewCell.h"

@implementation FundHoldStocksAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([FundHoldStockTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  FundHoldStockTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];

  FundHoldStock *stock = self.dataArray.array[indexPath.row];
  [cell bindFundHoldStock:stock];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  FundHoldStockTableViewCell *cell =
      (FundHoldStockTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  //注销cell单击事件
  cell.selected = NO;
  //取消选中项
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]
                           animated:YES];
  if ([self.dataArray.array count] <= indexPath.row)
    return;

  FundHoldStock *stock = self.dataArray.array[indexPath.row];
  [stock.fund showDetail];
}

@end

@implementation FundHoldStocksTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.top += 32.f;
  self.tableView.height -= 45.f;
  [self.littleCattleView setInformation:@"暂无持股明细"];

  NSArray *views =
      [[NSBundle mainBundle] loadNibNamed:@"FundHoldStockTableHeader"
                                    owner:nil
                                  options:nil];
  _tableHeader = [views firstObject];
  _tableHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 32.f);
  [self.view addSubview:_tableHeader];
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [FundHoldStockList requestHoldStocksWithParameters:
                         [self getRequestParamertsWithRefreshType:refreshType]
                                        withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"1";
  if (refreshType == RefreshTypeLoaderMore) {
    start = [@(self.dataArray.array.count + 20) stringValue];
  }
  return @{ @"code" : _fundCode, @"start" : start, @"reqnum" : @"20" };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"start"];
    NSString *lastId = [@(self.dataArray.array.count + 20) stringValue];
    ;
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  _stockList = (FundHoldStockList *)latestData;
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  if (latestData.getArray.count < 20) {
    self.tableView.tableFooterView.hidden = NO;
    self.footerView.hidden = YES;
  }
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[FundHoldStocksAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
        forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end
