//
//  HistoryTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-7-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "SimuUtil.h"
@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createView];
  }
  return self;
}
- (void)createView {
  //股票代码
  _codeLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0.0, 50, 52.5)];
  _codeLab.textAlignment = NSTextAlignmentRight;
  _codeLab.text = @"600300";
  _codeLab.textColor = [Globle colorFromHexRGB:Color_Stock_Code];
  _codeLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _codeLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_codeLab];

  //股票名称
  _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(16 + 50 + 17, 0.0, 160.0 / 2, 105.0 / 2)];
  _nameLab.textAlignment = NSTextAlignmentLeft;
  _nameLab.text = @"股票名称";
  _nameLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _nameLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _nameLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_nameLab];

  //已加入自选
  _addOptionalLab =
      [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 24.0 / 2 - 120.0 / 2, 0.0, 120.0 / 2, 105.0 / 2)];
  _addOptionalLab.textAlignment = NSTextAlignmentRight;
  _addOptionalLab.text = @"已加入自选";
  _addOptionalLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  _addOptionalLab.font = [UIFont systemFontOfSize:Font_Height_10_0];
  _addOptionalLab.backgroundColor = [UIColor clearColor];
  [self addSubview:_addOptionalLab];
  _addOptionalLab.hidden = YES;

  _optionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _optionalBtn.frame = CGRectMake(WIDTH_OF_SCREEN - 12 - 40, 0, 53,
                                  53); //高度最好是跟cell一样，但直接取的cell的值缺与创建时给的不一样
  _optionalBtn.backgroundColor = [UIColor clearColor];
  _optionalBtn.tag = 7770;
  [_optionalBtn setImage:[UIImage imageNamed:@"加自选_UP"] forState:UIControlStateNormal];
  [_optionalBtn setImage:[UIImage imageNamed:@"加自选_down"] forState:UIControlStateHighlighted];
  [_optionalBtn addTarget:self
                   action:@selector(createButtonTriggerMethods:)
         forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_optionalBtn];

  _lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 105.0 / 2, WIDTH_OF_SCREEN, 0.5)];
  _lineView.backgroundColor = [Globle colorFromHexRGB:Color_Border];
  [self addSubview:_lineView];
}
//创建按钮触发方法
- (void)createButtonTriggerMethods:(UIButton *)btn {
  [_delegate bidButtonHistoryCallbackMethodRow:self.rowInt cell:self];
}

@end
