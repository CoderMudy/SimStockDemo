//
//  topStockInfoView.m
//  SimuStock
//
//  Created by Mac on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "TopStockInfoView.h"
#import "StockUtil.h"

@implementation TopStockInfoView

@synthesize CenterOneValueLable = tsiv_CenterOneValueLable;
@synthesize CenterTowValueLable = tsiv_CenterTowValueLable;
@synthesize CenterthreeValueLable = tsiv_CenterthreeValueLable;

- (id)initWithFrame:(CGRect)frame IsDapa:(BOOL)isdapan {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    tsiv_CorIsTrend = isdapan;
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self creatViews];
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)creatViews {
  //背景
  UIImage *backimage = [[UIImage imageNamed:@"Trend_backGround_up.png"]
                        resizableImageWithCapInsets:UIEdgeInsetsMake(4, 9, 9, 9)];
  tsiv_backgroundImageView = [[UIImageView alloc] initWithImage:backimage];
  tsiv_backgroundImageView.frame = self.bounds;
  [self addSubview:tsiv_backgroundImageView];
  tsiv_backgroundImageView.hidden = YES;
  CGPoint pos = CGPointMake(0, 13);
  //创建当前价格
  tsiv_stockPriceLable = [[UILabel alloc]
                          initWithFrame:CGRectMake(pos.x + 3, pos.y, 340.f / 2, 38)];
  tsiv_stockPriceLable.backgroundColor = [UIColor clearColor];
  tsiv_stockPriceLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  tsiv_stockPriceLable.font = [UIFont boldSystemFontOfSize:48];
  tsiv_stockPriceLable.text = @"--";
  tsiv_stockPriceLable.textAlignment = NSTextAlignmentCenter;
  [self addSubview:tsiv_stockPriceLable];
  //创建涨跌价格
  tsiv_changePriceLable = [[UILabel alloc]
                           initWithFrame:CGRectMake(0 + 5,
                                                    tsiv_stockPriceLable.frame.origin.y +
                                                    tsiv_stockPriceLable.frame.size.height + 5,
                                                    340.f / 2, 16)];
  tsiv_changePriceLable.backgroundColor = [UIColor clearColor];
  tsiv_changePriceLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  tsiv_changePriceLable.font = [UIFont boldSystemFontOfSize:16];
  tsiv_changePriceLable.text = @"-- --";
  tsiv_changePriceLable.textAlignment = NSTextAlignmentCenter;
  [self addSubview:tsiv_changePriceLable];
  //创建涨跌幅度
  tsiv_profitPriceLable = [[UILabel alloc]
                           initWithFrame:CGRectMake(340.f / 4 - 5,
                                                    tsiv_stockPriceLable.frame.origin.y +
                                                    tsiv_stockPriceLable.frame.size.height + 5,
                                                    340.f / 4 - 5, 16)];
  tsiv_profitPriceLable.backgroundColor = [UIColor clearColor];
  tsiv_profitPriceLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  tsiv_profitPriceLable.font = [UIFont boldSystemFontOfSize:16];
  tsiv_profitPriceLable.text = @"--";
  tsiv_profitPriceLable.textAlignment = NSTextAlignmentLeft;
  [self addSubview:tsiv_profitPriceLable];
  tsiv_profitPriceLable.hidden = YES;
  
  //创建分割线
  tsiv_sepLineView = [[UIView alloc] init];
  tsiv_sepLineView.frame = CGRectMake(340.f / 2, pos.y - 7, 1, 72);
  tsiv_sepLineView.backgroundColor = [Globle colorFromHexRGB:@"#E0E0E1"];
  [self addSubview:tsiv_sepLineView];
  tsiv_sepLineView.hidden = YES;
  
  //建立左边两个名称和数值
  NSArray *nameArray = [NSArray
                        arrayWithObjects:@"最高", @"最低", @"量比", @"换手率", nil];
  CGRect NameLableRect = CGRectMake(
                                    370.f / 2, pos.y - 4, (self.bounds.size.width - 340.f / 2) / 2, 13);
  CGRect ValueLabeRect = CGRectMake(
                                    370.f / 2, pos.y + 11, (self.bounds.size.width - 340.f / 2) / 2, 13);
  CGFloat height = 72 / 2;
  CGFloat width = (self.bounds.size.width - 340.f / 2) / 2;
  for (int i = 0; i < 4; i++) {
    float m_moveWidth = 0;
    float m_moveHeight = 0;
    if (i == 0) {
      m_moveWidth = 0;
      m_moveHeight = 0;
    } else if (i == 1) {
      m_moveWidth = width;
      m_moveHeight = 0;
    } else if (i == 2) {
      m_moveWidth = 0;
      m_moveHeight = height;
    } else if (i == 3) {
      m_moveWidth = width;
      m_moveHeight = height;
    }
    //名称
    UILabel *nameLabe = [[UILabel alloc]
                         initWithFrame:CGRectOffset(NameLableRect, m_moveWidth, m_moveHeight)];
    nameLabe.backgroundColor = [UIColor clearColor];
    nameLabe.text = [nameArray objectAtIndex:i];
    nameLabe.textColor = [Globle colorFromHexRGB:Color_StockInfo_Name];
    nameLabe.textAlignment = NSTextAlignmentLeft;
    nameLabe.font = [UIFont systemFontOfSize:Font_Height_14_0];
    [self addSubview:nameLabe];
    //数值
    UILabel *ValueLabe = [[UILabel alloc]
                          initWithFrame:CGRectOffset(ValueLabeRect, m_moveWidth, m_moveHeight)];
    ValueLabe.backgroundColor = [UIColor clearColor];
    ValueLabe.text = @"--";
    ValueLabe.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    ValueLabe.textAlignment = NSTextAlignmentLeft;
    ValueLabe.font = [UIFont systemFontOfSize:Font_Height_13_0];
    [self addSubview:ValueLabe];
    
    if (i == 0) {
      tsiv_LeftOneNameLable = nameLabe;
      tsiv_LeftOneValueLable = ValueLabe;
    } else if (i == 1) {
      tsiv_rightOneNameLable = nameLabe;
      tsiv_rightOneValueLable = ValueLabe;
    } else if (i == 2) {
      tsiv_LeftTowNameLable = nameLabe;
      tsiv_LeftTowValueLable = ValueLabe;
    } else if (i == 3) {
      tsiv_rightTwoNameLable = nameLabe;
      tsiv_rightTwoValueLable = ValueLabe;
    }
  }
  
  //创建第一行三个值
  NSArray *nameRightArray = [NSArray
                             arrayWithObjects:@"今   开", @"昨   收", @"振   幅", @"内   盘",
                             @"外   盘", @"成交量", @"市盈率", @"成交额",
                             @"流通市值", nil];
  if (tsiv_CorIsTrend) {
    nameRightArray = [NSArray
                      arrayWithObjects:@"今   开", @"昨   收", @"成交额", @"上涨数",
                      @"平盘数", @"下跌数", @"市盈率", @"成交额",
                      @"流通市值", nil];
  }
  
  float m_width = self.bounds.size.width / 3;
  NameLableRect = CGRectMake(0, 82, m_width / 2, 14);
  ValueLabeRect = CGRectMake(m_width / 2, 82, m_width / 2, 14);
  CGRect rectname1 = CGRectZero;
  CGRect rectValue1 = CGRectZero;
  CGRect rectname2 = CGRectZero;
  CGRect rectValue2 = CGRectZero;
  CGRect rectname3 = CGRectZero;
  CGRect rectValue3 = CGRectZero;
  
  for (int i = 0; i < 9; i++) {
    float height = 17;
    if (i == 0) {
      rectname1 = NameLableRect = CGRectMake(0, 82, 40, 14);
      rectValue1 = ValueLabeRect = CGRectMake(40, 82, m_width - 50, 14);
    } else if (i == 1) {
      rectname2 = NameLableRect = CGRectMake(m_width, 82, 40, 14);
      rectValue2 = ValueLabeRect =
      CGRectMake(m_width + 40, 82, m_width - 50, 14);
      
    } else if (i == 2) {
      rectname3 = NameLableRect = CGRectMake(2 * m_width, 82, 55, 14);
      rectValue3 = ValueLabeRect =
      CGRectMake(2 * m_width + 55, 82, m_width - 55, 14);
    } else if (i == 3) {
      NameLableRect = CGRectOffset(rectname1, 0, height);
      ValueLabeRect = CGRectOffset(rectValue1, 0, height);
    } else if (i == 4) {
      NameLableRect = CGRectOffset(rectname2, 0, height);
      ValueLabeRect = CGRectOffset(rectValue2, 0, height);
    } else if (i == 5) {
      NameLableRect = CGRectOffset(rectname3, 0, height);
      ValueLabeRect = CGRectOffset(
                                   CGRectMake(rectValue3.origin.x - 12, rectValue3.origin.y,
                                              rectValue3.size.width + 12, rectValue3.size.height),
                                   0, height);
    } else if (i == 6) {
      NameLableRect = CGRectOffset(rectname1, 1, 2 * height);
      ValueLabeRect = CGRectOffset(rectValue1, 0, 2 * height);
    } else if (i == 7) {
      NameLableRect = CGRectOffset(rectname2, 0, 2 * height);
      ValueLabeRect = CGRectOffset(rectValue2, 0, 2 * height);
    } else if (i == 8) {
      NameLableRect = CGRectOffset(rectname3, 0, 2 * height);
      ValueLabeRect = CGRectOffset(rectValue3, 0, 2 * height);
    }
    //名称
    UILabel *nameLabe = [[UILabel alloc]
                         initWithFrame:NameLableRect]; // CGRectOffset(NameLableRect,
    // (i-k)*m_width, height)
    nameLabe.backgroundColor = [UIColor clearColor];
    nameLabe.text = [nameRightArray objectAtIndex:i];
    nameLabe.textColor = [Globle colorFromHexRGB:Color_StockInfo_Name];
    nameLabe.textAlignment = NSTextAlignmentRight;
    nameLabe.font = [UIFont systemFontOfSize:Font_Height_13_0];
    [self addSubview:nameLabe];
    //数值
    UILabel *ValueLabe = [[UILabel alloc]
                          initWithFrame:ValueLabeRect]; // CGRectOffset(ValueLabeRect,
    // (i-k)*m_width, height)
    ValueLabe.backgroundColor = [UIColor clearColor];
    ValueLabe.text = @"--";
    ValueLabe.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    ValueLabe.textAlignment = NSTextAlignmentRight;
    ValueLabe.font = [UIFont systemFontOfSize:Font_Height_12_0];
    [self addSubview:ValueLabe];
    
    if (i == 0) {
      tsiv_TopOneNameLable = nameLabe;
      tsiv_TopOneValueLable = ValueLabe;
      // ValueLabe.textAlignment = NSTextAlignmentCenter;
    } else if (i == 1) {
      tsiv_TopTowNameLable = nameLabe;
      tsiv_TopTowValueLable = ValueLabe;
      // ValueLabe.textAlignment = NSTextAlignmentCenter;
    } else if (i == 2) {
      tsiv_TopthreeNameLable = nameLabe;
      tsiv_TopthreeValueLable = ValueLabe;
      tsiv_TopthreeNameLable.textAlignment = NSTextAlignmentLeft;
    } else if (i == 3) {
      tsiv_CenterOneNameLable = nameLabe;
      tsiv_CenterOneValueLable = ValueLabe;
      // ValueLabe.textAlignment = NSTextAlignmentCenter;
    } else if (i == 4) {
      tsiv_CenterTowNameLable = nameLabe;
      tsiv_CenterTowValueLable = ValueLabe;
      // ValueLabe.textAlignment = NSTextAlignmentCenter;
    } else if (i == 5) {
      tsiv_CenterthreeNameLable = nameLabe;
      tsiv_CenterthreeValueLable = ValueLabe;
      tsiv_CenterthreeNameLable.textAlignment = NSTextAlignmentLeft;
    } else if (i == 6) {
      tsiv_bottomOneNameLable = nameLabe;
      tsiv_bottomOneValueLable = ValueLabe;
      // ValueLabe.textAlignment = NSTextAlignmentCenter;
    } else if (i == 7) {
      tsiv_bottomTowNameLable = nameLabe;
      tsiv_bottomTowValueLable = ValueLabe;
      
    } else if (i == 8) {
      tsiv_bottomThreeNameLable = nameLabe;
      tsiv_bottomThreeValueLable = ValueLabe;
      tsiv_bottomThreeNameLable.textAlignment = NSTextAlignmentLeft;
    }
  }
  
  if (tsiv_CorIsTrend) {
    //市盈率
    tsiv_bottomOneNameLable.hidden = YES;
    tsiv_bottomOneValueLable.hidden = YES;
    //成交额
    tsiv_bottomTowNameLable.hidden = YES;
    tsiv_bottomTowValueLable.hidden = YES;
    //流通市值
    tsiv_bottomThreeNameLable.hidden = YES;
    tsiv_bottomThreeValueLable.hidden = YES;
    
  } else {
    //市盈率
    tsiv_bottomOneNameLable.hidden = NO;
    tsiv_bottomOneValueLable.hidden = NO;
    //成交额
    tsiv_bottomTowNameLable.hidden = NO;
    tsiv_bottomTowValueLable.hidden = NO;
    //流通市值
    tsiv_bottomThreeNameLable.hidden = NO;
    tsiv_bottomThreeValueLable.hidden = NO;
  }
}
//设定个股报价信息
- (void)setHeadStcokInfo:(StockQuotationInfo *)Item IsDapan:(BOOL)isdapan {
  if (Item == nil)
    return;
  tsiv_CorIsTrend = isdapan;
  //个股信息
  PacketTableData *m_paketTableData = nil;
  //买卖5档
  PacketTableData *m_paketFiveTableData = nil;
  
  for (PacketTableData *obj in Item.dataArray) {
    if ([obj.tableName isEqualToString:@"CurStatus"])
      m_paketTableData = obj;
    else if ([obj.tableName isEqualToString:@"Top5Quotation"]) {
      m_paketFiveTableData = obj;
    }
  }
  if (nil == m_paketTableData ||
      [m_paketTableData.tableItemDataArray count] == 0)
    return;
  NSDictionary *dic = m_paketTableData.tableItemDataArray[0];
  NSDictionary *five_dic = nil;
  if (nil == m_paketFiveTableData ||
      [m_paketFiveTableData.tableItemDataArray count] > 0) {
    five_dic = m_paketFiveTableData.tableItemDataArray[0];
  }
  
  //收盘价格
  CGFloat closePrice = [dic[@"closePrice"] floatValue];
  CGFloat newprice = [dic[@"curPrice"] floatValue];
  //最新价格
  
  NSString *curPrice = [NSString stringWithFormat:@"%.2f", newprice];
  UIColor *color;
  //查看是否停盘
  if ([dic[@"state"] shortValue] == 1) {
    color = [Globle colorFromHexRGB:Color_Text_Common];
  } else if ([@"0.00" isEqualToString:curPrice]) {
    color = [Globle colorFromHexRGB:Color_Text_Common];
  } else {
    color = [StockUtil getColorByFloat:(newprice - closePrice)];
  }
  tsiv_stockPriceLable.textColor = color;
  tsiv_stockPriceLable.text = curPrice;
  
  if (tsiv_stockPriceLable.text.length > 6) {
    tsiv_stockPriceLable.font = [UIFont boldSystemFontOfSize:40];
    //    NSLog(@"-------------------长度大于6的时候size
    //    30-------------------");
  } else if (tsiv_stockPriceLable.text.length <= 6) {
    tsiv_stockPriceLable.font = [UIFont boldSystemFontOfSize:50];
    //    NSLog(@"-------------------长度小于5的时候size
    //    50-------------------");
  }
  
  //涨跌
  tsiv_changePriceLable.textColor = color;
  CGFloat f_updownprice = [dic[@"change"] floatValue];
  float f_profitPrice = [dic[@"changePer"] floatValue];
  tsiv_changePriceLable.text = [NSString
                                stringWithFormat:@"%+0.2f       %+0.2f%%", f_updownprice, f_profitPrice];
  //涨幅changePer
  // tsiv_profitPriceLable.textColor = color;
  
  // tsiv_profitPriceLable.text =[NSString stringWithFormat:@"%+0.2f%%",
  // f_profitPrice];
  
  if (tsiv_CorIsTrend == NO) {
    //个股
    //最高
    tsiv_LeftOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"highPrice"] floatValue]];
    //最低
    tsiv_rightOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"lowPrice"] floatValue]];
    //量比
    tsiv_LeftTowNameLable.text = @"量比";
    tsiv_LeftTowValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"amountScale"] floatValue]];
    //换手率
    tsiv_rightTwoNameLable.text = @"换手率";
    tsiv_rightTwoValueLable.text =
    [NSString stringWithFormat:@"%.2f%@", [dic[@"hsPer"] floatValue], @"%"];
    //今开
    tsiv_TopOneNameLable.hidden = NO;
    tsiv_TopOneValueLable.hidden = NO;
    tsiv_TopOneNameLable.text = @"今   开";
    tsiv_TopOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"openPrice"] floatValue]];
    //昨收
    tsiv_TopTowValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"closePrice"] floatValue]];
    //振幅
    tsiv_TopthreeNameLable.hidden = NO;
    tsiv_TopthreeValueLable.hidden = NO;
    tsiv_TopthreeValueLable.text =
    [NSString stringWithFormat:@"%.2f%@", [dic[@"zfPer"] floatValue], @"%"];
    //内盘
    tsiv_CenterOneNameLable.hidden = NO;
    tsiv_CenterOneNameLable.text = @"内   盘";
    tsiv_CenterOneValueLable.hidden = NO;
    tsiv_CenterOneValueLable.text =
    [self getVolumFormDic:dic WithKey:@"inAmount"];
    //外盘
    tsiv_CenterTowNameLable.hidden = NO;
    tsiv_CenterTowNameLable.text = @"外   盘";
    tsiv_CenterTowValueLable.hidden = NO;
    tsiv_CenterTowValueLable.text =
    [self getVolumFormDic:dic WithKey:@"outAmount"];
    //成交量
    tsiv_CenterthreeNameLable.hidden = NO;
    tsiv_CenterthreeNameLable.text = @"成交量";
    tsiv_CenterthreeValueLable.hidden = NO;
    tsiv_CenterthreeValueLable.text =
    [[self getMarketFlowValue:dic WithKey:@"totalAmount"]
     stringByAppendingString:@"手"];
    //市盈率
    tsiv_bottomOneNameLable.hidden = NO;
    tsiv_bottomOneNameLable.text = @"市盈率";
    tsiv_bottomOneValueLable.hidden = NO;
    tsiv_bottomOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"revenue"] floatValue]];
    //成交额
    tsiv_bottomTowNameLable.hidden = NO;
    tsiv_bottomTowNameLable.text = @"成交额";
    tsiv_bottomTowValueLable.hidden = NO;
    tsiv_bottomTowValueLable.text =
    [self getMarketFlowValue:dic WithKey:@"totalMoney"];
    //流通市值
    tsiv_bottomThreeNameLable.hidden = NO;
    tsiv_bottomThreeNameLable.text = @"流通市值";
    tsiv_bottomThreeValueLable.hidden = NO;
    tsiv_bottomThreeValueLable.text =
    [self getMarketFlowValue:dic WithKey:@"outShare"];
    
  } else {
    //大盘
    //最高
    tsiv_LeftOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"highPrice"] floatValue]];
    //最低
    tsiv_rightOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"lowPrice"] floatValue]];
    //量比
    tsiv_LeftTowNameLable.text = @"量比";
    tsiv_LeftTowValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"amountScale"] floatValue]];
    //振幅
    tsiv_rightTwoNameLable.text = @"振幅";
    tsiv_rightTwoValueLable.text =
    [NSString stringWithFormat:@"%.2f%@", [dic[@"zfPer"] floatValue], @"%"];
    
    ;
    //今开
    tsiv_TopOneNameLable.hidden = NO;
    tsiv_TopOneValueLable.hidden = NO;
    tsiv_TopOneNameLable.text = @"今   开";
    tsiv_TopOneValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"openPrice"] floatValue]];
    //昨收
    tsiv_TopTowValueLable.text =
    [NSString stringWithFormat:@"%.2f", [dic[@"closePrice"] floatValue]];
    //成交额
    tsiv_TopthreeNameLable.hidden = NO;
    tsiv_TopthreeNameLable.text = @"成交额";
    tsiv_TopthreeValueLable.text =
    [self getMarketFlowValue:dic WithKey:@"totalMoney"];
    //上涨数
    tsiv_CenterOneNameLable.hidden = NO;
    tsiv_CenterOneNameLable.text = @"上涨数";
    tsiv_CenterOneValueLable.hidden = NO;
    tsiv_CenterOneValueLable.text = [NSString
                                     stringWithFormat:@"%.0f", [five_dic[@"buyPrice1"] floatValue]];
    //平盘数
    tsiv_CenterTowNameLable.hidden = NO;
    tsiv_CenterTowNameLable.text = @"平盘数";
    tsiv_CenterTowValueLable.hidden = NO;
    tsiv_CenterTowValueLable.text =
    [NSString stringWithFormat:@"%.0f", [dic[@"revenue"] floatValue]];
    //下跌数
    tsiv_CenterthreeNameLable.hidden = NO;
    tsiv_CenterthreeNameLable.text = @"下跌数";
    tsiv_CenterthreeValueLable.hidden = NO;
    tsiv_CenterthreeValueLable.text = [NSString
                                       stringWithFormat:@"%.0f", [five_dic[@"sellPrice1"] floatValue]];
    
    //市盈率
    tsiv_bottomOneNameLable.hidden = YES;
    tsiv_bottomOneValueLable.hidden = YES;
    //成交额
    tsiv_bottomTowNameLable.hidden = YES;
    tsiv_bottomTowValueLable.hidden = YES;
    //流通市值
    tsiv_bottomThreeNameLable.hidden = YES;
    tsiv_bottomThreeValueLable.hidden = YES;
  }
}
//成交量，内外盘量等得计算
- (NSString *)getVolumFormDic:(NSDictionary *)dic WithKey:(NSString *)strkey {
  NSString *amount_money = nil;
  if ([dic[strkey] longLongValue] >= 100000000L) {
    float d_amount =
    ((double)[dic[strkey] longLongValue]) / ((double)100000000);
    amount_money = [NSString stringWithFormat:@"%.2f亿", d_amount];
  } else if ([dic[strkey] longLongValue] >= 10000) {
    NSString *roundAmountStr = [NSString
                                stringWithFormat:@"%ld",
                                (long)round(
                                            ((double)[dic[strkey] longLongValue] / 10000))];
    //如果整数部分大于等于3位，则四舍五入并只显示整数部分
    if (roundAmountStr.length >= 3) {
      amount_money = [NSString stringWithFormat:@"%@万", roundAmountStr];
    } else {
      float d_amount = ((double)[dic[strkey] longLongValue]) / ((double)10000);
      amount_money = [NSString stringWithFormat:@"%.2f万", d_amount];
    }
  } else {
    double d_amount = [dic[strkey] longLongValue];
    amount_money = [NSString stringWithFormat:@"%.0f", d_amount];
  }
  return amount_money;
}

