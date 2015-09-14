//
//  EditStockView.m
//  SimuStock
//
//  Created by Mac on 13-9-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "EditStockViewController.h"
#import "event_view_log.h"
#import "StockDBManager.h"
#import "StockPriceRemindClientVC.h"
#import "StockAlarmList.h"
#import "PortfolioStockModel.h"
#import "StockGroupToolTip.h"
#import "EditStockTip.h"
#import "SelectStocksViewController.h"
#import "UIButton+Block.h"

@implementation EditStockViewController

/** 加载自选股列表，页面初始化时调用，或者自选股列表变更时调用（用户登陆时） */
- (void)loadSelfStock {
  [_dataArray removeAllObjects];

  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];
  NSArray *stockCodes = [group stockCodeArray];
  for (NSString *stockCode in stockCodes) {
    NSArray *stocks =
        [StockDBManager searchFromDataBaseWith8CharCode:stockCode withRealTradeFlag:NO];
    if (stocks == nil || [stocks count] == 0) {
      continue;
    }

    for (StockFunds *item in stocks) {
      if ([item.code isEqualToString:stockCode]) {
        StockInfo *info = [[StockInfo alloc] init];
        if (info) {
          info.stockname = item.name;
          info.stockCode = item.stockCode;
          info.eightstockCode = item.code;
          info.isSelected = NO;
          info.firstType = [item.firstType stringValue];
          [_dataArray addObject:info];
        }
      }
    }
  }
  [_tableView reloadData];
}

- (id)initWithWithGroupId:(NSString *)groupId groupName:(NSString *)groupName {
  self = [super init];
  if (self) {
    _groupId = groupId;
    _groupName = groupName;
    //重新设置自选股数据
    _dataArray = [[NSMutableArray alloc] init];
    [self loadSelfStock];

    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak EditStockViewController *weakSelf = self;

  stockAlarmNotification = [[StockAlarmNotification alloc] init];
  stockAlarmNotification.onAddStockAlarm = ^(NSString *stockCode) {
    [weakSelf refreshTable];
  };
  stockAlarmNotification.onRemoveStockAlarm = ^(NSString *stockCode) {
    [weakSelf refreshTable];
  };

  selfStockChangeNotification = [[SelfStockChangeNotification alloc] init];
  selfStockChangeNotification.onSelfStockChange = ^{
    [weakSelf loadSelfStock];
  };

  loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  loginLogoutNotification.onLoginLogout = ^{
    [weakSelf loadSelfStock];
  };
}

- (void)refreshTable {
  [_tableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self creatControlViews];

  [_littleCattleView setInformation:@"暂无自选股"];
}

#pragma mark
#pragma mark 创建控件函数
- (void)creatControlViews {

  [_topToolBar resetContentAndFlage:[NSString stringWithFormat:@"%@自选股管理", _groupName]
                               Mode:TTBM_Mode_Leveltwo];
  _topToolBar.sbv_nameLable.adjustsFontSizeToFitWidth = YES;
  _topToolBar.sbv_nameLable.width = WIDTH_OF_SCREEN - 55 - 47.5f;

  self.indicatorView.hidden = YES;

  [self createSearchButton];
  [self creatEditStockButton];
  [self createTableHeader];

  //表格
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59 / 2, self.clientView.bounds.size.width,
                                                             self.clientView.bounds.size.height - 59 / 2)
                                            style:UITableViewStylePlain];

  [_tableView setEditing:YES animated:YES];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.clientView addSubview:_tableView];

  UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([FMMoveTableViewCell class]) bundle:nil];
  [_tableView registerNib:cellNib forCellReuseIdentifier:@"MoveCell"];
}

/**
 * 创建表头
 */
- (void)createTableHeader {
  UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"FMMoveTableHeaderView"
                                                      owner:nil
                                                    options:nil] lastObject];
  headerView.width = _clientView.width;
  [self.clientView addSubview:headerView];
}

/**
 * 创建搜索按钮
 */
- (void)createSearchButton {
  //按钮选中中视图

  BGColorUIButton *searchButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"] forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"] forState:UIControlStateHighlighted];
  [searchButton setNormalBGColor:[Globle colorFromHexRGB:@"086dae"]];
  [searchButton setHighlightBGColor:[Globle colorFromHexRGB:@"0c5e93"]];
  searchButton.frame = CGRectMake(self.view.width - 47.5 - 45, startY, 40, 45);
  [_topToolBar addSubview:searchButton];

  __weak EditStockViewController *weakSelf = self;
  [searchButton setOnButtonPressedHandler:^{
    [weakSelf searchButtonPress];
  }];
}

- (void)searchButtonPress {

  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"101"];
  OnStockSelected callback = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
    [TrendViewController showDetailWithStockCode:stockCode
                                   withStockName:stockName
                                   withFirstType:firstType
                                     withMatchId:@"1"];
  };
  SelectStocksViewController *selectStocksVC =
      [[SelectStocksViewController alloc] initStartPageType:SelfStockPage withCallBack:callback];

  [AppDelegate pushViewControllerFromRight:selectStocksVC];

  //取消所有选中状态
  for (StockInfo *obj in _dataArray) {
    obj.isSelected = NO;
  }
  _deleteButton.hidden = YES;
  [_tableView reloadData];
}

