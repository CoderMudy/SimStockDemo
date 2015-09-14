//
//  S5B5View.m
//  SimuStock
//
//  Created by Mac on 13-10-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "S5B5View.h"
#import "StockUtil.h"

@implementation S5B5View

- (id)initWithFrame:(CGRect)frame isIndexStock:(BOOL)isIndexStock {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    _priceArray = [[NSMutableArray alloc] init];
    _handsArray = [[NSMutableArray alloc] init];

    _isIndexStock = isIndexStock;
    if (_isIndexStock == NO) {
      //普通股
      [self creatViews];
    } else {
      //大盘股
      [self creatGrailViews];
    }
  }
  return self;
}

//普通个股
- (void)creatViews {
  _sellRect =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2);
  _buyRect = CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width,
                        self.bounds.size.height / 2);
  //加入卖5按钮
  CGRect titleRect =
      CGRectMake(_sellRect.origin.x, _sellRect.origin.y + 1, 15, 12);
  CGRect priceRect = CGRectMake(
      titleRect.origin.x + titleRect.size.width + 1, _sellRect.origin.y + 1,
      (_sellRect.size.width - titleRect.size.width - 2) / 2 - 6, 12);
  CGRect handsRect = CGRectMake(
      priceRect.origin.x + priceRect.size.width + 1, _sellRect.origin.y,
      (_sellRect.size.width - titleRect.size.width - 2) / 2 + 6, 12);

  float spaceheight = (self.bounds.size.height / 2 - 12) / 4.0;

  NSArray *array = @[ @"卖5", @"卖4", @"卖3", @"卖2", @"卖1" ];
  for (int i = 0; i < 5; i++) {

    //卖5~1
    UILabel *titleLabel = [[UILabel alloc]
        initWithFrame:CGRectOffset(titleRect, 0, i * spaceheight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_08_0];
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    titleLabel.text = array[i];
    [self addSubview:titleLabel];

    //价格
    UILabel *priceLabel = [[UILabel alloc]
        initWithFrame:CGRectOffset(priceRect, 0, i * spaceheight)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:Font_Height_09_0];
    priceLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    priceLabel.text = @"--";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [_priceArray addObject:priceLabel];
    [self addSubview:priceLabel];

    //手
    UILabel *handsLabel = [[UILabel alloc]
        initWithFrame:CGRectOffset(handsRect, 0, i * spaceheight)];
    handsLabel.backgroundColor = [UIColor clearColor];
    handsLabel.font = [UIFont systemFontOfSize:Font_Height_09_0];
    handsLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    handsLabel.text = @"--";
    handsLabel.textAlignment = NSTextAlignmentRight;
    [_handsArray addObject:handsLabel];
    [self addSubview:handsLabel];
  }

  //加入分割线
  UIView *breakLine = [[UIView alloc]
      initWithFrame:CGRectMake(5, self.bounds.size.height / 2 + 4,
                               self.bounds.size.width - 10, 1)];
  breakLine.backgroundColor = [Globle colorFromHexRGB:@"#c6dce0"];
  [self addSubview:breakLine];

  //加入买5按钮
  titleRect = CGRectMake(_buyRect.origin.x, _buyRect.origin.y + 12, 15, 10);
  priceRect = CGRectMake(
      titleRect.origin.x + titleRect.size.width + 1, _buyRect.origin.y + 11,
      (_buyRect.size.width - titleRect.size.width - 2) / 2 - 6, 12);
  handsRect = CGRectMake(
      priceRect.origin.x + priceRect.size.width + 1, _buyRect.origin.y + 10,
      (_buyRect.size.width - titleRect.size.width - 2) / 2 + 6, 12);

  array = @[ @"买1", @"买2", @"买3", @"买4", @"买5" ];

  for (int i = 0; i < 5; i++) {
    //买5~1
    UILabel *titleLabel = [[UILabel alloc]
        initWithFrame:CGRectOffset(titleRect, 0, i * spaceheight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:Font_Height_08_0];
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
    titleLabel.text = array[i];
    [self addSubview:titleLabel];

    //价格
    UILabel *lable = [[UILabel alloc]
        initWithFrame:CGRectOffset(priceRect, 0, i * spaceheight)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:9];
    lable.textColor = [Globle colorFromHexRGB:Color_Dark];
    lable.text = @"--";
    lable.textAlignment = NSTextAlignmentCenter;
    [_priceArray addObject:lable];
    [self addSubview:lable];

    //量
    lable = [[UILabel alloc]
        initWithFrame:CGRectOffset(handsRect, 0, i * spaceheight)];
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:9];
    lable.textColor = [Globle colorFromHexRGB:Color_Dark];
    lable.text = @"--";
    lable.textAlignment = NSTextAlignmentRight;
    [_handsArray addObject:lable];
    [self addSubview:lable];
  }
}