//流通市值计算(用四舍五入等方法，防止字符串过长)
- (NSString *)getMarketFlowValue:(NSDictionary *)dic
                         WithKey:(NSString *)strkey {
  NSString *amount_value = nil;
  
  if ([dic[strkey] longLongValue] >= 100000000) {
    float d_amount =
    ((double)[dic[strkey] longLongValue]) / ((double)100000000);
    
    NSString *roundAmountStr =
    [NSString stringWithFormat:@"%ld", (long)round(d_amount)];
    //如果整数部分大于等于3位，则四舍五入并只显示整数部分
    if (roundAmountStr.length >= 3) {
      amount_value = [NSString stringWithFormat:@"%@亿", roundAmountStr];
    } else {
      amount_value = [NSString stringWithFormat:@"%.1f亿", d_amount];
    }
  } else if ([dic[strkey] longLongValue] >= 10000) {
    float d_amount = ((double)[dic[strkey] longLongValue]) / (double)10000;
    
    NSString *roundAmountStr =
    [NSString stringWithFormat:@"%ld", (long)round(d_amount)];
    //如果整数部分大于等于4位，则四舍五入并只显示整数部分
    if (roundAmountStr.length >= 3) {
      amount_value = [NSString stringWithFormat:@"%@万", roundAmountStr];
    } else {
      amount_value = [NSString stringWithFormat:@"%.1f万", d_amount];
    }
  } else {
    long d_amount = [dic[strkey] longLongValue];
    amount_value = [NSString stringWithFormat:@"%lu", d_amount];
  }
  return amount_value;
}

