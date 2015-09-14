//
//  YouguuAccountViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YouguuAccountViewController.h"
#import "YouguuAccountCell.h"
#import "UILabel+SetProperty.h"
#import "ProcessInputData.h"
#import "CellBottomLinesView.h"

@implementation YouguuAccountTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([YouguuAccountCell class]);
  }
  return nibFileName;
}

/** 返回cell的个数  */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count];
}
/** 加载cell内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  YouguuAccountCell *cell = (YouguuAccountCell *)
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  WFCashFlowList *cashFlowList =
      [self.dataArray.array objectAtIndex:indexPath.row];
  //流水类型
  cell.sortLabel.text = cashFlowList.flowDesc;
  //字符串转换成时间
  cell.dateLabel.text = [SimuUtil
      getFullDateFromCtime:
          [NSNumber numberWithFloat:[cashFlowList.flowDatetime floatValue]]];
  //余额
  NSString *balance =
      [ProcessInputData convertMoneyString:cashFlowList.accountBalance];
  cell.balanceLabel.text = [NSString stringWithFormat:@"余额 ：%@", balance];
  //流水发生金额
  //用来判断流水金额(cashFlowList.flowAmount)的正负数，
  if ([cashFlowList.flowAmount floatValue] < 0) {
    cell.moneyLabel.textColor = [Globle colorFromHexRGB:@"#099544"];
    NSString *string =
        [ProcessInputData convertMoneyString:cashFlowList.flowAmount];
    cell.moneyLabel.text = string;
  } else if([cashFlowList.flowAmount floatValue] > 0) {
    cell.moneyLabel.textColor = [Globle colorFromHexRGB:@"#e43006"];
    NSString *string =
        [ProcessInputData convertMoneyString:cashFlowList.flowAmount];
    cell.moneyLabel.text = [@"+" stringByAppendingString:string];
  }else{
    cell.moneyLabel.textColor = [Globle colorFromHexRGB:@"#454545"];
    NSString *string =
    [ProcessInputData convertMoneyString:cashFlowList.flowAmount];
    cell.moneyLabel.text = string;
  }

  
  
  cell.userInteractionEnabled = NO;
  return cell;
}
/** 每个cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

@end

@implementation YouguuAccountTableViewController

-(void)viewDidLoad
{
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无账户资金流水"];
}


- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"0";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    WFCashFlowList *lastInfo =
        (WFCashFlowList *)[self.dataArray.array lastObject];
    fromId = [NSString stringWithFormat:@"%@", lastInfo.NumberId];
  }
  return @{ @"fromId" : fromId, @"pageSize" : pageSize };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    WFCashFlowList *lastInfo =
        (WFCashFlowList *)[self.dataArray.array lastObject];
    NSString *lastId = [NSString stringWithFormat:@"%@", lastInfo.NumberId];
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
  [WFAccountInterface capitalDetailRunningWaterWithInput:
                          [self getRequestParamertsWithRefreshType:refreshType]
                                            withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[YouguuAccountTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end

@implementation YouguuAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  /**  更改为"账户余额"并且隐藏刷新按钮 */
  [_topToolBar resetContentAndFlage:@"账户余额" Mode:TTBM_Mode_Leveltwo];
  /** 创建表格  */
  [self createYouguuAccountTableView];
  //上下拉刷新
  //重写刷新方法
  [self refreshButtonPressDown];
}

/** 创建表格  */
- (void)createYouguuAccountTableView {
  accountVC = [[YouguuAccountTableViewController alloc]
      initWithFrame:CGRectMake(0, 51, WIDTH_OF_SCREEN,
                               HEIGHT_OF_SCREEN - 51 - 64)];

  __weak YouguuAccountViewController *weakSelf = self;
  accountVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  accountVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  accountVC.onDataReadyCallBack = ^{
    [weakSelf onDataReady];
  };
  accountVC.showTableFooter = YES;

  [_clientView addSubview:accountVC.view];
  [self addChildViewController:accountVC];
}

- (void)onDataReady {
  //优顾账户赋值
  self.Youguu_Money_Amount =
      ((WFCashFlowList *)[accountVC.dataArray.array firstObject])
          .accountBalance;
  [self creatHeaderView];
}
/** 创建头部视图  */
- (void)creatHeaderView {
  UIView *headerView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
  headerView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  // 优顾账户
  UILabel *accountLabel = [[UILabel alloc] init];
  [accountLabel setupLableWithText:@"账户余额"
                      andTextColor:[Globle colorFromHexRGB:Color_Text_Common]
                       andTextFont:[UIFont systemFontOfSize:Font_Height_16_0]
                      andAlignment:NSTextAlignmentLeft];
  accountLabel.frame = CGRectMake(17, 0, 150, 40);
  [headerView addSubview:accountLabel];
  //优顾账户 金额
  UILabel *accountMoneyLabel = [[UILabel alloc] init];
  accountMoneyLabel.frame = CGRectMake((headerView.width - 140.f), 0, 130, 40);

  ///优顾账户金额分转换元
  NSString *youguu_Amount =
      [ProcessInputData convertMoneyString:self.Youguu_Money_Amount];
  [accountMoneyLabel
      setupLableWithText:[NSString stringWithFormat:@"%@元", youguu_Amount]
            andTextColor:[Globle colorFromHexRGB:Color_Text_Details]
             andTextFont:[UIFont systemFontOfSize:Font_Height_15_0]
            andAlignment:NSTextAlignmentRight];
  [headerView addSubview:accountMoneyLabel];
  [self.clientView addSubview:headerView];
  //分割线
  CellBottomLinesView * line = [[CellBottomLinesView alloc]init];
  line.backgroundColor = [Globle colorFromHexRGB:@"#EFEFF4"] ;
  line.height = 1.0f;
  line.frame = CGRectMake(0, 40, WIDTH_OF_SCREEN, 1.0f);
  [self.clientView addSubview:line];
}

///刷新按钮代理方法
- (void)refreshButtonPressDown {
  [accountVC refreshButtonPressDown];
}

@end
