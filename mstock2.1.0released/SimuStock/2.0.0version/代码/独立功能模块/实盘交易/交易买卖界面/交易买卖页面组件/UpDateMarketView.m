//
//  UpDateMarketView.m
//  SimuStock
//
//  Created by moulin wang on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UpDateMarketView.h"
#import "SimuUtil.h"
#import "StockUtil.h"

@implementation UpDateMarketView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    _amountArr = [[NSMutableArray alloc] init];
    _priceArr = [[NSMutableArray alloc] init];
    self.capitalOrFirm = YES;
    [self createViews];
  }
  return self;
}
- (void)createViews {
  [self createMasterView];
  [self createMarketView];
}
//创建主视图
- (void)createMasterView {
  _mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, 360.0 / 2)];
  _mainView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_mainView.layer setMasksToBounds:YES];
  _mainView.layer.cornerRadius = 2.0;
  _mainView.layer.masksToBounds = YES;                                       //隐藏边界
  _mainView.layer.borderColor = [Globle colorFromHexRGB:@"#cacaca"].CGColor; //边框颜色
  _mainView.layer.borderWidth = 1;
  [self addSubview:_mainView];
  //分割线
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 360.0 / 4 - 2.0, self.width - 1, 1.0)];
  lineView.backgroundColor = [Globle colorFromHexRGB:@"#cacaca"];
  [_mainView addSubview:lineView];
}
//创建行情视图
- (void)createMarketView {
  NSArray *arr =
      @[ @"卖5", @"卖4", @"卖3", @"卖2", @"卖1", @"买1", @"买2", @"买3", @"买4", @"买5" ];
  CGFloat leftMargin = 3.0f;
  CGFloat space = 1.0f;
  CGFloat widthItem = 23.f;
  CGFloat widthPrice = (self.width - widthItem - leftMargin * 2 - space * 2) / 2;
  CGFloat widthAount = (self.width - widthItem - leftMargin * 2 - space * 2) / 2;
  for (int i = 0; i < 10; i++) {
    UILabel *nameLab =
        [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 2.5 + 18.0 * i, widthItem, 12.0)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    nameLab.font = [UIFont systemFontOfSize:22.0 / 2];
    nameLab.text = [NSString stringWithFormat:@"%@", arr[i]];
    nameLab.numberOfLines = 1;
    nameLab.adjustsFontSizeToFitWidth = YES;
    [_mainView addSubview:nameLab];

    UILabel *priceLab =
        [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + widthItem + space, 2.5 + 18.0 * i, widthPrice, 12.0)];
    priceLab.backgroundColor = [UIColor clearColor];
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    priceLab.font = [UIFont systemFontOfSize:Font_Height_10_0];
    priceLab.text = @"--";
    priceLab.numberOfLines = 1;
    priceLab.adjustsFontSizeToFitWidth = YES;
    [_mainView addSubview:priceLab];
    [_priceArr addObject:priceLab];

    UILabel *amountLab =
        [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + widthItem + space + widthPrice + space,
                                                  2.5 + 18.0 * i, widthAount, 12.0)];
    amountLab.backgroundColor = [UIColor clearColor];
    amountLab.textAlignment = NSTextAlignmentRight;
    amountLab.textColor = [Globle colorFromHexRGB:Color_Dark];
    amountLab.font = [UIFont systemFontOfSize:Font_Height_10_0];
    amountLab.text = @"--";
    amountLab.numberOfLines = 1;
    amountLab.adjustsFontSizeToFitWidth = YES;
    [_mainView addSubview:amountLab];
    [_amountArr addObject:amountLab];
  }
}
//数据请求完成
- (void)dataRequestComplete:(RealTradeStockPriceInfo *)realTradeData {
  self.realTradeData = realTradeData;
  //如果停盘，显示“--”
  //  if (realTradeData.suspend) {
  //    [NewShowLabel setMessageContent:@"该股票已停牌"];
  //    for (int i = 0; i < 10; i++) {
  //      UILabel *priceLab = _priceArr[i];
  //      UILabel *amountLab = _amountArr[i];
  //      amountLab.text = @"--";
  //      priceLab.text = @"--";
  //      priceLab.textColor = [Globle colorFromHexRGB:Color_Dark];
  //    }
  //    return;
  //  }
  self.capitalOrFirm = YES;
  for (int i = 0; i < 10; i++) {
    UILabel *priceLab = _priceArr[i];
    UILabel *amountLab = _amountArr[i];
    if (i < 5) {
      NSString *price = self.realTradeData.sellPriceArray[4 - i];
      if ([price isEqualToString:@"0.00"]) {
        price = @"--";
      }

      amountLab.text = [NSString stringWithFormat:@"%@", self.realTradeData.sellAmountArray[4 - i]];
      priceLab.text = [NSString stringWithFormat:@"%@", price];
      priceLab.textColor = [self quotesDisplayFontColorAmountArray:self.realTradeData.sellAmountArray
                                                        priceArray:self.realTradeData.sellPriceArray
                                                             index:4 - i];

    } else {
      NSString *price = self.realTradeData.buyPriceArray[i - 5];
      if ([price isEqualToString:@"0.00"]) {
        price = @"--";
      }
      amountLab.text = [NSString stringWithFormat:@"%@", self.realTradeData.buyAmountArray[i - 5]];
      priceLab.text = [NSString stringWithFormat:@"%@", price];
      priceLab.textColor = [self quotesDisplayFontColorAmountArray:self.realTradeData.buyAmountArray
                                                        priceArray:self.realTradeData.buyPriceArray
                                                             index:i - 5];
    }
  }
}

