//
//  MarketHomeTableViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketHomeTableViewController.h"
#import "MarketConst.h"
#import "CustomPageData.h"
#import "MarketHeaderSectionView.h"
#import "MarketListViewController.h"
#import "SchollWebViewController.h"
#import "TrendViewController.h"

#import "MarketHomeWrapper.h"
#import "MobClick.h"

@implementation MarketHomeTableAdapter

- (id)initWithTableViewController:
          (BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList {
  if (self = [super initWithTableViewController:baseTableViewController
                                  withDataArray:dataList]) {
    self.titleNameArray = @[
      @"大盘指数",
      @"热门行业",
      @"热门概念",
      @"智能选股",
      @"涨幅榜",
      @"跌幅榜",
      @"换手榜",
      @"振幅榜",
      @"新股发行"
    ];

    _dataDic = [[NSMutableDictionary alloc] init];
  }
  return self;
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.titleNameArray count];
}

- (PacketTableData *)tableDataInSection:(MarketHomeSectionIndex)section {

  switch (section) {
  case MHSectionTypeIndex:
    return _dataDic[@"exponent"];

  case MHSectionTypeHotIndustry:
    return _dataDic[@"industry"];

  case MHSectionTypeHotNotion:
    return _dataDic[@"notion"];

  case MHSectionTypeRecommend:
    return _dataDic[@"toplist"];

  case MHSectionTypeRiseRank:
    return _dataDic[@"zdup"];

  case MHSectionTypeFailRank:
    return _dataDic[@"zddown"];

  case MHSectionTypeChangeHandRank:
    return _dataDic[@"hs"];

  case MHSectionTypeAmplitudeRank:
    return _dataDic[@"zf"];

  case MHSectionTypeIPOStocks:
    return _dataDic[@"newstock"];
  }
  return nil;
}

