//
//  SimuGroupMatchTableVC.m
//  SimuStock
//
//  Created by jhss on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuGroupMatchTableVC.h"
#import "UserListItem.h"
#import "simuMarchCounterVC.h"
#import "PersionMatchTableViewCell.h"
#import "SimuMatchInfo.h"
#import "StockUtil.h"

#import "SimuSchoolMatchsViewController.h"

@implementation SimuGroupMatchTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([PersionMatchTableViewCell class]);
  }
  return nibFileName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [self.dataArray.array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PersionMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  SimuPersionMatchItem *Item = self.dataArray.array[indexPath.row];
  cell.rankNum.text = Item.rankNum;
  cell.nameLabel.hidden = YES;
  cell.classLabel.hidden = YES;
  cell.rankClassLabel.text = Item.teamName;
  
  UIColor *color = [StockUtil getColorByChangePercent:Item.profitLabel];
  cell.profitStr.textColor = color;
  double profitability =
  [[Item.profitLabel substringWithRange:NSMakeRange(0, Item.profitLabel.length - 1)] doubleValue];
  if (profitability > 0.00) {
    cell.profitStr.text = [NSString stringWithFormat:@"+%@", Item.profitLabel];
  } else {
    cell.profitStr.text = Item.profitLabel;
  }
  cell.rankNum.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  switch (indexPath.row) {
  case 0: {
    cell.rankNum.textColor = [Globle colorFromHexRGB:@"#d20f0f"];
  } break;
  case 1: {
    cell.rankNum.textColor = [Globle colorFromHexRGB:@"#e98f00"];
  } break;
  case 2: {
    cell.rankNum.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  } break;

  default:
    break;
  }

  return cell;
}

#pragma mark - cell点击，创建某人单独页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  SimuPersionMatchItem *Item = self.dataArray.array[indexPath.row];
  SimuGroupMatchTableVC *groupTableView = (SimuGroupMatchTableVC *)self.baseTableViewController;
  SimuSchoolMatchsViewController *simuSchoolMatch =
      [[SimuSchoolMatchsViewController alloc] initWithTitleName:Item.teamName
                                                    withMatchID:groupTableView.matchId
                                                     withTempID:Item.teamId
                                                  withMatchType:nil];
  simuSchoolMatch.shareTitle = groupTableView.titleName;
  [AppDelegate pushViewControllerFromRight:simuSchoolMatch];

  return;
}

@end

@implementation SimuGroupMatchTableVC
- (id)initWithFrame:(CGRect)frame
          withMType:(NSString *)mType
        withMtahcID:(NSString *)matchID
       withRankType:(NSString *)rankType
      withTilteName:(NSString *)titleName {
  self = [super initWithFrame:frame];
  if (self) {
    self.mType = mType;
    self.matchId = matchID;
    self.rankType = rankType;
    self.titleName = titleName;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"1";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    fromId = [@(self.dataArray.array.count + 1) stringValue];
  }
  return @{ @"startid" : fromId, @"reqnum" : pageSize, @"mid" : self.matchId };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"startId"];
    NSString *lastId = [@(self.dataArray.array.count + 1) stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [SimuMatchInfo getGroupMatchWithInput:[self getRequestParamertsWithRefreshType:refreshType]
                          withMatchType:self.rankType
                           withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[SimuGroupMatchTableAdapter alloc] initWithTableViewController:self
                                                                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
@end
