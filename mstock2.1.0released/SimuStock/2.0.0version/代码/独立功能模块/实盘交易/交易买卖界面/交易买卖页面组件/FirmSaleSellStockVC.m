//
//  FirmSaleSellStockVC.m
//  SimuStock
//
//  Created by Yuemeng on 14-9-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleSellStockVC.h"
#import "SimuUtil.h"

#import "FirmSaleSellStockCell.h"
#import "RealTradeRequester.h"

#import "WFDataSharingCenter.h"

#define HIGH_OF_LABEL 30.0
#define HIGH_OF_TABLEHEADERVIEW 25.0

@interface FirmSaleSellStockVC () <UITableViewDelegate, UITableViewDataSource> {
  //功能说明标题栏
  UILabel *_titleLabel;
  //可卖出的股票表格
  UITableView *_sellStockTableView;

  //标题头 股票名称 代码 可用股票
  UIView *_headView;

  //判断从哪个界面跳过来的
  BOOL _capitalFromView;
}
//请求返回的数据模型
@property(nonatomic, strong) PositionData *positonData;

@property(strong, nonatomic) DataArray *positonCapitalData;

@end

@implementation FirmSaleSellStockVC

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithCapital:(BOOL)capital {
  self = [super init];
  if (self) {
    _capitalFromView = capital;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.positonCapitalData = [[DataArray alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  [_topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  //记录下导航栏高度
  CGFloat topBarHeight = _topToolBar.bounds.size.height;
  //创建标题栏
  _titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width,
                               HIGH_OF_LABEL)];
  _titleLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _titleLabel.text = @"请选择要卖出的股票";
  _titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_titleLabel];

  //创建个标题头
  CGRect headFrame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 1,
                                CGRectGetWidth(self.view.bounds), 39);
  _headView = [[UIView alloc] initWithFrame:headFrame];
  _headView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  [self.view addSubview:_headView];
  CGFloat m_width = self.view.bounds.size.width / 3.0f;
  CGFloat m_height = 39;

  //创建标题里面的内容
  NSArray *array = @[ @"股票名称", @"盈亏率", @"可卖股数" ];
  for (int i = 0; i < array.count; i++) {
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake(m_width * i, 0, m_width, m_height)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:Font_Height_12_0];
    label.textColor = [UIColor blackColor];
    label.text = array[i];
    [_headView addSubview:label];

    //加线
    UIView *lineLeftView = [[UIView alloc]
        initWithFrame:CGRectMake(m_width * i - 2, 1, 1, m_height - 2)];
    lineLeftView.backgroundColor = [Globle colorFromHexRGB:@"#f2f3f6"];
    UIView *linerighttView = [[UIView alloc]
        initWithFrame:CGRectMake(m_width * i - 1, 1, 1, m_height - 2)];
    linerighttView.backgroundColor =
        [Globle colorFromHexRGB:Color_BG_Table_Title];
    [_headView addSubview:lineLeftView];
    [_headView addSubview:linerighttView];
  }

  //创建表格
  CGRect tableViewRect = CGRectMake(
      0, CGRectGetMaxY(_headView.frame), CGRectGetWidth(self.view.bounds),
      CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_headView.frame));

  _sellStockTableView =
      [[UITableView alloc] initWithFrame:tableViewRect
                                   style:UITableViewStylePlain];
  _sellStockTableView.delegate = self;
  _sellStockTableView.dataSource = self;
  _sellStockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _sellStockTableView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  [self.view addSubview:_sellStockTableView];
  [_indicatorView startAnimating];
  if (_capitalFromView == YES) {
    //网络请求 实盘
    [self getDataRequest];
  } else {
    //配资实盘 网络数据请求
    [self capitalFrimStockMarketDetails];
  }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  if (_capitalFromView == YES) {
    if (!self.positonData) {
      return 0;
    }
  } else {
    if (!self.positonCapitalData) {
      return 0;
    }
  }
  //删除掉可用股票数为0的数据
  if (_capitalFromView == YES) {
    if (self.positonData.resultArr.count == 0) {
      return 0;
    } else {
      return self.positonData.resultArr.count;
    }
  } else {
    if (self.positonCapitalData.array.count == 0) {
      return 0;
    } else {
      return self.positonCapitalData.array.count;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_capitalFromView == YES) {
    return (indexPath.row < _positonData.resultArr.count) ? HEIGHT_OF_SELL_CELL
                                                          : 0;
  } else {
    return (indexPath.row < _positonCapitalData.array.count)
               ? HEIGHT_OF_SELL_CELL
               : 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //自定义的cell
  static NSString *cellID = @"cellID";
  FirmSaleSellStockCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellID];
  if (!cell) {
    cell =
        [[FirmSaleSellStockCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }

  if (_capitalFromView) {
    // cell更新数据
    PositionResult *resultData = _positonData.resultArr[indexPath.row];
    [cell setCellData:resultData];
  } else {
    WFfirmStockListData *stockPositon =
        self.positonCapitalData.array[indexPath.row];
    [cell setCapitalData:stockPositon];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_capitalFromView == YES) {
    PositionResult *resultData = _positonData.resultArr[indexPath.row];
    _getStockCodeBlock(resultData);
  } else {
    WFfirmStockListData *stockPositon =
        self.positonCapitalData.array[indexPath.row];
    _getStockCodeBlock(stockPositon);
  }
  [self leftButtonPress];
}

#pragma mark - 网络请求
- (void)getDataRequest {

  if (![SimuUtil isExistNetwork]) {
    [self judgeNetWorkStatus];
    [_indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  __weak FirmSaleSellStockVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    FirmSaleSellStockVC *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      _littleCattleView.hidden = YES;
      return NO;
    } else {
      return YES;
    }
  };

  //请求成功
  callback.onSuccess = ^(NSObject *object) {
    self.positonData = (PositionData *)object;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray
        addObjectsFromArray:[self deleteUselessDataWithArray:self.positonData
                                                                 .resultArr]];
    [self.positonData.resultArr removeAllObjects];
    [self.positonData.resultArr addObjectsFromArray:tempArray];
    if ([self.positonData.resultArr count] == 0) {
      [_littleCattleView isCry:NO];
      [_littleCattleView setInformation:@"暂无可卖股票"];
      [self showLalbeOrHide:YES];
    } else {
      _littleCattleView.hidden = YES;
      [self showLalbeOrHide:NO];
    }
    [_sellStockTableView reloadData];
  };
  //请求失败
  callback.onFailed = ^() {
    //失败 弱网情况下
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    if (self.positonData.resultArr.count == 0) {
      [_littleCattleView isCry:NO];
      [self showLalbeOrHide:YES];
    } else {
      [_littleCattleView isCry:YES];
      [self showLalbeOrHide:YES];
    }
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getQueryuserstockPath];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[PositionData class]
               withHttpRequestCallBack:callback];
}

