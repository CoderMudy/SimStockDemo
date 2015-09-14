//
//  StockPriceRemindClientVC.m
//  SimuStock
//
//  Created by jhss on 15-3-17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceRemindClientVC.h"
#import "StockUtil.h"
#import "StockAlarmList.h"
#import "TaskIdUtil.h"
#import "DoTaskStatic.h"
#import "PortfolioStockModel.h"

@interface StockPriceRemindClientVC () {
  ///字典： 规则类型 --> 输入框
  NSDictionary *ruleType2TextFieldMap;

  ///字典： 规则类型 --> 滑块开关
  NSDictionary *ruleType2SwitchMap;
}

@end

@implementation StockPriceRemindClientVC

- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
          withFirstType:(NSString *)firstType
            withMatchId:(NSString *)matchId {
  self = [super init];
  if (self) {
    _stockCodeLong = stockCode;
    //股票代码统一显示为6位
    (stockCode.length == 8) ? (_stockCode = [stockCode substringFromIndex:2])
                            : (_stockCode = stockCode);
    _stockName = stockName;
    _matchId = matchId;
    _firstType = firstType;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //创建顶部topBar
  [self createTopBarView];
  
  //创建提醒设置CV
  [self createRemindSettingVC];
  
  //初始化控件
  [self initTextFieldAndSwitch];


  [self refreshButtonPressDown];
}

///创建顶部topBar
- (void)createTopBarView {
  [_topToolBar resetContentAndFlage:@"提醒设置" Mode:TTBM_Mode_Leveltwo];
  
  //重置菊花位置
  [self resetIndicatorView];
  //创建提交按钮
  [self createSubmitBtn];
}

///初始化控件
-(void)initTextFieldAndSwitch{
  ruleType2TextFieldMap = @{
                            @(SART_StockPriceUpperLimit) : stockPriceRemindVC.stockPriceUptoTextField,
                            @(SART_StockPriceLowerLimit) :
                              stockPriceRemindVC.stockPriceDropstoTextField,
                            @(SART_DailyGainsUpperLimit) : stockPriceRemindVC.dailyGainsTextField,
                            @(SART_DailyGainsLowerLimit) : stockPriceRemindVC.dailyDropsTextField,
                            };
  ruleType2SwitchMap = @{
                         @(SART_StockPriceUpperLimit) : stockPriceRemindVC.stockPriceUptoSwitch,
                         @(SART_StockPriceLowerLimit) : stockPriceRemindVC.stockPriceDowntoSwitch,
                         @(SART_DailyGainsUpperLimit) : stockPriceRemindVC.dailyGainsToSwitch,
                         @(SART_DailyGainsLowerLimit) : stockPriceRemindVC.dailyDropsToSwitch,
                         @(SART_ShotLineSpirit) : stockPriceRemindVC.shotSpiritSwitch
                         };
}

///创建✨提醒设置✨VC
- (void)createRemindSettingVC {
  if (!stockPriceRemindVC) {
    stockPriceRemindVC = [[StockPriceRemindViewController alloc]
                          initWithNibName:@"StockPriceRemindViewController"
                          bundle:nil];
  }
  stockPriceRemindVC.view.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
  self.clientView.clipsToBounds = YES;
  [self.clientView addSubview:stockPriceRemindVC.view];
}


- (void)refreshButtonPressDown {
  
  stockPriceRemindVC.firstType = _firstType;
  stockPriceRemindVC.stockCode = _stockCodeLong;
  
  stockPriceRemindVC.stockNameLabel.text = _stockName;
  stockPriceRemindVC.stockIDLabel.text = _stockCode;
  
  
  [stockPriceRemindVC changeElement];
  //请求个股行情数据
  [self showStockData:_stockCodeLong];
  //查询股票所有规则
  [self showStockPriceRemindData:_stockCodeLong];
}

///重置联网指示器位置
- (void)resetIndicatorView {
  _indicatorView.frame =
      CGRectMake(self.view.bounds.size.width - 95,
                 _topToolBar.bounds.size.height - 45, 40, 45);
}

///创建提交按钮
- (void)createSubmitBtn {
  UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  submitBtn.frame = CGRectMake(self.view.bounds.size.width - 60,
                               _topToolBar.bounds.size.height - 45, 60, 45);
  submitBtn.backgroundColor = [UIColor clearColor];
  [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:Font_Height_16_0]];
  [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
  [submitBtn setTitle:@"提交" forState:UIControlStateHighlighted];

  [submitBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                  forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *rightImage = [[UIImage imageNamed:@"return_touch_down"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [submitBtn setBackgroundImage:rightImage forState:UIControlStateHighlighted];

  //防止重复点击
  __weak StockPriceRemindClientVC *blockSelf = self;
  ButtonPressed buttonPressed = ^{
    StockPriceRemindClientVC *strongSelf = blockSelf;
    if (strongSelf) {
      [strongSelf submitButtonPress:submitBtn];
    }
  };
  [submitBtn setOnButtonPressedHandler:buttonPressed];
  [self.view addSubview:submitBtn];
}



///展示股价提醒四个约束数据
- (void)showStockPriceRemindData:(NSString *)stockCode {

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPriceRemindClientVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindStockPriceRuleOperation:(StockAlarmRuleList *)obj];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *error, NSException *exc) {
    [BaseRequester defaultErrorHandler](error, exc);
  };

  [StockAlarmRuleList
      requestStockRemindOperationRulesDataWithUid:[SimuUtil getUserID]
                                withStockCodeLong:stockCode
                                     withCallback:callback];
}

///清空某只股票所有规则接口
- (void)emptyStockRules:(NSString *)stockCode {

  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPriceRemindClientVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:@"此股票预警删除成功"];
      StockAlarmList *alarmList =
          [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
      [alarmList deleteSelfStockAlarm:stockCode];
      [super leftButtonPress];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *error, NSException *exc) {
    [BaseRequester defaultErrorHandler](error, exc);
  };

  [EmptyStockAlarmRules requestEmptyStockRulesWithUid:[SimuUtil getUserID]
                                    withStockCodeLong:stockCode
                                         withCallback:callback];
}

///展示股票行情数据
- (void)showStockData:(NSString *)stockCode {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StockPriceRemindClientVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StockPriceRemindClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuPositionPageData:(StockQuotationInfo *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [StockQuotationInfo getStockQuotaWithFivePriceInfo:stockCode
                                        withCallback:callback];
}

- (NSString *)getPriceFormat {
  return [StockUtil getPriceFormatWithFirstType:_firstType];
}

///绑定股价提醒设置规则
- (void)bindStockPriceRuleOperation:(StockAlarmRuleList *)obj {
  _stockPriceRemindData = obj;

  if (stockMarketInfo == nil) {
    return;
  }

  [obj.ruleType2RuleDictionary
      enumerateKeysAndObjectsUsingBlock:^(NSNumber *ruleType, StockAlarmRule *p,
                                          BOOL *stop) {
        //设置规则显示值
        UITextField *textField = ruleType2TextFieldMap[@(p.ruleType)];
        if (textField) {

          textField.text = [NSString
              stringWithFormat:self.getPriceFormat, [p.value floatValue]];
        }

        //设置滑块开关
        UISwitch *switchView = ruleType2SwitchMap[@(p.ruleType)];
        if (p.ruleType == SART_ShotLineSpirit) {
          [switchView setOn:YES animated:NO];
        } else {
          [switchView setOn:p.value ? YES : NO animated:YES];
        }
      }];
  [stockPriceRemindVC resetTextColorOfTextField];
}

///绑定股价提醒设置分页的当前股价，涨跌幅等数据
- (void)bindSimuPositionPageData:(StockQuotationInfo *)data {
  //个股信息
  PacketTableData *packetTable = nil;
  for (PacketTableData *obj in data.dataArray) {
    if ([obj.tableName isEqualToString:@"CurStatus"]) {
      packetTable = obj;
    }
  }
  if (nil == packetTable || [packetTable.tableItemDataArray count] == 0)
    return;

  stockMarketInfo = packetTable.tableItemDataArray[0];
  CGFloat newprice = [stockMarketInfo[@"curPrice"] floatValue];
  CGFloat closePrice = [stockMarketInfo[@"closePrice"] floatValue];
  NSString *curPrice = [NSString stringWithFormat:@"%.2f", newprice];

  UIColor *color;
  
  //查看是否停盘
  if ([stockMarketInfo[@"state"] shortValue] == 1) {
    color = [Globle colorFromHexRGB:Color_Text_Common];
  } else if ([@"0.00" isEqualToString:curPrice]) {
    color = [Globle colorFromHexRGB:Color_Text_Common];
  } else {
    color = [StockUtil getColorByFloat:(newprice - closePrice)];
  }

  CGFloat upDownPrice = [stockMarketInfo[@"changePer"] floatValue];

  stockPriceRemindVC.stockPriceChangeLabel.text =
      [NSString stringWithFormat:@"%0.2f%%", upDownPrice];
  stockPriceRemindVC.stockPriceChangeLabel.textColor = color;
  NSString *filterString = [NSString stringWithFormat:self.getPriceFormat, newprice];
  CGSize size = [SimuUtil labelContentSizeWithContent:filterString withFont:Font_Height_13_0 withSize:CGSizeMake(stockPriceRemindVC.latestPriceLabel.width, 999)];
  stockPriceRemindVC.latestPriceWidth.constant = size.width;
  stockPriceRemindVC.latestPriceLabel.width = size.width;
  //最新价
  stockPriceRemindVC.latestPriceLabel.text = filterString;
//  if (stockPriceRemindVC.latestPriceLabel.text.length >= 8) {
//    [stockPriceRemindVC resetLatestPriceLabelFrame];
//  }
  stockPriceRemindVC.latestPriceLabel.textColor = color;

  if ([stockPriceRemindVC.latestPriceLabel.text floatValue] == 0 &&
      stockPriceRemindVC.latestPriceLabel.text.length != 0) {
    [NewShowLabel setMessageContent:ALERT_STOCK_PRICE_ZERO];
  }

  if (_stockPriceRemindData) {
    [self bindStockPriceRuleOperation:_stockPriceRemindData];
  }
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
}

///✨提交✨按钮点击事件
- (void)submitButtonPress:(UIButton *)btn {

  //无网判断
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  //有网但是没有获取到最新价的情况下，提示"没有获取到行情数据，无法设置提醒"
  if (stockPriceRemindVC.latestPriceLabel.text.length == 0) {
    [NewShowLabel setMessageContent:ALERT_STOCK_NOT_GER_TREND_DATA];
    return;
  }

  //最新股价为0，不发POST网络请求
  if (![stockPriceRemindVC validateLatestPrice]) {
    [NewShowLabel setMessageContent:ALERT_STOCK_PRICE_ZERO];
    return;
  }

  [stockPriceRemindVC resetTextColorOfTextField];

  //光标没有移除的情况下，需要将最新价与输入的股价涨到/跌到作判断
  if (![stockPriceRemindVC validatePriceUpLimit]) {
    [stockPriceRemindVC.stockPriceUptoTextField becomeFirstResponder];
    [NewShowLabel setMessageContent:INPUT_ERROR_STOCK_PRICE];
    return;
  }
  if (![stockPriceRemindVC validatePriceDownLimit]) {
    [stockPriceRemindVC.stockPriceDropstoTextField becomeFirstResponder];
    [NewShowLabel setMessageContent:INPUT_ERROR_STOCK_PRICE];
    return;
  }

  //涨幅跌幅不能输入小数点且不能为0
  if (![stockPriceRemindVC validateDailyGain]) {
    [stockPriceRemindVC.dailyGainsTextField becomeFirstResponder];
    [NewShowLabel setMessageContent:INPUT_ERROR_STOCK_PRICE];
    return;
  }
  if (![stockPriceRemindVC validateDailyDrop]) {
    [stockPriceRemindVC.dailyDropsTextField becomeFirstResponder];
    [NewShowLabel setMessageContent:INPUT_ERROR_STOCK_PRICE];
    return;
  }

  //短线精灵是否设置
  StockAlarmRuleList *rule =
      _stockPriceRemindData.ruleType2RuleDictionary[@(SART_ShotLineSpirit)];
  BOOL _notSettingShotSpirit =
      (rule && stockPriceRemindVC.shotSpiritSwitch.on) ||
      (rule == nil && !stockPriceRemindVC.shotSpiritSwitch.on);
  __block BOOL hasChanges = NO;

  [ruleType2TextFieldMap
      enumerateKeysAndObjectsUsingBlock:^(NSNumber *ruleType,
                                          UITextField *textFild, BOOL *stop) {
        StockAlarmRule *ruleOnServer =
            _stockPriceRemindData.ruleType2RuleDictionary[ruleType];
        UISwitch *switchView = ruleType2SwitchMap[ruleType];
        if (ruleOnServer) {
          if (switchView.on) {
            hasChanges =
                ![self isString:textFild.text equal2String:ruleOnServer.value];
          } else {
            hasChanges = YES;
          }
        } else {
          if (switchView.on) {
            hasChanges = YES;
          } else {
            hasChanges = NO;
          }
        }
        if (hasChanges) {
          *stop = YES;
        }
      }];

  //如果网络请求下来的四条数据与最后提交的数据一致则直接接返回到上一级页面
  if (!hasChanges && _notSettingShotSpirit) {
    //返回个股行情页面
    [super leftButtonPress];
    return;
  }

  if (!stockPriceRemindVC.stockPriceUptoSwitch.on &&
      !stockPriceRemindVC.stockPriceDowntoSwitch.on &&
      !stockPriceRemindVC.dailyGainsToSwitch.on &&
      !stockPriceRemindVC.dailyDropsToSwitch.on &&
      !stockPriceRemindVC.shotSpiritSwitch.on) {

    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"温馨提示"
                  message:@"确定要删除该股票预警吗？"
                 delegate:self
        cancelButtonTitle:@"取消"
        otherButtonTitles:@"确定", nil];
    [alertView show];
    return;
  }

  [self saveStockPriceRemind:_stockCodeLong];

  ///判断是否为自选股，如果不是则加入自选股
  if (![PortfolioStockManager isPortfolioStock:_stockCodeLong]) {
    [PortfolioStockManager setPortfolioStock:_stockCodeLong
                                  inGroupIds:@[ GROUP_ALL_ID ]];
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self emptyStockRules:_stockCodeLong];
  }
}

