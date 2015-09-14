//
//  DiamondRechargeCell.m
//  SimuStock
//
//  Created by Yuemeng on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DiamondRechargeCell.h"
#import "ProductListItem.h"
#import "CellBottomLinesView.h"

@implementation DiamondRechargeCell

- (void)awakeFromNib {
  _clickEnable = YES;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [_cellBottomLinesView resetViewWidth:self.width];
}

#pragma mark 对外接口
- (void)setCellData:(TrackCardInfo *)item {
  //钻石数量
  _numberLabel.text = [@"× " stringByAppendingString:item.DimondsCount];
  //修改购买价格
  NSString *pricetext;
  pricetext = [NSString stringWithFormat:@"¥ %@元", item.noCountPrice];
  [_valueButton setTitle:pricetext forState:UIControlStateNormal];
  //记录产品id
  _productId = item.CardID;
}

- (IBAction)valueButtonClick:(UIButton *)sender {
  if (_delegate) {
    if (_clickEnable) {
      _clickEnable = NO;
      NSLog(@"按钮已经被点击了");
      [_delegate buyButtonPressDown:_productId];
      [self performSelector:@selector(resetButtonVisible) withObject:nil afterDelay:2.5];
    }
  }
}

- (void)resetButtonVisible {
  _clickEnable = YES;
}

@end