#pragma mark - 实盘配资卖出股票查询
- (void)capitalFrimStockMarketDetails {
  if (![SimuUtil isExistNetwork]) {
    [self judgeNetWorkStatus];
    [_indicatorView stopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FirmSaleSellStockVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    FirmSaleSellStockVC *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      _littleCattleView.hidden = YES;
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    GetStockFirmPositionDataAnalysis *stockFirmPositon =
        (GetStockFirmPositionDataAnalysis *)obj;
    self.positonCapitalData.dataBinded = YES;
    //如果数据源不为空 清空 加入新是数据
    if (self.positonCapitalData.array.count != 0) {
      [self.positonCapitalData.array removeAllObjects];
    }
    //对数据进行处理
    NSMutableArray *posCapitalData =
        [self deleteUselessDataWithArray:stockFirmPositon.stockListArray];
    [self.positonCapitalData.array addObjectsFromArray:posCapitalData];
    if (self.positonCapitalData.array.count == 0) {
      [_littleCattleView isCry:NO];
      [_littleCattleView setInformation:@"暂无可卖股票"];
      [self showLalbeOrHide:YES];
    } else {
      _littleCattleView.hidden = YES;
      [self showLalbeOrHide:NO];
      dispatch_async(dispatch_get_main_queue(), ^{
        //刷新tableview
        [_sellStockTableView reloadData];
      });
    }
  };
  callback.onFailed = ^() {
    //失败 弱网情况下
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    if (self.positonCapitalData.dataBinded) {
      if (self.positonCapitalData.array.count == 0) {
        [_littleCattleView isCry:NO];
        [self showLalbeOrHide:YES];
      }
    } else {
      [_littleCattleView isCry:YES];
      [self showLalbeOrHide:YES];
    }
  };
  NSString *hsUserId = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount =
      [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineld = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSString *operatorNo = [WFDataSharingCenter shareDataCenter].operatorNo;

  //数据请求
  [GetStockFirmPositionData requestToSendGetDataWithHsUserId:hsUserId
                                         withHomsFundAccount:homsFundAccount
                                           withHomsCombineld:homsCombineld
                                              withOperatorNo:operatorNo
                                                withCallback:callback];
}

//对返回来的数据进行处理
- (NSMutableArray *)deleteUselessDataWithArray:(NSMutableArray *)mutableArray {
  if (_capitalFromView) {
    for (NSInteger i = 0; i < mutableArray.count; i++) {
      PositionResult *result = mutableArray[i];
      if (result.availableStock.integerValue <= 0) {
        [mutableArray removeObjectAtIndex:i];
        i--; //由于删除了当前元素，指针需要回退
      }
    }
  } else {
    //配资
    for (NSInteger i = 0; i < mutableArray.count; i++) {
      WFfirmStockListData *stockPositon = mutableArray[i];
      if (stockPositon.enableAmount.integerValue <= 0) {
        [mutableArray removeObjectAtIndex:i];
        i--;
      }
    }
  }
  return mutableArray;
}

//显示或者隐藏控件
- (void)showLalbeOrHide:(BOOL)showHide {
  _sellStockTableView.hidden = showHide;
}

//判断是否有网络
- (void)judgeNetWorkStatus {
  //无网
  [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  if (_capitalFromView) {
    if (self.positonData.resultArr.count != 0) {
      _littleCattleView.hidden = YES;
      [self showLalbeOrHide:NO];
    } else {
      [_littleCattleView isCry:YES];
      [self showLalbeOrHide:YES];
    }
  } else {
    //数据绑定 隐藏小牛
    if (!self.positonCapitalData.dataBinded) {
      [_littleCattleView isCry:YES];
      [self showLalbeOrHide:YES];
    } else {
      if (self.positonCapitalData.array.count == 0) {
        [_littleCattleView isCry:NO];
        [self showLalbeOrHide:YES];
      } else {
        _littleCattleView.hidden = YES;
        [self showLalbeOrHide:NO];
      }
    }
  }
}
//刷新按钮
- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  if (_capitalFromView) {
    //网络请求 实盘
    [self getDataRequest];
  } else {
    //配资实盘 网络数据请求
    [self capitalFrimStockMarketDetails];
  }
}

@end
