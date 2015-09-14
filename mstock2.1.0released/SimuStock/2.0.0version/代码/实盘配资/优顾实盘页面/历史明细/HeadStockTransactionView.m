//
//  HeadStockTransactionView.m
//  SimuStock
//
//  Created by moulin wang on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HeadStockTransactionView.h"
#import "Globle.h"

static HeadStockTransactionView *headStockTR;

@implementation HeadStockTransactionView

- (void)awakeFromNib {
  UIView *viewline = [[UIView alloc]
      initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5,
                               CGRectGetWidth(self.bounds), 0.5)];
  viewline.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  [self addSubview:viewline];
}

+ (HeadStockTransactionView *)shareHeadStockTransactionView {
  if (headStockTR == nil) {
    NSArray *array =
        [[NSBundle mainBundle] loadNibNamed:@"HeadStockTransactionView"
                                      owner:nil
                                    options:nil];
    headStockTR = [array firstObject];
  }
  return headStockTR;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
