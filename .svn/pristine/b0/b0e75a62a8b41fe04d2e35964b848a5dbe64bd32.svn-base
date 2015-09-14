//
//  SliederBuySellView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SliederBuySellView.h"
#import "PriceBuySellTool.h"
#import "SimuUtil.h"
#import "FoundMasterPurchViewConroller.h"
#import "NewShowLabel.h"
#import "event_view_log.h"
#import "UIButton+Block.h"
@interface SliederBuySellView () {
  /** 数据源 */
  SimuTradeBaseData *_simuTradeData;

  //展示lable靠左边 最小值
  CGFloat onLeftFloat;
  //展示label靠右边的 最大值
  CGFloat onRightFloat;

  /** 记录资金总量 */
  NSInteger totalCapitalFunds;
}
/** 判断是 市价还是限价 */
@property(assign, nonatomic) MarketFixedPriceType marketFixedPrice;
/** 枚举限价 市价 */
@property(assign, nonatomic) BuySellType buySellType;

/** 记录资金选择按钮是否被选中 */
@property(assign, nonatomic) BOOL moneyButton;

@end

@implementation SliederBuySellView

/** 对外提供的初始化方法 */
+ (SliederBuySellView *)showSliederBuySellViewWithBuySellType:(BuySellType)type {
  if (type == StockBuyType) {
    //买入
    return [[[NSBundle mainBundle] loadNibNamed:@"BuySliedView" owner:self options:nil] lastObject];
  } else if (type == StockSellType) {
    //卖出
    return
        [[[NSBundle mainBundle] loadNibNamed:@"SellSliedView" owner:self options:nil] lastObject];
  }
  return nil;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.moneyButtonBuyView.delegate = self;
  self.moneyButtonView.delegate = self;
  self.moneyButton = NO;

  [self.buyButton buttonWithTitle:@"买入"
               andNormaltextcolor:Color_White
         andHightlightedTextColor:Color_White];
  [self.buyButton setNormalBGColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
  [self.buyButton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  [self.sellButton buttonWithTitle:@"卖出"
                andNormaltextcolor:Color_White
          andHightlightedTextColor:Color_White];
  [self.sellButton setNormalBGColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
  [self.sellButton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  //按钮 放重复点击
  __weak SliederBuySellView *weakSelf = self;
  [self.buyButton setOnButtonPressedHandler:^{
    SliederBuySellView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf buttonDownForBuyOrSell:strongSelf.buyButton];
    }
  }];

  [self.sellButton setOnButtonPressedHandler:^{
    SliederBuySellView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf buttonDownForBuyOrSell:strongSelf.sellButton];
    }
  }];
}

