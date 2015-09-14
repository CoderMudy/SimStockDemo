//
//  MarketHomeTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketHomeTableViewCell.h"
#import "SimuUtil.h"
@implementation MarketHomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self greateUnitGridView];
  }
  return self;
}

- (void)greateUnitGridView {
  _complextArray = [[NSMutableArray alloc] init];
  _btnArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < 3; i++) {
    _complextView = [[ComplexView alloc]
        initWithFrame:CGRectMake((WIDTH_OF_SCREEN * i) / 3, 0.0,
                                 WIDTH_OF_SCREEN / 3 - 0.5,
                                 self.bounds.size.height)];
    [self addSubview:_complextView];
    [_complextArray addObject:_complextView];

    _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _jumpBtn.frame = _complextView.bounds;
    _jumpBtn.backgroundColor = [UIColor clearColor];
    _jumpBtn.tag = 6400 + i;
    [_jumpBtn setBackgroundImage:[UIImage imageNamed:@"灰色高亮点击态"]
                        forState:UIControlStateHighlighted];
    [_jumpBtn addTarget:self
                  action:@selector(buttonTriggeringMethod:)
        forControlEvents:UIControlEventTouchUpInside];
    [_complextView addSubview:_jumpBtn];
    [_btnArray addObject:_jumpBtn];
  }
  _lineViewA =
      [[UIView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 3 - 0.5, 0.0,
                                               0.5, self.bounds.size.height)];
  _lineViewA.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [self addSubview:_lineViewA];

  _lineViewB = [[UIView alloc]
      initWithFrame:CGRectMake((WIDTH_OF_SCREEN * 2) / 3 - 0.5, 0.0, 0.5,
                               self.bounds.size.height)];
  _lineViewB.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [self addSubview:_lineViewB];

  float leftMargin = -10;
  float rightMargin = 0;
  float nameWidth = WIDTH_OF_SCREEN / 3.f;
  //  float dataPerWidth = 80.0f;
  //  float middleWidth = 90;
  CGFloat fixSpace = 18;

  //股票名称
  _nameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace, 8.0, nameWidth - fixSpace, 16.0)];
  _nameLab.text = @"";
  _nameLab.textAlignment = NSTextAlignmentLeft;
  _nameLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _nameLab.font = [UIFont boldSystemFontOfSize:15.0];
    _nameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_nameLab];

  //股票代码
  _codeLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace, 27.0, nameWidth - fixSpace, 13.0)];
  _codeLab.text = @"";
  _codeLab.textAlignment = NSTextAlignmentLeft;
  _codeLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  _codeLab.font = [UIFont systemFontOfSize:13.0];
    _codeLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_codeLab];

  //最新价格
  _curPriceLab = [[UILabel alloc]
      initWithFrame:CGRectMake(fixSpace + leftMargin + nameWidth,
                               (90.0 - 42.0) / 4, nameWidth - fixSpace, 21.0)];
  _curPriceLab.text = @"";
  _curPriceLab.textAlignment = NSTextAlignmentRight;
  _curPriceLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _curPriceLab.font = [UIFont systemFontOfSize:20.0];
    _curPriceLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_curPriceLab];

  //涨跌幅度
  _dataPerLab = [[UILabel alloc]
      initWithFrame:CGRectMake(rightMargin + nameWidth * 2, (90.0 - 32.0) / 4,
                               nameWidth - fixSpace, 16.0)];
  _dataPerLab.text = @"";
  _dataPerLab.textAlignment = NSTextAlignmentRight;
  _dataPerLab.font = [UIFont systemFontOfSize:20];
    _dataPerLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_dataPerLab];

  //新股发行
  _latestStockView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 58.0 / 2)];
  _latestStockView.backgroundColor = [UIColor orangeColor];
  [self addSubview:_latestStockView];

  //新股股票名称
  UILabel *newNameLab = [[UILabel alloc]
      initWithFrame:CGRectMake(30.0, (58.0 - 26.0) / 4, 80.0, 26.0 / 2)];
  newNameLab.text = @"股票名称";
  newNameLab.textAlignment = NSTextAlignmentLeft;
  newNameLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  newNameLab.font = [UIFont boldSystemFontOfSize:24.0 / 2];
  newNameLab.backgroundColor = [UIColor clearColor];
  [_latestStockView addSubview:newNameLab];

  //总发行数（万股）
  UILabel *newIssuedLab = [[UILabel alloc]
      initWithFrame:CGRectMake((WIDTH_OF_SCREEN - 90.0) / 2, (58.0 - 26.0) / 4,
                               100.0, 26.0 / 2)];
  newIssuedLab.text = @"总发行数（万股）";
  newIssuedLab.textAlignment = NSTextAlignmentCenter;
  newIssuedLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  newIssuedLab.font = [UIFont boldSystemFontOfSize:24.0 / 2];
  newIssuedLab.backgroundColor = [UIColor clearColor];
  [_latestStockView addSubview:newIssuedLab];

  //申购日期
  UILabel *newDateLab = [[UILabel alloc]
      initWithFrame:CGRectMake(WIDTH_OF_SCREEN - rightMargin - nameWidth,
                               (58.0 - 26.0) / 4, 80.0, 26.0 / 2)];
  newDateLab.text = @"申购日期";
  newDateLab.textAlignment = NSTextAlignmentRight;
  newDateLab.textColor = [Globle colorFromHexRGB:Color_Table_Title];
  newDateLab.font = [UIFont boldSystemFontOfSize:24.0 / 2];
  newDateLab.backgroundColor = [UIColor clearColor];
  [_latestStockView addSubview:newDateLab];
  //上
  _upLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 45.0 - 1.0, WIDTH_OF_SCREEN, 0.5)];
  _upLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
  [self addSubview:_upLineView];
  //下
  _downLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 45.0 - 0.5, WIDTH_OF_SCREEN, 0.5)];
  _downLineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self addSubview:_downLineView];
}

- (void)buttonTriggeringMethod:(UIButton *)btn {
  [_delegate bidButtonMarketHomeCallbackMethod:btn.tag
                                       section:self.sectionInt
                                           row:self.rowInt];
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