/** table是否为空 */
- (BOOL)isEmpty:(PacketTableData *)tableData {
  return tableData == nil || tableData.tableItemDataArray == nil ||
         [tableData.tableItemDataArray count] == 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  PacketTableData *tableData = [self tableDataInSection:section];
  if ([self isEmpty:tableData]) {
    return 0;
  }

  if (section == MHSectionTypeIndex || section == MHSectionTypeHotIndustry ||
      section == MHSectionTypeHotNotion || section == MHSectionTypeRecommend) {
    return 1;
  }

  if (section == MHSectionTypeIPOStocks) {
    return [tableData.tableItemDataArray count] + 1;
  }

  return [tableData.tableItemDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  PacketTableData *tableData = [self tableDataInSection:section];
  if ([self isEmpty:tableData]) {
    return 0;
  }
  return 27.5f;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == MHSectionTypeIndex) {
    return 73.5f;
  } else if (indexPath.section <= MHSectionTypeRecommend) {
    return 86.0f;
  } else if (indexPath.section == MHSectionTypeIPOStocks) {
    if (indexPath.row == 0) {
      return 30.0f;
    }
    return 45.0f;
  }
  return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  static NSString *sectionCell = @"MarketHeaderSectionView";
  MarketHeaderSectionView *cell =
      [tableView dequeueReusableCellWithIdentifier:sectionCell];
  if (cell == nil) {
    cell = [[MarketHeaderSectionView alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:sectionCell
              withFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width,
                                   27.5)];
  }
  cell.sectionLabel.text = self.titleNameArray[section];

  cell.action = ^{
    [AppDelegate
        pushViewControllerFromRight:[[MarketListViewController alloc]
                                        initStockListType:2000 + section]];
  };

  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"cell";
  MarketHomeTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:Cell];
  if (cell == nil) {
    cell = [[MarketHomeTableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:Cell];
    cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }

  for (int i = 0; i < [cell.complextArray count]; i++) {
    cell.complextView = cell.complextArray[i];
    cell.jumpBtn = cell.btnArray[i];
    cell.complextView.arrowImage.hidden = YES;
    cell.complextView.leaderNameLab.hidden = YES;
    cell.complextView.hidden = YES;
    cell.jumpBtn.hidden = YES;
  }
  cell.lineViewA.hidden = YES;
  cell.lineViewB.hidden = YES;
  cell.nameLab.hidden = YES;
  cell.curPriceLab.hidden = YES;
  cell.dataPerLab.hidden = YES;
  cell.codeLab.hidden = YES;
  cell.upLineView.hidden = YES;
  cell.downLineView.hidden = YES;
  cell.latestStockView.hidden = YES;

  PacketTableData *tableData = [self tableDataInSection:indexPath.section];

  switch (indexPath.section) {
  //指数
  case MHSectionTypeIndex: {
    cell.sectionInt = indexPath.section;
    cell.rowInt = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    for (int i = 0; i < [cell.complextArray count]; i++) {
      cell.complextView = cell.complextArray[i];
      cell.complextView.frame =
          CGRectMake(tableView.bounds.size.width / 3.f * i, 0.0,
                     tableView.bounds.size.width / 3.f, 147.0 / 2);
      cell.jumpBtn = cell.btnArray[i];
      cell.complextView.arrowImage.hidden = NO;
      cell.complextView.hidden = NO;
      cell.jumpBtn.hidden = NO;
      cell.jumpBtn.frame = cell.complextView.bounds;
      cell.complextView.changeLab.top = 105.0 / 2;
    }
    cell.lineViewA.hidden = NO;
    cell.lineViewB.hidden = NO;
    cell.lineViewA.frame =
        CGRectMake(tableView.size.width / 3 - 0.5, 0.0, 0.5, 147.0 / 2);
    cell.lineViewB.frame =
        CGRectMake((tableView.size.width * 2) / 3 - 0.5, 0.0, 0.5, 147.0 / 2);
    if (!tableData) {
      break;
    }
    for (int i = 0; i < [tableData.tableItemDataArray count]; i++) {
      cell.complextView = cell.complextArray[i];
      NSMutableDictionary *dic = tableData.tableItemDataArray[i];
      //名
      cell.complextView.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
      NSString *curPrice =
          [NSString stringWithFormat:@"%0.2f", [dic[@"curPrice"] floatValue]];
      //价
      cell.complextView.curPriceLab.text = curPrice;
      //变
      NSString *change =
          [NSString stringWithFormat:@"%0.2f", [dic[@"change"] floatValue]];
      CGFloat dataPerFloat = [dic[@"dataPer"] floatValue];
      NSString *dataPer = [NSString stringWithFormat:@"%+0.2f%%", dataPerFloat];
      //色
      cell.complextView.curPriceLab.textColor =
          [StockUtil getColorByFloat:dataPerFloat];
      //箭
      CGFloat changeLabelWidth =
          [SimuUtil widthNeededOfLabel:cell.complextView.curPriceLab font:16];
      cell.complextView.arrowImage.left = (cell.complextView.width - changeLabelWidth) / 2 - 8 - 5;

      if ([dataPer hasPrefix:@"-"]) {
        cell.complextView.arrowImage.image =
            [UIImage imageNamed:@"跌小图标"]; // 16*25

      } else {
        cell.complextView.arrowImage.image =
            [UIImage imageNamed:@"涨" @"小图标"];
      }
      //幅
      cell.complextView.changeLab.text =
          [change stringByAppendingFormat:@"  %@", dataPer];
    }

  } break;
  //行业
  case MHSectionTypeHotIndustry:
  case MHSectionTypeHotNotion:
  case MHSectionTypeRecommend: {
    cell.lineViewA.hidden = NO;
    cell.lineViewB.hidden = NO;
    cell.lineViewA.frame =
        CGRectMake(tableView.size.width / 3 - 0.5, 0.0, 0.5, 172.0 / 2);
    cell.lineViewB.frame =
        CGRectMake((tableView.size.width * 2) / 3 - 0.5, 0.0, 0.5, 172.0 / 2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sectionInt = indexPath.section;
    cell.rowInt = indexPath.row;
    for (int i = 0; i < [cell.complextArray count]; i++) {
      cell.complextView = cell.complextArray[i];
      cell.complextView.frame =
          CGRectMake((tableView.bounds.size.width * i) / 3, 0.0,
                     tableView.bounds.size.width / 3 - 0.5, 172.0 / 2);
      cell.jumpBtn = cell.btnArray[i];
      cell.complextView.arrowImage.hidden = YES;
      cell.complextView.leaderNameLab.hidden = NO;
      cell.complextView.hidden = NO;
      cell.jumpBtn.hidden = NO;
      cell.jumpBtn.frame = cell.complextView.bounds;
      cell.complextView.changeLab.centerY = 142.0 / 2;
    }

    for (int i = 0; i < [tableData.tableItemDataArray count]; i++) {
      cell.complextView = cell.complextArray[i];
      NSMutableDictionary *dic = tableData.tableItemDataArray[i];
      cell.complextView.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
      float value = [dic[@"dataPer"] floatValue];
      NSString *curPrice = [NSString stringWithFormat:@"%+0.2f%%", value];
      cell.complextView.curPriceLab.textColor =
          [StockUtil getColorByFloat:value];
      cell.complextView.curPriceLab.text = curPrice;
      cell.complextView.leaderNameLab.text =
          [SimuUtil changeIDtoStr:dic[@"leaderName"]];
      NSString *change = [NSString
          stringWithFormat:@"%0.2f", [dic[@"leaderCurPrice"] floatValue]];
      CGFloat dataPerFloat = [dic[@"leaderDataPer"] floatValue];
      NSString *dataPer = [NSString stringWithFormat:@"%0.2f%%", dataPerFloat];
      if (![dataPer hasPrefix:@"-"]) {
        dataPer = [NSString stringWithFormat:@"+%0.2f%%", dataPerFloat];
      }
      cell.complextView.changeLab.text =
          [change stringByAppendingFormat:@"  %@", dataPer];
    }

  } break;
  case MHSectionTypeRiseRank:
  case MHSectionTypeFailRank:
  case MHSectionTypeChangeHandRank:
  case MHSectionTypeAmplitudeRank: {
    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor =
        [Globle colorFromHexRGB:@"#e8e8e8"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    cell.upLineView.frame =
        CGRectMake(0.0, 45.0 - 1.0, cell.bounds.size.width, 0.5);
    cell.downLineView.frame =
        CGRectMake(0.0, 45.0 - 0.5, cell.bounds.size.width, 0.5);
    cell.nameLab.hidden = NO;
    cell.curPriceLab.hidden = NO;
    cell.dataPerLab.hidden = NO;
    cell.codeLab.hidden = NO;
    cell.upLineView.hidden = NO;
    cell.downLineView.hidden = NO;

    if (indexPath.row <= [tableData.tableItemDataArray count]) {
      if (indexPath.row == ([tableData.tableItemDataArray count] - 1)) {
        cell.upLineView.hidden = YES;
        cell.downLineView.hidden = YES;
      }
      NSMutableDictionary *dic = tableData.tableItemDataArray[indexPath.row];
      cell.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];
      NSString *curPrice =
          [NSString stringWithFormat:@"%0.2f", [dic[@"curPrice"] floatValue]];
      cell.curPriceLab.text = curPrice;
      float value = [dic[@"dataPer"] floatValue];
      NSString *dataPer = [NSString stringWithFormat:@"%0.2f%%", value];

      if (indexPath.section == 4 || indexPath.section == 5) {
//        cell.curPriceLab.textColor = [StockUtil getColorByFloat:value];
        cell.dataPerLab.textColor = [StockUtil getColorByFloat:value];
      } else {
        cell.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
        cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      }

      cell.dataPerLab.text = dataPer;
      NSString *stockcode =
          [NSString stringWithFormat:@"%lld", [dic[@"code"] longLongValue]];
      if (stockcode.length == 8) {
        stockcode = [stockcode substringFromIndex:2];
      }
      cell.codeLab.text = stockcode;
    }

  } break;
  case MHSectionTypeIPOStocks: {
    cell.upLineView.hidden = NO;
    cell.downLineView.hidden = NO;
    if (indexPath.row == 0) {
      cell.latestStockView.hidden = NO;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.upLineView.frame =
          CGRectMake(0.0, 30.0 - 1.0, tableView.bounds.size.width, 0.5);
      cell.downLineView.frame =
          CGRectMake(0.0, 30.0 - 0.5, tableView.bounds.size.width, 0.5);
      break;
    } else {
      //取消选中效果
      UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
      cell.selectedBackgroundView = backView;

      cell.selectedBackgroundView.backgroundColor =
          [Globle colorFromHexRGB:@"#e8e8e8"];
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
      cell.nameLab.hidden = NO;
      cell.curPriceLab.hidden = NO;
      cell.dataPerLab.hidden = NO;
      cell.codeLab.hidden = NO;
      cell.upLineView.frame =
          CGRectMake(0.0, 45.0 - 1.0, cell.bounds.size.width, 0.5);
      cell.downLineView.frame =
          CGRectMake(0.0, 45.0 - 0.5, cell.bounds.size.width, 0.5);
    }

    if ((indexPath.row - 1) <= [tableData.tableItemDataArray count]) {
      NSMutableDictionary *dic =
          tableData.tableItemDataArray[indexPath.row - 1];
      cell.nameLab.text = [SimuUtil changeIDtoStr:dic[@"name"]];

      long long curlong = [dic[@"issueShare"] longLongValue];
      NSInteger curlFloat = curlong / 10000;
      NSString *curPrice = [NSString stringWithFormat:@"%ld", (long)curlFloat];
      cell.curPriceLab.text = curPrice;
      cell.dataPerLab.text = [SimuUtil changeIDtoStr:dic[@"applyDate"]];
      NSString *stockcode =
          [NSString stringWithFormat:@"%lld", [dic[@"code"] longLongValue]];
      if (stockcode.length == 8) {
        stockcode = [stockcode substringFromIndex:2];
      }
      cell.codeLab.text = stockcode;

//      cell.curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
      cell.dataPerLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    }

  } break;

  default:
    break;
  }
  cell.delegate = self;
  return cell;
}

// uitable的选择方法
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if (MHSectionTypeIPOStocks == indexPath.section && indexPath.row == 0) {
    return;
  }

  PacketTableData *tableData = [self tableDataInSection:indexPath.section];

  if (!tableData) {
    return;
  }

  if (MHSectionTypeIPOStocks == indexPath.section) {
    if ((indexPath.row - 1) <= [tableData.tableItemDataArray count]) {
      NSMutableDictionary *dic =
          tableData.tableItemDataArray[indexPath.row - 1];
      NSString *stockcode =
          [NSString stringWithFormat:@"%lld", [dic[@"code"] longLongValue]];

      NSString *url = sharesWeb_address;
      NSString *texturl = [url
          stringByAppendingFormat:@"resource/newstockhtml/%@/newstock.html",
                                  stockcode];

      [SchollWebViewController startWithTitle:@"新股发行" withUrl:texturl];
      return;
    }
  }
  if (indexPath.row <= [tableData.tableItemDataArray count]) {
    [self showStockArray:tableData.tableItemDataArray withIndex:indexPath.row];
  }
}

