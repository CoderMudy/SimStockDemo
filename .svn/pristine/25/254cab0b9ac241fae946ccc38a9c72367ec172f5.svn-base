//
//  BrokerNameListTableView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BrokerNameListTableView.h"
#import "StockCompanyCell.h"
#import "BaseRequester.h"
#import "CacheUtil.h"
#import "UIImageView+WebCache.h"
//缓存券商信息的类
#import "UserRealTradingInfo.h"

#import "SchollWebViewController.h"

@interface BrokerNameListTableView () {
  //券商分类数组
  NSMutableArray *_embeddedArray;         //内嵌
  NSMutableArray *_externalDownloadArray; //下载
  NSMutableArray *_webDownloadArray;      // web 广发特有的
  NSMutableArray *_HTMwebArray;           // HTM5 开户
}
/** 用来判断是开户还是登录 开户 YES  登录 NO */
@property(assign, nonatomic) BOOL openAccounLongin;
//枚举
@property(assign, nonatomic) BrokerOpenLogin brokerStockOpenOrLogin;
///记录非Web端的 cell位置
@property(assign, nonatomic) NSInteger oldLoginOrNewLogin;
/// AK
@property(copy, nonatomic) NSString *userAK;

@property(strong, nonatomic) NSMutableArray *brokerMutableArray;

@end

@implementation BrokerNameListTableView

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
           withStirng:(BrokerOpenLogin)openAccountOrLogin;
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    //开户 或者 登录
    self.brokerStockOpenOrLogin = openAccountOrLogin;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectedCellIndex = -1;
  }
  return self;
}

- (NSMutableArray *)brokerMutableArray {
  if (!_brokerMutableArray) {
    _brokerMutableArray = [NSMutableArray array];
  }
  return _brokerMutableArray;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (selectedCellIndex != -1) {
    if (self.oldLoginOrNewLogin == 2) {
      [self selectRow:0];
      return;
    } else {
      [self selectRow:selectedCellIndex];
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.userAK = [SimuUtil getAK];
  //行高
  self.tableView.rowHeight = 60.0f;
  //数据源
  _stockListsArray = [[DataArray alloc] init];
  //保存券商唯一标示符的数组
  _embeddedArray = [NSMutableArray array];
  _externalDownloadArray = [NSMutableArray array];
  _webDownloadArray = [NSMutableArray array];
  _HTMwebArray = [NSMutableArray array];
}
#pragma mark--  获取券商信息列表
- (void)getStockAccountsCompanyList {
  //先判断有没有缓存
  RealTradeSecuritiesCompanyList *companyList;
  //判断 有没有缓存数据
  if (!_stockListsArray.dataBinded) {
    // YES 开户 NO 登录
    switch (self.brokerStockOpenOrLogin) {
    case BrokerOpenAccount:
      companyList = [CacheUtil loadOpenStockAccountList];
      break;
    case BrokerLoginStock:
      companyList = [CacheUtil loadLoginStockAccountList];
      break;
    }
    if (companyList && [companyList.result count] > 0) {
      //有缓存
      [self bindSecuritiesCompanyList:companyList saveToCache:NO];
    }
  }
  //获取 当前券商
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BrokerNameListTableView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BrokerNameListTableView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return NO;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BrokerNameListTableView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSecuritiesCompanyList:(RealTradeSecuritiesCompanyList *)obj saveToCache:YES];
    }
  };
  callback.onFailed = ^() {
    //请求失败
    BrokerNameListTableView *strongSelf = weakSelf;
    if (strongSelf) {
      if (!strongSelf.stockListsArray.dataBinded) {
        //数据没绑定
        if (strongSelf.failedOrErrorBlock) {
          strongSelf.failedOrErrorBlock();
        }
      }
    }

  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    BrokerNameListTableView *strongSelf = weakSelf;
    if (strongSelf) {
      if (obj.message) {
        [NewShowLabel setMessageContent:obj.message];
      } else {
        [NewShowLabel showNoNetworkTip];
      }
      if (!strongSelf.stockListsArray.dataBinded) {
        //数据没绑定
        if (strongSelf.failedOrErrorBlock) {
          strongSelf.failedOrErrorBlock();
        }
      }
    }
  };

  //新接口
  switch (self.brokerStockOpenOrLogin) {
  case BrokerOpenAccount:
    //开户
    [RealTradeSecuritiesCompanyList loadNewBrokerageOpenAccountWithCallback:callback];
    break;
  case BrokerLoginStock:
    //登录
    [RealTradeSecuritiesCompanyList stockLoginList:callback];
    break;
  }
}

