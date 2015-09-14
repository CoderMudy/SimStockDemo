//
//  StockCompanyCell.m
//  SimuStock
//
//  Created by Mac on 15-3-3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockCompanyCell.h"
#import "Globle.h"

@implementation StockCompanyCell

- (void)awakeFromNib {
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:@"3c4049"];
  }
}

@end
