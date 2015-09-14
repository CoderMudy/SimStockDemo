//
//  PositionInfoView.m
//  SimuStock
//
//  Created by moulin wang on 14-2-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#define ButtonHeight 44.0 / 2

#define ButtonWidth 125.0 / 2

#define GapBetweenBtn (WIDTH_OF_SCREEN - 40 - 250) / 3

#import "PositionInfoView.h"
#import "UIImage+ColorTransformToImage.h"

@implementation PositionInfoView

- (id)initWithUserId:(NSString *)uid withMatchId:(NSString *)matchId withFrame:(CGRect)frame {
  if (self = [super init]) {
    self.frame = frame;
    self.matchId = matchId;
    self.uid = uid;
    self.clipsToBounds = YES;
    isHidden = YES;
    _infoView = [[UIView alloc] init];
    _lockView = [[UIView alloc] init];
    [self addSubview:_infoView];
    [self addSubview:_lockView];
    [self createInfoLabels];
    [self createLockLabels];
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

  __weak PositionInfoView *weakSelf = self;
  [_btnBuy setOnButtonPressedHandler:^{
    [weakSelf buyStock];
  }];
  [_btnSell setOnButtonPressedHandler:^{
    [weakSelf sellStock];
  }];
  [_btnMarket setOnButtonPressedHandler:^{
    PositionInfoView *strongSelf = weakSelf;
    if (strongSelf) {
      [TrendViewController showDetailWithStockCode:strongSelf.positionInfo.stockCode
                                     withStockName:strongSelf.positionInfo.stockName
                                     withFirstType:FIRST_TYPE_UNSPEC
                                       withMatchId:strongSelf.matchId];
    }

  }];
  [_btnTradeDetails setOnButtonPressedHandler:^{
    [weakSelf pushTradeDetails];
  }];
}
- (void)buyStock {
  if (self.buyStockAction) {
    self.buyStockAction(self.positionInfo.stockCode, self.positionInfo.stockName, self.matchId);
  } else {
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {

      [simuBuyViewController buyStockWithStockCode:self.positionInfo.stockCode
                                     withStockName:self.positionInfo.stockName
                                       withMatchId:self.matchId];

    }];
  }
}

- (void)sellStock {
  if (self.sellStockAction) {
    self.sellStockAction(self.positionInfo.stockCode, self.positionInfo.stockName, self.matchId);
  } else {
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {

      [simuSellViewController sellStockWithStockCode:self.positionInfo.stockCode
                                       withStockName:self.positionInfo.stockName
                                         withMatchId:self.matchId];

    }];
  }
}

- (void)pushTradeDetails {
  //持仓，交易明细
  TradeDetailView *view = [[TradeDetailView alloc] initWithUserId:self.uid
                                                      withMatchId:self.matchId
                                                 withPositionInfo:self.positionInfo];
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

//创建持仓不可见页面
- (void)createLockLabels {
  UILabel *Label1 = _positionNameLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 17, 70, 20)];
  Label1.text = @"持仓盈亏";
  Label1.backgroundColor = [UIColor clearColor];
  Label1.textAlignment = NSTextAlignmentLeft;
  Label1.textColor = [Globle colorFromHexRGB:Color_Gray];
  [_lockView addSubview:Label1];

  profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 17, 130, 20)];
  profitLabel.textAlignment = NSTextAlignmentLeft;
  profitLabel.backgroundColor = [UIColor clearColor];
  [_lockView addSubview:profitLabel];

  UILabel *Label2 = _valueNameLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 70, 20)];
  Label2.text = @"持仓市值";
  Label2.textAlignment = NSTextAlignmentLeft;
  Label2.backgroundColor = [UIColor clearColor];
  Label2.textColor = [Globle colorFromHexRGB:Color_Gray];
  [_lockView addSubview:Label2];

  valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 50, 130, 20)];
  valueLabel.textAlignment = NSTextAlignmentLeft;
  valueLabel.backgroundColor = [UIColor clearColor];
  valueLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  [_lockView addSubview:valueLabel];

  UIImageView *imageView = _lockimageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.5f, 6, 15, 20)];
  imageView.image = [UIImage imageNamed:@"Lock.png"];
  imageView.backgroundColor = [UIColor clearColor];

  UIView *loackView = _lockbackView = [[UIView alloc] initWithFrame:CGRectMake(60, 78, 32, 32)];
  loackView.layer.cornerRadius = 16.0f;
  [loackView.layer setMasksToBounds:YES];
  loackView.backgroundColor = [Globle colorFromHexRGB:@"#F86B6B"];
  [loackView addSubview:imageView];
  [_lockView addSubview:loackView];

  UILabel *Label3 = messageLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 85, 170, 20)];
  Label3.text = @"追踪该用户以查看持仓";
  Label3.textAlignment = NSTextAlignmentLeft;
  Label3.backgroundColor = [UIColor clearColor];
  Label3.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  [_lockView addSubview:Label3];
}
//设置持仓不可见信息
- (void)setLockProfit:(NSString *)profit AndValue:(NSString *)value withFrame:(CGRect)rect {
  self.frame = rect;
  _lockView.frame = rect;
  _infoView.hidden = YES;
  _lockView.hidden = NO;
  profitLabel.text = profit;
  profitLabel.textColor = [StockUtil getColorByProfit:profit];
  valueLabel.text = value;
}

