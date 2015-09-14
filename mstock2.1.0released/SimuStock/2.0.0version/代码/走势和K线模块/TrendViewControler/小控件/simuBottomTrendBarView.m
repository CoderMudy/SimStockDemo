//
//  simuBottomTrendBarView.m
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuBottomTrendBarView.h"
#import "simuBuyViewController.h"
#import "SimuPositionPageData.h"
#import "StockPriceRemindClientVC.h"
#import "StockAlarmList.h"

#import "YLImageToTitleButton.h"
#import "PortfolioStockModel.h"

@implementation MarketBottomButtonInfo

- (id)initWithTitle:(NSString *)titleName
    withNormalImage:(NSString *)notSellectedImageName
 withHighlightImage:(NSString *)sellectedImageName {
  if (self = [super init]) {
    self.titleName = titleName;
    self.notSellectedImageName = notSellectedImageName;
    self.sellectedImageName = sellectedImageName;
  }
  return self;
}

@end

@implementation simuBottomTrendBarView {
  NSMutableDictionary *allButtons;
}

///实盘看行情没有买入/卖出
- (id)initWithFrame:(CGRect)frame
        withMatchId:(NSString *)matchId
      withFirstType:(NSString *)firstType
          andisFirm:(BOOL)isfirm {
  if (self = [super initWithFrame:frame]) {
    self.matchId = matchId;
    [self initAllButtons];

    self.backgroundColor = [UIColor whiteColor];
    self.isFirm = isfirm;
    self.firstType = firstType;
  }
  return self;
}

- (void)initAllButtons {
  allButtons = [[NSMutableDictionary alloc] init];
  allButtons[@(MarketBottomButtonType_Buy)] =
      [[MarketBottomButtonInfo alloc] initWithTitle:@"买入"
                                    withNormalImage:@"买入_up"
                                 withHighlightImage:@"买入_down"];
  allButtons[@(MarketBottomButtonType_Sell)] =
      [[MarketBottomButtonInfo alloc] initWithTitle:@"卖出"
                                    withNormalImage:@"卖出_up"
                                 withHighlightImage:@"卖出_down"];
  allButtons[@(MarketBottomButtonType_AddPortfolio)] =
      [[MarketBottomButtonInfo alloc] initWithTitle:@"添加自选"
                                    withNormalImage:@"添加自选"
                                 withHighlightImage:@"添加自选_down"];
  allButtons[@(MarketBottomButtonType_Weibo)] =
      [[MarketBottomButtonInfo alloc] initWithTitle:@"聊股"
                                    withNormalImage:@"聊股_UP"
                                 withHighlightImage:@"聊股_down"];
  allButtons[@(MarketBottomButtonType_Alarm)] = [[MarketBottomButtonInfo alloc]
           initWithTitle:@"提醒"
         withNormalImage:@"提醒小图标02"
      withHighlightImage:@"提醒他小图标_down02"];
}

#pragma mark
#pragma mark 按钮点击相应
//左右切换按钮相应
- (void)changeStock:(UIButton *)button {
  if (button.tag == 1001) {
    //向左切换股票
    [self.delegate leftPressDown];
  } else if (button.tag == 1004) {
    //向右切换股票
    [self.delegate rightPressDown];
  }
}

- (void)onButtonPortfolioPressed {
  //增删自选股
  BOOL isselfstock =
      [PortfolioStockManager isPortfolioStock:self.delegate.stockCode];
  if (isselfstock) {
    StockAlarmList *alarmList =
        [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];

    if ([alarmList isSelfStockAlarm:self.delegate.stockCode]) {
      UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@"温馨提示"
                    message:@"将" @"会" @"在"
                    @"所有自选股列表中删除该股票，同时"
                    @"删除" @"该股票" @"的提醒，确认删除？"
                   delegate:self
          cancelButtonTitle:@"取消"
          otherButtonTitles:@"确定", nil];
      [alertView show];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@"温馨提示"
                    message:@"将" @"会" @"在所有自选股列表中删除"
                    @"该股票，确认删除？"
                   delegate:self
          cancelButtonTitle:@"取消"
          otherButtonTitles:@"确定", nil];
      [alertView show];
    }
  } else {
    //当前股票非自选股，需要加入为自选股
    [PortfolioStockManager
        setPortfolioStock:self.delegate.stockCode
                onSuccess:^{
                  [NewShowLabel setMessageContent:@"已添加自选股"];
                  [self resetSelfStockState:NO];
                }];
  }
}

