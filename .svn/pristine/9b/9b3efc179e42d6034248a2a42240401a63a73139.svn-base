//
//  ShareButtonForBuySellView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShareButtonForBuySellView.h"
#import "Globle.h"

@implementation ShareButtonForBuySellView
/** 对外初始化 */
+ (ShareButtonForBuySellView *)showShareButtonView {
  return [[[NSBundle mainBundle] loadNibNamed:@"ShareButtonForBuySellView"
                                        owner:nil
                                      options:nil] lastObject];
}
- (IBAction)buttonDown:(UIButton *)sender {
  sender.backgroundColor = [Globle colorFromHexRGB:@"#de9200"];
}
- (IBAction)buttonOutside:(UIButton *)sender {
  sender.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
}
- (IBAction)buttonUpInside:(UIButton *)sender {
  sender.backgroundColor = [Globle colorFromHexRGB:@"#f5ad00"];
  if (self.shareButtonBlock) {
    self.shareButtonBlock();
  }
}

@end
