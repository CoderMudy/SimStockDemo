//
//  StockFriendsViewController.m
//  SimuStock
//
//  Created by jhss on 14-4-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockFriendsViewController.h"
#import "StockUtil.h"

#import "AttentionEventObserver.h"

@implementation StockFriendsTableAdapter

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int contentOffsetY = scrollView.contentOffset.y;
  if (contentOffsetY != 0) {
    if ([self.dataArray.array count] > 0) {
      [((StockFriendsTableVC *)self.baseTableViewController)
              .searchField resignFirstResponder];
    }
  }
}

@end

@implementation StockFriendsTableVC {
  int page;
  AttentionEventObserver *attentionEventObserver;
}

- (id)initWithFrame:(CGRect)frame withSearchField:(UITextField *)searchField {
  if (self = [super initWithFrame:frame]) {
    self.searchField = searchField;
    attentionEventObserver = [[AttentionEventObserver alloc] init];
    __weak StockFriendsTableVC *weakSelf = self;
    attentionEventObserver.onAttentionAction = ^{
      [weakSelf refreshAttentionData];
    };
  }
  return self;
}

/** 将入参封装成一个dic */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *pageIndex = @"1";
  NSString *pagesize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    pageIndex = [@(page + 1) stringValue];
  }

  NSDictionary *dic = @{
    @"nickname" : _nickname ? _nickname : @"",
    @"pageindex" : pageIndex,
    @"pagesize" : pagesize
  };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"pageindex"];
    NSString *lastId = [@(page + 1) stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockFriendsTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [StockFriendsListWrapper
      requestStockFriendsWithParams:
          [self getRequestParamertsWithRefreshType:refreshType]
                        wthCallback:callback];
}
/** 绑定数据（调用默认的绑定方法），首先判断是否有效 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    [super bindRequestObject:latestData
        withRequestParameters:parameters
              withRefreshType:refreshType];
    self.headerView.hidden = NO;
    if (refreshType == RefreshTypeLoaderMore) {
      page += 1;
    } else {
      page = 1;
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"没有找到相关股友"];
}

@end

@implementation StockFriendsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createSearchBoxView];
  [self createTableView];
  tempSelectRow = -1;
  backAttentionInfo = NO;
  _indicatorView.hidden = YES;
}
#pragma mark
#pragma mark-------界面设计--------

//创建搜索框视图
- (void)createSearchBoxView {
  //增大点击区域
  UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  areaBtn.frame = CGRectMake(51, _topToolBar.bounds.size.height - 40,
                             self.view.width - 51 * 2, 34.5f);
  areaBtn.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [areaBtn addTarget:self
                action:@selector(inputTextFieldBecomeRespond)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:areaBtn];

  inputTextField = [[ExtendedTextField alloc]
      initWithFrame:CGRectMake(57, _topToolBar.bounds.size.height - 30,
                               self.view.width - 57 * 2, 17.5f)];
  inputTextField.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  inputTextField.textAlignment = NSTextAlignmentLeft;
  [inputTextField setValue:[Globle colorFromHexRGB:Color_Gray]
                forKeyPath:@"_placeholderLabel.textColor"];
  inputTextField.placeholder = @"请输入股友昵称";
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
                   action:@selector(getFriendListData)
         forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:searchButton];

  [inputTextField becomeFirstResponder];
}

- (void)getFriendListData {
  if (inputTextField.text.length > 0) {
    stockFriendsTableVC.nickname =
        [CommonFunc base64StringFromText:inputTextField.text];
    [stockFriendsTableVC refreshButtonPressDown];
  } else {
    [_indicatorView stopAnimating];
  }
  [inputTextField resignFirstResponder];
}

#pragma mark-----------网络请求开启，菊花转-----------
- (void)searchIndicatorViewZStatus {
  // zxc修改
  if ([inputTextField.text length] > 0) {
    searchButton.hidden = YES;
  } else {
    searchButton.hidden = NO;
  }
}

//输入栏扩大化
- (void)inputTextFieldBecomeRespond {
  [inputTextField becomeFirstResponder];
}

- (void)refreshButtonPressDown {
  [self getFriendListData];
}

- (void)createTableView {

  __weak StockFriendsViewController *weakSelf = self;

  stockFriendsTableVC =
      [[StockFriendsTableVC alloc] initWithFrame:_clientView.bounds
                                 withSearchField:inputTextField];

  stockFriendsTableVC.beginRefreshCallBack = ^{
    weakSelf.indicatorView.hidden = NO;
    [weakSelf.indicatorView startAnimating];
  };
  stockFriendsTableVC.endRefreshCallBack = ^{
    weakSelf.indicatorView.hidden = YES;
    [weakSelf.indicatorView stopAnimating];
  };
  [_clientView addSubview:stockFriendsTableVC.view];
  [self addChildViewController:stockFriendsTableVC];

  stockFriendsTableVC.headerView.hidden = YES;
}

#pragma mark---------end---------
#pragma mark

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [inputTextField resignFirstResponder];
}

#pragma mark
#pragma mark-------UITextFieldDelegate--------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField.text length] > 0) {
    [self getFriendListData];
    return YES;
  } else {
    return NO;
  }
}
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
    stockFriendsTableVC.headerView.hidden = YES;
    searchButton.userInteractionEnabled = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                  forState:UIControlStateNormal];
  } else {
    searchButton.userInteractionEnabled = YES;
    stockFriendsTableVC.headerView.hidden = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索"]
                  forState:UIControlStateNormal];
  }
  return YES;
}

#pragma mark - 左键返回
- (void)leftButtonPress {
  [inputTextField resignFirstResponder];
  [super leftButtonPress];
}

@end
