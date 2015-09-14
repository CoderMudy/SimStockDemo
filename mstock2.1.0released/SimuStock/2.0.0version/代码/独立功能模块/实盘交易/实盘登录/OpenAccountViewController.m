//
//  OpenAccountViewController.m
//  SimuStock
//
//  Created by Mac on 15-3-4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OpenAccountViewController.h"
#import "OpenAccountViewCell.h"
#import "OpenAccountItem.h"
#import "SchollWebViewController.h"
#import <tztDBSCKH/tztkhApp.h>
#import "UIImage+ColorTransformToImage.h"
#import "NewShowLabel.h"

@interface OpenAccountViewController ()

@end
/** 侧栏宽度 */
#define SwitchSlideWidth 60.0f
/** 控制器宽度 */
#define CurrentViewWidth self.view.frame.size.width - SwitchSlideWidth
/** 控制器高度 */
#define CurrentViewHeight self.view.frame.size.height - SwitchSlideWidth
#define FootViewHeight 150.0f
/** 左间隙宽度 */
#define LeftCuttingWidth 25.0f
/** 右间隙宽度 */
#define RightCuttingWidth 30.0f

@implementation OpenAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.noDataOrNoCache = NO;
  accountArray = [[NSMutableArray alloc] init];
  originalArray = [[NSMutableArray alloc] init];
  advArray = [[NSMutableArray alloc] init];
  advData = [[GameAdvertisingData alloc] init];
  advData.dataArray = [[NSMutableArray alloc] init];
  [self createTableview];
  [self createTablevewHeadView];
}
//得到券商的唯一 标示符
- (void)getBrokerSetNo:(NSDictionary *)setNoDic
   withBrokerSetNoType:(BrokersDownloadType)brokerDownloadType {
  _setNoMutableDic = [NSDictionary dictionaryWithDictionary:setNoDic];
  self.brokerDownloadT = brokerDownloadType;
}

#pragma mark - 刷新当前券商数据
/*
 *  需要刷新的参数
 *  accountArray 开户信息数据
 *  客服电话
 *  开户指引
 *  ios信息
 */
- (void)refreshOpenAccountInfo:(RealTradeSecuritiesCompany *)obj {
  //如果原始数据已存在，释放
  if ([originalArray count] > 0) {
    [originalArray removeAllObjects];
    [accountArray removeAllObjects];
  }
  if ([advArray count] > 0) {
    [advArray removeAllObjects];
  }
  //券商信息
  currentBrokerInfo = obj;
  // 客服电话
  openPhone = obj.openPhone;
  //开户指引
  openHelp = obj.openHelp;
  //当前证券
  currentAccountCompany = obj.name;

  // ios下载
  brokerDownload = obj.downloadIOS;
  // type
  brokerAccountType = obj.openType;

  self.noDataOrNoCache = YES;

  //重置 开户按钮
  [openAccountBtn setTitle:brokerAccountType.des forState:UIControlStateNormal];

  [sevicesBtn refreshImageTextButtonWithText:openPhone.title
                                WithTextFont:10.0f
                                   withImage:@"电话小图标"
                           withTextAlignment:NSTextAlignmentLeft
                                   withFrame:sevicesBtn.frame];
  [accoutGuideBtn refreshImageTextButtonWithText:openHelp.title
                                    WithTextFont:10.0f
                                       withImage:@"开户帮助小图标"
                               withTextAlignment:NSTextAlignmentRight
                                       withFrame:accoutGuideBtn.frame];
  [originalArray addObjectsFromArray:obj.openAccountArr];
  [advArray addObjectsFromArray:obj.advArray];
  [self showAdvLists];
  [self receiveRequestData];
}
#pragma mark - 左侧选择控件（表格）
/** 创建表格 */
- (void)createTableview {
  accountTableview =
      [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CurrentViewWidth, CurrentViewHeight)];
  accountTableview.delegate = self;
  accountTableview.dataSource = self;
  accountTableview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  accountTableview.bounces = NO;
  accountTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
  accountTableview.separatorColor = [UIColor clearColor];
  [self.view addSubview:accountTableview];
  //创建底部控件
  [accountTableview setTableFooterView:[self createTableViewFootView]];
}
/** 创建表头广告栏 */
- (void)createTablevewHeadView {
  [self topBillboard];
}

- (void)topBillboard {
  advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeOpenStockAccount];
  advViewVC.delegate = self;
  advViewVC.view.size = CGSizeMake(CurrentViewWidth, CurrentViewHeight);
  advViewVC.view.userInteractionEnabled = YES;
  [self addChildViewController:advViewVC];
  advViewVC.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
#pragma mark - 广告数据
- (void)showAdvLists {
  if ([advData.dataArray count] > 0) {
    [advData.dataArray removeAllObjects];
  }
  [advData.dataArray addObjectsFromArray:advArray];
  //绑定广告数据
  [advViewVC bindGameAdvertisingData:advData];
}

