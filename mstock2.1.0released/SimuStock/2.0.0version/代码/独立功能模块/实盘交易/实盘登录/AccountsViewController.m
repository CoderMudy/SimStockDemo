//
//  AccountsViewController.m
//  SimuStock
//
//  Created by Mac on 15-3-2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AccountsViewController.h"

/** 试验类 券商列表类 */

#import "BrokerageAccountListVC.h"

/** 侧栏宽度 */
#define SwitchSlideWidth 60.0f
/** 当前界面宽度 */
#define CurrentViewWidth self.clientView.frame.size.width
/** 当前界面高度 */
#define CurrentViewHeight self.clientView.frame.size.height
/** 德邦 */
#define StockTypeDebang @"StockTypeDebang"
/** 东莞 */
#define StockTypeDongGuan @"StockTypeDongGuan"
/** 导航条高度 */
#define navigationBarHeight 44.0f

@interface AccountsViewController ()
@property(strong, nonatomic) BrokerNameListTableView *brokerNameTableView;

@end

@implementation AccountsViewController

- (id)initWithPageTitle:(NSString *)pageTitile
        withCompanyName:(NSString *)selectedCompanyName
        onLoginCallBack:(OnLoginCallBack)onLoginCallBack {
  if (self = [super init]) {
    _pageTitle = pageTitile;
    _onLoginCallBack = onLoginCallBack;
    _selectedCompanyName = selectedCompanyName;
    isOpenStockAccountPage = [_pageTitle isEqualToString:@"实盘开户转户"];
    isLoginStockAccountPage = [_pageTitle isEqualToString:@"交易登录"];
  }
  return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _indicatorView.hidden = YES;
  //创建新牛
  [_littleCattleView setFrame:_clientView.bounds];
  [_topToolBar resetContentAndFlage:_pageTitle Mode:TTBM_Mode_Leveltwo];
  //右侧栏承接界面
  detailView = [[UIView alloc]
      initWithFrame:CGRectMake(SwitchSlideWidth, 0,
                               CurrentViewWidth - SwitchSlideWidth,
                               CurrentViewHeight)];
  detailView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  detailView.hidden = NO;
  [self.clientView addSubview:detailView];

  [self createServicesNumber];

  if (isLoginStockAccountPage) {
    //创建登录详情界面
    if (!self.stockLogonVC) {
      self.stockLogonVC = [[StockLogonViewController alloc]
          initWithNibName:@"StockLogonViewController"
                   bundle:nil];
      self.stockLogonVC.view.backgroundColor =
          [Globle colorFromHexRGB:@"#f7f7f7"];
      self.stockLogonVC.view.frame = detailView.bounds;
      self.stockLogonVC.onLoginSuccessBlock = self.onLoginCallBack;
      [detailView addSubview:self.stockLogonVC.view];
    }
    //开户跳转
    [customerServiceOrAccountButton setTitle:@"    5秒开户\n佣金万2.5起"
                                    forState:UIControlStateNormal];
    customerServiceOrAccountButton.tag = 5050;
    customerServiceOrAccountButton.titleLabel.font =
        [UIFont systemFontOfSize:Font_Height_12_0];
  }
  //创建左侧表格
  [self createTableview];
}
#pragma mark - servicesNumber
/** 客服热线 */
- (void)createServicesNumber {
  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  customerServiceOrAccountButton = rightButton;
  rightButton.frame =
      CGRectMake(self.view.frame.size.width - 100,
                 _topToolBar.frame.size.height - navigationBarHeight, 100,
                 navigationBarHeight);
  rightButton.titleLabel.numberOfLines = 0;
  [rightButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                    forState:UIControlStateNormal];
  [rightButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [rightButton addTarget:self
                  action:@selector(dialSevicesTelephoneNumber)
        forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:rightButton];
}
/** 开户跳转 */
- (void)dialSevicesTelephoneNumber {
  //实盘开户 开户跳转按钮
  [AppDelegate pushViewControllerFromRight:[[BrokerageAccountListVC alloc]
                                               initWithOnLoginCallbalck:nil]];
}

/** 点击哭泣的小牛进行的刷新操作 */
-(void)refreshButtonPressDown
{
  [self.brokerNameTableView getStockAccountsCompanyList];
}

#pragma mark - 左侧选择控件（表格）
/** 创建表格 */
- (void)createTableview {
  self.brokerNameTableView = [[BrokerNameListTableView alloc]
      initWithNibName:@"BrokerNameListTableView"
               bundle:nil
           withStirng:BrokerLoginStock];
  __weak AccountsViewController *weakSelf = self;
  self.brokerNameTableView.brokerCompanyListBlock =
  ^(RealTradeSecuritiesCompany *company, BrokerOpenLogin openLogin,
    NSDictionary *dic, BrokersDownloadType brokerType) {
    if (openLogin == BrokerLoginStock) {
      [weakSelf.stockLogonVC refreshOpenAccountInfo:company];
    }
  };
  CGRect frame = CGRectMake(0, 0, 60.0f, CGRectGetHeight(_clientView.bounds));
  self.brokerNameTableView.tableView.frame = frame;
  [self.clientView addSubview:self.brokerNameTableView.tableView];
  [self addChildViewController:self.brokerNameTableView];
  [self.brokerNameTableView getStockAccountsCompanyList];
}

+ (void)checkLogonRealTradeAndDoBlock:(OnLoginCallBack)onLoginCallBack {
  BOOL isRealTradeLogined = [SimuUser getUserFirmLogonSuccessStatus];
  BOOL infoComplete = [[RealTradeUrls
          singleInstance] autoLoadRealTradeUrlFactory]; //判断信息是否齐全

  if (!isRealTradeLogined || !infoComplete) {
    [AppDelegate
        pushViewControllerFromRight:[[AccountsViewController alloc]
                                        initWithPageTitle:@"交易登录"
                                          withCompanyName:nil
                                          onLoginCallBack:onLoginCallBack]];
  } else {
    onLoginCallBack(YES);
  }
}

@end
