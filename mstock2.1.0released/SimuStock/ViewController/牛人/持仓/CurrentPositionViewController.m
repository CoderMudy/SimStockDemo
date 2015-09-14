//
//  CurrentPositionViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CurrentPositionViewController.h"
#import "PositionCell.h"

@implementation StockPositionAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.currentPositionInfo) {
    if (self.currentPositionInfo.traceFlag < 0) {
      return 0;
    } else {
      if ([self.currentPositionInfo.positionList count] == 0) {
        if (self.currentPositionInfo.traceFlag >= 0) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return [self.dataArray.array count];
      }
    }
  } else {
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //如果是当前选择的
  if (indexPath.row == _selectedRowIndex) {
    return PositionHeight;
  } else {
    return 90.0F;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  PositionCell *cell = (PositionCell *)[tableView cellForRowAtIndexPath:indexPath];
  PositionInfoView *posionView = cell.positionView;

  //如果当前未追踪，点击无效
  if (indexPath.row == 0 && self.currentPositionInfo && self.currentPositionInfo.traceFlag < 0) {
    return;
  }

  [tableView beginUpdates];

  //如果点击当前选择的cell，则恢复大小，否则变大
  if (indexPath.row == _selectedRowIndex) {
    [posionView presentForPosition:90.0];
    _selectedRowIndex = -1; //设置为未选择
  } else {
    //如果不是第一次点击，则把上次点击的cell复原
    if (_selectedRowIndex != -1) {
      [self tableView:tableView
          didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRowIndex inSection:0]];
    }
    [posionView presentForPosition:PositionHeight];
    _selectedRowIndex = indexPath.row; //设置为当前选择
  }

  [tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *identifier = @"positioncell";
  PositionCell *cell = (PositionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell =
        [[PositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    PositionInfoView *infoView = [[PositionInfoView alloc] initWithUserId:self.userID
                                                              withMatchId:self.matchID                                                           withFrame:cell.bounds];
    [infoView createButton];
    cell.positionView = infoView;
    [cell addSubview:infoView];
  }
  cell.positionView.uid = self.userID;
  cell.positionView.matchId = self.matchID;
  cell.positionView.triangleImage.frame =
      CGRectMake(cell.frame.size.width - 7.0f / 2 - 27.0f / 2, 90.0f - 27.0f / 2, 27.0f / 2, 27.0f / 2);
  cell.positionView.positionRateLabel.hidden = NO; //持仓显示持仓比率
  //当数据为空时，如果追踪开启或自己，隐藏positionView
  if (self.currentPositionInfo.positionList.count == 0) {
    cell.positionView.hidden = NO;
  } else {
    [self setPositionItem:cell IndexPath:indexPath];
  }
  return cell;
}

- (void)setPositionItem:(PositionCell *)cell IndexPath:(NSIndexPath *)indexPath {
  if (self.currentPositionInfo) {
    //追踪他
    if (self.currentPositionInfo.traceFlag < 0 && self.currentPositionInfo.traceFlag != -3) {
      [cell.positionView setLockProfit:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.profit]
                              AndValue:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.value]
                             withFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 120)];
      //续费
    } else if (self.currentPositionInfo.traceFlag == -3) {
      [cell.positionView setLockProfitForTimeOut:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.profit]
                                        AndValue:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.value]
                                       withFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 120)];
      //正常显示
    } else {
      CGRect rect;
      if (indexPath.row == _selectedRowIndex) {
        rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, PositionHeight);
      } else {
        rect = CGRectMake(0, 0, WIDTH_OF_SCREEN, 90);
      }
      NSString *user_id = [SimuUtil getUserID];
      //自己持仓
      if ([user_id isEqualToString:self.userID]) {
        [cell.positionView setPosition:self.currentPositionInfo.positionList[indexPath.row]
                             withFrame:rect
                         withTraceFlag:0];
      } else {
        [cell.positionView setPosition:self.currentPositionInfo.positionList[indexPath.row]
                             withFrame:rect
                         withTraceFlag:-1];
      }
    }
  }
}

@end

