//
//  SimuTableDataResouce.m
//  SimuStock
//
//  Created by Mac on 13-8-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuTableDataResouce.h"
#import "StockEntrust.h"
#import "StockUtil.h"
#import "RealTradeTodayEntrust.h"

#define Color_Common [Globle colorFromHexRGB:Color_Text_Common]

@implementation SimuTableItem

@end
//*****************************SimuTableDataResouce*******************************************************************
@implementation SimuTableDataResouce

@synthesize HeadHeight = stdr_HeadHeight;
@synthesize FirstColWidth = stdr_FirstColWidth;
@synthesize LineHeight = stdr_LineHeight;
@synthesize CelWidthArray = stdr_CelWidthArray;
@synthesize allcolWidth = stdr_allcolWidth;
@synthesize allHeight = stdr_allHeight;
@synthesize LineNumber = stdr_LineNumber;
@synthesize ColNumber = stdr_ColNumber;
@synthesize checkBoxViewArray = stdr_checkBoxViewArray;
@synthesize delegate = _delegate;
@synthesize isSelfStockReset = sit_isSelfStockReset;

- (id)initWithIdentifier:(NSString *)indentifier {
  self = [self init];
  if (self) {
    self.viewIndentifier = indentifier;
    [self establishNavigationBarWithIndentifier:indentifier];
  }
  return self;
}

- (id)init {
  self = [super init];
  if (self) {
    sit_isAnimationRuning = NO;
    sit_isSelfStockType = NO;
    stdr_ColNumber = 0;
    stdr_LineNumber = 0;
    stdr_HeadHeight = 0;
    stdr_LineHeight = 0;
    stdr_FirstColWidth = 0;
    stdr_TotelSpaceWidth = 20;
    sit_isRsetSequence = NO;
    sit_isSelfStockReset = 0;
    sit_cor = -1;
    sit_state = -1;
    //其他列列宽
    stdr_CelWidthArray = [[NSMutableArray alloc] init];
    //标题头内容
    stdr_HeadContentArray = [[NSMutableArray alloc] init];
    //有排列按钮的信息数据
    sit_headListSequenceArray = [[NSMutableArray alloc] init];
    //排列按钮的箭头
    sit_headArrowImageViewArray = [[NSMutableArray alloc] init];
    stdr_headBaseViewArray = [[NSMutableArray alloc] init];

    //内容
    stdr_CellArray = [[NSMutableArray alloc] init];
    //复选框按钮数组
    stdr_checkBoxViewArray = [[NSMutableArray alloc] init];
    //设置字体
    sit_Font = [UIFont systemFontOfSize:15];
  }
  return self;
}
- (void)dealloc {

  [stdr_checkBoxViewArray removeAllObjects];
}

#pragma mark
#pragma mark 数据赋值 计算

- (void)resetParamerters {
  sit_isRsetSequence = NO;
  sit_isSelfStockReset++;
  stdr_ColNumber = 0;
  stdr_LineNumber = 0;
  stdr_HeadHeight = 0;
  stdr_LineHeight = 0;
  stdr_FirstColWidth = 0;
  stdr_TotelSpaceWidth = 20;
  [stdr_checkBoxViewArray removeAllObjects];
  [stdr_CelWidthArray removeAllObjects];
  [stdr_HeadContentArray removeAllObjects];
  [stdr_CellArray removeAllObjects];
}

/**重置列宽、边宽、总高度 */
- (void)resetColumnWidthAndHeightsWithMinWidth:(int)minWidth {
  //列宽赋初始值 如果没有内容 初始化的宽度 原始宽高
  for (id temp_obj in stdr_HeadContentArray) {
    NSString *obj = [SimuUtil changeIDtoStr:temp_obj];
    CGSize size = [obj sizeWithFont:sit_Font];
    CGFloat width = size.width;
    if (width < minWidth) {
      width = minWidth;
    }
    NSNumber *number = @(width);
    //计算列宽
    [stdr_CelWidthArray addObject:number];
  }

  //计算各个列的最大列宽
  for (NSArray *array in stdr_CellArray) {
    for (int i = 0; i < [array count]; i++) {
      //当前该列的最大值
      NSNumber *m_number = stdr_CelWidthArray[i];
      SimuTableItem *Item = array[i];
      CGSize size = [[SimuUtil changeIDtoStr:Item.contentone] sizeWithFont:sit_Font];
      if (size.width > [m_number floatValue]) {
        stdr_CelWidthArray[i] = @(size.width);
      }
    }
  }
  //加入边宽
  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
  for (NSNumber *obj in stdr_CelWidthArray) {
    NSNumber *number = @([obj floatValue] + stdr_TotelSpaceWidth);
    [tempArray addObject:number];
  }
  [stdr_CelWidthArray removeAllObjects];
  [stdr_CelWidthArray addObjectsFromArray:tempArray];
  [tempArray removeAllObjects];
  //第一列列宽
  stdr_FirstColWidth = [stdr_CelWidthArray[0] floatValue];
  //右侧列总长度
  stdr_allcolWidth = 0;
  for (int i = 1; i < [stdr_CelWidthArray count]; i++) {
    stdr_allcolWidth += [stdr_CelWidthArray[i] floatValue];
  }
  //总高度
  stdr_allHeight = stdr_LineHeight * [stdr_CellArray count];
}