#pragma mark - 区分 市价 和 限价
/** 区分 市价 和 限价 */
- (void)marketFixedAssignment:(MarketFixedPriceType)isEnd {
  self.marketFixedPrice = isEnd;
}
#pragma mark - 显示不显示添加资金按钮 专门 给牛人设置的
/** 显示不显示添加资金按钮 专门 给牛人设置的 */
- (void)showOrHiddenForMoneyButton:(BOOL)hidden {
  self.moneyButtonView.hidden = hidden;
}
#pragma mark - 给滑块贴图
/** 给滑块贴图 */
- (void)sliderMapImage:(BuySellType)type {
  self.buySellType = type;
  if (type == StockBuyType) {
    //买入滑块 贴图
    _sliderPrice.maximumValue = 0.0f;
    _sliderPrice.minimumValue = 0.0f;
    _sliderPrice.value = 0.0f;
    [_sliderPrice setThumbImage:[UIImage imageNamed:@"滑动按钮.png"] forState:UIControlStateNormal];
    [_sliderPrice setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                       forState:UIControlStateHighlighted];

    [_sliderPrice setMaximumTrackImage:[[UIImage imageNamed:@"买入数量进度条.png"] stretchableImageWithLeftCapWidth:4
                                                                                                              topCapHeight:0]
                              forState:UIControlStateNormal];
    [_sliderPrice setMinimumTrackImage:[[UIImage imageNamed:@"买入数量进度条左.png"] stretchableImageWithLeftCapWidth:4
                                                                                                                 topCapHeight:0]
                              forState:UIControlStateNormal];
    self.buyButton.layer.cornerRadius = 15.0f;
    self.buyButton.layer.masksToBounds = YES;

  } else if (type == StockSellType) {
    //卖出滑块
    _sellSlider.maximumValue = 0.0f;
    _sellSlider.minimumValue = 0.0f;
    _sellSlider.value = 0.0f;
    [_sellSlider setThumbImage:[UIImage imageNamed:@"滑动按钮.png"] forState:UIControlStateNormal];
    [_sellSlider setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                      forState:UIControlStateHighlighted];

    [_sellSlider setMaximumTrackImage:[[UIImage imageNamed:@"买入数量进度条.png"] stretchableImageWithLeftCapWidth:4
                                                                                                             topCapHeight:0]
                             forState:UIControlStateNormal];
    [_sellSlider setMinimumTrackImage:[[UIImage imageNamed:@"买入数量进度条左.png"] stretchableImageWithLeftCapWidth:4
                                                                                                                topCapHeight:0]
                             forState:UIControlStateNormal];
  }
}
#pragma mark - 绑定数据的方法
/** 绑定数据的方法 */
- (void)bindBuySellData:(SimuTradeBaseData *)data withSwitchRefreshSliderBool:(BOOL)isEnd {
  _simuTradeData = data;
  //记录资金总量
  totalCapitalFunds = data.fundsable;
  if (_buySellType == StockBuyType) {
    //买入
    if (_sliderPrice) {
      NSString *string = nil;
      if (isEnd) {
        _sliderPrice.value = data.stockamount / 100;
        //给label赋值
        self.fixedFoundsValue = [PriceBuySellTool moreFundsButtonDownWithSimuTradeData:data
                                                                  withStockBuySellView:_buySellTextField
                                                                            withAmount:data.stockamount];
        if (_marketFixedPrice == MarketPriceType) {
          string = [NSString stringWithFormat:@"￥ %d", (int)self.marketFoundsValue];
        } else if (_marketFixedPrice == FixedPriceType) {
          string = [NSString stringWithFormat:@"￥ %d", (int)self.fixedFoundsValue];
        }
        //重设label
        [self heavyShowLabelSetUpPositionWithContent:string
                                           withLabel:_showPriceLable
                                          withSilder:_sliderPrice];
        //股票数量
        self.buySellTextField.buyAmountTF.text = [NSString stringWithFormat:@"%ld", (long)data.stockamount];
      } else {
        if ([data.maxBuy longLongValue] >= 100) {
          _sliderPrice.maximumValue = [data.maxBuy longLongValue] / 100;
          _sliderPrice.minimumValue = 1;
          _sliderPrice.value = [data.maxBuy longLongValue] / 100;
          //记录市价 数据 和 限价数据
          if (data.fundsable <= 0) {
            _showPriceLable.hidden = YES;
          } else {
            _showPriceLable.hidden = NO;
            //限价
            self.fixedFoundsValue =
                [PriceBuySellTool marketFixedFoundsShowLableWithSimuTradeData:data
                                                              withBuySellType:FixedPriceType];
            //市价
            self.marketFoundsValue =
                [PriceBuySellTool marketFixedFoundsShowLableWithSimuTradeData:data
                                                              withBuySellType:MarketPriceType];
            if (self.marketFoundsValue >= data.fundsable) {
              self.marketFoundsValue = data.fundsable;
            }
            if (_marketFixedPrice == MarketPriceType) {
              string = [NSString stringWithFormat:@"￥ %d", (int)self.marketFoundsValue];
            } else if (_marketFixedPrice == FixedPriceType) {
              string = [NSString stringWithFormat:@"￥ %d", (int)self.fixedFoundsValue];
            }
            [self heavyShowLabelSetUpPositionWithContent:string
                                               withLabel:_showPriceLable
                                              withSilder:_sliderPrice];
          }
        } else {
          //当可买数量 不足 100 股
          [self whenNumberBuyIsInsufficient];
          if ([data.maxBuy isEqualToString:@"0"]) {
            _showPriceLable.hidden = NO;
            _fixedFoundsValue = [PriceBuySellTool marketFixedFoundsShowLableWithSimuTradeData:data
                                                                              withBuySellType:FixedPriceType];
            _marketFoundsValue = (int)data.fundsable;
            if (_marketFixedPrice == MarketPriceType) {
              string = [NSString stringWithFormat:@"￥ %d", (int)data.fundsable];
            } else if (_marketFixedPrice == FixedPriceType) {
              string = [NSString stringWithFormat:@"￥ %d", (int)self.fixedFoundsValue];
            }
            _showPriceLable.text = string;
          }
        }
        //刷新资金按钮
        if (_moneyButtonBuyView) {
          _moneyButton = NO;
          [_moneyButtonBuyView clearAllData];
          [_moneyButtonBuyView setTotolMoney:totalCapitalFunds];
          _moneyButtonBuyView.userInteractionEnabled = YES;
        }
      }
    }
  } else if (_buySellType == StockSellType) {
    //卖出界面
    if (_sellSlider) {
      if ([data.sellable longLongValue] >= 1) {
        _sellSlider.minimumValue = 1;
        _sellSlider.maximumValue = [data.sellable longLongValue];
        _sellSlider.value = [data.sellable longLongValue];
        //最大 最小可卖数
        _minSellAmountLabel.text = @"1";
        _maxSellAmountLabel.text = [NSString stringWithFormat:@"%lld", [data.sellable longLongValue]];

      } else {
        [self whenNumberBuyIsInsufficient];
      }
    }
  }
}
#pragma mark - 设置展示label
//设置展示label
- (void)heavyShowLabelSetUpPositionWithContent:(NSString *)content
                                     withLabel:(UILabel *)label
                                    withSilder:(UISlider *)slider {
  //重设lable的宽度
  CGSize size = [SimuUtil labelContentSizeWithContent:content
                                             withFont:Font_Height_12_0
                                             withSize:CGSizeMake(9999, CGRectGetHeight(label.bounds))];
  _showLableWidth.constant = size.width;
  label.text = content;
  CGFloat value = slider.value;
  CGFloat maxvalue = slider.maximumValue;
  if (maxvalue == 0) {
    maxvalue = 1;
  }
  CGFloat width;
  if (value > 1) {
    width = CGRectGetMinX(slider.frame) + CGRectGetWidth(slider.bounds) * (value / maxvalue) -
            size.width * 0.5 - 10;
  } else {
    width = 10.0f;
  }
  onLeftFloat = 10.0f;
  onRightFloat = CGRectGetMaxX(_sliderPrice.frame) - size.width * 0.5;
  if (width < onLeftFloat) {
    _showPriceLabelHorizontal.constant = onLeftFloat;
  } else if (width > onRightFloat) {
    _showPriceLabelHorizontal.constant = onRightFloat;
  } else {
    _showPriceLabelHorizontal.constant = width;
  }
}
#pragma makr-- 滑块滑动事件
- (IBAction)sliderChangedValue:(UISlider *)sender {
  if ((_buySellType == StockBuyType) && (sender.tag == 100)) {
    //买入
    if (sender.value <= 0) {
      return;
    }
    //记录滑块 滑动时的 限价和市价 金额
    if (_buySellTextField) {
      //市价
      _marketFoundsValue = [PriceBuySellTool fixedSliederFoundsWithNewPrice:@""
                                                                 withAmount:((NSInteger)sender.value * 100)
                                                          withSimuTradeData:_simuTradeData
                                                            withBuySellType:MarketPriceType];
      if (_marketFoundsValue >= _simuTradeData.fundsable) {
        _marketFoundsValue = _simuTradeData.fundsable;
      }
      //限价
      _fixedFoundsValue = [PriceBuySellTool fixedSliederFoundsWithNewPrice:_buySellTextField.buyPriceTF.text
                                                                withAmount:((NSInteger)sender.value * 100)
                                                         withSimuTradeData:_simuTradeData
                                                           withBuySellType:FixedPriceType];
    }
    NSString *string = nil;
    if (_marketFixedPrice == MarketPriceType) {
      string = [NSString stringWithFormat:@"￥ %ld", (long)_marketFoundsValue];
    } else if (_marketFixedPrice == FixedPriceType) {
      string = [NSString stringWithFormat:@"￥ %ld", (long)_fixedFoundsValue];
    }
    //重设lable的宽度
    [self heavyShowLabelSetUpPositionWithContent:string
                                       withLabel:_showPriceLable
                                      withSilder:_sliderPrice];
    //给可买数量textField赋值
    if ((NSInteger)sender.value * 100 > 0) {
      _buySellTextField.buyAmountTF.text = [NSString stringWithFormat:@"%ld", (long)sender.value * 100];
    }
    if (_moneyButtonBuyView.corIndexSel != -1) {
      _moneyButton = NO;
      [_moneyButtonBuyView clearAllData];
      [_moneyButtonBuyView setTotolMoney:totalCapitalFunds];
    }
  } else if ((_buySellType == StockSellType) && (sender.tag == 101)) {
    //卖出
    if (sender.value == 0) {
      return;
    } else {
      _buySellTextField.buyAmountTF.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    }
  }
}
#pragma makr - 给资金显示label赋值
/** 给资金显示label赋值 */
- (void)showLabelForMarketFiexd:(MarketFixedPriceType)type {
  if (_simuTradeData.fundsable != 0) {
    _showPriceLable.hidden = NO;
    if (type == MarketPriceType) {
      [self sizeForShowLabelWithPrice:_marketFoundsValue withLabel:_showPriceLable];
    } else if (type == FixedPriceType) {
      [self sizeForShowLabelWithPrice:_fixedFoundsValue withLabel:_showPriceLable];
    }
  } else {
    _showPriceLable.hidden = YES;
  }
}