///默认宽度
static float const seviceOrGuideBtnWith = 100.0f;
///默认高度
static float const seviceOrGuideBtnHeight = 30.0f;
///客服和指引高度
static float const seviceAndGuideHeight = 12.0f;
/** 创建表格底部控件(包括开户按钮及客服，指引) */
- (UIView *)createTableViewFootView {
  UIView *tbFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentViewWidth, FootViewHeight)];
  tbFootView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //开户按钮
  openAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  openAccountBtn.frame =
      CGRectMake(LeftCuttingWidth, 15, CurrentViewWidth - LeftCuttingWidth - RightCuttingWidth, 33);
  openAccountBtn.backgroundColor = [Globle colorFromHexRGB:@"ffa10e"];
  [openAccountBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
  NSString *titleOpenButton = nil;
  if (brokerAccountType.des == nil || brokerAccountType.des.length == 0) {
    titleOpenButton = @"我要开户/转户";
  } else {
    titleOpenButton = brokerAccountType.des;
  }
  [openAccountBtn setTitle:titleOpenButton forState:UIControlStateNormal];
  UIImage *openAccountBtnImage =
      [UIImage imageFromView:openAccountBtn withBackgroundColor:[Globle colorFromHexRGB:@"d18501"]];
  [openAccountBtn setBackgroundImage:openAccountBtnImage forState:UIControlStateHighlighted];
  __weak OpenAccountViewController *weakSelf = self;
  [openAccountBtn setOnButtonPressedHandler:^{
    [weakSelf openOrTransactionAccount];
  }];
  [tbFootView addSubview:openAccountBtn];
  //客服电话
  float sevieOrignY = openAccountBtn.frame.origin.y + openAccountBtn.frame.size.height + seviceAndGuideHeight;
  CGRect seviceFrame = CGRectMake(LeftCuttingWidth, sevieOrignY, seviceOrGuideBtnWith, seviceOrGuideBtnHeight);
  sevicesBtn = [[Image_TextButton alloc] initWithImage:@"电话小图标"
                                              withText:@"德邦证券客服"
                                          withTextFont:10.0f
                                         withTextColor:@"31bce9"
                                     withHighLighColor:Color_Blue_but
                                     withTextAlignment:NSTextAlignmentLeft
                                             withFrame:seviceFrame];
  sevicesBtn.origin = CGPointMake(seviceFrame.origin.x, seviceFrame.origin.y);
  [sevicesBtn.imageTextBtn addTarget:self
                              action:@selector(clickSeviceBtn)
                    forControlEvents:UIControlEventTouchUpInside];
  //开户指引
  CGRect accountFrame = CGRectMake(CurrentViewWidth - RightCuttingWidth - seviceOrGuideBtnWith,
                                   sevieOrignY, seviceOrGuideBtnWith, seviceOrGuideBtnHeight);
  accoutGuideBtn = [[Image_TextButton alloc] initWithImage:@"开户帮助小图标"
                                                  withText:@"德邦开户指引"
                                              withTextFont:10.0f
                                             withTextColor:@"31bce9"
                                         withHighLighColor:Color_Blue_but
                                         withTextAlignment:NSTextAlignmentRight
                                                 withFrame:accountFrame];
  accoutGuideBtn.origin = CGPointMake(
      CurrentViewWidth - RightCuttingWidth - accoutGuideBtn.frame.size.width, accountFrame.origin.y);
  [accoutGuideBtn.imageTextBtn addTarget:self
                                  action:@selector(clickAccoutGuideBtn)
                        forControlEvents:UIControlEventTouchUpInside];
  [tbFootView addSubview:sevicesBtn];
  [tbFootView addSubview:accoutGuideBtn];
  return tbFootView;
}

#pragma mark - GameAdvertisingDelegate
/** 判断有没有广告页 */
- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg {
  if (AdBool) {
    advViewVC.view.userInteractionEnabled = YES;
    accountTableview.tableHeaderView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    CGFloat factor = WIDTH_OF_SCREEN / 320;
    advViewVC.view.frame = CGRectMake(0.0, 0.0, CurrentViewWidth, openAccountAdvHeight * factor);
    accountTableview.tableHeaderView = advViewVC.view;
  } else {
    [advViewVC.view removeFromSuperview];
    accountTableview.tableHeaderView = nil;
  }
}
#pragma mark - buttonAction
/** 我要开户/转户 */
- (void)openOrTransactionAccount {
  if (!self.noDataOrNoCache) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  NSInteger type = brokerAccountType.type;
  switch (type) {
  case BrokerEmbeddedApp:
    //内嵌下载
    [self openURLFormAppWithBorkerSecNo:BrokerEmbeddedApp];
    return;
  case BrokerExternalDownloadAPP:
    //下载 开户APP
    [self openURLFormAppWithBorkerSecNo:BrokerExternalDownloadAPP];
    return;
  case BrokerWebAPP:
    // web开户
    [self openURLFormAppWithBorkerSecNo:BrokerWebAPP];
    return;
  case BrokerHTM5:
    // HTM5
    [self openURLFormAppWithBorkerSecNo:BrokerHTM5];
    return;
  default:
    break;
  }
}

