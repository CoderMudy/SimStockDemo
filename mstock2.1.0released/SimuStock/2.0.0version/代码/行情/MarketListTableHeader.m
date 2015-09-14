//
//  MarketListTableHeader.m
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketListTableHeader.h"
#import "Globle.h"

@implementation MarketListTableHeader

- (id)initWithFrame:(CGRect)frame
  withStockListType:(StockListType)stockListType
  withRecommendType:(RecommendStockType)recommendStockType
   withSortCallBack:(ButtonPressed)callback {
  if (self = [super initWithFrame:frame]) {
    _stockListType = stockListType;
    _recommendStockType = recommendStockType;
    _action = callback;
    [self createViews];
  }
  return self;
}

- (void)createViews {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  CGFloat fixSpace = 18;
  _firstColumn =
      CGRectMake(0, 0.0, WIDTH_OF_SCREEN / 3, self.bounds.size.height);
  _firstColumnSpace = CGRectMake(fixSpace, 0.0, WIDTH_OF_SCREEN / 3 - fixSpace,
                                 self.bounds.size.height);
  _secondColumn = CGRectMake(WIDTH_OF_SCREEN / 3, 0.0, WIDTH_OF_SCREEN / 3,
                             self.bounds.size.height);
  _secondColumnSpace =
      CGRectMake(WIDTH_OF_SCREEN / 3, 0.0, WIDTH_OF_SCREEN / 3 - 15,
                 self.bounds.size.height);
  _thirdColumn = CGRectMake((WIDTH_OF_SCREEN * 2) / 3, 0.0, WIDTH_OF_SCREEN / 3,
                            self.bounds.size.height);
  _thirdColumnSpace =
      CGRectMake((WIDTH_OF_SCREEN * 2) / 3, 0.0, WIDTH_OF_SCREEN / 3 - fixSpace,
                 self.bounds.size.height);
  _thirdColumnLeftSpace =
      CGRectMake((WIDTH_OF_SCREEN * 2) / 3 + 28 * RATIO_OF_SCREEN_WIDTH,
                 0.0, WIDTH_OF_SCREEN / 3 - fixSpace, self.bounds.size.height);

  switch (_stockListType) {
  case StockListTypeIndex:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createLableOnFrame:_thirdColumnSpace
                    withText:@"涨跌幅"
                   alingment:NSTextAlignmentRight];
    break;
  case StockListTypeIndustry:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"行业名称"
                   alingment:NSTextAlignmentLeft];
    [self createSortButtonOnFrame:_secondColumn withText:@"涨跌幅"];
    [self createLableOnFrame:_thirdColumnLeftSpace
                    withText:@"领涨股"
                   alingment:NSTextAlignmentLeft];
    break;
  case StockListTypeNotion:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"概念名称"
                   alingment:NSTextAlignmentLeft];
    [self createSortButtonOnFrame:_secondColumn withText:@"涨跌幅"];
    [self createLableOnFrame:_thirdColumnLeftSpace
                    withText:@"领涨股"
                   alingment:NSTextAlignmentLeft];
    break;
  case StockListTypeRecommend:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"选股指标"
                   alingment:NSTextAlignmentLeft];
    [self createSortButtonOnFrame:_secondColumn withText:@"涨跌幅"];
    [self createLableOnFrame:_thirdColumnLeftSpace
                    withText:@"领涨股"
                   alingment:NSTextAlignmentLeft];
    break;
  case StockListTypeRise:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createSortButtonOnFrame:_thirdColumn withText:@"涨跌幅"];
    break;
  case StockListTypeFall:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createSortButtonOnFrame:_thirdColumn withText:@"涨跌幅"];
    break;
  case StockListTypeExchange:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createSortButtonOnFrame:_thirdColumn withText:@"换手率"];
    break;
  case StockListTypeAmplitude:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createSortButtonOnFrame:_thirdColumn withText:@"振幅"];
    break;
  case StockListTypeIPO:
    [self createLableOnFrame:_firstColumn
                    withText:@"股票名称"
                   alingment:NSTextAlignmentCenter];
    [self createLableOnFrame:_secondColumn
                    withText:@"总发行数(万股)"
                   alingment:NSTextAlignmentCenter];
    [self createLableOnFrame:_thirdColumn
                    withText:@"申购日期"
                   alingment:NSTextAlignmentCenter];
    break;
  case StockListTypeIndustryNotion:
    [self createLableOnFrame:_firstColumnSpace
                    withText:@"股票名称"
                   alingment:NSTextAlignmentLeft];
    [self createLableOnFrame:_secondColumnSpace
                    withText:@"最新价"
                   alingment:NSTextAlignmentRight];
    [self createSortButtonOnFrame:_thirdColumn withText:@"涨跌幅"];
    break;
  case StockListTypeStocksOfRecommnendType:
    switch (_recommendStockType) {
    case RecommendStockTypeRocket:
      [self createLableOnFrame:_firstColumnSpace
                      withText:@"股票名称"
                     alingment:NSTextAlignmentLeft];
      [self createLableOnFrame:_secondColumnSpace
                      withText:@"最新价"
                     alingment:NSTextAlignmentRight];
      [self createLableOnFrame:_thirdColumnSpace
                      withText:@"放量倍数"
                     alingment:NSTextAlignmentRight];
      break;

    case RecommendStockTypeTopest:
      [self createLableOnFrame:_firstColumnSpace
                      withText:@"股票名称"
                     alingment:NSTextAlignmentLeft];
      [self createLableOnFrame:_secondColumnSpace
                      withText:@"最新价"
                     alingment:NSTextAlignmentRight];
      [self createLableOnFrame:_thirdColumnSpace
                      withText:@"涨跌幅"
                     alingment:NSTextAlignmentRight];
      break;

    case RecommendStockType5Coming:
      [self createLableOnFrame:_firstColumnSpace
                      withText:@"股票名称"
                     alingment:NSTextAlignmentLeft];
      [self createLableOnFrame:_secondColumnSpace
                      withText:@"最新价"
                     alingment:NSTextAlignmentRight];
      [self createLableOnFrame:_thirdColumnSpace
                      withText:@"净流入(万元)"
                     alingment:NSTextAlignmentRight];
      break;

    case RecommendStockTypeMACD:
      [self createLableOnFrame:_firstColumnSpace
                      withText:@"股票名称"
                     alingment:NSTextAlignmentLeft];
      [self createLableOnFrame:_secondColumnSpace
                      withText:@"最新价"
                     alingment:NSTextAlignmentRight];
      [self createLableOnFrame:_thirdColumnSpace
                      withText:@"涨跌幅"
                     alingment:NSTextAlignmentRight];
      break;

    case RecommendStockTypeHotBuy:
      [self createLableOnFrame:_firstColumnSpace
                      withText:@"股票名称"
                     alingment:NSTextAlignmentLeft];
      [self createLableOnFrame:_secondColumnSpace
                      withText:@"最新价"
                     alingment:NSTextAlignmentRight];
      [self createLableOnFrame:_thirdColumnSpace
                      withText:@"热度"
                     alingment:NSTextAlignmentRight];
      break;
    }
    break;
  default:
    break;
  }
  [self createSplitLines];
}

