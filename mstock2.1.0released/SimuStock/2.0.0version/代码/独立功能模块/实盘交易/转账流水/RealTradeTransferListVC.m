//
//  realTradeTransfWaterVC.m
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeTransferListVC.h"

#import "SimuUtil.h"
#import "realTradTransCell.h"
#import "RealTradeRequester.h"

@interface RealTradeTransferListVC () <UITableViewDataSource, UITableViewDelegate> {

  //表格
  UITableView *rttf_tableView;
  //数据数组
  NSMutableArray *rttf_dataArray;
  //表格头
  UIView *rttf_headView;
}

@end

@implementation RealTradeTransferListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  rttf_dataArray = [[NSMutableArray alloc] init];
  [self creatControlerViews];
  [self getTransferWaterFromNet];

  [_littleCattleView setInformation:@"暂无流水数据"];
}

- (void)dealloc {
  if (rttf_dataArray) {
    rttf_dataArray = nil;
  }
}
#pragma mark
#pragma mark 创建控件
- (void)creatControlerViews {
  [self resetTopToolBarView];
  [self creatTableView];
}
//创建上导航栏控件
- (void)resetTopToolBarView {

  [_topToolBar resetContentAndFlage:@"转账流水" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.butonIsVisible = NO;
}

//创建表格
- (void)creatTableView {
  CGRect tablerect =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, self.view.bounds.size.height - _topToolBar.frame.size.height);
  //_topToolBar.frame.origin.y+_topToolBar.frame.size.height
  rttf_tableView = [[UITableView alloc] initWithFrame:tablerect style:UITableViewStylePlain];
  rttf_tableView.dataSource = self;
  rttf_tableView.delegate = self;
  rttf_tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  rttf_tableView.showsVerticalScrollIndicator = YES;
  rttf_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  rttf_tableView.allowsSelection = NO;
  rttf_tableView.bounces = YES;
  [self.clientView addSubview:rttf_tableView];
}
#pragma mark
#pragma mark 协议回调函数
// SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  [self getTransferWaterFromNet];
}

- (void)resetUI {

  [_indicatorView stopAnimating];
}

#pragma mark
#pragma mark 系统控件协议函数
// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [rttf_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  realTradTransCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[realTradTransCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
  }
  if ([rttf_dataArray count] > indexPath.row) {
    RealTradeFundTransferHistoryItem *obj = rttf_dataArray[indexPath.row];
    [cell resetData:obj];
  }
  return cell;
}
// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

  NSArray *array = @[ @"时间", @"银行", @"金额", @"方向/状态" ];
  float width = WIDTH_OF_SCREEN / 4;
  rttf_headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
  rttf_headView.backgroundColor = [Globle colorFromHexRGB:@"#e1e3e9"];
  for (int i = 0; i < [array count]; i++) {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i)*width, (30 - 18) / 2, width, 18)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = array[i];
    lable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
    [rttf_headView addSubview:lable];
    //加入纵向分割线
    if (i != 0) {
      UIView *lineleftView = [[UIView alloc] initWithFrame:CGRectMake((i)*width, 0, 1, 30)];
      lineleftView.backgroundColor = [Globle colorFromHexRGB:@"#f2f3f6"];
      UIView *linerighttView = [[UIView alloc] initWithFrame:CGRectMake((i)*width + 1, 0, 1, 30)];
      linerighttView.backgroundColor = [Globle colorFromHexRGB:@"#ced0d6"];
      [rttf_headView addSubview:lineleftView];
      [rttf_headView addSubview:linerighttView];
    }
  }

  return rttf_headView;
}

#pragma mark
#pragma mark 网络接口
//从网络得到转账流水数据
- (void)getTransferWaterFromNet {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    (rttf_dataArray.count == 0) ? [_littleCattleView isCry:YES] : (_littleCattleView.hidden = YES);
    return;
  }

  //  转入转出历史查询
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {

    RealTradeFundTransferHistory *result = (RealTradeFundTransferHistory *)obj;
    if (result) {
      [rttf_dataArray removeAllObjects];
      [rttf_dataArray addObjectsFromArray:result.history];
      (result.history.count == 0) ? [_littleCattleView isCry:NO] : (_littleCattleView.hidden = YES);
      if (result.history.count == 0) {
        rttf_tableView.bounces = NO;
      } else {
        rttf_tableView.bounces = YES;
      }
      if (rttf_tableView) {
        [rttf_tableView reloadData];
      }
    }
    [self resetUI];
  };
  callback.onFailed = ^() {
    [self resetUI];
    [BaseRequester defaultFailedHandler]();
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [self resetUI];
    [BaseRequester defaultErrorHandler](error, ex);
  };
  [RealTradeFundTransferHistory loadFundTransferHistoryWithCallback:callback];

  [_indicatorView startAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
