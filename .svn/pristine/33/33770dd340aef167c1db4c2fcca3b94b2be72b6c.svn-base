//
//  ExpertPlanTableViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertPlanTableViewController.h"
//持仓数据

#import "EPPlanTableHeader.h"
#import "TrendViewController.h"
#import "EPTradeDetailView.h"

// tableview 适配器
@implementation ExpertPlanAdapter

- (ExpertPlanTableViewController *)owner {
  return (ExpertPlanTableViewController *)self.baseTableViewController;
}

- (ExpertPlanData *)expertData {
  return ((ExpertPlanTableViewController *)self.baseTableViewController).expertPlanData;
}

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([StockPositionInfoTableViewCell class]);
  }
  return nibFileName;
}

#pragma mark-- cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.expertData judgeExpert] || [self.expertData judgeUserPurchased] ||
      [self.expertData judgePlanIsSuccounCloseOrOffShef]) {
    if (indexPath.row == [self selectedRowIndex]) {
      return UnFoldHeight;
    } else {
      return FoldHeight;
    }
  }
  return 0;
}

#pragma mark-- 每个区 分多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if ([self.expertData judgeExpert] || [self.expertData judgeUserPurchased] ||
      [self.expertData judgePlanIsSuccounCloseOrOffShef]) {
    return self.dataArray.array.count;
  }
  return 0;
}

#pragma mark-- cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //显示持仓
  if ([self.expertData judgeExpert] || [self.expertData judgeUserPurchased] ||
      [self.expertData judgePlanIsSuccounCloseOrOffShef]) {
    StockPositionInfoTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:self.nibName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    PositionInfo *positionInfo = self.dataArray.array[indexPath.row];
    cell.showSellableAmount = [self.expertData judgeExpert];
    cell.btnSell.enabled = ![self.expertData judgeExpert] ||
                           ([self.expertData judgeExpert] && positionInfo.sellableAmount > 0);

    [cell bindPositionInfo:positionInfo];
    if (indexPath.row == _selectedRowIndex) {
      cell.buttonContainer.hidden = NO;
      cell.height = UnFoldHeight;
    } else {
      cell.height = FoldHeight;
      cell.buttonContainer.hidden = YES;
    }
    cell.buyAction = self.owner.buyAction;
    cell.sellAction = self.owner.sellAction;

    __weak ExpertPlanAdapter *weakSelf = self;
    cell.marketAction = ^(PositionInfo *positionInfo) {
      [TrendViewController showDetailWithStockCode:positionInfo.stockCode
                                     withStockName:positionInfo.stockName
                                     withFirstType:FIRST_TYPE_UNSPEC
                                       withMatchId:weakSelf.expertData.accoundId];
    };

    cell.tradeListAction = ^(PositionInfo *positionInfo) {
      ExpertPlanAdapter *strongSelf = weakSelf;
      if (strongSelf) {
        EPTradeDetailView *vc =
            [[EPTradeDetailView alloc] initWithExpertPlanData:strongSelf.expertData
                                                withPositonId:positionInfo];
        [AppDelegate pushViewControllerFromRight:vc];
      }
    };
    return cell;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (([self.expertData judgeExpert] || [self.expertData judgeUserPurchased] ||
       [self.expertData judgePlanIsSuccounCloseOrOffShef]) &&
      self.dataArray.array.count != 0) {
    StockPositionInfoTableViewCell *cell =
        (StockPositionInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    if (indexPath.row == _selectedRowIndex) {
      [cell fold:YES];
      _selectedRowIndex = -1; //设置为未选择
    } else {
      //如果不是第一次点击，则把上次点击的cell复原
      if (_selectedRowIndex != -1) {
        [self tableView:tableView
            didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRowIndex inSection:0]];
      }
      [cell fold:NO];
      _selectedRowIndex = indexPath.row; //设置为当前选择
    }
    [tableView endUpdates];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //什么 时候 显示 持仓 计划运行状态 或者 牛人视角
  if ([self.expertData isUserWithPlanRunning] || [self.expertData isExpertPlanWithRunning] ||
      [self.expertData isExpertPlanRecruitmengPeriod] || [self.expertData judgeUserPurchased]) {
    return 46.0f;
  }
  return 0.0f;
}

//持仓数据头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([self.expertData isUserWithPlanRunning] || [self.expertData isExpertPlanWithRunning] ||
      [self.expertData isExpertPlanRecruitmengPeriod] || [self.expertData judgeUserPurchased]) {
    if (_planPositionView == nil) {
      _planPositionView = [EPPlanPositionView createEPPlanPositionView];
      //绑定数据
      _planPositionView.dataPlan = self.expertData;
    }
    if (self.owner.expertAccountData) {
      [_planPositionView bindDataForPositionView:self.owner.expertAccountData];
      //将账户资产里的数据 绑定
      [self.tableHeader.accountAssestView bindDataWithExpertAccount:self.owner.expertAccountData];
    }
    return _planPositionView;
  }
  return nil;
}