- (void)showStockArray:(NSArray *)stockArray withIndex:(long)index {
  NSMutableDictionary *dic = stockArray[index];
  NSString *stockName = [SimuUtil changeIDtoStr:dic[@"name"]];
  NSString *stockCode = dic[@"code"];
  NSString *firstType = [dic[@"firstType"] stringValue];
  NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:stockArray];
  [TrendViewController showDetailWithStockCode:stockCode
                                 withStockName:stockName
                                 withFirstType:firstType
                                   withMatchId:@"1"
                                withStockArray:dataArray
                                     withIndex:index];
}

#pragma mark--------MarketHomeTableViewCellDelegate--------
- (void)bidButtonMarketHomeCallbackMethod:(NSInteger)tag
                                  section:(NSInteger)section
                                      row:(NSInteger)row {

  PacketTableData *paketTableData = [self tableDataInSection:section];
  if (!paketTableData) {
    return;
  }
  if (MHSectionTypeIndex == section) {
    [self showStockArray:paketTableData.tableItemDataArray
               withIndex:tag - 6400];
  } else {

    NSMutableDictionary *dic = paketTableData.tableItemDataArray[tag - 6400];
    NSString *stockname = [SimuUtil changeIDtoStr:dic[@"name"]];
    NSString *stockcode = [NSString stringWithFormat:@"%@", dic[@"code"]];

    MarketListViewController *marketListVC;
    if (section == MHSectionTypeRecommend) {
      marketListVC =
          [[MarketListViewController alloc] initRecommendCode:stockcode
                                            withRecommendName:stockname];
    } else {
      marketListVC =
          [[MarketListViewController alloc] initIndustryNotionCode:stockcode
                                            withIndustryNotionName:stockname];
    }

    //切换
    [AppDelegate pushViewControllerFromRight:marketListVC];
  }
}

