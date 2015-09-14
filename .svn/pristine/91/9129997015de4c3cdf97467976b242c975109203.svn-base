//
//  FinancialDetailsViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FinancialDetailsViewController.h"
#import "FinancialDetailsCell.h"

@interface FinancialDetailsViewController () <UITableViewDataSource,
                                              UITableViewDelegate> {
  UITableView *financialTableView;
  /** 编号 */
  NSString *userNumberNo;
  //数据源
  DataArray *_dataArray;
}
@end

@implementation FinancialDetailsViewController

static NSString *cellID = @"cell";

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.topToolBar resetContentAndFlage:@"资金明细" Mode:TTBM_Mode_Leveltwo];
  //创建UITableView
  [self creatTabelView];
  [self creatHeadView];
  //注册cell
  [financialTableView registerNib:[UINib nibWithNibName:@"FinancialDetailsCell"
                                                 bundle:Nil]
           forCellReuseIdentifier:cellID];
  _dataArray = [[DataArray alloc] init];
  [NSThread detachNewThreadSelector:@selector(requestDetailsData)
                           toTarget:self
                         withObject:nil];
}

#pragma mark -UITableView
- (void)creatTabelView {
  CGRect tableViewFrame =
      CGRectMake(0, 27.50f, self.view.bounds.size.width,
                 self.view.bounds.size.height - topToolBarHeight - 27.50f);
  financialTableView =
      [[UITableView alloc] initWithFrame:tableViewFrame
                                   style:UITableViewStylePlain];
  financialTableView.delegate = self;
  financialTableView.dataSource = self;
  financialTableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  financialTableView.tableFooterView =
      [[UIView alloc] initWithFrame:CGRectZero];
  financialTableView.backgroundView = nil;
  [self.clientView addSubview:financialTableView];
}

//创建头
- (void)creatHeadView {
  UIView *headView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 27.50f)];
  headView.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  [self.clientView addSubview:headView];

  //编号标题
  UILabel *label =
      [[UILabel alloc] initWithFrame:CGRectMake(37 * 0.444, 19 * 0.444,
                                                52 * 0.444 + 5, 27 * 0.444)];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  label.textAlignment = NSTextAlignmentLeft;
  label.text = @"编号";
  [headView addSubview:label];

  //动态编号
  UILabel *numLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 21 * 0.444,
                               CGRectGetWidth(self.view.bounds) -
                                   CGRectGetMaxX(label.frame) - 25 * 0.444,
                               22 * 0.444)];
  numLabel.backgroundColor = [UIColor clearColor];
  numLabel.font = [UIFont systemFontOfSize:10];
  numLabel.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  numLabel.textAlignment = NSTextAlignmentRight;
  numLabel.text = @"12465145634615";
  [headView addSubview:numLabel];
}

#pragma mark -viewDidLayoutSubviews
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if ([financialTableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [financialTableView setLayoutMargins:UIEdgeInsetsZero];
  }
  if ([financialTableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [financialTableView setSeparatorInset:UIEdgeInsetsZero];
  }
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _dataArray.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FinancialDetailsCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellID
                                      forIndexPath:indexPath];
  WFfinancialDetailsModeData *mode = _dataArray.array[indexPath.row];
  [cell bindDataForCell:mode];
  return cell;
}

#pragma mark - 获取数据源
- (void)requestDetailsData {
  //先判断网络
  if (![SimuUtil isExistNetwork]) {
    [self notWork];
    return;
  }
  _littleCattleView.hidden = YES;
  //获取数据源
  __weak FinancialDetailsViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    FinancialDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    WFfinancialDetailsModeData *mode = (WFfinancialDetailsModeData *)obj;
    if (mode == nil || mode.array.count == 0) {
      if (!_dataArray.dataBinded) {
        [_littleCattleView isCry:NO];
      } else {
        _littleCattleView.hidden = YES;
      }
    }

    //绑定数据
    [self bindModeWithFinancialDetails:mode];

  };
  [WFFinancialDetailsData requestFinancialDetailsModeData:@"0"
                                             withPageSize:@"20"
                                             withCallbacl:callback];
}

#pragma mark - 如果没网络情况
- (void)notWork {
  [_indicatorView stopAnimating];
  //判断是否有数据
  if (!_dataArray.dataBinded) {
    //显示无网络小牛
    [_littleCattleView isCry:YES];
  } else {
    //隐藏小牛
    _littleCattleView.hidden = YES;
  }
}

//绑定数据
- (void)bindModeWithFinancialDetails:(WFfinancialDetailsModeData *)obj {
  [_dataArray.array removeAllObjects];
  [_dataArray.array addObjectsFromArray:obj.array];

  _dataArray.dataBinded = YES;
  [financialTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