- (BOOL)canDelete {
  BOOL canDeleteFlag = NO;
  for (StockInfo *obj in _dataArray) {
    if (obj.isSelected == YES) {
      canDeleteFlag = YES;
      break;
    }
  }
  return canDeleteFlag;
}

- (void)clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (buttonIndex == 1) {
    NSMutableArray *deletedStockArray = [[NSMutableArray alloc] init];
    NSMutableArray *deletedStockAlarmArray = [[NSMutableArray alloc] init];

    StockAlarmList *stockAlarmList = [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    for (StockInfo *obj in _dataArray) {
      if (obj.isSelected) {
        [deletedStockArray addObject:obj];
        if ([_groupId isEqualToString:GROUP_ALL_ID] && [stockAlarmList isSelfStockAlarm:obj.eightstockCode]) {
          [deletedStockAlarmArray addObject:obj.eightstockCode];
        }
      }
    }
    //删除本页面自选股数据
    [_dataArray removeObjectsInArray:deletedStockArray];

    [_tableView reloadData];
    _deleteButton.hidden = YES;

    //重新设置股票
    [self setSelfStock];
    [[NSNotificationCenter defaultCenter] postNotificationName:SelfStockChangeNotificationName
                                                        object:nil];

    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"99"];
    //删除股价预警
    [deletedStockAlarmArray enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx, BOOL *stop) {
      HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
      callBack.onSuccess = ^(NSObject *obj) {
        StockAlarmList *stockAlarmList = [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
        [stockAlarmList deleteSelfStockAlarm:stockCode];
      };
      callBack.onFailed = ^{
      };
      callBack.onError = ^(BaseRequestObject *obj, NSException *ex) {
      };
      [EmptyStockAlarmRules requestEmptyStockRulesWithUid:[SimuUtil getUserID]
                                        withStockCodeLong:stockCode
                                             withCallback:callBack];
    }];
  }
}

//创建删除按钮
- (void)creatEditStockButton {
  //加入删除按钮
  _deleteButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];

  [_deleteButton buttonWithTitle:@"删除"
              andNormaltextcolor:@"82f8ff"
        andHightlightedTextColor:@"82f8ff"];
  [_deleteButton setNormalBGColor:[Globle colorFromHexRGB:@"086dae"]];
  [_deleteButton setHighlightBGColor:[Globle colorFromHexRGB:@"0c5e93"]];

  [_deleteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

  _deleteButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  _deleteButton.frame = CGRectMake(_topToolBar.bounds.size.width - 47.5f, startY, 47.5f, 45.0);
  [_topToolBar addSubview:_deleteButton];

  __weak EditStockViewController *weakSelf = self;

  [_deleteButton setOnButtonPressedHandler:^{
    EditStockViewController *strongSelf = weakSelf;
    if (![strongSelf canDelete]) {
      return;
    }
    NSArray *groupArray = [NSArray arrayWithObject:strongSelf.groupId];
    NSString *tipMessage =
        ([strongSelf.groupId isEqualToString:GROUP_ALL_ID]
             ? @"将会在所有自选股列表中删除该股票，确认删除？"
             : @"将会删除该分组中的股票，不会影响其他列表，确认删除？");

    [EditStockTip showEditStockTipWithContent:tipMessage
        andSureCallBack:^{
          [[strongSelf getSelectedStockCodes] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            [PortfolioStockManager removePortfolioStock:obj withGroupIds:groupArray];
          }];
          [strongSelf clickedButtonAtIndex:1];
          [PortfolioStockManager synchronizePortfolioStock];
        }
        andCancleCallBack:^{
          [strongSelf clickedButtonAtIndex:0];
        }];

  }];

  _deleteButton.hidden = YES;

  self.onTableRowSelectedCallback = ^(NSInteger rowIndex, BOOL isSecected) {
    EditStockViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf resetDeleteButtonOnRow:rowIndex selected:isSecected];
    }
  };
}

- (NSArray *)getSelectedStockCodes {
  __block NSMutableArray *tempArrayM = [NSMutableArray array];
  [_dataArray enumerateObjectsUsingBlock:^(StockInfo *infoItem, NSUInteger idx, BOOL *stop) {
    if (infoItem.isSelected) {
      [tempArrayM addObject:infoItem.eightstockCode];
    }
  }];
  return tempArrayM;
}

- (void)resetDeleteButtonOnRow:(NSInteger)rowIndex selected:(BOOL)isSecected {
  StockInfo *infoItem = _dataArray[rowIndex];
  if (infoItem) {
    infoItem.isSelected = isSecected;
  }
  _deleteButton.hidden = ![self canDelete];
}

