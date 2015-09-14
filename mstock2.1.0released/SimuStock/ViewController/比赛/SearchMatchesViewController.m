//
//  SearchMatchesViewController.m
//  SimuStock
//
//  Created by jhss on 14-5-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SearchMatchesViewController.h"
#import "CommonFunc.h"
//比赛tableview
#import "MatchTableViewController.h"

@interface SearchMatchesViewController ()
/** 数据展示 tableview */
@property(strong, nonatomic) MatchTableViewController *searchMatchVC;

@end

@implementation SearchMatchesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];

  [self createSearchTableView];
  _indicatorView.hidden = YES;
}

#pragma mark-- 创建tableview
- (void)createSearchTableView {
  CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.clientView.bounds),
                            CGRectGetHeight(self.clientView.bounds));
  self.searchMatchVC =
      [[MatchTableViewController alloc] initWithFrame:frame
                                   withMatchStockType:SearchMatch];
  self.searchMatchVC.searchField = inputTextField;
  self.searchMatchVC.showTableFooter = YES;
  __weak SearchMatchesViewController *weakSelf = self;
  self.searchMatchVC.endEditBlock = ^(){
    SearchMatchesViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.view endEditing:YES];
    }
  };
  
  
  [self.clientView addSubview:self.searchMatchVC.view];
  [self addChildViewController:self.searchMatchVC];
  self.searchMatchVC.headerView.hidden = YES;

  
  self.searchMatchVC.beginRefreshCallBack = ^() {
    weakSelf.indicatorView.hidden = NO;
    [weakSelf.indicatorView startAnimating];

  };

  self.searchMatchVC.endRefreshCallBack = ^() {
    weakSelf.indicatorView.hidden = YES;
    [weakSelf.indicatorView stopAnimating]; //停止菊花
  };
}

//创建搜索栏 _topToolBar 上面的控件
- (void)createMainView {
  //增大点击区域
  UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  areaBtn.frame =
      CGRectMake(51, _topToolBar.bounds.size.height - 40, self.view.width - 51*2, 34.5f);
  areaBtn.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [areaBtn addTarget:self
                action:@selector(inputTextFieldBecomeRespond)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:areaBtn];

  inputTextField = [[ExtendedTextField alloc]
      initWithFrame:CGRectMake(57, _topToolBar.bounds.size.height - 30, self.view.width - 57 * 2,
                               17.5f)];
  inputTextField.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  inputTextField.textAlignment = NSTextAlignmentLeft;
  [inputTextField setValue:[Globle colorFromHexRGB:Color_Gray]
                forKeyPath:@"_placeholderLabel.textColor"];
  inputTextField.placeholder = @"请输入比赛名称";
  inputTextField.font = [UIFont systemFontOfSize:Font_Height_15_0];
  [_topToolBar addSubview:inputTextField];
  inputTextField.delegate = self;
  inputTextField.returnKeyType = UIReturnKeySearch;
  [inputTextField setMaxLength:12];

  // zxc蓝色分割线
  UIView *lineView = [[UIView alloc]
      initWithFrame:CGRectMake(areaBtn.right - 35,
                               _topToolBar.bounds.size.height - 34, 0.5,
                               22.5f)];
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [_topToolBar addSubview:lineView];

  //搜索按钮
  searchButton = [[UIButton alloc]
      initWithFrame:CGRectMake(areaBtn.right - 34,
                               _topToolBar.bounds.size.height - 40, 34, 34.5f)];
  [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索记录背景"]
                          forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                forState:UIControlStateNormal];
  searchButton.userInteractionEnabled = NO;

  [searchButton addTarget:self
                   action:@selector(getStockMatchesListData:)
         forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:searchButton];

  [inputTextField becomeFirstResponder];
}
//输入栏按钮扩大化
- (void)inputTextFieldBecomeRespond {
  [inputTextField becomeFirstResponder];
}

- (void)getStockMatchesListData:(UIButton *)button {
  //键盘收回
  [inputTextField resignFirstResponder];

  //点击搜索
  self.searchMatchVC.textFiled =
      [CommonFunc base64StringFromText:inputTextField.text];
  [self.searchMatchVC refreshButtonPressDown];
}
/**键盘搜索按钮*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField.text length] > 0) {
    //键盘收回
    [inputTextField resignFirstResponder];
    self.searchMatchVC.textFiled =
        [CommonFunc base64StringFromText:inputTextField.text];
    [self.searchMatchVC refreshButtonPressDown];
    return YES;
  } else {
    return NO;
  }
}

#pragma mark
#pragma mark-------表格视图------
//滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [inputTextField resignFirstResponder];
  //滑动开始禁止点击搜索
  searchButton.selected = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  //滑动结束可以点击搜索
  searchButton.selected = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [inputTextField resignFirstResponder];
}
#pragma mark
#pragma mark-------UITextFieldDelegate--------

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];

  //按钮背景变化（删除一位一位的删，跟踪）
  if ([toBeString length] == 0 && [textField.text length] == 1) {
    searchButton.userInteractionEnabled = NO;
    self.searchMatchVC.headerView.hidden = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                  forState:UIControlStateNormal];
  } else {
    searchButton.userInteractionEnabled = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索"]
                  forState:UIControlStateNormal];
    self.searchMatchVC.headerView.hidden = NO;
  }
  return YES;
}

- (void)refreshButtonPressDown {
  if ([inputTextField.text length] > 0) {
    //键盘收回
    [inputTextField resignFirstResponder];
    [self.searchMatchVC refreshButtonPressDown];
  } else {
    [self.indicatorView stopAnimating];
  }
}

#pragma mark - 左键返回
- (void)leftButtonPress {
  inputTextField.delegate = nil;
  [inputTextField resignFirstResponder];
  [super leftButtonPress];
}

#pragma mark - 界面完全显示再弹键盘
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"UITextFieldTextDidChangeNotification"
              object:inputTextField];
}
@end
