//
//  StockSearchTableVC.m
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockSearchTableVC.h"
#import "PortfolioStockModel.h"
#import "StockDBManager.h"
#import "StockSearchTableViewCell.h"
#import "SelfStockUtil.h"

@implementation StockSearchTableAdapter

- (NSString *)nibName {
  return NSStringFromClass([StockSearchTableViewCell class]);
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 53.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StockSearchTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  //取消选中效果
  UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
  cell.selectedBackgroundView = backView;
  cell.selectedBackgroundView.backgroundColor =
      [Globle colorFromHexRGB:@"#e8e8e8"];

  StockFunds *stock = self.dataArray.array[indexPath.row];
  [cell bindStockFunds:stock];
  __weak StockSearchTableAdapter *weakSelf = self;
  [cell.btnAddStock setOnButtonPressedHandler:^{
    [weakSelf addPortfolioStock:stock];
  }];

  return cell;
}

- (void)addPortfolioStock:(StockFunds *)stock {
  [((StockSearchTableVC *)self.baseTableViewController)
          .searchField endEditing:YES];

  __weak StockSearchTableAdapter *weakSelf = self;
  [PortfolioStockManager
      setPortfolioStock:stock.code
              onSuccess:^{
                [weakSelf.baseTableViewController.tableView reloadData];
              }];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  [((StockSearchTableVC *)self.baseTableViewController)
          .searchField resignFirstResponder];
  StockFunds *stock = self.dataArray.array[indexPath.row];
  if (self.onStockSelectedCallback) {
    self.onStockSelectedCallback(stock.code, stock.name,
                                 [stock.firstType stringValue]);
  }
}

- (OnStockSelected)onStockSelectedCallback {
  return ((StockSearchTableVC *)self.baseTableViewController)
      .onStockSelectedCallback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int contentOffsetY = scrollView.contentOffset.y;
  if (contentOffsetY != 0) {
    if ([self.dataArray.array count] > 0) {
      [((StockSearchTableVC *)self.baseTableViewController)
              .searchField resignFirstResponder];
    }
  }
}

@end

@implementation StockSearchTableVC {
  SelfStockChangeNotification *portfolioStockChangeObserver;
}

- (id)initWithFrame:(CGRect)frame withSearchField:(UITextField *)searchField {
  if (self = [super initWithFrame:frame]) {
    self.searchField = searchField;
  }
  return self;
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockSearchTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)refreshButtonPressDown {
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
  if (self.endRefreshCallBack) {
    self.endRefreshCallBack();
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [self setExclusiveTouchForButtons:self.view];
  [super viewDidAppear:animated];
}

- (void)setExclusiveTouchForButtons:(UIView *)myView {
  for (UIView *v in [myView subviews]) {
    if ([v isKindOfClass:[UIButton class]])
      [((UIButton *)v)setExclusiveTouch:YES];
    else if ([v isKindOfClass:[UIView class]]) {
      [self setExclusiveTouchForButtons:v];
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createOtherViews];
  self.headerView.hidden = YES;
  self.footerView.hidden = YES;

  keyboardView = [[SimuKeyBoardView alloc]
      initWithFrame:CGRectMake(0, self.view.bounds.size.height - 218,
                               self.view.bounds.size.width, 218)];
  self.searchField.inputView = keyboardView;
  keyboardView.delegate = self;
  self.searchField.delegate = self;
  [self addObservers];
}

- (void)addObservers {
  __weak StockSearchTableVC *weakSelf = self;
  portfolioStockChangeObserver = [[SelfStockChangeNotification alloc] init];
  portfolioStockChangeObserver.onSelfStockChange = ^{
    [weakSelf.tableView reloadData];
  };
}

#pragma mark--------UITextFieldDelegate---------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (self.onSearchFieldFocus) {
    self.onSearchFieldFocus();
  }
}

- (void)createOtherViews {
  //清空查询视图
  UIView *inquiryView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width,
                               60.0 / 2)];
  inquiryView.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  //清空
  UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  emptyBtn.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  emptyBtn.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 60.0 / 2);
  [emptyBtn setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                 forState:UIControlStateNormal];
  [emptyBtn setTitle:@"清除查询记录" forState:UIControlStateNormal];
  emptyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
  [emptyBtn setBackgroundImage:[UIImage imageNamed:@"比赛按钮高亮状态"]
                      forState:UIControlStateHighlighted];

  [inquiryView addSubview:emptyBtn];
  [self.tableView setTableFooterView:inquiryView];
  __weak StockSearchTableVC *weakSelf = self;
  [emptyBtn setOnButtonPressedHandler:^{
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"确认清除历史纪录？"
                                  delegate:weakSelf
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
    [alert show];
  }];

  promptLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width,
                               100.0 / 2)];
  promptLab.textAlignment = NSTextAlignmentCenter;
  promptLab.text = @"没有找到相关股票";
  promptLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  promptLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  promptLab.backgroundColor = [UIColor clearColor];
  [self.tableView addSubview:promptLab];
  promptLab.hidden = YES;

  [self didShowHisSearchStockView:_filterStockIndex];
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //确定
    [self realClearHisRecords];
    [self.tableView reloadData];
  } else {
    //取消
  }
}

- (void)realClearHisRecords {
  [SimuUtil setSearchHistryStockContent:@""];
  [self didShowHisSearchStockView:_filterStockIndex];
  self.tableView.tableFooterView.hidden = YES;
}