//点击中间按钮
- (void)buttonpressdown:(YLImageToTitleButton *)button {
  MarketBottomButtonType type = button.tag - 2000;
  switch (type) {
  case MarketBottomButtonType_Buy: {
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          //买入
          [simuBuyViewController buyStockWithStockCode:self.delegate.stockCode
                                         withStockName:self.delegate.stockName
                                           withMatchId:@"1"];
        }];
  } break;
  case MarketBottomButtonType_Sell: {
    //卖出
    //是否持仓
    if ([SimuPositionPageData isStockSellable:self.delegate.stockCode]) {
      [simuSellViewController sellStockWithStockCode:self.delegate.stockCode
                                       withStockName:self.delegate.stockName
                                         withMatchId:@"1"];
    } else {
      //未持仓
      [NewShowLabel setMessageContent:@"您未持有该股票"];
    }
  } break;
  case MarketBottomButtonType_AddPortfolio: {
    [self onButtonPortfolioPressed];
  } break;
  case MarketBottomButtonType_Weibo: {
    ///发布聊股
    if ([_delegate respondsToSelector:@selector(distributeVC)]) {
      [self.delegate distributeVC];
    }
  } break;
  case MarketBottomButtonType_Alarm: {
    StockAlarmList *alarmList =
        [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    //判断是否设置估价预警
    [alarmList isSelfStockAlarm:self.delegate.stockCode]
        ? [self resetSelfStockAlarmState:YES]
        : [self resetSelfStockAlarmState:NO];

    ///股价提醒
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          [StockPriceRemindClientVC
              stockRemindVCWithStockCode:self.delegate.stockCode
                           withStockName:self.delegate.stockName
                           withFirstType:self.delegate.firstType
                             withMatchId:@"1"];
        }];
  } break;
  default:
    break;
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //当前股票是自选股，需要删除
    StockAlarmList *alarmList =
        [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    //删除股票预警信息
    if ([alarmList isSelfStockAlarm:self.delegate.stockCode]) {
      [alarmList deleteSelfStockAlarm:self.delegate.stockCode];
      [self emptyStockRules:self.delegate.stockCode];
    }
    //删除自选股
    [PortfolioStockManager removePortfolioStock:self.delegate.stockCode
                                   withGroupIds:@[ GROUP_ALL_ID ]];
    [PortfolioStockManager synchronizePortfolioStock];

    [self resetSelfStockState:YES andSelfStockAlarmState:NO];
    [NewShowLabel setMessageContent:@"已删除自选股"];
  }
}

///清空某只股票所有规则接口
- (void)emptyStockRules:(NSString *)stockCode {
  if (![SimuUtil isLogined]) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    StockAlarmList *alarmList =
        [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];
    [alarmList deleteSelfStockAlarm:stockCode];
  };
  callback.onFailed = ^{
    NSLog(@"股价预警删除失败。。。。");
  };

  [EmptyStockAlarmRules requestEmptyStockRulesWithUid:[SimuUtil getUserID]
                                    withStockCodeLong:stockCode
                                         withCallback:callback];
}

//重新设置自选股状态
- (void)resetSelfStockState:(BOOL)isAddState {
  YLImageToTitleButton *button =
      [self findButtonByType:MarketBottomButtonType_AddPortfolio];
  if (isAddState) {
    button.imageBut.image = [UIImage imageNamed:@"添加自选"];
    //设定状态未增加自选股
    button.lblTitle.text = @"添加自选";
    button.lblTitle.textColor = [Globle colorFromHexRGB:@"#444444"];
  } else {
    button.imageBut.image = [UIImage imageNamed:@"添加自选_down"];
    //设定状态未删除自选股
    button.lblTitle.text = @"删除自选";
  }

  return;
}

//重新设置预警状态
- (void)resetSelfStockAlarmState:(BOOL)isAlarmState {
  YLImageToTitleButton *button =
      [self findButtonByType:MarketBottomButtonType_Alarm];
  if (isAlarmState) {
    button.imageBut.image =
        [UIImage imageNamed:@"提醒他小图标_" @"do" @"w" @"n" @"0" @"2"];
  } else {
    button.imageBut.image = [UIImage imageNamed:@"提醒小图标02"];
  }
}

- (YLImageToTitleButton *)findButtonByType:(MarketBottomButtonType)type {
  return (YLImageToTitleButton *)[self viewWithTag:(2000 + type)];
}

//重新设定增删自选股状态和股价预警状态
- (void)resetSelfStockState:(BOOL)isAddState
     andSelfStockAlarmState:(BOOL)isAlarm {
  [self resetSelfStockState:isAddState];
  [self resetSelfStockAlarmState:isAlarm];
}

//重新设定左右按钮
- (void)resetLOrRButton:(BOOL)leftstate RightButton:(BOOL)rightstate {
  if (leftstate) {
    [leftButton setEnabled:YES];
    leftButton.hidden = NO;
  } else {
    [leftButton setEnabled:NO];
    leftButton.hidden = YES;
  }

  if (rightstate) {
    [rightButton setEnabled:YES];
    rightButton.hidden = NO;
  } else {
    [rightButton setEnabled:NO];
    rightButton.hidden = YES;
  }
}