- (void)sizeForShowLabelWithPrice:(NSInteger)funds withLabel:(UILabel *)label {
  NSString *string = [NSString stringWithFormat:@"￥ %ld", (long)funds];
  CGSize size = [SimuUtil labelContentSizeWithContent:string
                                             withFont:Font_Height_12_0
                                             withSize:CGSizeMake(9999, CGRectGetHeight(label.bounds))];
  _showLableWidth.constant = size.width;
  label.text = string;
}

#pragma makr - 清楚数据的方法
/** 清楚数据的方法 */
- (void)eliminateData {
  _simuTradeData = nil;
  if (_buySellType == StockBuyType) {
    _showPriceLable.hidden = YES;
    _sliderPrice.maximumValue = 0;
    _sliderPrice.minimumValue = 0;
    _sliderPrice.value = 0;
    _moneyButton = NO;
    _marketFoundsValue = 0;
    _fixedFoundsValue = 0;
    if (_moneyButtonBuyView) {
      [_moneyButtonBuyView clearAllData];
      _moneyButtonBuyView.userInteractionEnabled = NO;
    }
  } else if (_buySellType == StockSellType) {
    _sellSlider.minimumValue = 0;
    _sellSlider.maximumValue = 0;
    _sellSlider.value = 0;
    _maxSellAmountLabel.text = @"0";
    _minSellAmountLabel.text = @"0";
  }
}
#pragma makr - 重置某些属性
/** 重置某些属性 */
- (void)whenNumberBuyIsInsufficient {
  //买入界面
  if (_buySellType == StockBuyType) {
    _sliderPrice.maximumValue = 0;
    _sliderPrice.minimumValue = 0;
    _sliderPrice.value = 0;
    _showPriceLabelHorizontal.constant = 20.0f;
    _showPriceLable.textAlignment = NSTextAlignmentLeft;
    _moneyButton = NO;
    [_moneyButtonBuyView clearAllData];
  } else if (_buySellType == StockSellType) {
    _sellSlider.minimumValue = 0;
    _sellSlider.maximumValue = 0;
    _sellSlider.value = 0;
    _minSellAmountLabel.text = @"0";
    _maxSellAmountLabel.text = @"0";
  }
}