///重新计算宽度
- (void)reCalculationWidth {
  //计算各个列的最大列宽
  for (NSArray *array in stdr_CellArray) {
    for (int i = 0; i < [array count]; i++) {
      //当前该列的最大值
      NSNumber *m_number = stdr_CelWidthArray[i];
      SimuTableItem *Item = array[i];
      CGSize size = [[SimuUtil changeIDtoStr:Item.contentone] sizeWithFont:sit_Font];
      if (size.width > [m_number floatValue]) {
        stdr_CelWidthArray[i] = @(size.width);
      }
    }
  }
  //加入边宽
  NSMutableArray *tempArray = [[NSMutableArray alloc] init];
  for (NSNumber *obj in stdr_CelWidthArray) {
    NSNumber *number = @([obj floatValue] + stdr_TotelSpaceWidth);
    [tempArray addObject:number];
  }
  [stdr_CelWidthArray removeAllObjects];
  [stdr_CelWidthArray addObjectsFromArray:tempArray];
  [tempArray removeAllObjects];
  //第一列列宽
  stdr_FirstColWidth = [stdr_CelWidthArray[0] floatValue];
  //右侧列总长度
  stdr_allcolWidth = 0;
  for (int i = 1; i < [stdr_CelWidthArray count]; i++) {
    stdr_allcolWidth += [stdr_CelWidthArray[i] floatValue];
  }
  //总高度
  stdr_allHeight = stdr_LineHeight * [stdr_CellArray count];
}

/**
 *  创建导航栏  今日成交 今日委托  历史数据
 */
- (void)establishNavigationBarWithIndentifier:(NSString *)indentifier {
  [stdr_CelWidthArray removeAllObjects];
  NSArray *array = nil;
  if ([indentifier isEqualToString:@"今日委托"]) {
    // clang-format off
    array = @[ @"撤单", @"状态", @"股票名称", @"操作类型", @"委托价格", @"委托数量", @"委托时间" ];
    // clang-format on
  } else if ([indentifier isEqualToString:@"今日成交"] ||
             [indentifier isEqualToString:@"历史成交"]) {
    array = @[ @"操作", @"股票名称", @"成交价格", @"成交数量", @"成交时间" ];
  }
  //列数赋值
  stdr_ColNumber = [array count];
  //头说明行高
  stdr_HeadHeight = 36;
  //普通行行高
  stdr_LineHeight = 47;
  //字体高度
  CGSize size = [@"大" sizeWithFont:sit_Font];
  stdr_FontHeight = size.height;
  [stdr_HeadContentArray removeAllObjects];
  [stdr_HeadContentArray addObjectsFromArray:array];
  [self resetColumnWidthAndHeightsWithMinWidth:0];
  //[self reCalculationWidth];
}

