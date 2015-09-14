//
//  FiveDayRiseStocksTableVCViewController.m
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FiveDayRiseStocksTableVC.h"

@implementation FiveDayRiseStocksTableAdapter

//- (NSString *)nibName {
//  static NSString *nibFileName;
//  if (nibFileName == nil) {
//    nibFileName = NSStringFromClass([SameStockHeroTableViewCell class]);
//  }
//  return nibFileName;
//}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 94.0f;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSInteger row = [self.dataArray.array count] / 2;
  if (([self.dataArray.array count] % 2) == 1) {
    row += 1;
  }
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *Cell1 = @"cell1";
  GainersTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:Cell1];
  if (cell == nil) {
    cell =
        [[GainersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:Cell1];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.rowInt = indexPath.row;
  cell.delegate = self;
  for (int i = 0; i < 2; i++) {
    if ([self.dataArray.array count] < (2 * indexPath.row + i + 1)) {
      break;
    }
    cell.gainersView = cell.gainArray[i];
    RoseStockItem *stock = self.dataArray.array[2 * indexPath.row + i];
    cell.gainersView.gainLab.textColor = [StockUtil getColorByText:stock.gain];

    NSString *nameStr = [NSString
        stringWithFormat:@"%@ (%@)", stock.stockName, stock.stockCode];
    //涨幅
    NSString *gainStr = stock.gain;

    if ([gainStr hasPrefix:@"-"]) {
      gainStr =
          [gainStr stringByReplacingOccurrencesOfString:@"-" withString:@""];

      cell.gainersView.arrowsImageV.image =
          [UIImage imageNamed:@"跌" @"绿按钮"];
    } else {
      cell.gainersView.arrowsImageV.image =
          [UIImage imageNamed:@"涨" @"红按钮"];
    }
    CGSize labelsize =
        [gainStr sizeWithFont:[UIFont systemFontOfSize:20.0]
            constrainedToSize:CGSizeMake(tableView.bounds.size.width / 2 - 59.0,
                                         21.0)
                lineBreakMode:NSLineBreakByCharWrapping];
    cell.gainersView.gainView.frame = CGRectMake(
        (tableView.bounds.size.width / 2 - labelsize.width - 59.0) / 2, 36.0,
        labelsize.width + 59.0, 21.0);

    cell.gainersView.priceLab.textColor =
        [StockUtil getColorByText:stock.priceIncrease];

    NSString *priceStr = nil;
    if ([stock.priceIncrease hasPrefix:@"-"]) {
      priceStr = [NSString
          stringWithFormat:@"%@ (%@)", stock.curPrice, stock.priceIncrease];
    } else {
      priceStr = [NSString
          stringWithFormat:@"%@ (+%@)", stock.curPrice, stock.priceIncrease];
    }
    
    CGSize labelsizeOfCurPri =
    [priceStr sizeWithFont:[UIFont systemFontOfSize:10.0]
        constrainedToSize:CGSizeMake(tableView.bounds.size.width / 2 - 45.0,
                                     21.0)
            lineBreakMode:NSLineBreakByCharWrapping];

    cell.gainersView.curPriView.frame = CGRectMake(
        (tableView.bounds.size.width / 2 - labelsizeOfCurPri.width - 45.0) / 2, 65.0,
        labelsizeOfCurPri.width + 45.0, 21.0);
    
    
    cell.gainersView.gainTitleLab.text = @"5日涨幅";
    cell.gainersView.gainLab.text = gainStr;
    cell.gainersView.nameLab.text = nameStr;
    cell.gainersView.priceLab.text = priceStr;
  }

  return cell;
}

- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag row:(NSInteger)row {

  RoseStockItem *dic = nil;
  if (tag == 7700) {
    if ([self.dataArray.array count] < (2 * row + 1)) {
      return;
    }
    dic = self.dataArray.array[2 * row];
  } else if (tag == 7701) {
    if ([self.dataArray.array count] < (2 * row + 2)) {
      return;
    }
    dic = self.dataArray.array[2 * row + 1];
  } else {
    return;
  }
  if (!dic) {
    return;
  }

  if (self.onStockSelectedCallback) {
    self.onStockSelectedCallback(dic.stockCode, dic.stockName,
                                 FIRST_TYPE_UNSPEC);
  }
}

- (OnStockSelected)onStockSelectedCallback {
  return ((FiveDayRiseStocksTableVC *)self.baseTableViewController)
      .onStockSelectedCallback;
}

@end

@implementation FiveDayRiseStocksTableVC

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *pageIndex = @"1";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    NSInteger page = 1;
    if ([self.dataArray.array count] > 0) {
      page = [self.dataArray.array count] / 20 + 1;
    }
    pageIndex = [@(page) stringValue];
  }
  return @{ @"pageIndex" : pageIndex, @"pageSize" : pageSize };
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [FiveDayRoseStocks getFiveDayRoseStocksWithParams:
                         [self getRequestParamertsWithRefreshType:refreshType]
                                       withCallback:callback];
}
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {

  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"pageIndex"];
    NSInteger page = [self.dataArray.array count] / 20 + 1;
    if ([fromId integerValue] != page) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore &&
      self.dataArray.array.count >= 100) {
    [((FiveDayRoseStocks *)latestData).stocks removeAllObjects];
  }
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[FiveDayRiseStocksTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
  self.showTableFooter = YES;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end