@end

@implementation MarketHomeTableViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MarketHomeWrapper requestMarketHomeWithCallback:callback];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MarketHomeTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  NSArray *array = [latestData getArray];

  MarketHomeTableAdapter *adapter = (MarketHomeTableAdapter *)_tableAdapter;
  [adapter.dataDic removeAllObjects];
  for (PacketTableData *tableData in array) {
    adapter.dataDic[tableData.tableName] = tableData;
  }

  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  if (refreshType == RefreshTypeRefresh) {
    [NewShowLabel setMessageContent:@"行情更新成功"];
  }
  self.footerView.hidden = YES;
}

/** 是否支持自动加载更多 */
- (BOOL)supportAutoLoadMore {
  return NO;
}

- (void)dealloc {
  [self stopMyTimer];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

#pragma mark
#pragma mark 定时器相关函数

//设置定时器刷新时间
- (void)timerRefresh:(NSNotification *)notification {
  if (showBool) {
    [self stopMyTimer];
    [self initTrendTimer];
  }
}
//创建定时器
- (void)initTrendTimer {
  //得到刷新数据
  self.refreshTime = [SimuUtil getCorRefreshTime];
  if (self.refreshTime == 0) {
    [self stopMyTimer];
    return;
  }
  timeinterval = self.refreshTime;
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
    }
  }
  iKLTimer =
      [NSTimer scheduledTimerWithTimeInterval:timeinterval
                                       target:self
                                     selector:@selector(KLineHandleTimer:)
                                     userInfo:nil
                                      repeats:YES];
}
//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (self.refreshTime != [SimuUtil getCorRefreshTime]) {
    [self initTrendTimer];
  }
  if (iKLTimer == theTimer) {
    //如果无网络，则什么也不做；
    if (![SimuUtil isExistNetwork]) {
      return;
    }
    //如果当前交易所状态为闭市，则什么也不做
    if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
      return;
    }

    if (!showBool) {
      return;
    }

    [self requestResponseWithRefreshType:RefreshTypeTimerRefresh];
  }
}
//定时器停止
- (void)stopMyTimer {
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
      iKLTimer = nil;
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"行情"];

  NSLog(@"market home table view will appear");

  //页面切换对定时器做控制
  [self initTrendTimer];

  showBool = YES;

  if (!self.dataArray.dataBinded) {
    //请求
    [self requestResponseWithRefreshType:RefreshTypeTimerRefresh];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  NSLog(@"market home table view will viewWillDisappear");
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"行情"];

  //页面切换对定时器做控制
  [self stopMyTimer];
  showBool = NO;
}

@end
