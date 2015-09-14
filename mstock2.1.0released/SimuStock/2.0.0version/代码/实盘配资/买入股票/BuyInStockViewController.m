//
//  BuyInStockViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BuyInStockViewController.h"
#import "BuyInStockActualTradingView.h"
#import "SimulatorBuyInStockView.h"
#import "UILabel+SetProperty.h"

/** 实盘金额、天数、费用信息视图之间的距离 */
#define Buy_In_View_Margin 7

@interface BuyInStockViewController ()

/** 配资买入视图 */
@property(strong, nonatomic) BuyInStockActualTradingView *buyInView;
/** 实盘交易视图 */
@property(strong, nonatomic) BuyInStockActualTradingView *actulTradingView;
/** 模拟交易视图 */
@property(strong, nonatomic) SimulatorBuyInStockView *simulatorTradingView;

@end

@implementation BuyInStockViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.topToolBar resetContentAndFlage:@"买入股票" Mode:TTBM_Mode_Sideslip];
  self.indicatorView.hidden = YES;

  [self setupSubviews];
}

/** 设置子控件 */
- (void)setupSubviews {
  [self.clientView addSubview:self.buyInView];
  [self.clientView addSubview:self.actulTradingView];
  [self.clientView addSubview:self.simulatorTradingView];

  [self setupSubviewsFrame];

  /** 设置三个视图的标题 */
  [self.buyInView.titleLable
      setAttributedTextWithFirstString:@"配资买入"
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_18_0]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:@"（我出钱，你炒股）"
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_13_0]
                        andSecondColor:[Globle
                                           colorFromHexRGB:Color_Icon_Title]];
  [self.actulTradingView.titleLable
      setAttributedTextWithFirstString:@"配资交易"
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_18_0]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:
                           @"（支持德邦证券，东莞证券）"
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_13_0]
                        andSecondColor:[Globle
                                           colorFromHexRGB:Color_Icon_Title]];
  [self.simulatorTradingView.titleLable
      setAttributedTextWithFirstString:@"模拟交易"
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_18_0]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:
                           @"（超仿真、分红送股实盘同步）"
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_13_0]
                        andSecondColor:[Globle
                                           colorFromHexRGB:Color_Icon_Title]];

  self.buyInView.imageView.image = [UIImage imageNamed:@"配资买入小图标."
                                                       @"png"];
  self.actulTradingView.imageView.image =
      [UIImage imageNamed:@"实盘交易小图标.png"];

  self.buyInView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  self.actulTradingView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  self.simulatorTradingView.backgroundColor =
      [Globle colorFromHexRGB:Color_White];

  [self.buyInView setupSubviews];
  [self.actulTradingView setupSubviews];

  [self.simulatorTradingView.simulatorBuyBtn setTitle:@"模拟买入"
                                             forState:UIControlStateNormal];
  [self.simulatorTradingView.simulatorBuyBtn
      setTitleColor:[Globle colorFromHexRGB:@"#df1515"]
           forState:UIControlStateNormal];

  /** 设置按钮的圆弧边框 */
  [self.buyInView setupButtonLayer];
  [self.actulTradingView setupButtonLayer];
  [self.simulatorTradingView setupButtonLayer];
}

/** 设置子控件的位置尺寸 */
- (void)setupSubviewsFrame {
  /** 设置配资买入视图的位置尺寸 */
  self.buyInView.width = self.clientView.width;
  self.buyInView.top = 0;
  self.buyInView.left = 0;

  [self addMarginViewWithTop:self.buyInView.bottom];
  [self addMarginViewWithTop:self.buyInView.bottom + Buy_In_View_Margin + 1.0];

  /** 设置实盘交易视图的位置尺寸 */
  self.actulTradingView.width = self.clientView.width;
  self.actulTradingView.top = self.buyInView.bottom + Buy_In_View_Margin + 2.0;
  self.actulTradingView.left = 0;

  [self addMarginViewWithTop:self.actulTradingView.bottom];
  [self addMarginViewWithTop:self.actulTradingView.bottom + Buy_In_View_Margin +
                             1.0];

  /** 设置模拟交易视图的位置尺寸 */
  self.simulatorTradingView.width = self.clientView.width;
  self.simulatorTradingView.top =
      self.actulTradingView.bottom + Buy_In_View_Margin + 2.0;
  self.simulatorTradingView.left = 0;

  [self addMarginViewWithTop:self.simulatorTradingView.bottom];
}

/** 添加分割视图 */
- (void)addMarginViewWithTop:(CGFloat)top;
{
  UIView *temp_view = [[UIView alloc]
      initWithFrame:CGRectMake(0, top, self.clientView.width, 1.0)];
  [self.clientView addSubview:temp_view];
  temp_view.backgroundColor = [Globle colorFromHexRGB:@"#e9e9e9"];
}

#pragma mark--- 懒加载 ---
/** 懒加载配资买入视图（通过BuyinStockView.xib创建） */
- (BuyInStockActualTradingView *)buyInView {
  if (_buyInView == nil) {
    _buyInView = [[[NSBundle mainBundle] loadNibNamed:@"StockBuyInView"
                                                owner:nil
                                              options:nil] lastObject];
  }
  return _buyInView;
}

/** 懒加载实盘交易视图（通过BuyinStockView.xib创建） */
- (BuyInStockActualTradingView *)actulTradingView {
  if (_actulTradingView == nil) {
    _actulTradingView = [[[NSBundle mainBundle] loadNibNamed:@"StockBuyInView"
                                                       owner:nil
                                                     options:nil] lastObject];
  }
  return _actulTradingView;
}

/** 懒加载模拟交易视图（通过BuyinStockView.xib创建） */
- (SimulatorBuyInStockView *)simulatorTradingView {
  if (_simulatorTradingView == nil) {
    _simulatorTradingView =
        [[[NSBundle mainBundle] loadNibNamed:@"SimulatorBuyInView"
                                       owner:nil
                                     options:nil] lastObject];
  }
  return _simulatorTradingView;
}

@end
