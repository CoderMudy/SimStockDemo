//
//  SameStockSupermanListViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SameStockHeroListViewController.h"
#import "SameStockHeroTableViewCell.h"
#import "HomepageViewController.h"

@implementation SameStockHeroTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([SameStockHeroTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 92.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SameStockHeroTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  if (cell == nil) {
    cell = [[SameStockHeroTableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:self.nibName];

    //取消选中效果
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    backView.backgroundColor = [Globle colorFromHexRGB:@"#e8e8e8"];
    backView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = backView;
  }
  NSString *format = _priceFormat ? _priceFormat() : @"%.2f";
  SameStockHero *superman = self.dataArray.array[indexPath.row];
  [cell bindSameStockHero:superman
          withPriceFormat:format
            withTableView:tableView
            withIndexPath:indexPath];

  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  if (indexPath.row == self.dataArray.array.count - 1) {
    cell.separatorLine.hidden = YES;
  } else {
    cell.separatorLine.hidden = NO;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SameStockHeroTableViewCell *cell =
      (SameStockHeroTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  //注销cell单击事件
  cell.selected = NO;
  //取消选中项
  [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]
                           animated:YES];
  if ([self.dataArray.array count] <= indexPath.row)
    return;

  SameStockHero *hero = self.dataArray.array[indexPath.row];
  [HomepageViewController showWithUserId:[hero.user.userId stringValue]
                               titleName:hero.user.nickName
                                 matchId:@"1"];
}

@end

@implementation SameStockHeroListViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [SameStockHeroList requestHeroListWithStockCode:_stockCode
                                     withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[SameStockHeroTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
    ((SameStockHeroTableAdapter *)_tableAdapter).priceFormat = _priceFormat;
  }
  return _tableAdapter;
}

- (id)initWithFrame:(CGRect)frame withStockCode:(NSString *)stockCode {
  if (self = [super initWithFrame:frame]) {
    self.stockCode = stockCode;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无牛人持有该股票"];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  _heroList = (SameStockHeroList *)latestData;
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

/** 重置股票代码 */
- (void)resetStockCode:(NSString *)stockCode {
  self.heroList = nil;
  self.stockCode = stockCode;
  [self.dataArray reset];
  [self.tableView reloadData];
}

@end
