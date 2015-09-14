//
//  FirmSaleSearchStockVC.m
//  SimuStock
//
//  Created by Yuemeng on 14-9-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleSearchStockVC.h"
#import "StockDBManager.h"
#import "FirmSaleSearchStockCell.h"

@implementation RealStockSearchTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return HEIGHT_OF_BUY_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"cellID";
  FirmSaleSearchStockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

  if (!cell) {
    cell = [[FirmSaleSearchStockCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }

  StockFunds *tableDBItem = self.dataArray.array[indexPath.row];
  [cell setInformationWithDBTableItem:tableDBItem];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  [((StockSearchTableVC *)self.baseTableViewController).searchField resignFirstResponder];
  StockFunds *stock = self.dataArray.array[indexPath.row];
  if (self.onStockSelectedCallback) {
    self.onStockSelectedCallback(stock.code, stock.name, [stock.firstType stringValue]);
  }
}

- (OnStockSelected)onStockSelectedCallback {
  return ((StockSearchTableVC *)self.baseTableViewController).onStockSelectedCallback;
}

@end

@implementation RealStockSearchTableVC

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[RealStockSearchTableAdapter alloc] initWithTableViewController:self
                                                                       withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

@end

@implementation FirmSaleSearchStockVC

#define HEIGHT_OF_SEARCHBAR 30.0

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  //开启过滤指数股
  _filterStockIndex = YES;

  [_topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;

  //搜索框背景
  UIView *stockSearchBackground =
      [[UIView alloc] initWithFrame:CGRectMake(0, _topToolBar.bounds.size.height, self.view.bounds.size.width, HEIGHT_OF_SEARCHBAR * 2)];
  stockSearchBackground.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:stockSearchBackground];
  //搜索框背景底线 1像素灰线
  UIView *stockSearchBackgroundBottomLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0, stockSearchBackground.bounds.size.height - 1,
                                               stockSearchBackground.bounds.size.width, 1)];
  stockSearchBackgroundBottomLineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [stockSearchBackground addSubview:stockSearchBackgroundBottomLineView];

  //股票搜索框
  _stockSearchTextField =
      [[UITextField alloc] initWithFrame:CGRectMake(10, 55, self.view.bounds.size.width - 10 * 2, HEIGHT_OF_SEARCHBAR)];
  _stockSearchTextField.center = stockSearchBackground.center;
  _stockSearchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _stockSearchTextField.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _stockSearchTextField.layer.cornerRadius = HEIGHT_OF_SEARCHBAR / 2;
  _stockSearchTextField.layer.borderWidth = 1;
  _stockSearchTextField.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor];
  _stockSearchTextField.textAlignment = NSTextAlignmentLeft;
  _stockSearchTextField.placeholder = @"请输入股票代码或拼音首字母";
  [_stockSearchTextField setValue:[Globle colorFromHexRGB:Color_Gray]
                       forKeyPath:@"_placeholderLabel.textColor"];
  _stockSearchTextField.font = [UIFont systemFontOfSize:HEIGHT_OF_SEARCHBAR / 2];
  //背景图 宽度与placeholder文字长度对应
  UIView *magnifierBackgrounView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, HEIGHT_OF_SEARCHBAR,
                               HEIGHT_OF_SEARCHBAR)];
  //放大镜
  UIImageView *magnifierImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT_OF_SEARCHBAR / 2, HEIGHT_OF_SEARCHBAR / 2)];
  magnifierImageView.center = magnifierBackgrounView.center;
  magnifierImageView.contentMode = UIViewContentModeScaleAspectFit;
  magnifierImageView.image = [UIImage imageNamed:@"magnifier"];
  [magnifierBackgrounView addSubview:magnifierImageView];

  _stockSearchTextField.leftView = magnifierBackgrounView;
  _stockSearchTextField.leftViewMode = UITextFieldViewModeAlways;
  [self.view addSubview:_stockSearchTextField];

  CGRect tableRect = CGRectMake(0, topToolBarHeight + HEIGHT_OF_SEARCHBAR * 2, self.view.bounds.size.width,
                                self.view.bounds.size.height - topToolBarHeight - HEIGHT_OF_SEARCHBAR * 2);

  __weak FirmSaleSearchStockVC *weakSelf = self;

  RealStockSearchTableVC *stockSearchTableVC =
      [[RealStockSearchTableVC alloc] initWithFrame:tableRect
                                    withSearchField:_stockSearchTextField];
  stockSearchTableVC.filterStockIndex = _filterStockIndex;
  stockSearchTableVC.onStockSelectedCallback = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
    [weakSelf leftButtonPress];
    weakSelf.searchStockCodeBlock(stockCode, stockName, firstType);
  };

  stockSearchTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  stockSearchTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [self.view addSubview:stockSearchTableVC.view];
  [self addChildViewController:stockSearchTableVC];
}

#pragma mark - topBanner返回键
//点击左键
- (void)leftButtonPress {
  [_stockSearchTextField resignFirstResponder];
  [super leftButtonPress];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //呈现动画结束后才弹出键盘
  [_stockSearchTextField becomeFirstResponder];
}

@end