//今日成交
- (void)resetDealList:(NSObject *)list withBool:(BOOL)isCapital {
  [self resetParamerters];

  RealTradeDealList *realList = nil;
  WFTodayJosnData *todayData = nil;
  if (isCapital == YES) {
    realList = (RealTradeDealList *)list;
  } else {
    todayData = (WFTodayJosnData *)list;
  }

  //行赋值
  NSInteger number = isCapital == YES ? [realList.list count] : [todayData.todayDataMutableArray count];
  if (number == 0) {
    [self establishNavigationBarWithIndentifier:@"今日成交"];
    return;
  }
  stdr_LineNumber = number;
  //内容赋值
  [stdr_CellArray removeAllObjects];
  int row = 0;
  int col = 0;

  if (isCapital) {
    for (RealTradeTodayDealItem *obj in realList.list) {
      NSMutableArray *lineArray = [[NSMutableArray alloc] init];
      //操作
      col = 0;
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:obj.type
                               withColor:Color_Common];

      //股票名称
      [self addTwoLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                          withContentOne:obj.stockName
                            withColorOne:Color_Common
                          withContentTwo:obj.stockCode
                            withColorTwo:[Globle colorFromHexRGB:Color_Yellow]
                               withEqual:NO];

      //成交价格
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:obj.price
                               withColor:Color_Common];

      //成交数量
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:[SimuUtil changeIDtoStr:obj.amount]
                               withColor:Color_Common];

      //成交时间
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:[SimuUtil changeIDtoStr:obj.time]
                               withColor:Color_Common];

      row++;
      if (nil != lineArray) {
        [stdr_CellArray addObject:lineArray];
      }
    }
  } else {
    for (RealTradeTodayEntrustItem *todayObj in todayData.todayDataMutableArray) {
      NSMutableArray *toadayArray = [NSMutableArray array];

      //操作
      col = 0;
      [self addOneLineItemWithCollection:toadayArray
                                 withRow:row
                              withColumn:col++
                             withContent:todayObj.type
                               withColor:Color_Common];

      //股票名称
      [self addTwoLineItemWithCollection:toadayArray
                                 withRow:row
                              withColumn:col++
                          withContentOne:todayObj.stockName
                            withColorOne:Color_Common
                          withContentTwo:todayObj.stockCode
                            withColorTwo:[Globle colorFromHexRGB:Color_Yellow]
                               withEqual:NO];

      //成交价格
      [self addOneLineItemWithCollection:toadayArray
                                 withRow:row
                              withColumn:col++
                             withContent:todayObj.price
                               withColor:Color_Common];

      //成交数量
      NSNumber *num = [NSNumber numberWithLongLong:todayObj.amount];
      [self addOneLineItemWithCollection:toadayArray
                                 withRow:row
                              withColumn:col++
                             withContent:[SimuUtil changeIDtoStr:num]
                               withColor:Color_Common];

      //成交时间
      NSArray *array = [todayObj.time componentsSeparatedByString:@" "];
      [self addTwoLineItemWithCollection:toadayArray
                                 withRow:row
                              withColumn:col++
                          withContentOne:array[0]
                            withColorOne:Color_Common
                          withContentTwo:array[1]
                            withColorTwo:Color_Common
                               withEqual:YES];
      row++;
      if (nil != toadayArray) {
        [stdr_CellArray addObject:toadayArray];
      }
    }
  }
  [self establishNavigationBarWithIndentifier:@"今日成交"];
}

#pragma mark - 配资历史成交数据
- (void)bindHistoryData:(NSMutableArray *)historyDataArray {

  [self resetParamerters];
  if (historyDataArray.count == 0) {
    [self establishNavigationBarWithIndentifier:@"历史成交"];
    return;
  }

  //行赋值
  stdr_LineNumber = historyDataArray.count;
  //内容赋值
  [stdr_CellArray removeAllObjects];
  int row = 0;
  int col = 0;
  for (WFHistoryInfoMode *obj in historyDataArray) {
    NSMutableArray *lineArray = [[NSMutableArray alloc] init];
    //操作
    col = 0;
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:obj.entrustDirection
                             withColor:Color_Common];

    //股票名称
    [self addTwoLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                        withContentOne:obj.stockName
                          withColorOne:Color_Common
                        withContentTwo:obj.stockCode
                          withColorTwo:[Globle colorFromHexRGB:Color_Yellow]
                             withEqual:NO];

    //成交价格
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:obj.businessPrice
                             withColor:Color_Common];

    //成交数量
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:[SimuUtil changeIDtoStr:obj.businessAmount]
                             withColor:Color_Common];

    //成交时间
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:[SimuUtil changeIDtoStr:obj.businessTime]
                             withColor:Color_Common];
    row++;
    if (nil != lineArray) {
      [stdr_CellArray addObject:lineArray];
    }
  }
  //重新计算 宽和高
  [self establishNavigationBarWithIndentifier:@"历史成交"];
}