- (void)setSelfStock {
  __block NSMutableString *stockList = [[NSMutableString alloc] init];
  NSMutableArray *stocks = [[NSMutableArray alloc] init];
  [_dataArray enumerateObjectsUsingBlock:^(StockInfo *obj, NSUInteger idx, BOOL *stop) {
    if (idx != 0) {
      [stockList appendString:@","];
    }
    [stockList appendString:obj.eightstockCode];
    [stocks addObject:obj.eightstockCode];
  }];

  QuerySelfStockElement *group =
      [[PortfolioStockManager currentPortfolioStockModel].local findGroupById:_groupId];

  //自选股信息发生变更，更新数据
  if (![stockList isEqualToString:[group stockListStringWithSplit:@","]]) {
    [group.stockCodeArray removeAllObjects];
    [group.stockCodeArray addObjectsFromArray:stocks];
    [[PortfolioStockManager currentPortfolioStockModel] save];
  }
}

- (void)leftButtonPress {
  [self setSelfStock];
  NSLog(@"☀️同步分组信息");
  [PortfolioStockManager synchronizePortfolioStock];
  [super leftButtonPress];
}

//#pragma mark -
//#pragma mark Controller life cycle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //小牛显示判断
  (_dataArray.count == 0) ? [_littleCattleView isCry:NO] : (_littleCattleView.hidden = YES);
  return [_dataArray count];
}

- (UITableViewCell *)tableView:(FMMoveTableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"MoveCell";
  FMMoveTableViewCell *cell =
      (FMMoveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  cell.contentView.width = tableView.width;
  cell.width = tableView.width;

  /******************************** NOTE ********************************
   * Implement this check in your table view data source to ensure that the
   *moving
   * row's content is reseted
   **********************************************************************/
  __weak EditStockViewController *weakSelf = self;
  [cell setOnSelectedCallback:^(BOOL isSecected) {
    EditStockViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf onTableRowSelectedCallback](indexPath.row, isSecected);
    }
  }];

  if (_dataArray) {
    [cell bindStockItemInfo:_dataArray[indexPath.row]];
  }

  [cell setShouldIndentWhileEditing:NO];
  [cell setShowsReorderControl:NO];

  [cell.stockGroupButton setOnButtonPressedHandler:^{
    [StockGroupToolTip showWithEightStockCode:[_dataArray[indexPath.row] eightstockCode]
        andSureBtnClickBlock:^(NSArray *selectedGroupIds, NSString *eightStockCode) {
          //本地删除
          QuerySelfStockData *tempData = [PortfolioStockManager currentPortfolioStockModel].local;
          [tempData.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *element, NSUInteger idx, BOOL *stop) {
            //如果包含当前组，侧添加，否则删除
            if ([selectedGroupIds containsObject:element.groupId]) {
              if (![element.stockCodeArray containsObject:eightStockCode] && eightStockCode.length == 8) {
                [element.stockCodeArray insertObject:eightStockCode atIndex:0];
              }
            } else {
              if (![element.groupId isEqualToString:GROUP_ALL_ID]) {
                [element.stockCodeArray removeObject:eightStockCode];
              }
            }
          }];
          [[PortfolioStockManager currentPortfolioStockModel] save];

          //本地表格删除
          if (![selectedGroupIds containsObject:_groupId] && ![_groupId isEqualToString:GROUP_ALL_ID]) {
            [_dataArray enumerateObjectsUsingBlock:^(StockInfo *info, NSUInteger idx, BOOL *stop) {
              if ([info.eightstockCode isEqualToString:eightStockCode]) {
                [_dataArray removeObject:info];
                [_tableView reloadData];
                *stop = YES;
              }
            }];
          }

        }
        andCancleBtnClickBlock:^{

        }
        showGroupAll:NO];
  }];

  return cell;
}

//#pragma mark -
//#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  //注销cell单击事件
  cell.selected = NO;
  //取消选中项
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
  if ([_dataArray count] <= indexPath.row)
    return;
  SelfStockItem *dic = _dataArray[indexPath.row];

  [TrendViewController showDetailWithStockCode:dic.code
                                 withStockName:dic.stockName
                                 withFirstType:dic.firstType
                                   withMatchId:@"1"
                                withStockArray:_dataArray
                                     withIndex:indexPath.row];
}

//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

//移动cell时的操作
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath {

  if (sourceIndexPath != destinationIndexPath) {

    id object = _dataArray[sourceIndexPath.row];
    [_dataArray removeObjectAtIndex:sourceIndexPath.row];
    if (destinationIndexPath.row > [_dataArray count]) {
      [_dataArray addObject:object];
    } else {
      [_dataArray insertObject:object atIndex:destinationIndexPath.row];
    }
    [_tableView reloadData];
  }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView
    titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 2) {
    return @"删除";
  }
  return @"删除";
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleNone;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark
#pragma mark 功能函数
- (void)resetVisibleEditButton {
  BOOL canedit = NO;
  _deleteButton.hidden = NO;
  for (StockInfo *obj in _dataArray) {
    if (obj.isSelected == YES) {
      canedit = YES;
    }
  }
  if (canedit == YES) {
    _deleteButton.enabled = YES;
  } else {
    _deleteButton.enabled = NO;
  }
}

@end