@implementation CurrentPositionViewController

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userid withMatckId:(NSString *)matchId {
  if (self = [super initWithFrame:frame]) {
    self.userID = userid;
    self.matchID = matchId;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.footerView.hidden = YES;
  self.headerView.hidden = YES;

  [self refreshButtonPressDown];
  [self.littleCattleView setInformation:@"暂无持仓股票"];
  self.littleCattleView.height -= 40;
}

#pragma mark-- 子类必须实现的
/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  return YES;
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [SimuRankPositionPageData requestPositionDataWithUid:self.userID
                                           withMatchId:self.matchID
                                            withReqnum:@"-1"
                                            withFormid:@"0"
                                          withCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  _stockPositionAdapter.selectedRowIndex = -1; //持仓列表初始化为未选择状态
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];

  self.footerView.hidden = YES;
  self.headerView.hidden = YES;

  _currentPositionInfo = (SimuRankPositionPageData *)latestData;
  _stockPositionAdapter.currentPositionInfo = _currentPositionInfo;
  self.positionReadyCallBack(_currentPositionInfo);
  [self.tableView setTableHeaderView:[self positionHeaderView]];

  //如果已经追踪或自己的
  if (self.currentPositionInfo.traceFlag >= 0) {
    self.tableView.bounces = YES;
    self.tableView.scrollEnabled = YES;
    if (self.currentPositionInfo.positionAmount.integerValue == 0) {
      [self.littleCattleView isCry:NO];
    } else {
      self.littleCattleView.hidden = YES;
    }
  } else {
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    self.littleCattleView.hidden = YES;
  }

  [self.tableView reloadData];
}

- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _stockPositionAdapter = [[StockPositionAdapter alloc] initWithTableViewController:self
                                                                        withDataArray:self.dataArray];
    _stockPositionAdapter.userID = self.userID;
    _stockPositionAdapter.matchID = self.matchID;
    _tableAdapter = _stockPositionAdapter;
  }
  return _tableAdapter;
}

- (UIView *)positionHeaderView {
  //追踪才需要显示
  if (self.currentPositionInfo.traceFlag >= 0) {

    //样式：持仓盈亏 金额           仓位：22.60%
    UIView *headerView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 24)];
    headerView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    //持仓盈亏
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 150, 16)];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.font = [UIFont systemFontOfSize:14];
    positionLabel.text = @"持仓盈亏 ：";
    positionLabel.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    positionLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:positionLabel];

    //盈亏数字
    UILabel *positionProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 4, 150, 16)];
    positionProfitLabel.backgroundColor = [UIColor clearColor];
    positionProfitLabel.text = [NSString stringWithFormat:@"%.2f", self.currentPositionInfo.profit];
    positionProfitLabel.font = [UIFont systemFontOfSize:14];
    positionProfitLabel.textColor = [StockUtil getColorByFloat:self.currentPositionInfo.profit];
    positionProfitLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:positionProfitLabel];

    //仓位：22.60%
    UILabel *positionPrecentLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 106, 4, 212, 16)];
    positionPrecentLabel.backgroundColor = [UIColor clearColor];
    if (self.currentPositionInfo.positionRate == nil) {
      positionPrecentLabel.text = [NSString stringWithFormat:@"仓位 ："];
    } else {
      positionPrecentLabel.text = [NSString stringWithFormat:@"仓位 ：%@", //不要再动了，这样才能正确显示
                                                             self.currentPositionInfo.positionRate];
    }

    positionPrecentLabel.font = [UIFont systemFontOfSize:14];
    positionPrecentLabel.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    positionPrecentLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:positionPrecentLabel];

    //底边灰线。
    UIView *upLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 24 - 1.0, WIDTH_OF_SCREEN, 0.5)];
    upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    [headerView addSubview:upLineView];
    //下(分割线)
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 24 - 0.5, WIDTH_OF_SCREEN, 0.5)];
    downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
    [headerView addSubview:downLineView];
    return headerView;
  } else { // trackFlag < 0
    //没有追踪的话，显示
    //持仓盈亏，持仓市值
    //锁定图标
    PositionInfoView *infoView;
    //续费
    if (self.currentPositionInfo.traceFlag == -3) {
      infoView = [[PositionInfoView alloc] initWithUserId:self.userID
                                              withMatchId:self.matchID
                                                withFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 120.0)];
      [infoView setLockProfitForTimeOut:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.profit]
                               AndValue:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.value]
                              withFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 120.0)];
      //未追踪
    } else {
      infoView = [[PositionInfoView alloc] initWithUserId:self.userID
                                              withMatchId:self.matchID
                                                withFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 120.0)];
      [infoView setLockProfit:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.profit]
                     AndValue:[NSString stringWithFormat:@"%.2f", self.currentPositionInfo.value]
                    withFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 120.0)];
    }

    //底边灰线。
    UIView *upLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 120 - 1.0, WIDTH_OF_SCREEN, 0.5)];
    upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    [infoView addSubview:upLineView];
    //下(分割线)
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 120 - 0.5, WIDTH_OF_SCREEN, 0.5)];
    downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
    [infoView addSubview:downLineView];
    return infoView;
  }
}

@end