/** 字母键盘，修改编辑框数据 */
- (void)textFieldChangeWithCharButtonPress:(UIButton *)button {
  if (button == nil || self.searchField == nil) {
    return;
  }

  if (button.tag == 27) { //删除按钮
    [self onDeleteKey];
  } else if (button.tag == 19) { //清空按钮
    [self onClearkey];
  } else if (button.tag == 30) {

  } else if (button.tag == 28) { //隐藏
    [self.searchField resignFirstResponder];
  } else if (button.tag == 29) { //确定按钮
    [self.searchField resignFirstResponder];
    [self resetSearchResult];
    return;
  } else { //普通字母输入按钮
    [self onNumberLetterKey:NO keyButton:button];
  }
  [self resetSearchResult];
}

/** 数字键盘，修改编辑框数据 */
- (void)textFieldChangeWithSelfButtonPress:(UIButton *)button {
  if (button == nil || self.searchField == nil) {
    return;
  }

  if (button.tag == 4) { //删除按钮
    [self onDeleteKey];
  } else if (button.tag == 9) {
    //隐藏键盘按钮
    [self.searchField resignFirstResponder];
    return;
  } else if (button.tag == 14) { //清空按钮
    [self onClearkey];
  } else if (button.tag == 17) { //确定按钮
    [self.searchField resignFirstResponder];
    [self resetSearchResult];
    return;
  } else if (button.tag == 18) {
    // abc按钮
  } else { //普通数字输入按钮
    [self onNumberLetterKey:YES keyButton:button];
  }

  [self resetSearchResult];
}

/** 删除按钮 */
- (void)onDeleteKey {

  NSString *text = self.searchField.text;
  NSInteger lenth = [text length] - 1;
  if (lenth > -1) {
    text = [text substringToIndex:[text length] - 1];
  }
  self.searchField.text = text;
  if ([self.searchField.text length] == 0) {
    promptLab.hidden = YES;
  }
  //滚动到初始位置
  if (self.searchField.text.length == 0) {
    [self tableViewScrollToTop];
  }
}

/** 清空按钮 */
- (void)onClearkey {
  self.searchField.text = @"";
  promptLab.hidden = YES;
  //滚动到初始位置
  if (self.searchField.text.length == 0) {
    [self tableViewScrollToTop];
  }
}

- (void)onNumberLetterKey:(BOOL)isNumber keyButton:(UIButton *)button {
  NSString *allcontent =
      [self.searchField.text stringByAppendingString:button.titleLabel.text];
  NSInteger length = allcontent.length;

  if (length > 6) {
    return;
  }
  NSString *key = button.titleLabel.text;
  if (!isNumber && !keyboardView.siShiftDown) {
    key = [button.titleLabel.text lowercaseString];
  }
  self.searchField.text = [self.searchField.text stringByAppendingString:key];

  [self tableViewScrollToTop];
}

///滚动到初始位置
- (void)tableViewScrollToTop {
  if (self.tableView && self.tableView.contentOffset.y != 0) {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
  }
}

- (void)resetSearchResult {
  NSString *content = self.searchField.text;
  if (content && [content length] > 0) {
    [self didShowSearchStockView];
  } else {
    [self didShowHisSearchStockView:_filterStockIndex];
  }
}

//重新设置搜索框显示内容
- (void)didShowSearchStockView {
  [self.dataArray reset];
  NSArray *array =
      [StockDBManager searchStockWithQueryText:self.searchField.text
                             withRealTradeFlag:YES];
  self.tableView.tableFooterView.hidden = YES;
  [self.tableView setTableHeaderView:nil];

  if (!array || array.count == 0) {
    [self.tableView reloadData];
    promptLab.hidden = NO;
    return;
  }

  for (NSInteger i = 0; i < 20 && i < array.count; i++) {
    StockFunds *simudbtableitem = array[i];
    if (_filterStockIndex && [simudbtableitem.code characterAtIndex:1] == '0') {
      continue;
    }
    [self.dataArray.array addObject:simudbtableitem];
  }

  if ([self.dataArray.array count] > 0) {
    self.tableView.userInteractionEnabled = YES;
    promptLab.hidden = YES;
    self.tableView.hidden = NO;
  } else {
    self.tableView.userInteractionEnabled = NO;
    promptLab.hidden = NO;
  }
  [self.tableView reloadData];
}

///展示历史搜索股票纪录
- (void)didShowHisSearchStockView:(BOOL)isFilterStockIndex {
  [self.dataArray reset];

  NSString *stockcodes = [SimuUtil getSearchHistryStockContent];
  NSArray *stockArray = [stockcodes componentsSeparatedByString:@","];

  for (NSString *obj in stockArray) {
    if (obj == nil || [obj isEqualToString:@""] || [obj length] != 8)
      continue;

    if (isFilterStockIndex && [obj characterAtIndex:1] == '0') {
      continue;
    }
    NSArray *result = [StockDBManager searchFromDataBaseWith8CharCode:obj
                                                    withRealTradeFlag:YES];
    if (result && [result count] > 0) {
      [self.dataArray.array addObject:result[0]];
    }
  }
  [self.tableView setTableHeaderView:_tableHeader];
  if ([self.dataArray.array count] > 0) {
    self.tableView.tableFooterView.hidden = NO;
    self.tableView.userInteractionEnabled = YES;
  } else {
    self.tableView.tableFooterView.hidden = YES;
    self.tableView.userInteractionEnabled = NO;
  }
  [self.tableView reloadData];
}

#pragma mark---------------------自制键盘代理---------------------
#pragma mark
#pragma mark---------------------SimuKeyBoardViewDelegate---------------------
//数字按钮点击
- (void)keyButtonDown:(UIButton *)index {
  [self textFieldChangeWithSelfButtonPress:index];
}
//字母按钮点击
- (void)keyButtonCharDown:(UIButton *)index {
  [self textFieldChangeWithCharButtonPress:index];
}

@end
