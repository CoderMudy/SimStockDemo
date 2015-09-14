//
//  ClosedPositionView.m
//  SimuStock
//
//  Created by Mac on 15/8/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#define ButtonHeight 44.0 / 2

#define ButtonWidth 125.0 / 2

#define GapBetweenBtn (WIDTH_OF_SCREEN - 40 - 250) / 3

#import "UIImage+ColorTransformToImage.h"

#import "ClosedPositionView.h"

@implementation ClosedPositionView

- (id)initWithUserId:(NSString *)uid withMatchId:(NSString *)matchId withFrame:(CGRect)frame {
  if (self = [super init]) {
    self.frame = frame;
    self.matchId = matchId;
    self.uid = uid;
    self.clipsToBounds = YES;
    isHidden = YES;

    _infoView = [[UIView alloc] init];
    [self addSubview:_infoView];
    [self createInfoLabels];
  }
  return self;
}

static NSInteger RowNum = 6;

- (void)createInfoLabels {
  self.positionRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 200, 18, 184, 16)];
  self.positionRateLabel.textAlignment = NSTextAlignmentRight;
  self.positionRateLabel.font = [UIFont systemFontOfSize:15];
  self.positionRateLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  self.positionRateLabel.backgroundColor = [UIColor clearColor];
  [_infoView addSubview:self.positionRateLabel];

  for (int i = 0; i < RowNum; ++i) {
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(28, 15 + i * 25, 90, 19)];
    if (i == 0)
      Label.hidden = YES;
    if (i == 2)
      Label.hidden = NO;
    Label.textAlignment = NSTextAlignmentRight;
    Label.font = [UIFont systemFontOfSize:Font_Height_16_0];
    Label.textColor = [Globle colorFromHexRGB:Color_Gray];
    Label.tag = 20 + i;
    Label.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:Label];

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 15 + i * 25, 180, 19)];
    if (i == 0) {
      infoLabel.frame = CGRectMake(35, 15 + i * 25, 200, 19);
    }
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    infoLabel.tag = 10 + i;
    infoLabel.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:infoLabel];
  }
  //左边的弧形条
  _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 14, 12, self.bounds.size.height - 26)];
  _lineView.clipsToBounds = YES;
  [_infoView addSubview:_lineView];
  CALayer *userLayer = _lineView.layer;
  [userLayer setCornerRadius:6.0];
  userLayer.borderWidth = 1;

  //三角标
  _triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"展开小三角"]];
  _triangleImage.frame = CGRectMake(self.frame.size.width - 7.0 / 2 - 27.0 / 2,
                                    self.frame.size.height - 27.0 / 2, 27.0 / 2, 27.0 / 2);
  [_infoView addSubview:_triangleImage];

  //底边灰线。细
  _uplineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE * 2,
                                               self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE)];
  _uplineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [_infoView addSubview:_uplineView];
  //下(分割线)
  _downlineView =
      [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE,
                                               self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE)];
  _downlineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [_infoView addSubview:_downlineView];
}
//创建底部四个按钮
- (void)createButton {
  _btnBuy = [self createButtonWithIndex:0 withTitle:@"买入"];
  _btnSell = [self createButtonWithIndex:1 withTitle:@"卖出"];
  _btnMarket = [self createButtonWithIndex:2 withTitle:@"行情"];
  _btnTradeDetails = [self createButtonWithIndex:3 withTitle:@"交易明细"];

  [_infoView addSubview:_btnBuy];
  [_infoView addSubview:_btnSell];
  [_infoView addSubview:_btnMarket];
  [_infoView addSubview:_btnTradeDetails];
  buttonArray = @[ _btnBuy, _btnSell, _btnMarket, _btnTradeDetails ];

  __weak ClosedPositionView *weakSelf = self;
  [_btnBuy setOnButtonPressedHandler:^{
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      ClosedPositionView *strongSelf = weakSelf;
      if (strongSelf) {
        [simuBuyViewController buyStockWithStockCode:strongSelf.closedPositionInfo.stockCode
                                       withStockName:strongSelf.closedPositionInfo.stockName
                                         withMatchId:strongSelf.matchId];
      }

    }];

  }];
  [_btnSell setOnButtonPressedHandler:^{
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      ClosedPositionView *strongSelf = weakSelf;
      if (strongSelf) {
        [simuSellViewController sellStockWithStockCode:strongSelf.closedPositionInfo.stockCode
                                         withStockName:strongSelf.closedPositionInfo.stockName
                                           withMatchId:strongSelf.matchId];
      }
    }];

  }];
  [_btnMarket setOnButtonPressedHandler:^{
    ClosedPositionView *strongSelf = weakSelf;
    if (strongSelf) {
      [TrendViewController showDetailWithStockCode:strongSelf.closedPositionInfo.stockCode
                                     withStockName:strongSelf.closedPositionInfo.stockName
                                     withFirstType:FIRST_TYPE_UNSPEC
                                       withMatchId:strongSelf.matchId];
    }

  }];
  [_btnTradeDetails setOnButtonPressedHandler:^{
    [weakSelf pushTradeDetails];
  }];
}
- (void)pushTradeDetails {
  //清仓
  TradeDetailView *view = [[TradeDetailView alloc] initWithUserId:self.uid
                                                      withMatchId:self.matchId
                                           withClosedPositionInfo:self.closedPositionInfo]; //
  [AppDelegate pushViewControllerFromRight:view];
}