//撤单列表
- (void)resetRevokeList:(NSMutableArray *)dataArray {
  [self resetParamerters];
  if (dataArray.count == 0) {
    [self establishNavigationBarWithIndentifier:@"今日委托"];
    return;
  }

  //行赋值
  stdr_LineNumber = [dataArray count];
  //内容赋值
  [stdr_CellArray removeAllObjects];
  int row = 0;
  int col = 0;
  for (id<EntrustItem> obj in dataArray) {
    NSMutableArray *lineArray = [[NSMutableArray alloc] init];
    //撤单复选框
    col = 0;
    SimuTableItem *m_tabItme = [[SimuTableItem alloc] init];
    m_tabItme.row = row;
    m_tabItme.col = col;
    m_tabItme.canSelected = [obj canSelected];
    m_tabItme.lineMode = USCC_Mode_CheckBox;
    [lineArray addObject:m_tabItme];
    col++;

    //状态
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:[obj status]
                             withColor:Color_Common];

    //股票名称
    [self addTwoLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                        withContentOne:[obj stockName]
                          withColorOne:Color_Common
                        withContentTwo:[obj stockCode]
                          withColorTwo:[Globle colorFromHexRGB:Color_Yellow]
                             withEqual:NO];

    //操作类型
    NSString *marketFiexdType = [obj catagoryMarketFiexd];
    if (![marketFiexdType isEqualToString:@""]) {
      [self addTwoLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                          withContentOne:[obj catagoryMarketFiexd]
                            withColorOne:Color_Common
                          withContentTwo:[obj type]
                            withColorTwo:Color_Common
                               withEqual:YES];
    } else {
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:[obj type]
                               withColor:Color_Common];
    }
    //委托价格
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:[obj price]
                             withColor:Color_Common];

    //委托数量
    [self addOneLineItemWithCollection:lineArray
                               withRow:row
                            withColumn:col++
                           withContent:[obj amountString]
                             withColor:Color_Common];

    //委托时间
    //区分两行
    if ([obj dateString] && [[obj dateString] length] > 0) {
      [self addTwoLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                          withContentOne:[obj dateString]
                            withColorOne:Color_Common
                          withContentTwo:[obj timeString]
                            withColorTwo:Color_Common
                               withEqual:YES];
    } else {
      //单行
      [self addOneLineItemWithCollection:lineArray
                                 withRow:row
                              withColumn:col++
                             withContent:[obj timeString]
                               withColor:Color_Common];
    }
    row++;
    if (nil != lineArray) {
      [stdr_CellArray addObject:lineArray];
    }
  }

  [self establishNavigationBarWithIndentifier:@"今日委托"];
}

- (void)setPagedata:(SimuPageData *)pagedata {
  [self resetParamerters];

  if (pagedata == nil)
    return;

  if (pagedata.pagetype == DataPageType_Market_GetStockInfo) {
    sit_isSelfStockType = NO;
    sit_isRsetSequence = YES;
    //自选股信息
    CustomPageData *m_pagedata = (CustomPageData *)pagedata;
    //持仓数据页面解析
    //列数赋值
    stdr_ColNumber = 11;
    //行赋值
    stdr_LineNumber = [m_pagedata.stockTrendArray count];
    //头说明行高
    stdr_HeadHeight = 36;
    //普通行行高
    stdr_LineHeight = 47;
    //字体高度
    CGSize size = [@"大" sizeWithFont:sit_Font];
    stdr_FontHeight = size.height;

    //头名称赋值
    NSArray *array = @[
      @"股票名称",
      @"最新价  ",
      @"涨幅  ",
      @"涨跌  ",
      @"总量  ",
      @"总额  ",
      @"今开",
      @"昨收",
      @"最高",
      @"最低",
      @"振幅  "
    ];
    [stdr_HeadContentArray removeAllObjects];
    [stdr_HeadContentArray addObjectsFromArray:array];
    //头名称设置排序按钮纪录
    NSArray *squene = @[ @"0", @"1", @"1", @"1", @"1", @"1", @"0", @"0", @"0", @"0", @"1" ];
    [sit_headListSequenceArray removeAllObjects];
    [sit_headListSequenceArray addObjectsFromArray:squene];

    //内容赋值
    [stdr_CellArray removeAllObjects];
    int row = 0;
    int col = 0;
    for (StockInfo *obj in m_pagedata.stockTrendArray) {
      NSMutableArray *lineArray = [[NSMutableArray alloc] init];
      //股票名称
      col = 0;
      SimuTableItem *m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.stockname;
      m_tabItme.contenttwo = obj.stockCode;
      m_tabItme.lineMode = USCC_Mode_TwoLine;
      m_tabItme.colorMode = Color_Common;
      m_tabItme.twocolorMode = [Globle colorFromHexRGB:Color_Yellow];
      [lineArray addObject:m_tabItme];
      col++;
      //昨收价格
      float f_tempclosePrice = [obj.closePrice isEqualToString:@"--"] ? 0 : [obj.closePrice floatValue];
      float f_newestPrice = [obj.cornewPrices isEqualToString:@"--"] ? 0 : [obj.cornewPrices floatValue];
      UIColor *stockColor = [StockUtil getColorByFloat:(f_newestPrice - f_tempclosePrice)];
      //最新价格
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.cornewPrices;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.cornewPrices isEqualToString:@"--"] ? Color_Common : stockColor;

      [lineArray addObject:m_tabItme];
      col++;
      //涨幅
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.gains;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.gains isEqualToString:@"--"] ? Color_Common : stockColor;
      [lineArray addObject:m_tabItme];
      col++;
      //涨跌
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.updownValue;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.updownValue isEqualToString:@"--"] ? Color_Common : stockColor;
      [lineArray addObject:m_tabItme];
      col++;
      //总量
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.allVolume;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = Color_Common;
      [lineArray addObject:m_tabItme];
      col++;
      //总额
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.allAutome;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = Color_Common;
      [lineArray addObject:m_tabItme];
      col++;
      //今开
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.openPrice;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.openPrice isEqualToString:@"--"] ? Color_Common : stockColor;
      [lineArray addObject:m_tabItme];
      col++;
      //昨收
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.closePrice;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = Color_Common;
      [lineArray addObject:m_tabItme];
      //最高
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.hightPrice;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.hightPrice isEqualToString:@"--"] ? Color_Common : stockColor;
      [lineArray addObject:m_tabItme];
      col++;
      //最低
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.lowestPrice;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = [obj.lowestPrice isEqualToString:@"--"] ? Color_Common : stockColor;
      [lineArray addObject:m_tabItme];
      col++;
      //振幅
      m_tabItme = [[SimuTableItem alloc] init];
      m_tabItme.row = row;
      m_tabItme.col = col;
      m_tabItme.contentone = obj.amplitude;
      m_tabItme.lineMode = USCC_Mode_OneLine;
      m_tabItme.colorMode = Color_Common;
      [lineArray addObject:m_tabItme];

      row++;
      if (nil != lineArray) {
        [stdr_CellArray addObject:lineArray];
      }
    }
    [stdr_CelWidthArray removeAllObjects];
    [self resetColumnWidthAndHeightsWithMinWidth:60];
  }
}

