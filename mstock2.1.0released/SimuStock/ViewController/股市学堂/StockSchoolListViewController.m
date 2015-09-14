//--
//  StockSchoolListViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-4-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockSchoolListViewController.h"
#import "SchollWebViewController.h"
#import "StockSchoolListCell.h"
#import "CustomPageData.h"


@implementation StockSchoolListTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([StockSchoolListCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 36;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StockSchoolListCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  SchoolArticleData *articleData = self.dataArray.array[indexPath.row];
  cell.contentTitle.text = articleData.articleTitle;
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  SchoolArticleData *article = self.dataArray.array[indexPath.row];

  [SchollWebViewController startWithTitle:article.articleTitle
                                  withUrl:article.articleUrl];
}

@end

/*
 *
 */
@implementation StockSchoolListTableViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [SchoolArticleDataList
      requestPositionDataWithParameters:
          [self getRequestParamertsWithRefreshType:refreshType]
                           withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"1";
  NSString *length = @"20";
  NSString *moduleId = self.moduleId;
  //诡异的接口设计，取最新的20条为（0，-20）
  if (refreshType == RefreshTypeLoaderMore) {
    start = [NSString
        stringWithFormat:@"%ld", (long)((self.dataArray.array.count / 20) + 1)];
  }

  return @{ @"start" : start, @"length" : length, @"moduleId" : moduleId };
}

- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {

    NSInteger start = ((self.dataArray.array.count / 20) + 1);

    if (start != [parameters[@"start"] integerValue]) {
      return NO;
    }
  }
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockSchoolListTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
}

@end

/*
 *
 */
@implementation StockSchoolListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //导航视图
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];

  [self createTableView];
  [self refreshButtonPressDown];
}

- (void)createTableView {
  _tableVC = [[StockSchoolListTableViewController alloc]
      initWithFrame:self.clientView.bounds];
  [self.clientView addSubview:_tableVC.view];
  [self addChildViewController:_tableVC];

  _tableVC.moduleId = self.moduleId;

  __weak StockSchoolListViewController *weakSelf = self;
  _tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
}

#pragma mark
#pragma mark 代理方法------------------进入刷新状态就会调用---------------
// SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  [_tableVC refreshButtonPressDown];
}

@end