//大盘(没用)
- (void)creatGrailViews {
  NSArray *nameArray = @[
    @"量比:",
    @"振幅:",
    @"上涨:",
    @"平盘:",
    @"下跌:",
    @"深成指:",
    @"创业板:",
    @"中小板:",
    @"沪深300:",
    @"上证180:",
    @"深圳综指:"
  ];

  float spageHeight = self.bounds.size.height / 11.f;
  CGRect nameRect = CGRectMake(2, 9, 79 / 2, 12);
  CGRect valueRect =
      CGRectMake(nameRect.origin.x + nameRect.size.width + 1, nameRect.origin.y,
                 74 / 2, nameRect.size.height);
  float m_spaceheight = 0;
  for (int i = 0; i < 11; i++) {
    if (i == 5)
      m_spaceheight = 2;
    //名称
    UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectOffset(nameRect, 0,
                                   m_spaceheight + i * spageHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = [Globle colorFromHexRGB:Color_Dark];
    label.text = [nameArray objectAtIndex:i];
    label.textAlignment = NSTextAlignmentLeft;
    [_priceArray addObject:label];
    [self addSubview:label];

    //数值
    label = [[UILabel alloc]
        initWithFrame:CGRectOffset(valueRect, 0,
                                   m_spaceheight + i * spageHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = [Globle colorFromHexRGB:Color_Dark];
    label.text = @"--";
    label.textAlignment = NSTextAlignmentCenter;
    [_handsArray addObject:label];
    [self addSubview:label];
  }
}

- (void)setPageDate:(StockQuotationInfo *)info
        priceFormat:(NSString *)priceFormat {
  if (info == nil)
    return;
  PacketTableData *tableData = nil;
  PacketTableData *headData = nil;

  for (PacketTableData *obj in info.dataArray) {
    if ([obj.tableName isEqualToString:@"Top5Quotation"])
      tableData = obj;
    else if ([obj.tableName isEqualToString:@"CurStatus"]) {
      headData = obj;
    }
  }

  if (!tableData || [tableData.tableItemDataArray count] == 0)
    return;
  if (!headData || [headData.tableItemDataArray count] == 0)
    return;

  NSDictionary *dic = tableData.tableItemDataArray[0];
  NSDictionary *dicPrice = headData.tableItemDataArray[0];

  //普通股
  if (_isIndexStock == NO) {
    //收盘价格
    float closePrice = [dicPrice[@"closePrice"] floatValue];
    //卖5买5 价格
    NSArray *priceArray = [NSArray
        arrayWithObjects:
            [NSString
                stringWithFormat:priceFormat, [dic[@"sellPrice5"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"sellPrice4"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"sellPrice3"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"sellPrice2"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"sellPrice1"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"buyPrice1"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"buyPrice2"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"buyPrice3"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"buyPrice4"] floatValue]],
            [NSString
                stringWithFormat:priceFormat, [dic[@"buyPrice5"] floatValue]],
            nil];

    //卖5买5 手
    NSArray *handsArray = @[
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"sellAmount5"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"sellAmount4"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"sellAmount3"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"sellAmount2"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"sellAmount1"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"buyAmount1"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"buyAmount2"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"buyAmount3"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"buyAmount4"] longLongValue]],
      [StockUtil
          handsStringForS5B5FromVolume:[dic[@"buyAmount5"] longLongValue]]
    ];
    //取得买卖量的最大长度
    //        float maxWidth = [self getMaxWidthForArray:handsArray];
    CGFloat maxWidth = 35.f;
    //卖5
    // float f_sellPrice1=[Item.sellprice_Five floatValue];
    for (int i = 0; i < [_priceArray count]; i++) {
      //手
      UILabel *handsLabel = [_handsArray objectAtIndex:i];
      if (handsLabel) {
        handsLabel.text = [handsArray objectAtIndex:i];
        handsLabel.frame = CGRectMake(self.bounds.size.width - maxWidth - 2,
                                      handsLabel.frame.origin.y, maxWidth,
                                      handsLabel.bounds.size.height);
      }
      handsLabel.adjustsFontSizeToFitWidth = YES;
      //价格
      float curentPrice = [priceArray[i] floatValue];
      UILabel *priceLabel = _priceArray[i];
      priceLabel.textColor =
          [StockUtil getColorByFloat:(curentPrice - closePrice)];
      //查看是否停盘
      if ([dicPrice[@"state"] shortValue] == 1) {
        priceLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
      }
      if ([[handsArray objectAtIndex:i] longLongValue] == 0) {
        priceLabel.textColor = [Globle colorFromHexRGB:Color_Dark];
      }

      priceLabel.text = [priceArray objectAtIndex:i];
      priceLabel.frame =
          CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y,
                     handsLabel.frame.origin.x - priceLabel.frame.origin.x,
                     priceLabel.bounds.size.height);
      priceLabel.adjustsFontSizeToFitWidth = YES;
    }

  } else {
    //大盘指数
    //振幅计算
    float closePrice = [dicPrice[@"closePrice"] floatValue];
    if (closePrice == 0)
      closePrice = 0.1;
    float f_hightPrice = [dicPrice[@"highPrice"] floatValue];
    float f_lowerPrice = [dicPrice[@"lowPrice"] floatValue];
    float f_divideprice = f_hightPrice - f_lowerPrice;
    float f_amplitude = f_divideprice / closePrice * 100;
    NSString *profitStr = [NSString stringWithFormat:@"%.2f", f_amplitude];
    profitStr = [profitStr stringByAppendingString:@"%"];

    //上涨
    NSString *s_risePrice = [NSString
        stringWithFormat:@"%.0f", [dicPrice[@"closePrice"] floatValue]];
    //平盘
    NSString *s_flatPrice = [NSString
        stringWithFormat:@"%.0f", [dicPrice[@"closePrice"] floatValue]];
    //下跌
    NSString *s_fallPrice = [NSString
        stringWithFormat:@"%.0f", [dicPrice[@"closePrice"] floatValue]];

    NSArray *priceArray =
        [NSArray arrayWithObjects:@"", profitStr, s_risePrice, s_flatPrice,
                                  s_fallPrice, nil];

    //收盘价格

    for (int i = 0; i < [priceArray count]; i++) {

      UILabel *lable = [_handsArray objectAtIndex:i];
      lable.textColor = [Globle colorFromHexRGB:Color_Dark];
      lable.text = [priceArray objectAtIndex:i];
    }
  }
}
//从数组中，取得字符串的最大宽度
//- (CGFloat)getMaxWidthForArray:(NSArray *)contentArray {
//  UIFont *font = [UIFont systemFontOfSize:9];
//  float width = 0;
//
//  for (NSString *obj in contentArray) {
//    CGSize size = CGSizeZero;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//      size = [obj
//          sizeWithAttributes:[NSDictionary
//                                 dictionaryWithObject:font
//                                               forKey:NSFontAttributeName]];
//    } else {
//      size = [obj sizeWithFont:font];
//    }
//    if (size.width > width) {
//      width = size.width;
//    }
//  }
//  return width;
//}

- (void)setDapaPageDate:(NSMutableArray *)stocks {

  if (_isIndexStock == NO)
    return;
  int i = 5;
  for (StockInfo *obj in stocks) {
    //当前价格
    float newPrice = [obj.cornewPrices floatValue];
    //收盘价格
    float closePrice = [obj.closePrice floatValue];
    //标签
    if (i < [_handsArray count]) {
      UILabel *lable = _handsArray[i];
      lable.textColor = [StockUtil getColorByFloat:(newPrice - closePrice)];
      lable.text = obj.cornewPrices;
    }
    i++;
  }
}

#pragma mark
#pragma mark 对外接口
//清除所有数据
- (void)clearAllData {

  for (UILabel *lable in _priceArray) {
    lable.text = @"";
  }
  for (UILabel *lable in _handsArray) {
    lable.text = @"";
  }
}

@end