#pragma mark
#pragma mark 得到各个cell的标签 （不包括名称标签）
- (UIView *)getTableCellLable:(NSInteger)row Column:(NSInteger)col {
  if (stdr_CellArray == nil || [stdr_CellArray count] == 0)
    return nil;
  if ([stdr_CellArray count] <= row || stdr_ColNumber <= col)
    return nil;
  if ([stdr_CelWidthArray count] <= col)
    return nil;

  CGPoint startPos = CGPointMake(stdr_TotelSpaceWidth / 4, 7);
  CGFloat frameHeight = stdr_LineHeight - 16;
  CGFloat frameWidth = stdr_TotelSpaceWidth / 2;

  SimuTableItem *m_tableItem = stdr_CellArray[row][col];
  //当为第一列时
  CGRect backRect = CGRectZero;
  if (col == 0)
    backRect = CGRectMake(0, stdr_LineHeight * row, stdr_FirstColWidth, stdr_LineHeight);
  else {
    CGFloat m_width = [stdr_CelWidthArray[col] floatValue];
    CGFloat m_startwidth = 0;
    for (int i = 1; i < col; i++) {
      m_startwidth += [stdr_CelWidthArray[i] floatValue];
    }
    backRect = CGRectMake(m_startwidth, stdr_LineHeight * row, m_width, stdr_LineHeight);
  }

  if (m_tableItem.lineMode == USCC_Mode_TwoLine) {
    //两行模式
    UIView *ItemView = [[UIView alloc] initWithFrame:backRect];
    ItemView.backgroundColor = [UIColor clearColor];
    //第一行
    UILabel *firstlineLable =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backRect.size.width, backRect.size.height * 2 / 3)];
    firstlineLable.backgroundColor = [UIColor clearColor];
    firstlineLable.text = m_tableItem.contentone;
    firstlineLable.font = sit_Font;
    firstlineLable.textAlignment = NSTextAlignmentCenter;
    firstlineLable.textColor = m_tableItem.colorMode;
    [ItemView addSubview:firstlineLable];

    //第二行
    firstlineLable =
        [[UILabel alloc] initWithFrame:CGRectMake(0, backRect.size.height / 2, backRect.size.width, backRect.size.height / 3)];
    firstlineLable.backgroundColor = [UIColor clearColor];
    firstlineLable.text = m_tableItem.contenttwo;
    firstlineLable.font = [UIFont systemFontOfSize:Font_Height_12_0];
    firstlineLable.textColor = m_tableItem.twocolorMode;
    firstlineLable.textAlignment = NSTextAlignmentCenter;
    [ItemView addSubview:firstlineLable];

    return ItemView;
  } else if (m_tableItem.lineMode == USCC_Mode_TwoLineEqual) {
    //两行模式
    UIView *ItemView = [[UIView alloc] initWithFrame:backRect];
    ItemView.backgroundColor = [UIColor clearColor];
    //第一行
    UILabel *firstlineLable =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backRect.size.width, backRect.size.height * 2 / 3 - 3)];
    firstlineLable.backgroundColor = [UIColor clearColor];
    firstlineLable.text = m_tableItem.contentone;
    firstlineLable.font = sit_Font;
    firstlineLable.textAlignment = NSTextAlignmentCenter;
    firstlineLable.textColor = m_tableItem.colorMode;
    [ItemView addSubview:firstlineLable];

    //第二行
    firstlineLable =
        [[UILabel alloc] initWithFrame:CGRectMake(0, backRect.size.height / 2, backRect.size.width, backRect.size.height / 3)];
    firstlineLable.backgroundColor = [UIColor clearColor];
    firstlineLable.text = m_tableItem.contenttwo;
    firstlineLable.font = sit_Font;
    firstlineLable.textAlignment = NSTextAlignmentCenter;
    firstlineLable.textColor = m_tableItem.twocolorMode;
    [ItemView addSubview:firstlineLable];

    return ItemView;
  } else if (m_tableItem.lineMode == USCC_Mode_OneLine) {
    UIView *ItemView = [[UIView alloc] initWithFrame:backRect];
    CGRect ItemRect = CGRectMake(startPos.x, startPos.y, backRect.size.width - frameWidth,
                                 frameHeight); //

    UILabel *ItemLable = [[UILabel alloc] initWithFrame:ItemRect]; //
    //创建背景图像
    ItemLable.textColor = m_tableItem.colorMode;
    ItemLable.backgroundColor = [UIColor clearColor];
    ItemLable.text = m_tableItem.contentone;
    ItemLable.font = sit_Font;
    ItemLable.textAlignment = NSTextAlignmentCenter;
    [ItemView addSubview:ItemLable];
    return ItemView;

  } else if (m_tableItem.lineMode == USCC_Mode_CheckBox) {
    //复选框模式
    int width = 29;
    int height = 29;
    UIView *ItemView = [[UIView alloc] initWithFrame:backRect];
    SimuChechBoxView *m_checkBoxView =
        [[SimuChechBoxView alloc] initWithFrame:CGRectMake((ItemView.bounds.size.width - width) / 2,
                                                           (ItemView.bounds.size.height - height) / 2, width, height)]; //
    m_checkBoxView.onSelectedCallback = ^(BOOL isSecected) {
      [self onTableRowSelectedCallback](row, isSecected);
    };
    m_checkBoxView.hidden = !m_tableItem.canSelected;
    [stdr_checkBoxViewArray addObject:m_checkBoxView];
    m_checkBoxView.row = row;
    [ItemView addSubview:m_checkBoxView];
    return ItemView;
  }

  return nil;
}