- (void)openURLFormAppWithBorkerSecNo:(BrokersDownloadType)brokerType {
  NSString *key = [NSString stringWithFormat:@"%ld", (long)brokerType];
  NSArray *array = _setNoMutableDic[key];
  if (array.count != 0 && array) {
    for (int i = 0; i < array.count; i++) {
      NSInteger num = [array[i] integerValue];
      if (currentBrokerInfo.secNo == num) {
        switch (brokerType) {
        case BrokerEmbeddedApp:
          [self openAccountDeBang];
          return;
        case BrokerExternalDownloadAPP: {
          BOOL isEnd = [self determineWhetherPhoneHadASoftwareInstalled:brokerDownload.customurl];
          if (isEnd) {
            [self openAppFormLocalOpenDesignater:brokerDownload.customurl];
          } else {
            [self downloadAppStockAccount:brokerDownload.download];
          }
        }
          return;
        case BrokerWebAPP:
          //待续
          return;
        case BrokerHTM5:
          [self openAccountForHTM5WithURL:brokerAccountType.brokerMain];
          return;
        default:
          return;
        }
      }
    }
  }
}

#pragma mark - 下载券商开户APP
- (void)downloadAppStockAccount:(NSString *)url {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - 判断手机本地有没有安装某个app
- (BOOL)determineWhetherPhoneHadASoftwareInstalled:(NSString *)url {
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - 打开本地知道APP
- (void)openAppFormLocalOpenDesignater:(NSString *)url {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - HTM5
- (void)openAccountForHTM5WithURL:(NSString *)url {
  NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
      kCFAllocatorDefault, (CFStringRef)url, NULL, NULL, kCFStringEncodingUTF8));
  NSString *title = [NSString stringWithFormat:@"%@开户", currentBrokerInfo.name];
  [SchollWebViewController startWithTitle:title
                                  withUrl:encodedString
                      withBrokerLogonBool:YES
                           withBrokerType:BrokerOpenAccount];
}
/** 点击客服按钮 */
- (void)clickSeviceBtn {
  if (!self.noDataOrNoCache) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [[UIApplication sharedApplication]
      openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [openPhone.des stringByReplacingOccurrencesOfString:@"-"
                                                                                                                          withString:@""]]]];
}

/** 德邦开户 */
- (void)openAccountDeBang {
//开启德邦账户
#if !(TARGET_IPHONE_SIMULATOR)
  NSString *pActionKey = @"10048";
  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
  UINavigationController *nav = app.viewController.navigationController;
  NSArray *pArry = @[ app.window, nav, self, pActionKey ];
  NSDictionary *params = @{ @"APP" : pArry, @"RunByURL" : @"0" };
  tztkhApp *tzapp = [tztkhApp getShareInstance];
  [tzapp SetUISign:1];
  [tzapp callService:params withDelegate:app.viewController];
  [tzapp setMenuBarHidden:YES animated:NO];
  return;
#else
  NSURL *url = [NSURL URLWithString:@"com.tzt.tebon.kh://abc"];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
  } else {
    [[UIApplication sharedApplication]
        openURL:[NSURL URLWithString:@"https://kaihu.tebon.com.cn/download/sjkh/" @"download.htm"]];
  }
#endif
}

/** 德邦开户指引 */
- (void)clickAccoutGuideBtn {
  if (!self.noDataOrNoCache) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //开户 指引
  [SchollWebViewController startWithTitle:openHelp.title withUrl:openHelp.des];
}

#pragma mark
#pragma mark - uitableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  OpenAccountItem *item = accountArray[indexPath.section];
  return item.textHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentViewWidth, RightCuttingWidth)];
  headView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //竖线图片
  UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftCuttingWidth, 16, 3, 14)];
  lineImageView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [headView addSubview:lineImageView];
  //标题
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 16, 100, 14)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
  [titleLabel setTextColor:[Globle colorFromHexRGB:@"22222"]];
  [headView addSubview:titleLabel];
  RealTradeSecuritiesCompanyDes *des = originalArray[section];
  titleLabel.text = des.title;
  return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 40.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [accountArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"OpenAccountViewCell";
  OpenAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  OpenAccountItem *item = accountArray[indexPath.section];
  cell.accountDetailTextView.text = item.details;
  [cell.accountDetailTextView setTextSize:12.f];
  [cell.accountDetailTextView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [cell.accountDetailTextView fitToSuggestedHeight];
  return cell;
}
#pragma mark - 加载券商数据
- (void)receiveRequestData {
  for (int st = 0; st < [originalArray count]; st++) {
    RealTradeSecuritiesCompanyDes *des = originalArray[st];
    OpenAccountItem *item = [[OpenAccountItem alloc] init];
    item.details = [NSString stringWithString:des.content];
    item.textHeight = [FTCoreTextView heightWithText:item.details
                                               width:CurrentViewWidth - LeftCuttingWidth - RightCuttingWidth
                                                font:12.0f];
    [accountArray addObject:item];
  }
  [accountTableview reloadData];
}

@end