///创建分割线
- (void)createSplitLines {
  return;
  for (int i = 0; i < 4; i++) {
    UIView *lineView = [[UIView alloc] init];
    if (i == 0 || i == 2) {
      if (i == 0) {
        lineView.frame = CGRectMake(WIDTH_OF_SCREEN / 3 - 0.5, 0.0, 0.5,
                                    self.bounds.size.height);
      } else {
        lineView.frame = CGRectMake((WIDTH_OF_SCREEN * 2) / 3 - 0.5, 0.0, 0.5,
                                    self.bounds.size.height);
      }
      lineView.backgroundColor = [Globle colorFromHexRGB:@"#f2f3f6"];
    } else {
      if (i == 1) {
        lineView.frame =
            CGRectMake(WIDTH_OF_SCREEN / 3, 0.0, 0.5, self.bounds.size.height);
      } else {
        lineView.frame = CGRectMake((WIDTH_OF_SCREEN * 2) / 3, 0.0, 0.5,
                                    self.bounds.size.height);
      }
      lineView.backgroundColor = [Globle colorFromHexRGB:@"#d1d3d8"];
    }
    [self addSubview:lineView];
  }
}

///创建Label类型的表头列
- (void)createLableOnFrame:(CGRect)frame
                  withText:(NSString *)text
                 alingment:(NSTextAlignment)alingment {
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:24.0 / 2];
  label.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  label.textAlignment = alingment;
  [self addSubview:label];
  label.text = text;
}

///创建可排序类型的表头列
- (void)createSortButtonOnFrame:(CGRect)frame withText:(NSString *)text {
  //排序按钮
  UIButton *downUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  downUpBtn.frame = frame;
  downUpBtn.backgroundColor = [UIColor clearColor];
  [downUpBtn setBackgroundImage:[UIImage imageNamed:@"灰色高亮点击态"]
                       forState:UIControlStateHighlighted];
  [downUpBtn setOnButtonPressedHandler:self.action];
  [self addSubview:downUpBtn];
  self.sortButton = downUpBtn;

  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.width = label.width - 30 * RATIO_OF_SCREEN_WIDTH;
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:12.0];
  label.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  label.textAlignment = NSTextAlignmentRight;
  [self addSubview:label];
  label.text = text;

  CGFloat right = frame.origin.x + frame.size.width;

  UIImageView *arrowImageView = [[UIImageView alloc] init];
  if (_stockListType == StockListTypeFall) { //仅仅“跌幅榜”排序向上
    arrowImageView.image = [UIImage imageNamed:@"排序_上"];
  } else {
    arrowImageView.image = [UIImage imageNamed:@"排序_下"];
  }
  arrowImageView.frame =
      CGRectMake(right - 25 * RATIO_OF_SCREEN_WIDTH,
                 (self.bounds.size.height - 11.5) / 2, 7.5, 11.5);
  [self addSubview:arrowImageView];
  self.sortOrderImageView = arrowImageView;
  //菊花控件
  UIActivityIndicatorView *attentionIndicatorView =
      [[UIActivityIndicatorView alloc]
          initWithFrame:CGRectMake(right - 22.5 * RATIO_OF_SCREEN_WIDTH,
                                   (self.bounds.size.height - 10) / 2, 10, 10)];
  attentionIndicatorView.activityIndicatorViewStyle =
      UIActivityIndicatorViewStyleWhite;
  [self addSubview:attentionIndicatorView];
  self.sortingIndicatorView = attentionIndicatorView;
}

@end
