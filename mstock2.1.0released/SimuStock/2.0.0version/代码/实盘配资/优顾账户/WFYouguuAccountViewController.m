//
//  WFYouguuAccountViewController.m
//  SimuStock
//
//  Created by Jhss on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFYouguuAccountViewController.h"

@implementation WFYouguuAccountAdapter


///** 创建表格  */
//- (void)createYouguuAccountTableView {
//  self.baseTableViewController = [[UITableView alloc]
//                           initWithFrame:CGRectMake(0, 51, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN-51-64)];
//  self.accountTabelView.dataSource = self;
//  self.accountTabelView.delegate = self;
//  self.accountTabelView.backgroundColor =
//  [Globle colorFromHexRGB:Color_BG_Common];
//  self.accountTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
//  [self.clientView addSubview:self.accountTabelView];
//}
///** 创建头部视图  */
//- (void)creatHeaderView {
//  UIView * headerView = [[UIView alloc]
//                         initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//  headerView.backgroundColor = [Globle colorFromHexRGB:Color_White];
//  // 优顾账户
//  UILabel *accountLabel = [[UILabel alloc] init];
//  [accountLabel setupLableWithText:@"优顾账户"
//                      andTextColor:[Globle colorFromHexRGB:Color_Text_Common]
//                       andTextFont:[UIFont systemFontOfSize:Font_Height_16_0]
//                      andAlignment:NSTextAlignmentLeft];
//  accountLabel.frame = CGRectMake(17, 0, 150, 40);
//  [headerView addSubview:accountLabel];
//  //优顾账户 金额
//  UILabel *accountMoneyLabel = [[UILabel alloc] init];
//  accountMoneyLabel.frame = CGRectMake(180, 0, 130, 40);
//  
//  ///优顾账户金额分转换元
//  NSString * youguu_Amount = [ProcessInputData convertMoneyString:self.Youguu_Money_Amount];
//  [accountMoneyLabel
//   setupLableWithText:[NSString stringWithFormat:@"%@元",youguu_Amount]
//   andTextColor:[Globle colorFromHexRGB:Color_Text_Details]
//   andTextFont:[UIFont systemFontOfSize:Font_Height_15_0]
//   andAlignment:NSTextAlignmentRight];
//  [headerView addSubview:accountMoneyLabel];
//  [self.clientView addSubview:headerView];
//  
//}


/** 返回cell的个数  */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.receiveData.array count];
}
/** 加载cell内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cell";
  YouguuAccountCell *cell =
  (YouguuAccountCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"YouguuAccountCell"
                                          owner:self
                                        options:nil] lastObject];
  }
  
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
  WFCashFlowList *cashFlowList = [self.receiveData.array objectAtIndex:indexPath.row];
  //流水类型
  cell.sortLabel.text = cashFlowList.flowDesc;
  //字符串转换成时间
  cell.dateLabel.text = [SimuUtil getFullDateFromCtime:[NSNumber numberWithFloat:[cashFlowList.flowDatetime floatValue]]];
  //余额
  NSString *balance = [ProcessInputData convertMoneyString:cashFlowList.accountBalance];
  cell.balanceLabel.text = [NSString stringWithFormat:@"余额：%@",balance];
  //流水发生金额
  //用来判断流水金额(cashFlowList.flowAmount)的正负数，
  BOOL minusSign = ([cashFlowList.flowAmount floatValue] > 0)  ? YES : NO;
  if (!minusSign) {
    cell.moneyLabel.textColor = [Globle colorFromHexRGB:Color_Green];
    NSString *string = [ProcessInputData convertMoneyString:cashFlowList.flowAmount];
    cell.moneyLabel.text = string;
  }else
  {
    cell.moneyLabel.textColor = [Globle colorFromHexRGB:Color_Red];
    NSString *string = [ProcessInputData convertMoneyString:cashFlowList.flowAmount];
    cell.moneyLabel.text = [@"+" stringByAppendingString:string];
  }
  
  //  /**设置cell选中后是白色 */
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //  cell.backgroundColor = [UIColor whiteColor];
  cell.userInteractionEnabled = NO;
  return cell;
  
}
/** 每个cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}





@end

@implementation  WFYouguuAccountViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSString *start = @"0";
  NSString *reqnum = @"-20";
  //诡异的接口设计，取最新的20条为（0，-20）
  if (refreshType == RefreshTypeLoaderMore) {
    start = [((WFCashFlowList *)[self.dataArray.array lastObject])
             .NumberId stringValue];
    reqnum = @"20";
  }
  [WFAccountInterface capitalDetailRunningWaterWithFromId:start withPageSize:reqnum withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    start = [((WFCashFlowList *)[self.dataArray.array lastObject])
             .NumberId stringValue];
  }
  return @{ @"start" : start };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"start"];
    NSString *lastId = [((WFCashFlowList *)[self.dataArray.array lastObject])
                        .NumberId stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 是否支持自动加载更多 */
- (BOOL)supportAutoLoadMore {
  return NO;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  
  _tableView.frame =CGRectMake(0, 51, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN-51-64);
  [self.view addSubview:_tableView];
 
  
  // Do any additional setup after loading the view.
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[WFYouguuAccountAdapter alloc]
                     initWithTableViewController:self
                     withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end