- (void)addOneLineItemWithCollection:(NSMutableArray *)lineArray
                             withRow:(int)row
                          withColumn:(int)col
                         withContent:(NSString *)content
                           withColor:(UIColor *)color {
  SimuTableItem *m_tabItme = [[SimuTableItem alloc] init];
  m_tabItme.row = row;
  m_tabItme.col = col;
  m_tabItme.contentone = content;
  m_tabItme.lineMode = USCC_Mode_OneLine;
  m_tabItme.colorMode = color;
  [lineArray addObject:m_tabItme];
}

- (void)addTwoLineItemWithCollection:(NSMutableArray *)lineArray
                             withRow:(int)row
                          withColumn:(int)col
                      withContentOne:(NSString *)content1
                        withColorOne:(UIColor *)mode1
                      withContentTwo:(NSString *)content2
                        withColorTwo:(UIColor *)mode2
                           withEqual:(BOOL)equal {
  SimuTableItem *m_tabItme = [[SimuTableItem alloc] init];
  m_tabItme.row = row;
  m_tabItme.col = col;
  m_tabItme.contentone = content1;
  m_tabItme.contenttwo = content2;
  m_tabItme.lineMode = equal ? USCC_Mode_TwoLineEqual : USCC_Mode_TwoLine;
  m_tabItme.colorMode = mode1;
  m_tabItme.twocolorMode = mode2;
  [lineArray addObject:m_tabItme];
}

