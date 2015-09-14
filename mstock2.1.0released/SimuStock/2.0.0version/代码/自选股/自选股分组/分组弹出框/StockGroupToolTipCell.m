//
//  StockGroupToolTipCell.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockGroupToolTipCell.h"

@implementation StockGroupToolTipCell

- (void)awakeFromNib {
  [self.groupSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(4.5, 3, 4.5, 3)];
}

- (IBAction)clickOnGroupSelectBtn:(UIButton *)sender {
  self.groupSelectBtn.selected = !self.groupSelectBtn.selected;
  if (self.selectBtnClickBlock) {
    self.selectBtnClickBlock(self.groupId, self.groupSelectBtn.selected);
  }
}

@end
