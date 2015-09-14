//
//  ClosedPositionViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ClosedPositionViewController.h"
#import "SimuRankClosedPositionPageData.h"
#import "PositionCell.h"
#import "SeperatorLine.h"
#import "ClosedPositionView.h"

@implementation ClosedPositionTableAdapter

- (NSInteger)selectedRowIndex {
  return ((ClosedPositionViewController *)self.baseTableViewController).selectedRowIndex;
}

- (ClosedPositionViewController *)owner {
  return (ClosedPositionViewController *)self.baseTableViewController;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row == self.selectedRowIndex) {
    return self.allCellHeight;
  } else {
    return self.foldCellHeight;
  }
}

- (CGFloat)allCellHeight {
  return _showButtons ? 200.0F : 170.f;
}

- (CGFloat)foldCellHeight {
  return 75.0F;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PositionCell *cell = (PositionCell *)[tableView cellForRowAtIndexPath:indexPath];
  PositionInfoView *posionView = cell.positionView;

  [tableView beginUpdates];

  if (indexPath.row == self.owner.selectedRowIndex) {
    [posionView present:self.foldCellHeight];
    self.owner.selectedRowIndex = -1; //设置为未选择
  } else {
    //如果不是第一次点击，则把上次点击的cell复原
    if (self.owner.selectedRowIndex != -1) {
      [self tableView:tableView
          didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.owner.selectedRowIndex
                                                     inSection:0]];
    }
    [posionView present:self.allCellHeight];
    self.owner.selectedRowIndex = indexPath.row; //设置为当前选择
  }
  [tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"closedPositioncell";
  ClosedPositionCell *cell = (ClosedPositionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[ClosedPositionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    ClosedPositionView *infoView = [[ClosedPositionView alloc] initWithUserId:self.owner.userID
                                                                  withMatchId:self.owner.matchID
                                                                    withFrame:cell.bounds];
    if (_showButtons) {
      [infoView createButton];
    }

    cell.positionView = infoView;
    [cell addSubview:infoView];
  }
  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  cell.positionView.triangleImage.frame = CGRectMake(
      self.owner.view.frame.size.width - 7.0f / 2 - 27.0f / 2, 75.0f - 27.0f / 2, 27.0f / 2, 27.0f / 2);
  cell.positionView.positionRateLabel.hidden = YES; //清仓不显示持仓比率
  cell.positionView.uid = self.owner.userID;
  cell.positionView.matchId = self.owner.matchID;
  //清仓列表为0，则隐藏
  if (self.dataArray.array.count == 0) {
    cell.positionView.hidden = YES;
  } else {
    cell.positionView.hidden = NO;
    [self setClosedPositionItem:cell IndexPath:indexPath];
  }
  return cell;
}

- (void)setClosedPositionItem:(ClosedPositionCell *)cell IndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row == self.owner.selectedRowIndex) {
    [cell.positionView setClosedPosition:self.dataArray.array[indexPath.row]

                               withFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 200)];

    cell.positionView.triangleImage.hidden = YES;
  } else {
    [cell.positionView setClosedPosition:self.dataArray.array[indexPath.row]

                               withFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 75)];

    cell.positionView.triangleImage.hidden = NO;
  }
}

@end

@implementation ClosedPositionViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [SimuRankClosedPositionPageData requestClosedPositionWithParameters:[self getRequestParamertsWithRefreshType:refreshType]
                                                         withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromid = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    ClosedPositionInfo *closedInfo = (ClosedPositionInfo *)[self.dataArray.array lastObject];
    fromid = closedInfo.seqID;
  }
  return @{
    @"userid" : self.userID,
    @"matchid" : self.matchID,
    @"reqnum" : @"20",
    @"fromid" : fromid
  };
}

- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    ClosedPositionInfo *closedInfo = (ClosedPositionInfo *)[self.dataArray.array lastObject];
    if (![closedInfo.seqID isEqualToString:parameters[@"fromid"]]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[ClosedPositionTableAdapter alloc] initWithTableViewController:self
                                                                      withDataArray:self.dataArray];
    ((ClosedPositionTableAdapter *)_tableAdapter).showButtons = [@"1" isEqualToString:_matchID];
  }
  return _tableAdapter;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userid withMatckId:(NSString *)matchId {
  if (self = [super initWithFrame:frame]) {
    _showTopSeperatorLine = NO;
    self.userID = userid;
    self.matchID = matchId;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.littleCattleView setInformation:@"暂无清仓数据"];

  if (_showTopSeperatorLine) {
    HorizontalSeperatorLine *topSeperatorLine =
        [[HorizontalSeperatorLine alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
    [self.view addSubview:topSeperatorLine];
    self.tableView.top += 1;
    self.tableView.height -= 1;
  }
}

- (BOOL)dataBinded {
  return self.dataArray.dataBinded;
}

- (void)refreshButtonPressDown {
  _selectedRowIndex = -1;
  [super refreshButtonPressDown];
}

@end