//获得 头里面的内容
- (UIView *)getTableHeadCellLable:(NSInteger)row Column:(NSInteger)col {
  if (sit_isRsetSequence == YES && sit_isSelfStockReset > 1) {
    [self resetHeadViewPos];
    return nil;
  }
  CGPoint startPos = CGPointMake(stdr_TotelSpaceWidth / 4, 8);
  CGFloat frameHeight = stdr_HeadHeight - 16;
  CGFloat frameWidth = stdr_TotelSpaceWidth / 2;

  if (stdr_HeadContentArray == nil || [stdr_HeadContentArray count] == 0)
    return nil;
  if (col == 0) {
    CGRect rect = CGRectMake(0, 0, stdr_FirstColWidth, stdr_HeadHeight);
    CGRect lablerect = CGRectMake(startPos.x, startPos.y, stdr_FirstColWidth - frameWidth, frameHeight);
    UIView *baseview = [[UIView alloc] initWithFrame:rect];
    baseview.backgroundColor = [UIColor clearColor];

    NSLog(@"%@", NSStringFromCGRect(baseview.frame));

    UILabel *textlable = [[UILabel alloc] initWithFrame:lablerect];
    NSLog(@"%@", NSStringFromCGRect(textlable.frame));
    textlable.backgroundColor = [UIColor clearColor];
    textlable.text = stdr_HeadContentArray[col];
    textlable.font = sit_Font;
    textlable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
    textlable.textAlignment = NSTextAlignmentCenter;
    NSLog(@"%@", NSStringFromCGRect(textlable.frame));
    [baseview addSubview:textlable];
    return baseview;
  } else {
    CGFloat m_width = [stdr_CelWidthArray[col] floatValue];
    CGFloat m_startwidth = 0;
    for (int i = 1; i < col; i++) {
      m_startwidth += [stdr_CelWidthArray[i] floatValue];
    }
    CGRect rect = CGRectMake(m_startwidth, 0, m_width, stdr_HeadHeight);
    CGRect lablerect = CGRectMake(startPos.x, startPos.y, m_width - frameWidth, frameHeight);

    UIView *baseview = [[UIView alloc] initWithFrame:rect];
    NSLog(@"%@", NSStringFromCGRect(baseview.frame));
    UILabel *textlable = [[UILabel alloc] initWithFrame:lablerect];
    NSLog(@"%@", NSStringFromCGRect(textlable.frame));
    textlable.backgroundColor = [UIColor clearColor];
    textlable.text = stdr_HeadContentArray[col];
    textlable.font = sit_Font;
    textlable.tag = 1001;
    textlable.textColor = [Globle colorFromHexRGB:Color_Table_Title];
    textlable.textAlignment = NSTextAlignmentCenter;
    NSLog(@"%@", NSStringFromCGRect(textlable.frame));
    [baseview addSubview:textlable];

    if (sit_isRsetSequence == YES) {
      //加入箭头和按钮
      if ([sit_headListSequenceArray count] > col) {
        NSString *flage = sit_headListSequenceArray[col];
        if ([flage isEqualToString:@"1"] == YES) {
          //加入箭头
          UIImage *arrowimage = [UIImage imageNamed:@"selfstock_down.png"];
          // int test=sit_cor;
          if (sit_cor != -1) {
            if (col == sit_cor) {
              if (sit_state == 1) {
                //从大到小
                arrowimage = [UIImage imageNamed:@"selfstock_sel_down.png"];
              } else {
                //从小到大
                arrowimage = [UIImage imageNamed:@"selfstock_sel_up.png"];
              }
            }
          } else {
            if (sit_isSelfStockType == NO) {
              if (col == 2) {
                arrowimage = [UIImage imageNamed:@"selfstock_sel_down.png"];
              }
            }
          }

          UIImageView *imageview = [[UIImageView alloc] initWithImage:arrowimage];
          imageview.frame =
              CGRectMake(lablerect.origin.x + lablerect.size.width - arrowimage.size.width - 2,
                         lablerect.origin.y + (lablerect.size.height - arrowimage.size.height) / 2,
                         arrowimage.size.width, arrowimage.size.height);
          [sit_headArrowImageViewArray addObject:imageview];
          imageview.tag = 1002;
          [baseview addSubview:imageview];

          //加入透明按钮
          UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
          button.backgroundColor = [UIColor clearColor];
          button.tag = col - 1;
          button.frame = baseview.bounds;
          [button addTarget:self
                        action:@selector(buttonPress:)
              forControlEvents:UIControlEventTouchDown];
          [baseview addSubview:button];
          [stdr_headBaseViewArray addObject:baseview];

        } else {
          UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
          [sit_headArrowImageViewArray addObject:imageview];
          [stdr_headBaseViewArray addObject:baseview];
        }
      }
    }

    //         //加入纵向分割线
    UIView *lineleftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 1, rect.size.height - 2)];
    lineleftView.backgroundColor = [Globle colorFromHexRGB:@"#f2f3f6"];
    UIView *linerighttView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 1, rect.size.height - 2)];
    linerighttView.backgroundColor = [Globle colorFromHexRGB:@"#ced0d6"];
    [baseview addSubview:lineleftView];
    [baseview addSubview:linerighttView];
    return baseview;
  }
}