- (BOOL)isString:(NSString *)str1 equal2String:(NSString *)str2 {
  NSString *formatStr1;
  if (str1 == nil) {
    formatStr1 = @"-1";
  } else {
    formatStr1 = [NSString stringWithFormat:@"%.2f", [str1 floatValue]];
  }

  NSString *formatStr2;
  if (str2 == nil) {
    formatStr2 = @"-1";
  } else {
    formatStr2 = [NSString stringWithFormat:@"%.2f", [str2 floatValue]];
  }
  return [formatStr1 isEqualToString:formatStr2];
}

///保存股价提醒四个约束
- (void)saveStockPriceRemind:(NSString *)stockCode {

  NSMutableArray *ruleArray =
      [[NSMutableArray alloc] init]; //[@{} mutableCopy];

  [ruleType2SwitchMap enumerateKeysAndObjectsUsingBlock:^(NSNumber *ruleType,
                                                          UISwitch *switchView,
                                                          BOOL *stop) {
    UITextField *textField = ruleType2TextFieldMap[ruleType];
    StockAlarmRule *ruleOnServer =
        _stockPriceRemindData.ruleType2RuleDictionary[ruleType];

    NSString *operation;
    NSString *ruleId = @"0"; // default: 空，需要验证增加规则时，ruleId =?
    if (ruleOnServer) {
      if (switchView.on) {
        if (![self isString:textField.text equal2String:ruleOnServer.value]) {
          // modify
          operation = [@(SAR_ModifyOperation) stringValue];
          ruleId = ruleOnServer.ruleId;
        }
      } else {
        // deleted
        operation = [@(SAR_DeleteOperation) stringValue];
        ruleId = ruleOnServer.ruleId;
      }

    } else {
      if (switchView.on) {
        // add
        operation = [@(SAR_InsertOperation) stringValue];
      } else {
        // do nothing
      }
    }
    NSMutableDictionary *dicRules = [[NSMutableDictionary alloc] init];
    if (textField) {
      if (operation) {
        dicRules[@"operation"] = operation;
        dicRules[@"ruleId"] = ruleId;
        dicRules[@"ruleType"] = [ruleType stringValue];
        dicRules[@"value"] = textField.text;
        [ruleArray addObject:dicRules];
      }
    } else {
      if (operation) {
        dicRules[@"operation"] = operation;
        dicRules[@"ruleId"] = ruleId;
        dicRules[@"ruleType"] = [ruleType stringValue];
        dicRules[@"value"] = @"0";
        [ruleArray addObject:dicRules];
      }
    }

  }];

  NSDictionary *dic = @{
    @"userId" : [SimuUtil getUserID],
    @"stockCode" : stockCode,
    @"ruleOperations" : ruleArray
  };

  // dic to json string
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
  NSString *jsonStr = [[NSString alloc] initWithBytes:[jsonData bytes]
                                               length:[jsonData length]
                                             encoding:NSUTF8StringEncoding];

  NSDictionary *dic2 = @{ @"data" : jsonStr };

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    StockAlarmList *alarmList =
        [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    [alarmList addSelfStockAlarm:stockCode];
    if ([[SimuUtil getFirstSetStockAlarm] isEqualToString:@""]) {
      ///首次设置预警
      [DoTaskStatic doTaskWithTaskType:TASK_FIRST_ALARMED];
    } else {
      NSLog(@"首次设置股价预警任务已经完成！！！");
    }

    [NewShowLabel setMessageContent:ALERT_STOCK_PRICE_SET_SUCCESS];

    //返回个股行情页面
    [super leftButtonPress];
  };

  callback.onFailed = ^{
    NSLog(@"股价提醒设置失败");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *exc) {
    [BaseRequester defaultErrorHandler](error, exc);
  };

  NSString *url =
      [user_address stringByAppendingString:@"jhss/stockalarm/savestockrules"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic2
              withRequestObjectClass:[JsonRequestObject class]
             withHttpRequestCallBack:callback];
}

+ (void)stockRemindVCWithStockCode:(NSString *)stockCode
                     withStockName:(NSString *)stockName
                     withFirstType:(NSString *)firstType
                       withMatchId:(NSString *)matchId {
  NSLog(@"stockCode2:%@", stockCode);
  StockPriceRemindClientVC *stockRemindVC =
      [[StockPriceRemindClientVC alloc] initWithStockCode:stockCode
                                            withStockName:stockName
                                            withFirstType:firstType
                                              withMatchId:matchId];

  [AppDelegate pushViewControllerFromRight:stockRemindVC];
}

@end
