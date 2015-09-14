//
//  ExpertHomePageTbaleVC.m
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertHomePageTbaleVC.h"
#import "ExpertNavigationView.h"
#import "ExpertCell.h"
#import "MasterTradeListWrapper.h"
#import "HomepageViewController.h"
#import "CacheUtil.h"
#import "ExpertRecommendViewController.h"


/**
 *  tableView控制器
 */
@implementation ExpertHomePageAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([ExpertCell class]);
  }
  return nibFileName;
}

#pragma mark-- cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 150;
}

#pragma mark-- 每个区 分多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (![self.baseTableViewController dataBinded]) {
    return 2;
  }
  return self.dataArray.array.count;
}

#pragma mark-- cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (![self.baseTableViewController dataBinded]) {
    [cell notWorkBindData];
  }else{
   [cell bindData:self.dataArray.array[indexPath.row]]; 
  }
  return cell;
}

/** 点击cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (self.dataArray.array.count > 0 && self.dataArray) {
    ConcludesListItem *item = self.dataArray.array[indexPath.row];
    if (item.writer.userId)
      [HomepageViewController showWithUserId:[item.writer.userId stringValue]
                                   titleName:item.writer.nickName
                                     matchId:MATCHID];
  }
}

/** 头高 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 46;
}

/** 头 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (_headNavigationView == nil) {
    _headNavigationView = [ExpertNavigationView showExpertNavigatView];
  }
  return _headNavigationView;
}

@end

/**
 *  tableView
 */
@interface ExpertHomePageTbaleVC ()

@end

@implementation ExpertHomePageTbaleVC

- (id)initWithFrame:(CGRect)frame withMainViewController:(SimuMainViewController *)controller {
  self = [super initWithFrame:frame];
  if (self) {
    self.mainVC = controller;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //隐藏上啦刷
  self.littleCattleView.hidden = YES;
}
//加载缓存
-(void)loadCache{
  
}


#pragma mark-- 子类必须实现的
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  //数据请求
  [MasterTradeListWrapper requestMasterTradeListWithInput:[self getRequestParamertsWithRefreshType:refreshType]
                                             withCallback:callback];
}

/** 参数 */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"0";
  NSString *reqnum = @"-20";
  if (refreshType == RefreshTypeLoaderMore) {
    start = [((ConcludesListItem *)[self.dataArray.array lastObject]).time stringValue];
    reqnum = @"20";
  }
  return @{ @"from" : start, @"reqNum" : reqnum };
}

/** 是否加载更多 */
- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[ExpertHomePageAdapter alloc] initWithTableViewController:self
                                                                 withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    //注册cell
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"from"];
    NSString *lastId = [((ConcludesListItem *)[self.dataArray.array lastObject]).time stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

//刷新
- (void)refreshButtonPressDown {
  //判断网络
  if (![SimuUtil isExistNetwork]) {
    //数据有没有绑定
    if (![self dataBinded]) {
      [self.tableView reloadData];
      self.footerView.hidden = YES;
    }
  }else{
    [self requestResponseWithRefreshType:RefreshTypeRefresh];
  }
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
  [super refreshViewBeginRefreshing:refreshView];
    if (self.gameAdvertisingBlock) {
      self.gameAdvertisingBlock();
    }
}

-(void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self.tableView reloadData];
}

/** 当服务器挂了 情况下 返货 失败的情况下 该页面不需要 无网络小牛*/
- (void)setNoNetWork{
  [NewShowLabel showNoNetworkTip];
  if (!self.dataArray.dataBinded) {
    self.tableView.tableFooterView = nil;
    self.littleCattleView.hidden = YES;
  }
}

@end