#pragma mark 背景图拉伸距离
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //保留上次坐标
  static CGFloat contentOffsetY = 0.0f;
  static NSInteger MAXsetY = 0.0f;
  if (scrollView.contentOffset.y < 0.0f) {
    self.tableHeader.expertInfoView.backgroundImageView.frame = CGRectMake(
        scrollView.contentOffset.y, scrollView.contentOffset.y,
        WIDTH_OF_SCREEN - scrollView.contentOffset.y * 2, 145.5f - scrollView.contentOffset.y);
  }
  if ((NSInteger)scrollView.contentOffset.y == 0 && contentOffsetY < scrollView.contentOffset.y &&
      (NSInteger)contentOffsetY != 0 && MAXsetY == 65) {
    contentOffsetY = 0.0f;
    MAXsetY = 0;
    if (self.owner.pullDownRefreshAction) {
      self.owner.pullDownRefreshAction();
    }
  }
  if (scrollView.contentOffset.y < -65.0f) {
    MAXsetY = 65;
  }
  contentOffsetY = scrollView.contentOffset.y;
}

- (EPPlanTableHeader *)tableHeader {
  return (EPPlanTableHeader *)self.baseTableViewController.tableView.tableHeaderView;
}

@end

/** tableview */
@interface ExpertPlanTableViewController () {
  // header 数据
  ExpertPlanData *_expertPlanData;
}
@end

@implementation ExpertPlanTableViewController

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"ClearProfitAndStopVCData"
                                                object:nil];
}

//初始化
- (id)initWithFrame:(CGRect)frame
      withAccountID:(NSString *)accountId
      withTargetUid:(NSString *)targetUid
 withExpertPlanData:(ExpertPlanData *)expertPlanData {
  if (self = [super initWithFrame:frame]) {
    self.accountID = accountId;
    self.targetUid = targetUid;
    _expertPlanData = expertPlanData;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshDataForTabelView)
                                               name:@"ClearProfitAndStopVCData"
                                             object:nil];

  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
  self.littleCattleView.height = 180;
  [self.littleCattleView resetFrame:self.littleCattleView.frame];
}

- (void)refreshDataForTabelView {
  [self refreshButtonPressDown];
}

#pragma mark-- 子类必须实现的
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  //从新定义 什么情况下请求数据
  if (_expertPlanData.state == UserNotPurchasedState &&
      _expertPlanData.planState == PlanStateRecruitmengPeriod) {
    [self.tableView reloadData];
    return;
  }

  NSDictionary *dic = @{
    @"accountId" : self.accountID,
    @"targetUid" : self.targetUid,
  };
  [EPexpertPositionData requetPositionDataWithDic:dic withCallback:callback];
}

/** 是否加载更多 */
- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_expertPlanAdapter == nil) {
    _expertPlanAdapter =
        [[ExpertPlanAdapter alloc] initWithTableViewController:self withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_expertPlanAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_expertPlanAdapter.nibName];
  }
  return _expertPlanAdapter;
}
/** 绑定数据 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];

  self.expertAccountData = (EPexpertPositionData *)latestData;
  _expertPlanData.planGoalData.currentProfit = _expertAccountData.stockProfitRate;
  [((EPPlanTableHeader *)self.tableView.tableHeaderView)
          .planGoalView bindDataForProfitOrPlanDays:_expertPlanData.planGoalData
                                   withForceRefresh:YES];

  [_expertPlanAdapter.planPositionView bindDataForPositionView:self.expertAccountData];
  //用户未购买时，显示lockView
  if ([_expertPlanData judgeUserNoPurchasedPlanRunning]) {
    self.tableView.tableFooterView = self.lockView;
  }

  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
}

- (NSArray *)getExpertPlanPositionArray {
  return self.dataArray.array;
}

- (UIView *)lockView {
  if (_lockCell == nil) {
    _lockCell =
        [[[NSBundle mainBundle] loadNibNamed:@"EPPLockCell" owner:self options:nil] lastObject];
    _lockCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _lockCell.height = 180.0f;
  }

  return _lockCell;
}

//刷新
- (void)refreshButtonPressDown {
  _expertPlanAdapter.selectedRowIndex = -1;
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
@end