//设置持仓追踪过期信息（信息全）
- (void)setLockProfitForTimeOut:(NSString *)profit
                       AndValue:(NSString *)value
                      withFrame:(CGRect)rect {
  self.frame = rect;

  messageLable.text = @"追踪已到期，请使用追踪卡继续追踪"; // 256px
  messageLable.font = [UIFont systemFontOfSize:Font_Height_16_0];

  CGFloat messageLength = messageLable.text.length * Font_Height_16_0;
  //间距根据字号和文字数量自动调整
  _lockbackView.frame = CGRectMake((self.bounds.size.width - 32 - messageLength) / 3, 78, 32, 32);
  messageLable.frame = CGRectMake(_lockbackView.frame.origin.x * 2 + _lockbackView.frame.size.width,
                                  85, messageLength, 16);

  [self setLockProfit:profit AndValue:value withFrame:rect];
}

//为个人中心设置持仓不可见信息（StockPositionViewForPCController类使用）
- (void)setLockProfitForPersonCenter:(NSString *)profit
                            AndValue:(NSString *)value
                           withFrame:(CGRect)rect {

  [self setLockProfit:profit AndValue:value withFrame:rect];

  _lockimageView.image = [UIImage imageNamed:@"小红锁.png"];
  _lockimageView.frame = CGRectMake(16, (rect.size.height - _lockimageView.bounds.size.height) / 2,
                                    _lockimageView.bounds.size.width, _lockimageView.bounds.size.height);
  [_lockView addSubview:_lockimageView];
  _lockbackView.hidden = YES;
  messageLable.frame = CGRectMake(_lockimageView.frame.origin.x + _lockimageView.frame.size.width + 5,
                                  _lockimageView.frame.origin.y + 3, 200, 16);
  profitLabel.hidden = YES;
  _positionNameLable.hidden = YES;
  _valueNameLable.hidden = YES;
  valueLabel.hidden = YES;
}

//设置持仓追踪过期信息（有问题）
- (void)setLockProfitForTimeOutForPersonCenter:(NSString *)profit
                                      AndValue:(NSString *)value
                                     withFrame:(CGRect)rect {

  [self setLockProfit:profit AndValue:value withFrame:rect];

  _lockimageView.image = [UIImage imageNamed:@"小红锁.png"];
  _lockimageView.frame = CGRectMake(16, (rect.size.height - _lockimageView.bounds.size.height) / 2,
                                    _lockimageView.bounds.size.width, _lockimageView.bounds.size.height);
  [_lockView addSubview:_lockimageView];
  _lockbackView.hidden = YES;
  messageLable.frame = CGRectMake(_lockimageView.frame.origin.x + _lockimageView.frame.size.width + 5,
                                  _lockimageView.frame.origin.y + 3, 200, 16);
  profitLabel.hidden = YES;
  _positionNameLable.hidden = YES;
  _valueNameLable.hidden = YES;
  valueLabel.hidden = YES;

  messageLable.text = @"追踪已到期,请购买追踪卡继续追踪.";
  messageLable.font = [UIFont systemFontOfSize:Font_Height_12_0];
}

