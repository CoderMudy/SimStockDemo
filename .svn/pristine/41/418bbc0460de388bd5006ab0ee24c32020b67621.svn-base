//
//  MyIncomingTableViewCell.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyIncomingTableViewCell.h"

@implementation MyIncomingTableViewCell

#pragma mark - cell复用关键字
- (NSString *)reuseIdentifier {
  return _reuseId;
}

#pragma mark - 绑定数据
- (void)bindDataWith:(MyWalletFlowElement *)element {
  // 1.交易类型：
  /*
   *交易类型。
   *1：申请提现
   *2：兑换钻石
   *3：追踪收入
   *5：牛人计划追踪分成
   */
  switch (element.tradeType) {
  case 1: {
    _tradeTypeLabel.text = @"申请提现";
    _tradeStatusLabel.hidden = NO;
  } break;
  case 2: {
    _tradeTypeLabel.text = @"兑换钻石";
    _tradeStatusLabel.hidden = NO;
  } break;
  case 3: {
    _tradeTypeLabel.text = @"追踪收入";
    _tradeStatusLabel.hidden = YES;
  } break;
  case 5: {
    _tradeTypeLabel.text = @"追踪收入";
    _tradeStatusLabel.hidden = YES;
  } break;
  default:
    break;
  }

  // 2.交易金额，根据交易类型是否为钻石决定如何显示控件
  if (element.tradeType == 2) {
    _diamondButton.hidden = NO;
    _tradeFeeLabel.hidden = YES;
    NSString *fee =
        [NSString stringWithFormat:@"  x %d", (int)element.tradeFee];
    [_diamondButton setTitle:fee forState:UIControlStateNormal];
  } else if (element.tradeType == 5) {
    _diamondButton.hidden = YES;
    _tradeFeeLabel.hidden = NO;
    _tradeFeeLabel.text = [NSString stringWithFormat:@"+%.2f", element.tradeFee];
  } else {
    _diamondButton.hidden = YES;
    _tradeFeeLabel.hidden = NO;
    //申请提现，-号开头；追踪收入，+号开头
    if (element.tradeType == 1) {
      _tradeFeeLabel.text =
          [NSString stringWithFormat:@"-%.2f", element.tradeFee];
    } else if (element.tradeType == 3) {
      _tradeFeeLabel.text =
          [NSString stringWithFormat:@"+%.2f", element.tradeFee];
    }
  }

  // 3.交易时间
  _timeLabel.text = element.tradeTime;

  // 4.交易状态
  /*
   *交易类型。
   *0：交易关闭
   *1：正在处理
   *2：交易成功
   *3：兑换成功
   */
  switch (element.tradeStatus) {
  case 0: {
    _tradeStatusLabel.text = @"交易关闭";
    [self changeBackgroundAndTextColor:NO];
  } break;
  case 1: {
    _tradeStatusLabel.text = @"正在处理";
    // cell背景蓝色
    [self changeBackgroundAndTextColor:YES];
  } break;
  case 2: {
    _tradeStatusLabel.text = @"交易成功";
    [self changeBackgroundAndTextColor:NO];
  } break;
  case 3: {
    _tradeStatusLabel.text = @"兑换成功";
    [self changeBackgroundAndTextColor:NO];
  } break;

  default:
    break;
  }
}

- (void)changeBackgroundAndTextColor:(BOOL)isProcessing {
  // 如果正在处理，则可以点击
  self.userInteractionEnabled = isProcessing;

  if (isProcessing) {
    self.contentView.backgroundColor = [Globle colorFromHexRGB:@"#D3EEFF"];
  } else {
    self.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
