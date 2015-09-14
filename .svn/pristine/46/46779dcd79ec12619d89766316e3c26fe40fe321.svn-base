//
//  StockSearchViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-7-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockSearchViewController.h"
#import "StockDBManager.h"
#import "MobClick.h"
#import "TrendViewController.h"
#import "StockSearchTableVC.h"

#define NUMBERS @"0123456789"

@implementation StockSearchViewController {
  StockSearchTableVC *stockSearchTableVC;
}

//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"股票查询"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"股票查询"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  self.indicatorView.hidden = YES;
  //创建搜索框视图
  [self createSearchBoxView];
  [self createTabbedView];
}

//创建分页视图
- (void)createTabbedView {

  _clientView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  CGRect tableHeaderRect =
      CGRectMake(0.0, 9.f, _clientView.bounds.size.width, 51.5f);
  UIView *tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderRect];

  //标题
  UILabel *titleLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0.0, 15.f, _clientView.bounds.size.width, 30.f)];
  titleLab.backgroundColor = [UIColor clearColor];
  titleLab.text = @"最近查询股票";
  titleLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  titleLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  titleLab.textAlignment = NSTextAlignmentCenter;
  [tableHeaderView addSubview:titleLab];
  //下划线
  UIView *underline = [[UIView alloc]
      initWithFrame:CGRectMake(15.f, 51.f, _clientView.bounds.size.width - 30.0,
                               0.5)];
  underline.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [tableHeaderView addSubview:underline];

  __weak StockSearchViewController *weakSelf = self;

  stockSearchTableVC =
      [[StockSearchTableVC alloc] initWithFrame:_clientView.bounds
                                withSearchField:searchField];
  stockSearchTableVC.filterStockIndex = NO;
  stockSearchTableVC.tableHeader = tableHeaderView;
  stockSearchTableVC.onStockSelectedCallback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        [weakSelf invokeSelectedCallbackWithStockCode:stockCode
                                        withStockName:stockName
                                        withFirstType:firstType];
      };
  stockSearchTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  stockSearchTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [_clientView addSubview:stockSearchTableVC.view];
  [self addChildViewController:stockSearchTableVC];
  [stockSearchTableVC.tableView setTableHeaderView:tableHeaderView];
}

- (void)invokeSelectedCallbackWithStockCode:(NSString *)stockCode
                              withStockName:(NSString *)stockName
                              withFirstType:(NSString *)firstType {
  NSArray *array = [StockDBManager searchFromdataWithStockName:stockName
                                                 withStockCode:stockCode];
  StockFunds *stock = array[0];
  if (stock) {
    stockCode = stock.code;
  }

  [SimuUtil addSearchHistryStockContent:stockCode];
  [TrendViewController showDetailWithStockCode:stockCode
                                 withStockName:stockName
                                 withFirstType:firstType
                                   withMatchId:@"1"];
}

//创建搜索框视图
- (void)createSearchBoxView {
  //增大点击区域
  UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  areaBtn.frame = CGRectMake(51.f, _topToolBar.bounds.size.height - 40,
                             _topToolBar.bounds.size.width - 51.f * 2, 34.5f);
  areaBtn.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [areaBtn addTarget:self
                action:@selector(clickTriggeringMethodIncreaseArea)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:areaBtn];

  searchField = [[UITextField alloc]
      initWithFrame:CGRectMake(57.f, _topToolBar.bounds.size.height - 30,
                               _topToolBar.bounds.size.width - 57.f * 2, 17.5f)];
  searchField.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  searchField.textAlignment = NSTextAlignmentLeft;
  [searchField setValue:[Globle colorFromHexRGB:Color_Gray]
             forKeyPath:@"_placeholderLabel.textColor"];
  searchField.placeholder = @"请输入股票代码或拼音首字母";
  searchField.font = [UIFont systemFontOfSize:Font_Height_13_0];
  [_topToolBar addSubview:searchField];

  [searchField becomeFirstResponder];
}

//增大点击区域
- (void)clickTriggeringMethodIncreaseArea {
  [searchField becomeFirstResponder];
}

#pragma mark - 界面完全显示再弹键盘
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [searchField becomeFirstResponder];
}

- (void)leftButtonPress {
  [searchField resignFirstResponder]; //必须撤销第一响应，否则会导致self被多引用
  [super leftButtonPress];
}

@end
