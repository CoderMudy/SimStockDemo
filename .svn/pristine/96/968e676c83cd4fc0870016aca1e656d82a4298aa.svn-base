//
//  MatchCreateConfirmTip.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchCreateConfirmTip.h"
#import "Globle.h"
#import "SimuUtil.h"

@implementation MatchCreateConfirmTip

/** 弹出提示框 */
+ (void)showTipWithMessage:(NSString *)message
             withSureBlock:(CallBackBlock)sureBlock
           withCancelBlock:(CallBackBlock)canelBlock {
  MatchCreateConfirmTip *tip = [[[NSBundle mainBundle] loadNibNamed:@"MatchCreateConfirmTip"
                                                              owner:nil
                                                            options:nil] firstObject];
  tip.showTextLabel.text = message;
  tip.clickSureBtnBlock = sureBlock;
  tip.clickCancelBtnBlock = canelBlock;

  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  [mainWindow addSubview:tip];
}

- (IBAction)sureBtnTouchDown:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
}

- (IBAction)sureBtnTouchUpOutside:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
}

- (IBAction)sureBtnTouchUpInside:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
  if (self.clickSureBtnBlock) {
    self.clickSureBtnBlock();
  }
  [self removeFromSuperview];
}

- (IBAction)cancelBtnTouchDown:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_Gray_but]];
}

- (IBAction)cancelBtnTouchUpOutside:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_Gray_butDown]];
}

- (IBAction)cancelBtnTouchUpInside:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_Gray_butDown]];
  if (self.clickCancelBtnBlock) {
    self.clickCancelBtnBlock();
  }
  [self removeFromSuperview];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = [SimuUtil labelContentSizeWithContent:self.showTextLabel.text
                                             withFont:Font_Height_14_0
                                             withSize:CGSizeMake(self.showTextLabel.size.width, 9999)];
  if (size.height > self.showTextLabel.bounds.size.height) {
    self.showLableHeight.constant = size.height;
    self.showTextLabel.height = self.showLableHeight.constant;
  }
}

@end
