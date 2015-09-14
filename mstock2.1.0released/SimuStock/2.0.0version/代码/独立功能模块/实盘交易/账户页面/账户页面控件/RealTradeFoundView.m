//
//  realTradeFoundView.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeFoundView.h"
#import "SimuUtil.h"

@implementation RealTradeFoundView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self creatViews];
  }
  return self;
}
- (void)creatViews {
  //总资产(数值)
  rtfv_tofundsValueLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, 18)];
  rtfv_tofundsValueLable.backgroundColor = [UIColor clearColor];
  rtfv_tofundsValueLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  rtfv_tofundsValueLable.font = [UIFont boldSystemFontOfSize:18];
  rtfv_tofundsValueLable.textAlignment = NSTextAlignmentCenter;
  rtfv_tofundsValueLable.text = @"0.00";
  [self addSubview:rtfv_tofundsValueLable];
  //总资产（名称）
  rtfv_tofundsNameLable =
      [[UILabel alloc] initWithFrame:CGRectMake(0, rtfv_tofundsValueLable.frame.origin.y + rtfv_tofundsValueLable.frame.size.height + 6,
                                                self.bounds.size.width / 2, 12)];
  rtfv_tofundsNameLable.backgroundColor = [UIColor clearColor];
  rtfv_tofundsNameLable.textColor = [Globle colorFromHexRGB:Color_Gray];
  rtfv_tofundsNameLable.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  rtfv_tofundsNameLable.textAlignment = NSTextAlignmentCenter;
  rtfv_tofundsNameLable.text = @"总资产";
  [self addSubview:rtfv_tofundsNameLable];

  //股票市值(数值)
  rtfv_stockCapValueLable =
      [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, 18)];
  rtfv_stockCapValueLable.backgroundColor = [UIColor clearColor];
  rtfv_stockCapValueLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  rtfv_stockCapValueLable.font = [UIFont boldSystemFontOfSize:18];
  rtfv_stockCapValueLable.textAlignment = NSTextAlignmentCenter;
  rtfv_stockCapValueLable.text = @"0.00";
  [self addSubview:rtfv_stockCapValueLable];
  //股票市值（名称）
  rtfv_stockCapNameLable =
      [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2,
                                                rtfv_stockCapValueLable.frame.origin.y + rtfv_stockCapValueLable.frame.size.height + 6,
                                                self.bounds.size.width / 2, 14)];
  rtfv_stockCapNameLable.backgroundColor = [UIColor clearColor];
  rtfv_stockCapNameLable.textColor = [Globle colorFromHexRGB:Color_Gray];
  rtfv_stockCapNameLable.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  rtfv_stockCapNameLable.textAlignment = NSTextAlignmentCenter;
  rtfv_stockCapNameLable.text = @"股票市值";
  [self addSubview:rtfv_stockCapNameLable];

  //可用金额(数值)
  rtfv_amountAvailValueLable =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width / 2, 18)];
  rtfv_amountAvailValueLable.backgroundColor = [UIColor clearColor];
  rtfv_amountAvailValueLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  rtfv_amountAvailValueLable.font = [UIFont boldSystemFontOfSize:18];
  rtfv_amountAvailValueLable.textAlignment = NSTextAlignmentCenter;
  rtfv_amountAvailValueLable.text = @"0.00";
  [self addSubview:rtfv_amountAvailValueLable];
  //可用金额（名称）
  rtfv_amountAvailNameLable =
      [[UILabel alloc] initWithFrame:CGRectMake(0, rtfv_amountAvailValueLable.frame.origin.y +
                                                       rtfv_amountAvailValueLable.frame.size.height + 6,
                                                self.bounds.size.width / 2, 12)];
  rtfv_amountAvailNameLable.backgroundColor = [UIColor clearColor];
  rtfv_amountAvailNameLable.textColor = [Globle colorFromHexRGB:Color_Gray];
  rtfv_amountAvailNameLable.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  rtfv_amountAvailNameLable.textAlignment = NSTextAlignmentCenter;
  rtfv_amountAvailNameLable.text = @"可用金额";
  [self addSubview:rtfv_amountAvailNameLable];

  //冻结金额(数值)
  rtfv_frozenAmountValueLable =
      [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2, 50, self.bounds.size.width / 2, 18)];
  rtfv_frozenAmountValueLable.backgroundColor = [UIColor clearColor];
  rtfv_frozenAmountValueLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  rtfv_frozenAmountValueLable.font = [UIFont boldSystemFontOfSize:18];
  rtfv_frozenAmountValueLable.textAlignment = NSTextAlignmentCenter;
  rtfv_frozenAmountValueLable.text = @"0.00";
  [self addSubview:rtfv_frozenAmountValueLable];
  //可用金额（名称）
  rtfv_frozenAmountNameLable =
      [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2,
                                                rtfv_frozenAmountValueLable.frame.origin.y +
                                                    rtfv_frozenAmountValueLable.frame.size.height + 6,
                                                self.bounds.size.width / 2, 14)];
  rtfv_frozenAmountNameLable.backgroundColor = [UIColor clearColor];
  rtfv_frozenAmountNameLable.textColor = [Globle colorFromHexRGB:Color_Gray];
  rtfv_frozenAmountNameLable.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
  rtfv_frozenAmountNameLable.textAlignment = NSTextAlignmentCenter;
  rtfv_frozenAmountNameLable.text = @"持仓盈亏";
  [self addSubview:rtfv_frozenAmountNameLable];

  //资金转入
  BGColorUIButton *uibutton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  uibutton.frame = CGRectMake(10, 97, (self.bounds.size.width - 40) / 2, 31);

  [uibutton buttonWithTitle:@"资金转入"
            andNormaltextcolor:Color_White
      andHightlightedTextColor:Color_White];
  [uibutton setNormalBGColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [uibutton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_butDown]];
  [uibutton addTarget:self
                action:@selector(buttonPressDwon:)
      forControlEvents:UIControlEventTouchUpInside];
  uibutton.tag = 40001;
  [self addSubview:uibutton];
  //资金转出
  BGColorUIButton *uibutton2 = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  uibutton2.frame = CGRectMake(10 + self.bounds.size.width / 2, 97, (self.bounds.size.width - 40) / 2, 31);
  [uibutton2 buttonWithTitle:@"资金转出"
            andNormaltextcolor:Color_White
      andHightlightedTextColor:Color_White];
  [uibutton2 setNormalBGColor:[Globle colorFromHexRGB:Color_yellow_but]];
  [uibutton2 setHighlightBGColor:[Globle colorFromHexRGB:Color_yellow_butDown]];
  uibutton2.tag = 40002;
  [uibutton2 addTarget:self
                action:@selector(buttonPressDwon:)
      forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:uibutton2];
  //中央分隔线
  UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 1, 2, 0.5, 87)];
  leftView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:leftView];
  UIView *rightView =
      [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 0.5, 2, 0.5, 87)];
  rightView.backgroundColor = [Globle colorFromHexRGB:@"#d6d6d6"];
  [self addSubview:rightView];
}

#pragma mark
#pragma mark 按钮回调
- (void)buttonPressDwon:(UIButton *)button {
  if (_delegate && [_delegate respondsToSelector:@selector(fundButtonPressDwon:)]) {
    [_delegate fundButtonPressDwon:button.tag];
  }
}
#pragma mark
#pragma mark 对外接口
- (void)resetData:(PositionData *)pagedata {
  if (pagedata == nil)
    return;
  //总资产
  rtfv_tofundsValueLable.text = pagedata.zzc;
  //股票市值
  rtfv_stockCapValueLable.text = pagedata.zxsz;
  //可用金额
  rtfv_amountAvailValueLable.text = pagedata.kyzj;
  //冻结金额
  rtfv_frozenAmountValueLable.text = pagedata.ccykje;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
