//
//  RealTradeSpecialTradeViewController.m
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RTSpecialTradeVC.h"
#import "BaseRequester.h"
#import "SchollWebViewController.h"
#import "NetLoadingWaitView.h"

@implementation RTSpecialTradeVC

- (void)viewDidLoad {
  [super viewDidLoad];

  //添加标题
  [_topToolBar resetContentAndFlage:@"指定交易" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.frame =
      CGRectMake(_topToolBar.bounds.size.width - 80, _topToolBar.bounds.size.height - 45, 40, 45);
  _indicatorView.butonIsVisible = NO;
  [self createTradeRuleButton];

  self.viewContainer = [[RTSpecialTradeViewHolder alloc] initWithParentView:self.clientView];
  [self.viewContainer.btnSpecialTrade addTarget:self
                                         action:@selector(fireDoSpecialTrade)
                               forControlEvents:UIControlEventTouchUpInside];
  [self.viewContainer hideUIs:YES];
  //取得页面初始化需要的信息
  [self performSelector:@selector(loadSpecialTrade) withObject:nil afterDelay:0.1];

  [_littleCattleView setInformation:@"暂无交易信息"];
}

//创建交易规则按钮
- (void)createTradeRuleButton {

  //获取到导航条指针
  _btnTradeRule = [UIButton buttonWithType:UIButtonTypeCustom];
  _btnTradeRule.frame =
      CGRectMake(_topToolBar.bounds.size.width - 40, _topToolBar.bounds.size.height - 45, 40, 45);
  [_btnTradeRule setImage:[UIImage imageNamed:@"交易规则图标"] forState:UIControlStateNormal];
  [_btnTradeRule setImage:[UIImage imageNamed:@"交易规则图标"] forState:UIControlStateHighlighted];
  [_btnTradeRule setBackgroundImage:[UIImage imageNamed:@"导航按钮按下态效果.png"]
                           forState:UIControlStateHighlighted];
  [_btnTradeRule addTarget:self
                    action:@selector(rulesButtonPress:)
          forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:_btnTradeRule];
}

- (void)refreshButtonPressDown {
  [self loadSpecialTrade];
}

- (void)rulesButtonPress:(UIButton *)btn {
  NSString *textUrl = @"http://www.youguu.com/opms/html/article/32/2014/0925/2611.html";
  [SchollWebViewController startWithTitle:@"指定交易" withUrl:textUrl];
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
  if (self.dataBinded) {
    _littleCattleView.hidden = YES;
  } else {
    [_littleCattleView isCry:YES];
  }
}

- (void)stopLoading {
  [_indicatorView stopAnimating];
}

- (void)loadSpecialTrade {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  __weak RTSpecialTradeVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    RTSpecialTradeVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    RTSpecialTradeVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindData:(RealTradeSpecifiedTransaction *)obj];
    }
  };

  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [RealTradeSpecifiedTransaction loadSpecifiedTransactionWithCallback:callback];
}

- (void)bindData:(RealTradeSpecifiedTransaction *)result {
  self.dataBinded = YES;
  _littleCattleView.hidden = YES;
  [self.viewContainer bindSpecifiedTransaction:result];
}

- (void)fireDoSpecialTrade {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                 message:@"确定要对该账户进行指定交易吗？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                       otherButtonTitles:@"确定", nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //确定
    [self requestSpecialTrade];
  } else {
    //取消
  }
}
- (void)requestSpecialTrade {

  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:@"设置指定交易成功"];
  };
  callback.onFailed = ^() {
    [NewShowLabel setMessageContent:@"设置指定交易失败"];
  };

  [RealTradeDoSpecifiedTransaction doSpecifiedTransactionWithCallback:callback];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

@implementation RTSpecialTradeViewHolder

- (instancetype)initWithParentView:(UIView *)rootView {
  self = [super init];
  int width = rootView.bounds.size.width;

  //添加指定交易信息
  int startHeight = 45 + 33;
  int labelWidth = width - 64 * 2;
  _txtStockHolderCode = [[UILabel alloc] initWithFrame:CGRectMake(64, startHeight, labelWidth, 20)];
  [_txtStockHolderCode setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [_txtStockHolderCode setFont:[UIFont systemFontOfSize:18.0]];
  [_txtStockHolderCode setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
  _txtStockHolderCode.backgroundColor = [UIColor clearColor];
  _txtStockHolderCode.text = @"股东代码";
  [rootView addSubview:_txtStockHolderCode];

  startHeight = startHeight + 20 + 10;
  _txtStockHolderName = [[UILabel alloc] initWithFrame:CGRectMake(64, startHeight, labelWidth, 20)];
  [_txtStockHolderName setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [_txtStockHolderName setFont:[UIFont systemFontOfSize:18.0]];
  [_txtStockHolderName setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
  _txtStockHolderName.text = @"股东姓名";
  _txtStockHolderName.backgroundColor = [UIColor clearColor];
  [rootView addSubview:_txtStockHolderName];

  startHeight = startHeight + 20 + 10;
  _txtMarketType = [[UILabel alloc] initWithFrame:CGRectMake(64, startHeight, labelWidth, 20)];
  [_txtMarketType setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [_txtMarketType setFont:[UIFont systemFontOfSize:18.0]];
  [_txtMarketType setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
  _txtMarketType.text = @"市场类别";
  _txtMarketType.backgroundColor = [UIColor clearColor];
  [rootView addSubview:_txtMarketType];

  startHeight = startHeight + 20 + 37;
  labelWidth = width - 60 * 2;
  _btnSpecialTrade = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  _btnSpecialTrade.frame = CGRectMake(60, startHeight, labelWidth, 39);
  [_btnSpecialTrade.layer setMasksToBounds:YES];
  _btnSpecialTrade.layer.cornerRadius = 39 / 2;
  [_btnSpecialTrade setNormalBGColor:[Globle colorFromHexRGB:@"31bce9"]];
  [_btnSpecialTrade setHighlightBGColor:[Globle colorFromHexRGB:@"086dae"]];
  [_btnSpecialTrade buttonWithTitle:@"指定交易"
                 andNormaltextcolor:Color_White
           andHightlightedTextColor:Color_White];
  _btnSpecialTrade.titleLabel.font = [UIFont systemFontOfSize:Font_Height_21_0];
  _btnSpecialTrade.titleLabel.textAlignment = NSTextAlignmentCenter;
  _btnSpecialTrade.enabled = NO;
  [rootView addSubview:_btnSpecialTrade];

  return self;
}

- (void)hideUIs:(BOOL)hidden {
  _txtStockHolderCode.hidden = hidden;
  _txtStockHolderName.hidden = hidden;
  _txtMarketType.hidden = hidden;
  _btnSpecialTrade.hidden = hidden;
}

- (void)bindSpecifiedTransaction:(RealTradeSpecifiedTransaction *)result {
  [self hideUIs:NO];
  _txtStockHolderCode.text = [NSString stringWithFormat:@"股东代码: %@", result.stockholderCode];
  _txtStockHolderName.text = [NSString stringWithFormat:@"股东名称: %@", result.stockholderName];
  _txtMarketType.text = [NSString stringWithFormat:@"市场类别: %@", result.marketType];
  _btnSpecialTrade.enabled = YES;
}

@end
