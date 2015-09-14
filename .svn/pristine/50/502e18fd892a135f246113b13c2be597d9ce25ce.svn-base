//
//  GainersTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GainersTableViewCell.h"
#import "SimuUtil.h"
@implementation GainersTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createView];
  }
  return self;
}
//创建视图
- (void)createView {
  _gainArray = [[NSMutableArray alloc] init];
  GainersView *gainersView1 = [[GainersView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN / 2.0f - 0.25f,
                               187.0f / 2)];
  [self addSubview:gainersView1];
  [_gainArray addObject:gainersView1];

  _stocksBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
  _stocksBtn1.frame =
      CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN / 2.0f - 0.25f, 187.0f / 2);
  _stocksBtn1.backgroundColor = [UIColor clearColor];
  _stocksBtn1.tag = 7700;
  [_stocksBtn1 setBackgroundImage:[UIImage imageNamed:@"灰色高亮点击态"]
                         forState:UIControlStateHighlighted];
  [_stocksBtn1 addTarget:self
                  action:@selector(createButtonTriggerMethods:)
        forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_stocksBtn1];

  GainersView *gainersView2 = [[GainersView alloc]
      initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 2.0f + 0.25f, 0.0,
                               WIDTH_OF_SCREEN / 2 - 0.25f, 187.0f / 2)];
  [self addSubview:gainersView2];
  [_gainArray addObject:gainersView2];

  _stocksBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
  _stocksBtn2.frame = CGRectMake(WIDTH_OF_SCREEN/ 2 + 0.25f, 0.0,
                                 WIDTH_OF_SCREEN / 2 - 0.25f, 187.0f / 2);
  _stocksBtn2.backgroundColor = [UIColor clearColor];
  _stocksBtn2.tag = 7701;
  [_stocksBtn2 setBackgroundImage:[UIImage imageNamed:@"灰色高亮点击态"]
                         forState:UIControlStateHighlighted];
  [_stocksBtn2 addTarget:self
                  action:@selector(createButtonTriggerMethods:)
        forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_stocksBtn2];

  _verticalLine = [[UIView alloc]
      initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 2 - 0.25f, 0.0, 0.5,
                               187.0f / 2)];
  _verticalLine.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [self addSubview:_verticalLine];

  _transverseLine = [[UIView alloc]
      initWithFrame:CGRectMake(30.0f / 2, 187.0f / 2, WIDTH_OF_SCREEN - 30, 0.5)];
  _transverseLine.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [self addSubview:_transverseLine];
}
//创建按钮触发方法
- (void)createButtonTriggerMethods:(UIButton *)btn {
  [_delegate bidButtonMarketHomeCallbackMethod:btn.tag row:self.rowInt];
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