- (void)setAllButtonArray {

  [self removeAllSubviews];

  float leftbuttonWidth = 30.0f;
  // toolBar顶端一像素的线
  UIView *toolBarTopLineView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  toolBarTopLineView.backgroundColor = [Globle colorFromHexRGB:@"#000000"];
  toolBarTopLineView.alpha = 0.08;
  [self addSubview:toolBarTopLineView];
  //创建左边切换股票按钮牛
  leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  leftButton.frame = CGRectMake(0, 0, leftbuttonWidth, self.bounds.size.height);
  [leftButton setBackgroundColor:[UIColor clearColor]];
  [leftButton setImage:[UIImage imageNamed:@"左箭头_trend"]
              forState:UIControlStateNormal];
  [leftButton setImage:[UIImage imageNamed:@"左箭头_down"]
              forState:UIControlStateHighlighted];
  [leftButton addTarget:self
                 action:@selector(changeStock:)
       forControlEvents:UIControlEventTouchUpInside];
  leftButton.tag = 1001;
  [self addSubview:leftButton];
  //创建右边切换按钮
  rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightButton.frame = CGRectMake(self.bounds.size.width - leftbuttonWidth, 0,
                                 leftbuttonWidth, self.bounds.size.height);
  [rightButton setBackgroundColor:[UIColor clearColor]];
  [rightButton setImage:[UIImage imageNamed:@"右箭头_trend"]
               forState:UIControlStateNormal];
  [rightButton setImage:[UIImage imageNamed:@"右箭头_down"]
               forState:UIControlStateHighlighted];
  [rightButton addTarget:self
                  action:@selector(changeStock:)
        forControlEvents:UIControlEventTouchUpInside];
  rightButton.tag = 1004;
  [self addSubview:rightButton];

  NSArray *btnTypeArray = @[
    @(MarketBottomButtonType_Buy),
    @(MarketBottomButtonType_Sell),
    @(MarketBottomButtonType_AddPortfolio),
    @(MarketBottomButtonType_Weibo),
    @(MarketBottomButtonType_Alarm)
  ];

  if ([StockUtil isMarketIndex:self.delegate.firstType]) {
    btnTypeArray = @[
      @(MarketBottomButtonType_AddPortfolio),
      @(MarketBottomButtonType_Alarm)
    ];

  } else if (self.isFirm) {
    btnTypeArray = @[
      @(MarketBottomButtonType_AddPortfolio),
      @(MarketBottomButtonType_Weibo),
      @(MarketBottomButtonType_Alarm)
    ];
  } else {
    if ([@"1" isEqualToString:_matchId]) { //模拟盘
      if ([SimuUtil isLogined]) {
        if (![SimuPositionPageData isStockSellable:self.delegate.stockCode]) {
          btnTypeArray = @[
            @(MarketBottomButtonType_Buy),
            @(MarketBottomButtonType_AddPortfolio),
            @(MarketBottomButtonType_Weibo),
            @(MarketBottomButtonType_Alarm)
          ];
        }
      } else {
        btnTypeArray = @[
          @(MarketBottomButtonType_Buy),
          @(MarketBottomButtonType_AddPortfolio),
          @(MarketBottomButtonType_Weibo),
          @(MarketBottomButtonType_Alarm)
        ];
      }
    } else { //非模拟盘不显示买卖按钮
      btnTypeArray = @[
        @(MarketBottomButtonType_AddPortfolio),
        @(MarketBottomButtonType_Weibo),
        @(MarketBottomButtonType_Alarm)
      ];
    }
  }

  CGFloat otherbuttonWidth =
      (self.bounds.size.width - 2 * 30) / [btnTypeArray count];

  [btnTypeArray enumerateObjectsUsingBlock:^(NSNumber *btnType, NSUInteger idx,
                                             BOOL *stop) {
    MarketBottomButtonInfo *simubtninfo = allButtons[btnType];

    YLImageToTitleButton *button = [[YLImageToTitleButton alloc]
        initWithFrame:CGRectMake(30 + otherbuttonWidth * idx, 0,
                                 otherbuttonWidth, self.bounds.size.height)
          andImageAry:@[
            simubtninfo.notSellectedImageName,
            simubtninfo.sellectedImageName
          ]
          andTitleAry:simubtninfo.titleName];
    button.tag = 2000 + [btnType integerValue];
    [button addTarget:self action:@selector(buttonpressdown:)];
    [self addSubview:button];
  }];

  //设定自选股状态
  //是自选股，需要设定未删除自选股
  StockAlarmList *alarmList =
      [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];

  [self resetSelfStockState:![PortfolioStockManager
                                isPortfolioStock:self.delegate.stockCode]
      andSelfStockAlarmState:[alarmList
                                 isSelfStockAlarm:self.delegate.stockCode]];
}

@end