- (void)buttonPress:(UIButton *)button {
  if (button == nil)
    return;

  if (sit_isAnimationRuning == YES)
    return;
  sit_isAnimationRuning = YES;
  //    UIAlertView * test=[[UIAlertView alloc] initWithTitle:@"按钮点击"
  //    message:@"按钮已经点击" delegate:nil cancelButtonTitle:@"取消"
  //    otherButtonTitles:nil];
  //    [test show];
  //    [test release];
  //修改图片
  UISortListMode Sort = USCC_Mode_Default;
  NSInteger m_nColIndex = button.tag;
  NSInteger m_index = 0;

  if (m_nColIndex < [sit_headArrowImageViewArray count]) {
    UIImage *imageUpSel = [UIImage imageNamed:@"selfstock_sel_up.png"];
    UIImage *imageDownSel = [UIImage imageNamed:@"selfstock_sel_down.png"];
    UIImage *imageDefalut = [UIImage imageNamed:@"selfstock_down.png"];
    for (UIImageView *obj in sit_headArrowImageViewArray) {
      if (m_index == m_nColIndex) {
        UIImageView *imageView = obj;

        if (sit_isSelfStockType == YES) {
          if (imageView.image == imageUpSel) {
            [self ViewWithAnimation:imageView Image:imageDefalut];
            Sort = USCC_Mode_Default;
          } else if (imageView.image == imageDownSel) {
            [self ViewWithAnimation:imageView Image:imageUpSel];
            Sort = USCC_Mode_LowerToHigh;
          } else if (imageView.image == imageDefalut) {

            [self ViewWithAnimation:imageView Image:imageDownSel];
            Sort = USLM_Mode_HighToLower;
          }
        } else {
          if (imageView.image == imageUpSel) {
            [self ViewWithAnimation:imageView Image:imageDownSel];
            Sort = USLM_Mode_HighToLower;
          } else if (imageView.image == imageDownSel) {
            [self ViewWithAnimation:imageView Image:imageUpSel];
            Sort = USCC_Mode_LowerToHigh;
          } else if (imageView.image == imageDefalut) {

            [self ViewWithAnimation:imageView Image:imageDownSel];
            Sort = USLM_Mode_HighToLower;
          }
        }
        if (_delegate) {
          //          [_delegate ResequenceTableList:Sort Cor:m_nColIndex + 1];
          //          //4.13
        }

      } else {
        if (obj.image != imageDefalut) {
          obj.image = imageDefalut;
        }
      }
      m_index++;
    }
  }
}

#pragma mark
#pragma mark 重新设置头区域
- (void)resetHeadViewPos {
  if (stdr_headBaseViewArray == nil || [stdr_headBaseViewArray count] == 0)
    return;
  CGPoint startPos = CGPointMake(stdr_TotelSpaceWidth / 4, 8);
  CGFloat frameHeight = stdr_HeadHeight - 16;
  CGFloat frameWidth = stdr_TotelSpaceWidth / 2;
  int index = 1;
  for (UIView *obj in stdr_headBaseViewArray) {
    CGFloat m_width = [stdr_CelWidthArray[index] floatValue];
    CGFloat m_startwidth = 0;
    for (int i = 1; i < index; i++) {
      m_startwidth = m_startwidth + [stdr_CelWidthArray[i] floatValue];
      ;
    }
    CGRect rect = CGRectMake(m_startwidth, 0, m_width, stdr_HeadHeight);
    CGRect lablerect = CGRectMake(startPos.x, startPos.y, m_width - frameWidth, frameHeight);
    obj.frame = rect;
    for (UIView *viewobj in [obj subviews]) {
      if (viewobj.tag == 1001) {
        viewobj.frame = lablerect;
      } else if (viewobj.tag == 1002) {
        UIImage *arrowimage = [UIImage imageNamed:@"selfstock_down.png"];
        viewobj.frame =
            CGRectMake(lablerect.origin.x + lablerect.size.width - arrowimage.size.width - 2,
                       lablerect.origin.y + (lablerect.size.height - arrowimage.size.height) / 2,
                       arrowimage.size.width, arrowimage.size.height);
        ;
      } else if (viewobj.tag == index - 1) {
        // viewobj.frame=obj.bounds;
      }
    }
    index++;
  }
}

//设定初始化的选中列和选中状态
- (void)setIniteItemCorOrState:(NSInteger)Item_col State:(NSInteger)Item_Type {
  //网络排序
  switch (Item_col) {
  case 1: {
    //最新价
    sit_cor = 1;
  } break;
  case 2: {
    //涨幅
    sit_cor = 2;
  } break;
  case 6: {
    //涨跌
    sit_cor = 3;
  } break;
  case 3: {
    //总量
    sit_cor = 4;
  } break;
  case 4: {
    //总额
    sit_cor = 5;
  } break;
  case 5: {
    //振幅
    sit_cor = 10;
  } break;
  default:
    break;
  }
  //设定排序方式
  if (Item_Type == 1) {
    //从大到小
    sit_state = 1;
  } else {
    //从小到大
    sit_state = 0;
  }
}

#pragma mark
#pragma mark 动画
//重新设置排训箭头图片动画
- (void)ViewWithAnimation:(UIImageView *)view Image:(UIImage *)image {
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.3];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAni)];
  //动画效果
  //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
  // forView:view cache:YES];
  view.transform = CGAffineTransformRotate(view.transform, M_PI);
  view.transform = CGAffineTransformRotate(view.transform, M_PI);
  view.image = image;
  [UIView commitAnimations];
}
- (void)stopAni {
  sit_isAnimationRuning = NO;
}

@end