//设置持仓可见信息
- (void)setPosition:(PositionInfo *)positionInfo
          withFrame:(CGRect)rect
      withTraceFlag:(NSInteger)canTrace {
  self.positionInfo = positionInfo;
  self.frame = rect;
  _infoView.frame = rect;
  _infoView.hidden = NO;
  _lockView.hidden = YES;
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
    @"当前价：",
    @"成本价：",
    //    @"持股仓位：",
    @"持股数量：",
    @"持股市值："
  ];
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:RowNum];
  if (positionInfo) {
    //股票名称(代码)
    NSString *namecode =
        [NSString stringWithFormat:@"%@（%@）", positionInfo.stockName, [StockUtil sixStockCode:positionInfo.stockCode]];
    [mutableArray addObject:namecode];
    NSString *format = [StockUtil getPriceFormatWithTradeType:positionInfo.tradeType];
    //盈亏金额(盈亏率)
    NSString *str_Profit =
        [NSString stringWithFormat:@"%@ (%@)", [NSString stringWithFormat:format, positionInfo.profit], positionInfo.profitRate];
    NSMutableAttributedString *mystringAttr =
        [self textColorRedOrGrenn:str_Profit andPositionInfo:positionInfo andBool:YES];
    [mutableArray addObject:mystringAttr];

    NSString *curPrice = [NSString stringWithFormat:format, positionInfo.curPrice];
    NSString *costPrice = [NSString stringWithFormat:format, positionInfo.costPrice];
    //当前价
    NSString *str_corPirce = [NSString stringWithFormat:@"%@ (%@)", curPrice, positionInfo.changePercent];
    NSMutableAttributedString *mutStringAttr =
        [self textColorRedOrGrenn:str_corPirce andPositionInfo:positionInfo andBool:NO];
    [mutableArray addObject:mutStringAttr];
    //成本价
    [mutableArray addObject:costPrice];
    //持股仓位
    //    [mutableArray addObject:positionInfo.positionRate];
    //持股数量(可卖数)
    NSString *position_number = nil;
    //此处有问题，逻辑需要调整，只比较了一个持仓
    if (0 == canTrace) {
      position_number =
          [NSString stringWithFormat:@"%@ (可卖%lld)", positionInfo.amount, positionInfo.sellableAmount];
    } else {
      position_number = [NSString stringWithFormat:@"%@", positionInfo.amount];
    }
    [mutableArray addObject:position_number];
    //持股市值
    [mutableArray addObject:[NSString stringWithFormat:format, positionInfo.value]];
    if ([@"" isEqualToString:positionInfo.positionRate]) {
      self.positionRateLabel.text = @"";
    } else {
      self.positionRateLabel.text = [positionInfo.positionRate stringByAppendingString:@"仓"];
    }

    for (int i = 0; i < RowNum; ++i) {
      UILabel *label = (UILabel *)[self viewWithTag:20 + i];
      label.text = array[i];

      UILabel *infoLabel = (UILabel *)[self viewWithTag:10 + i];

      if (i == 1) {
        NSMutableAttributedString *attrib = mutableArray[1];
        infoLabel.attributedText = attrib;
      }
      if (i == 2) {
        NSMutableAttributedString *att = mutableArray[2];
        infoLabel.attributedText = att;
        infoLabel.hidden = NO;
        label.hidden = NO;
      }
      if (i != 1 && i != 2) {
        infoLabel.text = mutableArray[i];
      }
      if (i == 6) {
        infoLabel.hidden = NO;
        label.hidden = NO;
      }
    }
    //设定按钮位置
    for (int i = 0; i < 4; ++i) {
      UIButton *button = buttonArray[i];
      button.frame = CGRectMake(30 + i * (ButtonWidth + GapBetweenBtn), 173, ButtonWidth, ButtonHeight);
    }

    if (positionInfo.bProfit) {
      _lineView.layer.borderColor = [[Globle colorFromHexRGB:@"#ae1e20"] CGColor];
      [self drawGradientColor:0];
    } else {
      _lineView.layer.borderColor = [[Globle colorFromHexRGB:@"#077636"] CGColor];
      [self drawGradientColor:1];
    }
    //设置卖出按钮状态
    BOOL isMyself = [self.uid isEqualToString:[SimuUtil getUserID]];
    if ((isMyself && positionInfo.sellableAmount > 0) ||
        (!isMyself && [SimuPositionPageData isStockSellable:positionInfo.stockCode]))
      canTrace = 0;
    else
      canTrace = -1;
    [self setSellButtonEnable:canTrace];
  }
}

//改变颜色字体的方法
- (NSMutableAttributedString *)textColorRedOrGrenn:(NSString *)text
                                   andPositionInfo:(PositionInfo *)positioninfo
                                           andBool:(BOOL)isEnd {
  NSMutableAttributedString *myStringAttr = [[NSMutableAttributedString alloc] initWithString:text];
  //颜色
  UIColor *colorProfit;
  UIColor *colorProfitRate;

  NSString *format = [StockUtil getPriceFormatWithTradeType:positioninfo.tradeType];

  if (isEnd == YES) {
    //根据需求 返回需要的颜色
    colorProfit = [StockUtil getColorByProfit:[NSString stringWithFormat:format, positioninfo.profit]];
    colorProfitRate = [StockUtil getColorByProfit:positioninfo.profitRate];
  } else if (isEnd == NO) {
    colorProfit = [StockUtil getColorByChangePercent:positioninfo.changePercent];
    colorProfitRate = colorProfit;
  }

  NSString *colorString1 = (isEnd ? [NSString stringWithFormat:format, positioninfo.profit]
                                  : [NSString stringWithFormat:format, positioninfo.curPrice]);
  NSString *colorString2 = isEnd == YES ? positioninfo.profitRate : positioninfo.changePercent;
  //给一段字体 不同的字段赋予不同的颜色
  [myStringAttr addAttribute:NSForegroundColorAttributeName
                       value:colorProfit
                       range:NSMakeRange(0, [colorString1 length])];
  [myStringAttr addAttribute:NSForegroundColorAttributeName
                       value:colorProfitRate
                       range:NSMakeRange([colorString1 length] + 2, [colorString2 length])];
  return myStringAttr;
}

//设置卖出按钮状态
- (void)setSellButtonEnable:(NSInteger)flag {
  UIButton *sellButton = (UIButton *)[self viewWithTag:101];
  if (sellButton) {
    if (flag == 0) {
      [sellButton.layer setBorderColor:[[Globle colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
      sellButton.enabled = YES;
    } else {
      [sellButton.layer setBorderColor:[[Globle colorFromHexRGB:Color_Gray] CGColor]]; //描边颜色
      sellButton.enabled = NO;
    }
  }
}

//展开或收缩清仓页面
- (void)present:(CGFloat)height {

  isHidden = NO;

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