#pragma mark - 绑定数据
- (void)bindSecuritiesCompanyList:(RealTradeSecuritiesCompanyList *)obj
                      saveToCache:(BOOL)saveToCache {
  //缓存
  if (saveToCache) {
    switch (self.brokerStockOpenOrLogin) {
    case BrokerOpenAccount:
      //开户缓存
      [CacheUtil saveOpenStockAccountList:obj];
      break;
    case BrokerLoginStock:
      //登录缓存
      [CacheUtil saveLoginStockAccountList:obj];
      break;
    }
  }
  _stockListsArray.dataBinded = YES;
  [_stockListsArray.array removeAllObjects];
  self.companyList = (RealTradeSecuritiesCompanyList *)obj;
  if (self.brokerStockOpenOrLogin == BrokerOpenAccount) {
    //开户 券商信息类
    for (RealTradeSecuritiesCompany *company in self.companyList.result) {
      //将开户的分类
      if (company.openType.type == BrokerEmbeddedApp) {
        [_embeddedArray addObject:@(company.secNo)];
      } else if (company.openType.type == BrokerExternalDownloadAPP) {
        [_externalDownloadArray addObject:@(company.secNo)];
      } else if (company.openType.type == BrokerWebAPP) {
        [_webDownloadArray addObject:@(company.secNo)];
      } else if (company.openType.type == BrokerHTM5) {
        // HTM 开户
        [_HTMwebArray addObject:@(company.secNo)];
      } else {
        //其他
      }
      [_stockListsArray.array addObject:company];
    }
  } else {

    //排序 登录
    //排除 比AK小的券商
    [self getBrokerAKComparisonWithUsreAK:self.companyList];

    NSString *companyName = [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeUserTradingCompany];
    //如果该券商之前有缓存过 放到第一位
    [self changeBrokerPosition:companyName];
    [_stockListsArray.array addObjectsFromArray:self.brokerMutableArray];
  }

  _secNoDic = @{
    [NSString stringWithFormat:@"%ld", (long)BrokerEmbeddedApp] : _embeddedArray,
    [NSString stringWithFormat:@"%ld", (long)BrokerExternalDownloadAPP] : _externalDownloadArray,
    [NSString stringWithFormat:@"%ld", (long)BrokerWebAPP] : _webDownloadArray,
    [NSString stringWithFormat:@"%ld", (long)BrokerHTM5] : _HTMwebArray
  };
  //刷新Tableview
  [self.tableView reloadData];
  //默认选中第一行
  [self selectRow:0];
}
#pragma mark - 指定选中哪一行
- (void)selectRow:(NSUInteger)row {
  //选中
  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]
                              animated:NO
                        scrollPosition:UITableViewScrollPositionTop];
  if (self.stockListsArray.dataBinded) {
    if ([self.tableView.delegate
            respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
      [self.tableView.delegate tableView:self.tableView
                 didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    }
  }
}

/** 获取当前AK  比较券商AK 大小 */
- (NSMutableArray *)getBrokerAKComparisonWithUsreAK:(RealTradeSecuritiesCompanyList *)company {

  if (self.brokerMutableArray.count != 0) {
    [self.brokerMutableArray removeAllObjects];
  }

  for (RealTradeSecuritiesCompany *com in company.result) {
    if (com.oldNewTypeLogin != 2) {
      //判断AK 不为Web端
      int isEnd = [self.userAK compare:com.ak options:NSCaseInsensitiveSearch];
      if (isEnd == NSOrderedDescending || isEnd == NSOrderedSame) {
        //要求 self.userAK > com.ak 的券商才能显示
        [self.brokerMutableArray addObject:com];
      }
    } else {
      // type == 2  为web端 都显示
      [self.brokerMutableArray addObject:com];
    }
  }
  return self.brokerMutableArray;
}

/** 更换券商显示位置 */
- (void)changeBrokerPosition:(NSString *)companyName {
  if (companyName && ![companyName isEqualToString:@""]) {
    for (int i = 0; i < self.brokerMutableArray.count; i++) {
      RealTradeSecuritiesCompany *company = self.brokerMutableArray[i];
      if ([companyName isEqualToString:company.name]) {
        //如果相同 交换位置
        self.brokerMutableArray[i] = self.brokerMutableArray[0];
        self.brokerMutableArray[0] = company;
        return;
      }
    }
  }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _stockListsArray.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"StockCompanyCell";
  StockCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] firstObject];
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
  }
  RealTradeSecuritiesCompany *company = _stockListsArray.array[indexPath.row];
  [cell.stockCompanyIcon setImageWithURL:[NSURL URLWithString:company.logo]
                        placeholderImage:[UIImage imageNamed:@"牛头"]];
  cell.stockCompanyName.text = company.name;
  return cell;
}
#pragma mark -  点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //记录选中的第几行
  selectedCellIndex = indexPath.row;
  //删选数据
  [self bindCompanyListToMainPageWithIndexPath:indexPath];
}

#pragma mark-- 对右侧开户或者登录页面进行数据绑定
- (void)bindCompanyListToMainPageWithIndexPath:(NSIndexPath *)indexPath {
  if (selectedCellIndex == -1) {
    return;
  }
  //得到 那个Cell 对于的券商数据
  RealTradeSecuritiesCompany *company = _stockListsArray.array[selectedCellIndex];
  NSInteger typeNum = company.oldNewTypeLogin;
  self.oldLoginOrNewLogin = typeNum;
  switch (self.brokerStockOpenOrLogin) {
  case BrokerOpenAccount:
    if (self.brokerCompanyListBlock) {
      self.brokerCompanyListBlock(company, self.brokerStockOpenOrLogin, _secNoDic, self.brokerDownloadType);
    }
    break;
  case BrokerLoginStock:
    // 1 正常登陆
    if (typeNum == 1) {
      if (self.brokerCompanyListBlock) {
        self.brokerCompanyListBlock(company, self.brokerStockOpenOrLogin, _secNoDic, self.brokerDownloadType);
      }
    } else if (typeNum == 2) {
      // 2 web登陆交易
      NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
          kCFAllocatorDefault, (CFStringRef)company.url, NULL, NULL, kCFStringEncodingUTF8));
      NSString *title = [NSString stringWithFormat:@"%@交易", company.name];
      [SchollWebViewController startWithTitle:title
                                      withUrl:encodedString
                          withBrokerLogonBool:YES
                               withBrokerType:BrokerLoginStock];
      [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    break;
  }
}

@end