- (UIButton *)createButtonWithIndex:(NSInteger)index withTitle:(NSString *)title {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(10 + index * (ButtonWidth + GapBetweenBtn), 0.0, ButtonWidth, ButtonHeight);
  button.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [button.layer setMasksToBounds:YES];
  button.layer.cornerRadius = 11.0f;
  [button.layer setBorderColor:[[Globle colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
  [button.layer setBorderWidth:0.5];                                               //描边粗细
  UIImage *InfoImageDown =
      [UIImage imageFromView:button withBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [button setBackgroundImage:InfoImageDown forState:UIControlStateHighlighted];
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
  [button setTitleColor:[Globle colorFromHexRGB:Color_White] forState:UIControlStateHighlighted];
  [button setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateDisabled];
  button.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  return button;
}

//设置清仓信息
- (void)setClosedPosition:(ClosedPositionInfo *)closedPositionInfo withFrame:(CGRect)rect {
  _closedPositionInfo = closedPositionInfo;

  self.frame = rect;
  _infoView.frame = rect;
  _infoView.hidden = NO;
  rightButton.hidden = NO;
  _lineView.frame = CGRectMake(7, 14, 12, self.bounds.size.height - 26);
  _triangleImage.frame = CGRectMake(self.bounds.size.width - 7.0 / 2 - 27.0 / 2,
                                    self.bounds.size.height - 27.0 / 2, 27.0 / 2, 27.0 / 2);

  rightButton.frame = CGRectMake(278, (self.frame.size.height - 32) / 2, 32, 32);
  _uplineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE * 2,
                                 self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  _downlineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE,
                                   self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  NSArray *array = @[
    @"股票名称：",
    @"盈亏金额：",
    @"建仓时间：",
    @"清仓时间：",
    @"持股时长：",
    @"交易次数：",
    @""
  ];
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:6];
  if (closedPositionInfo) {
    //名称和代码
    NSString *namecode =
        [NSString stringWithFormat:@"%@（%@）", closedPositionInfo.stockName, closedPositionInfo.stockCode];
    [mutableArray addObject:namecode];
    //盈亏和盈亏率
    NSString *profitAndRate =
        [NSString stringWithFormat:@"%@ (%@)", closedPositionInfo.profit, closedPositionInfo.profitRate];
    [mutableArray addObject:profitAndRate];
    //建仓时间
    [mutableArray addObject:closedPositionInfo.createAt];
    //清仓时间
    [mutableArray addObject:closedPositionInfo.closeAt];
    //持有天数
    NSString *position_Days = [NSString stringWithFormat:@"%@ 天", closedPositionInfo.totalDays];
    [mutableArray addObject:position_Days];
    //交易次数
    [mutableArray addObject:closedPositionInfo.tradeTimes];
    [mutableArray addObject:@""];

    self.positionRateLabel.text = @"";
    for (int i = 0; i < 7; ++i) {
      UILabel *label = (UILabel *)[self viewWithTag:20 + i];
      label.text = array[i];

      UILabel *infoLabel = (UILabel *)[self viewWithTag:10 + i];
      infoLabel.text = mutableArray[i];
      if (i == 1) {
        infoLabel.textColor = [StockUtil getColorByProfit:closedPositionInfo.profit];
      }
      if (i == 2) {
        infoLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
        if (rect.size.height > 90) {
          infoLabel.hidden = NO;
          label.hidden = NO;
        } else {
          infoLabel.hidden = YES;
          label.hidden = YES;
        }
      }
      if (i == 6) {
        infoLabel.hidden = YES;
        label.hidden = YES;
      }
    }
    if (closedPositionInfo.bProfit) {
      _lineView.layer.borderColor = [[Globle colorFromHexRGB:@"#ae1e20"] CGColor];
      [self drawGradientColor:0];
    } else {
      _lineView.layer.borderColor = [[Globle colorFromHexRGB:@"#077636"] CGColor];
      [self drawGradientColor:1];
    }
    //设定按钮位置
    for (int i = 0; i < 4; ++i) {
      UIButton *button = buttonArray[i];
      button.frame = CGRectMake(30 + i * (ButtonWidth + GapBetweenBtn), 169, ButtonWidth, ButtonHeight);
    }

    //设置卖出按钮状态
    int flag = -1;
    if ([SimuUtil isLogined]) {
      if ([SimuPositionPageData isStockSellable:closedPositionInfo.stockCode])
        flag = 0;
      else
        flag = -1;
    }
    [self setSellButtonEnable:flag];
  }
}

//设置卖出按钮状态
- (void)setSellButtonEnable:(NSInteger)flag {
  if (_btnSell) {
    if (flag == 0) {
      [_btnSell.layer setBorderColor:[[Globle colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
      _btnSell.enabled = YES;
    } else {
      [_btnSell.layer setBorderColor:[[Globle colorFromHexRGB:Color_Gray] CGColor]]; //描边颜色
      _btnSell.enabled = NO;
    }
  }
}

//展开或收缩清仓页面
- (void)present:(CGFloat)height {

  isHidden = height < self.frame.size.height;

  if (!isHidden) {
    UILabel *label = (UILabel *)[self viewWithTag:22];
    UILabel *infoLabel = (UILabel *)[self viewWithTag:12];
    label.hidden = NO;
    infoLabel.hidden = NO;
  }

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(stop)];

  if (height > self.frame.size.height) {
    _triangleImage.hidden = YES;
  } else {
    _triangleImage.hidden = NO;
  }
  self.frame = CGRectMake(0, 0, self.frame.size.width, height);
  _infoView.frame = self.frame;
  _lineView.frame = CGRectMake(7, 14, 12, height - 26);

  _uplineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE * 2,
                                 self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  _downlineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE,
                                   self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  rightButton.frame = CGRectMake(278, (height - 32) / 2, 32, 32);
  [UIView commitAnimations];
}
//展开或收缩持仓页面
- (void)presentForPosition:(CGFloat)height {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(stop)];
  if (height > self.frame.size.height) {
    _triangleImage.hidden = YES;
    isHidden = NO;
    UILabel *label = (UILabel *)[self viewWithTag:22];
    UILabel *infoLabel = (UILabel *)[self viewWithTag:12];
    label.hidden = NO;
    infoLabel.hidden = NO;
  } else {
    _triangleImage.hidden = NO;
    isHidden = NO;
  }
  self.frame = CGRectMake(0, 0, self.frame.size.width, height);
  _infoView.frame = self.frame;
  _lineView.frame = CGRectMake(7, 14, 12, height - 26);
  _triangleImage.frame = CGRectMake(self.bounds.size.width - 7.0 / 2 - 27.0 / 2,
                                    self.bounds.size.height - 27.0 / 2, 27.0 / 2, 27.0 / 2);
  _uplineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE * 2,
                                 self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  _downlineView.frame = CGRectMake(0, self.bounds.size.height - HEIGHT_OF_BOTTOM_LINE,
                                   self.bounds.size.width, HEIGHT_OF_BOTTOM_LINE);
  rightButton.frame = CGRectMake(278, (height - 32) / 2, 32, 32);
  [UIView commitAnimations];
}

- (void)stop {
  if (isHidden) {
    dispatch_async(dispatch_get_main_queue(), ^{
      UILabel *label = (UILabel *)[self viewWithTag:22];
      UILabel *infoLabel = (UILabel *)[self viewWithTag:12];
      label.hidden = YES;
      infoLabel.hidden = YES;
    });
  }
}
//绘制渐变色
- (void)drawGradientColor:(NSInteger)colorType {
  UIGraphicsBeginImageContext(_lineView.frame.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGFloat colors[2][8] = {
      {195.0 / 255.0, 34.0 / 255.0, 36.0 / 255.0, 1, 219.0 / 255.0, 26.0 / 255.0, 27.0 / 255.0, 1},
      {8.0 / 255.0, 133.0 / 255.0, 61.0 / 255.0, 1, 9.0 / 255.0, 149.0 / 255.0, 68.0 / 255.0, 1}};
  CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors[colorType], NULL, 2);
  CGColorSpaceRelease(rgb);
  CGContextDrawLinearGradient(context, gradient, CGPointMake(0, _lineView.frame.size.height),
                              CGPointMake(0, 0), kCGGradientDrawsAfterEndLocation);
  _lineView.image = UIGraphicsGetImageFromCurrentImageContext();
  CGGradientRelease(gradient);
}

@end

@implementation ClosedPositionCell

@end