#pragma makr-- 买卖Button点击事件
- (void)buttonDownForBuyOrSell:(UIButton *)sender {
  self.buySellTextField.isOriginalView = NO;
  sender.backgroundColor = [Globle colorFromHexRGB:@"31bce9"];
  [self.buySellTextField.buyPriceTF resignFirstResponder];
  [self.buySellTextField.buyAmountTF resignFirstResponder];
  //判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (![_buySellTextField judgeTextFieldContent]) {
    NSString *content = @"";
    NSString *code = _buySellTextField.stockCodeTF.text;
    if ([code length] == 0) {
      if (_buySellType == StockBuyType) {
        content = @"请选择要买入的股票";
      } else if (_buySellType == StockSellType) {
        content = @"请选择要卖出的股票";
      }
    } else {
      content = @"股票不可交易";
    }
    [self alertShow:content];
    return;
  }

  if (_simuTradeData.newstockPrice == 0) {
    [NewShowLabel setMessageContent:@"获取股票信息失败,请刷新"];
    return;
  }
  //判断输入框里的内容
  NSString *type = nil;
  NSString *num = nil;
  if (_buySellType == StockBuyType) {
    type = @"买入";
    num = @"36";
  } else if (_buySellType == StockSellType) {
    type = @"卖出";
    num = @"37";
  }
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:num];
  NSString *content = nil;
  if (_buySellType == StockBuyType) {
    //买
    if (_marketFixedPrice == MarketPriceType) {
      if (![self lowesFundsWithSimuTradeData:_simuTradeData]) {
        return;
      }
      content = [NSString stringWithFormat:@"您确定要以市价买入%ld元的[%@]吗?",
                                           (long)self.marketFoundsValue, _buySellTextField.stockNameTF.text];
    } else if (_marketFixedPrice == FixedPriceType) {
      NSString *string = [_buySellTextField judgePriceTextFieldContent];
      if (![string isEqualToString:@""]) {
        [self alertShow:string];
        return;
      }
      NSString *amount = [_buySellTextField judgeAmountTextFieldContent];
      if (![amount isEqualToString:@""]) {
        [self alertShow:amount];
        return;
      }
      if (![self lowesFundsWithSimuTradeData:_simuTradeData]) {
        return;
      }
      content =
          [NSString stringWithFormat:@"您确定要以%@元的价格限价%@ [%@] %@股？", _buySellTextField.buyPriceTF.text,
                                     type, _buySellTextField.stockNameTF.text, _buySellTextField.buyAmountTF.text];
    }
  } else if (_buySellType == StockSellType) {
    //卖
    if (_marketFixedPrice == MarketPriceType) {
      //判断数量
      NSString *amountString = [_buySellTextField judgeAmountTextFieldContent];
      if (![amountString isEqualToString:@""]) {
        [self alertShow:amountString];
        return;
      }
      //卖出
      content = [NSString stringWithFormat:@"您确定要以市价卖出[%@]%@股吗?",
                                           _buySellTextField.stockNameTF.text, _buySellTextField.buyAmountTF.text];

    } else if (_marketFixedPrice == FixedPriceType) {
      //判断价格
      NSString *priceString = [_buySellTextField judgePriceTextFieldContent];
      if (![priceString isEqualToString:@""]) {
        [self alertShow:priceString];
        return;
      }
      NSString *amountString = [_buySellTextField judgeAmountTextFieldContent];
      if (![amountString isEqualToString:@""]) {
        [self alertShow:amountString];
        return;
      }
      content =
          [NSString stringWithFormat:@"您确定要以%@元的价格限价%@ [%@] %@股？", _buySellTextField.buyPriceTF.text,
                                     type, _buySellTextField.stockNameTF.text, _buySellTextField.buyAmountTF.text];
    }
  }
  [self creatAlartView:content];
}