//取得最新价格
- (NSString *)getNewPrice {
  if (tsiv_stockPriceLable) {
    return tsiv_stockPriceLable.text;
  }
  return Nil;
}
//取得涨跌幅
- (NSString *)getProfit {
  if (tsiv_changePriceLable) {
    NSArray *array =
    [tsiv_changePriceLable.text componentsSeparatedByString:@" "];
    return [array objectAtIndex:MAX(([array count] - 1), 0)];
  }
  return nil;
}
- (NSString *)getUpDownPrice {
  if (tsiv_changePriceLable) {
    return tsiv_changePriceLable.text;
  }
  return nil;
}
//清除数据
- (void)clearallData {
  //当前价格
  tsiv_stockPriceLable.text = @"--";
  //当前涨跌价格
  tsiv_changePriceLable.text = @"-- --";
  //当前涨跌幅度
  tsiv_profitPriceLable.text = @"--";
  //左一数值
  tsiv_LeftOneValueLable.text = @"";
  //左二数值
  tsiv_LeftTowValueLable.text = @"";
  //右一数值
  tsiv_rightOneValueLable.text = @"";
  //右二数值
  tsiv_rightTwoValueLable.text = @"";
  
  //上方第一行第一列数值
  tsiv_TopOneValueLable.text = @"";
  //上方第一行第二列数值
  tsiv_TopTowValueLable.text = @"";
  //上方第一行第三列数值
  tsiv_TopthreeValueLable.text = @"";
  
  //上方第二行第一列数值
  tsiv_CenterOneValueLable.text = @"";
  //上方第一行第二列数值
  tsiv_CenterTowValueLable.text = @"";
  //上方第一行第三列数值
  tsiv_CenterthreeValueLable.text = @"";
}

@end