#pragma mark-- 配资数据绑定
- (void)capitalBindData:(WFStockByInfoData *)stockInfoData {
  self.stockInforData = stockInfoData;
  //如果停盘，显示“--”
  if (stockInfoData.suspend || [stockInfoData.stockCode isEqualToString:@""] ||
      stockInfoData.stockCode.length == 0) {
    for (int i = 0; i < 10; i++) {
      UILabel *priceLab = _priceArr[i];
      UILabel *amountLab = _amountArr[i];
      amountLab.text = @"--";
      priceLab.text = @"--";
      priceLab.textColor = [Globle colorFromHexRGB:Color_Dark];
    }
    return;
  }
  self.capitalOrFirm = NO;
  for (int i = 0; i < 10; i++) {
    UILabel *priceLab = _priceArr[i];
    UILabel *amountLab = _amountArr[i];
    if (i < 5) {
      NSString *price = stockInfoData.sellPriceArray[4 - i];
      if ([price isEqualToString:@"0.00"]) {
        price = @"--";
      }
      amountLab.text = [NSString stringWithFormat:@"%@", self.stockInforData.sellAmountArray[4 - i]];
      priceLab.text = [NSString stringWithFormat:@"%@", price];
      priceLab.textColor = [self quotesDisplayFontColorAmountArray:self.stockInforData.sellAmountArray
                                                        priceArray:self.stockInforData.sellPriceArray
                                                             index:4 - i];

    } else {
      NSString *price = stockInfoData.buyPriceArray[i - 5];
      if ([price isEqualToString:@"0.00"]) {
        price = @"--";
      }
      amountLab.text = [NSString stringWithFormat:@"%@", self.stockInforData.buyAmountArray[i - 5]];
      priceLab.text = [NSString stringWithFormat:@"%@", price];
      priceLab.textColor = [self quotesDisplayFontColorAmountArray:self.stockInforData.buyAmountArray
                                                        priceArray:self.stockInforData.buyPriceArray
                                                             index:i - 5];
    }
  }
}

//行情显示字体颜色设置
- (UIColor *)quotesDisplayFontColorAmountArray:(NSArray *)amountArr
                                    priceArray:(NSArray *)priceArr
                                         index:(NSInteger)row {

  if (self.capitalOrFirm == YES) {
    return [StockUtil getColorByFloat:[priceArr[row] floatValue] - [self.realTradeData.closePrice floatValue]];
  } else {
    return [StockUtil getColorByFloat:[priceArr[row] floatValue] - [self.stockInforData.closePrice floatValue]];
  }
}

//用于买入或卖出后清空数据
- (void)clearData {
  [_priceArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    ((UILabel *)obj).text = @"--";
    ((UILabel *)obj).textColor = [Globle colorFromHexRGB:Color_Dark];
  }];
  [_amountArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    ((UILabel *)obj).text = @"--";
    ((UILabel *)obj).textColor = [Globle colorFromHexRGB:Color_Dark];
  }];
}

@end