- (void)alertShow:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
  [alert show];
}
//创建警告框
- (void)creatAlartView:(NSString *)showcontent {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:showcontent
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  [alert show];
}
#pragma makr-- alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    if (self.downButtonBuySell) {
      //校验数据
      if ([self.buySellTextField checkDataForBuySellTextFiled]) {
        NSString *price = nil;
        NSString *token = _simuTradeData.token;
        if (_marketFixedPrice == MarketPriceType) {
          price = @"";
        } else if (_marketFixedPrice == FixedPriceType) {
          price = _buySellTextField.buyPriceTF.text;
        }
        self.downButtonBuySell(self.marketFoundsValue, price, token);
      }
    }
  } else {
    //取消
  }
}
#pragma mark-- 判断资金情况
//判断资金情况
- (BOOL)lowesFundsWithSimuTradeData:(SimuTradeBaseData *)data {
  double price = 0.0;
  if (_marketFixedPrice == MarketPriceType) {
    price = data.uplimitedPrice;
  } else if (_marketFixedPrice == FixedPriceType) {
    price = data.buyPrice;
  }
  CGFloat lowesFuns = price * 100 + data.minFee;
  if (_marketFoundsValue < lowesFuns) {
    [NewShowLabel setMessageContent:@"委托金额过低,不能提交"];
    return NO;
  } else {
    return YES;
  }
}

