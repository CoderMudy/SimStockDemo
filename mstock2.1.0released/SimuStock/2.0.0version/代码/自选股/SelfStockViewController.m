//
//  SelfStockViewController.m
//  SimuStock
//
//  Created by Mac on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SelfStockViewController.h"
#import "SelectStocksViewController.h"
#import "TrendViewController.h"

@implementation SelfStockViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self creatControlViews];

  __weak SelfStockViewController *weakSelf = self;

  [btnSearch setOnButtonPressedHandler:^{
    [weakSelf showSearchStockPage];
  }];

  //网络访问
  [_tableViewController requestResponseWithRefreshType:RefreshTypeTimerRefresh];
}

#pragma mark
#pragma mark 创建各个控件
- (void)creatControlViews {

  _indicatorView.frame =
      CGRectMake(_topToolBar.bounds.size.width - 82, _topToolBar.bounds.size.height - 45, 40, 45);

  [_topToolBar resetContentAndFlage:@"自选股" Mode:TTBM_Mode_Leveltwo];

  //搜索按钮
  [self creatSearchButton];

  //创建表格页面
  [self creatTableView];

  //管理按钮
  [self creatEditStockButton];
}
//创建表格
- (void)creatTableView {
  _tableViewController = [[SelfStockTableViewController alloc] initWithFrame:self.clientView.bounds];
  [self.clientView addSubview:_tableViewController.view];
  [self addChildViewController:_tableViewController];

  __weak SelfStockViewController *weakSelf = self;
  _tableViewController.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  _tableViewController.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  _tableViewController.onDataReadyCallBack = ^{
    [weakSelf onEndRefresh];
  };
}

- (void)onEndRefresh {
  if ([_tableViewController shouldShowManageButton]) {
    btnEdit.hidden = NO;
  } else {
    btnEdit.hidden = YES;
  }
}

//创建搜索按钮
- (void)creatSearchButton {
  //按钮选中中视图
  BGColorUIButton *searchButton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"] forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"] forState:UIControlStateHighlighted];
  [searchButton setNormalBGColor:[Globle colorFromHexRGB:@"086dae"]];
  [searchButton setHighlightBGColor:[Globle colorFromHexRGB:@"0c5e93"]];
  searchButton.frame =
      CGRectMake(_topToolBar.bounds.size.width - 40, _topToolBar.bounds.size.height - 45, 40, 45);
  [_topToolBar addSubview:searchButton];
  _indicatorView.left = searchButton.left - _indicatorView.width;
  btnSearch = searchButton;
}

//创建管理按钮
- (void)creatEditStockButton {
  btnEdit = [[BGColorUIButton alloc] initWithFrame:CGRectZero];
  btnEdit.normalBGColor = [UIColor clearColor];
  btnEdit.highlightBGColor = [Globle colorFromHexRGB:@"#105c98"];
  [btnEdit buttonWithTitle:@"管理"
            andNormaltextcolor:@"4dfdff"
      andHightlightedTextColor:@"4dfdff"];
  btnEdit.titleLabel.font = [UIFont systemFontOfSize:16];

  __weak SelfStockViewController *weakSelf = self;
  [btnEdit setOnButtonPressedHandler:^{
    [weakSelf.tableViewController manageSelfStocks];
  }];
  CGFloat width = CGRectGetHeight(_indicatorView.bounds);
  btnEdit.frame =
      CGRectMake((WIDTH_OF_SCREEN - width) / 2.f,CGRectGetMinY(_indicatorView.frame),width, width);
  [_topToolBar addSubview:btnEdit];

  btnEdit.hidden = YES;
}

#pragma mark
#pragma mark----SimuIndicatorDelegate----
- (void)refreshButtonPressDown {
  [_tableViewController requestResponseWithRefreshType:RefreshTypeRefresh];
}

#pragma mark
#pragma mark 按钮点击函数

- (void)showSearchStockPage {
  OnStockSelected callback = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
    [TrendViewController showDetailWithStockCode:stockCode
                                   withStockName:stockName
                                   withFirstType:firstType
                                     withMatchId:@"1"];
  };
  SelectStocksViewController *selectStocksVC =
      [[SelectStocksViewController alloc] initStartPageType:SelfStockPage withCallBack:callback];

  [AppDelegate pushViewControllerFromRight:selectStocksVC];
}

@end
