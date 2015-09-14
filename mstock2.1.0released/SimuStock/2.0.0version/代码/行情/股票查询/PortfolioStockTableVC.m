//
//  PortfolioStockTableVC.m
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PortfolioStockTableVC.h"

#import "SelfStockTableModel.h"
#import "PortfolioStockModel.h"

@implementation PortfolioStockTableAdapter

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

  cell.stocksBtn1.hidden = NO;
  cell.stocksBtn2.hidden = NO;
  cell.verticalLine.hidden = NO;
  for (int i = 0; i < 2; i++) {
    cell.gainersView = cell.gainArray[i];
    if ([self.dataArray.array count] < (2 * indexPath.row + i + 1)) {
      cell.stocksBtn2.hidden = YES;
      cell.gainersView.hidden = YES;
      break;
    }
    cell.gainersView.hidden = NO;
    SelfStockItem *itemInfo = self.dataArray.array[2 * indexPath.row + i];
    NSString *nameStr = [NSString
        stringWithFormat:@"%@ (%@)", itemInfo.stockName, itemInfo.stockCode];
    //涨幅
    NSString *gainStr =
        [NSString stringWithFormat:@"%0.2f%%", itemInfo.dataPer];
    cell.gainersView.gainLab.textColor =
        [StockUtil getColorByFloat:itemInfo.dataPer];

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
            constrainedToSize:CGSizeMake(tableView.bounds.size.width / 2 -
                                             (30.0f + 15.0 / 2 + 10.0f),
                                         21.0)
                lineBreakMode:NSLineBreakByCharWrapping];
    cell.gainersView.gainView.frame =
        CGRectMake((tableView.bounds.size.width / 2 - labelsize.width -
                    (30.0f + 15.0 / 2 + 10.0f)) /
                       2,
                   36.0, labelsize.width + 30.0f + 15.0 / 2 + 10.0f, 21.0);

    cell.gainersView.arrowsImageV.left = 30.0f;
    cell.gainersView.gainLab.left = 30.0f + 15.0 / 2 + 10.0f;
    NSString *format =
        [StockUtil getPriceFormatWithFirstType:itemInfo.firstType];
    NSString *formatWithSign =
        [StockUtil isFund:itemInfo.firstType] ? @"%+0.3f" : @"%+0.2f";
    //最新价
    NSString *curPriceStr =
        [NSString stringWithFormat:format, itemInfo.curPrice];
    //增长数
    NSString *increaseStr =
        [NSString stringWithFormat:formatWithSign, itemInfo.change];
    NSString *priceStr =
        [NSString stringWithFormat:@"%@ (%@)", curPriceStr, increaseStr];
    cell.gainersView.priceLab.textColor =
        [StockUtil getColorByFloat:itemInfo.change];

    CGSize labelsizeOfCurPri =
        [priceStr sizeWithFont:[UIFont systemFontOfSize:10.0]
             constrainedToSize:CGSizeMake(
                                   tableView.bounds.size.width / 2 - 45.0, 21.0)
                 lineBreakMode:NSLineBreakByCharWrapping];

    cell.gainersView.curPriView.frame = CGRectMake(
        (tableView.bounds.size.width / 2 - labelsizeOfCurPri.width - 45.0) / 2,
        65.0, labelsizeOfCurPri.width + 45.0, 21.0);

    cell.gainersView.gainLab.text = gainStr;
    cell.gainersView.nameLab.text = nameStr;
    cell.gainersView.priceLab.text = priceStr;
  }

  return cell;
}

- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag row:(NSInteger)row {

  SelfStockItem *stock = nil;
  if (tag == 7700) {
    if ([self.dataArray.array count] < (2 * row + 1)) {
      return;
    }
    stock = self.dataArray.array[2 * row];
  } else if (tag == 7701) {
    if ([self.dataArray.array count] < (2 * row + 2)) {
      return;
    }
    stock = self.dataArray.array[2 * row + 1];
  } else {
    return;
  }
  if (!stock) {
    return;
  }

  if (self.onStockSelectedCallback) {
    self.onStockSelectedCallback(stock.code, stock.stockName, stock.firstType);
  }
}

- (OnStockSelected)onStockSelectedCallback {
  return ((PortfolioStockTableVC *)self.baseTableViewController)
      .onStockSelectedCallback;
}

@end

@implementation PortfolioStockTableVC {
  SelfStockChangeNotification *portfolioStockChangeObserver;
}

- (NSString *)getSelfStocksWithFilterIndex:(BOOL)filterIndex {
  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local
          findGroupById:GROUP_ALL_ID];

  if (!filterIndex) {
    return [group stockListStringWithSplit:@","];
  }

  __block NSMutableString *stockList = [[NSMutableString alloc] init];
  __block NSInteger index = 0;
  [group.stockCodeArray
      enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx,
                                   BOOL *stop) {
        if (stockCode.length != 0) {
          if ([stockCode characterAtIndex:1] != '0') { //过滤指数股
            if (index != 0) {
              [stockList appendString:@","];
            }
            [stockList appendString:stockCode];
            index++;
          }
        }
      }];
  return stockList;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  NSString *stockCodes = [self getSelfStocksWithFilterIndex:_filterStockIndex];
  if ([stockCodes length] == 0) {
    [self endRefreshLoading];
    StockTableData *data = [[StockTableData alloc] init];
    data.stocks = [@[] mutableCopy];
    [self bindRequestObject:data
        withRequestParameters:nil
              withRefreshType:refreshType];
    return;
  }

  [StockTableData getSelfStockInfo:stockCodes withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[PortfolioStockTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView
      setInformation:@"您" @"还没有自选股\n向右滑动看更多股票"];
  [self addObservers];
}

- (void)addObservers {
  __weak PortfolioStockTableVC *weakSelf = self;
  portfolioStockChangeObserver = [[SelfStockChangeNotification alloc] init];
  portfolioStockChangeObserver.onSelfStockChange = ^{
    [weakSelf.tableView reloadData];
  };
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end