#pragma makr-- 资金选择框点击事件
- (void)moneyButtonPressDown:(NSInteger)index {
  NSInteger funds = 0;
  self.moneyButton = YES;
  if (index == 0) {
    if (_sliderPrice) {
      funds = 20000;
    }
  } else if (index == 1) {
    if (_sliderPrice) {
      funds = 50000;
    }
  } else if (index == 2) {
    if (_sliderPrice) {
      funds = 100000;
    }
  } else if (index == 3) {
    if (_sliderPrice) {
      funds = 200000;
    }
  }
  //滑块的value
  _marketFoundsValue = funds;
  if (_buySellType == StockBuyType) {
    NSString *stockPrice = nil;
    if (_marketFixedPrice == MarketPriceType) {
      stockPrice = @"";
    } else if (_marketFixedPrice == FixedPriceType) {
      stockPrice = _buySellTextField.buyPriceTF.text;
    }
    if (self.moreFoundButton) {
      self.moreFoundButton(funds, stockPrice);
    }
  }
}
#pragma mark-- 根据价格的改变来计算资金 或者 数量的改变 来重置滑块
/** 根据价格的改变来计算资金 或者 数量的改变 来重置滑块 */
- (void)priceOrAmountChangeReSetUpSliderWithPice:(NSString *)price
                                 withBuySellType:(BuySellType)type
                                        withBool:(BOOL)isEnd {
  // YES  为价格发生变化 NO 为数量发生变化
  if (type == StockBuyType) {
    if (isEnd) {
      //价格
      self.fixedFoundsValue =
          [PriceBuySellTool priceChangeCalculationFundsWihtPrcie:price
                                                      withAmount:[_buySellTextField.buyAmountTF.text integerValue]
                                               withSimuTradeData:_simuTradeData];
      NSString *string = [NSString stringWithFormat:@"￥ %ld", (long)self.fixedFoundsValue];
      _showPriceLable.textAlignment = NSTextAlignmentCenter;
      [self heavyShowLabelSetUpPositionWithContent:string
                                         withLabel:_showPriceLable
                                        withSilder:_sliderPrice];
    } else {
      //买入数量发生变化了
      if ([price longLongValue] <= [_simuTradeData.maxBuy longLongValue]) {
        _buySellTextField.buyAmountTF.text = price;
        _sliderPrice.value = [price integerValue] / 100;
        [self reSetUpShowLableAndSlider:price];
      } else {
        _buySellTextField.buyAmountTF.text =
            [NSString stringWithFormat:@"%lld", [_simuTradeData.maxBuy longLongValue]];
        _sliderPrice.value = [_simuTradeData.maxBuy integerValue] / 100;
        [self reSetUpShowLableAndSlider:_buySellTextField.buyAmountTF.text];
      }
    }
  } else if (type == StockSellType) {
    //卖出
    if (_simuTradeData.newstockPrice == 0) {
      _buySellTextField.buyAmountTF.text = price;
      _sellSlider.value = [_simuTradeData.sellable integerValue];
    } else {
      if ([price integerValue] <= [_simuTradeData.sellable integerValue]) {
        _buySellTextField.buyAmountTF.text = price;
        _sellSlider.value = [price integerValue];
      } else {
        _buySellTextField.buyAmountTF.text = _simuTradeData.sellable;
        _sellSlider.value = [_simuTradeData.sellable integerValue];
      }
    }
  }
}
#pragma mark-- 重新设置滑块和label
- (void)reSetUpShowLableAndSlider:(NSString *)num {
  if (!_moneyButton) {
    self.marketFoundsValue = [PriceBuySellTool fixedSliederFoundsWithNewPrice:@""
                                                                   withAmount:[num longLongValue]
                                                            withSimuTradeData:_simuTradeData
                                                              withBuySellType:MarketPriceType];
  }
  self.fixedFoundsValue = [PriceBuySellTool fixedSliederFoundsWithNewPrice:_buySellTextField.buyPriceTF.text
                                                                withAmount:[num longLongValue]
                                                         withSimuTradeData:_simuTradeData
                                                           withBuySellType:FixedPriceType];
  //资金显示赋值
  NSString *string = nil;
  string = [NSString stringWithFormat:@"￥ %ld", (long)_fixedFoundsValue];
  //重设lable的宽度
  [self heavyShowLabelSetUpPositionWithContent:string
                                     withLabel:_showPriceLable
                                    withSilder:_sliderPrice];
  if (_moneyButtonBuyView.corIndexSel != -1) {
    _moneyButton = NO;
    [_moneyButtonBuyView clearAllData];
    [_moneyButtonBuyView setTotolMoney:totalCapitalFunds];
  }
}

#pragma mark-- 添加资金卡
- (void)ButtonPressUp:(NSInteger)index {
  [_buySellTextField.buyPriceTF resignFirstResponder];
  [_buySellTextField.buyAmountTF resignFirstResponder];
  //资金卡页面
  FoundMasterPurchViewConroller *mfvc_masterPruchesViewController =
      [[FoundMasterPurchViewConroller alloc] init];
  [AppDelegate pushViewControllerFromRight:mfvc_masterPruchesViewController];
}

@end
