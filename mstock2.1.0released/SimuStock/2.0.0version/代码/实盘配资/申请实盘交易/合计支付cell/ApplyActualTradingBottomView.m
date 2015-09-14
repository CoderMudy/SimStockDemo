//
//  ApplyForActualTradingBottomView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuUtil.h"

@implementation ApplyActualTradingBottomView

+ (ApplyActualTradingBottomView *)applyActulTradingBottomView {
  ApplyActualTradingBottomView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ApplyActualTradingBottomView"
                                     owner:nil
                                   options:nil] lastObject];
  return temp_view;
}

- (void)awakeFromNib {
  self.payBtn.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.payBtn.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];
  self.payBtn.layer.cornerRadius = self.payBtn.height / 2;
  self.payBtn.layer.masksToBounds = YES;
  self.payBtn.enabled = YES;

  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateNormal];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateSelected];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateHighlighted];

  [self.haveReadBtn setBackgroundImage:[SimuUtil imageFromColor:@"#71BB46"]
                              forState:UIControlStateSelected];
  self.haveReadBtn.normalBGColor = [Globle colorFromHexRGB:@"#AFB3b5"];
  self.haveReadBtn.highlightBGColor = [Globle colorFromHexRGB:@"#055081"];
  self.haveReadBtn.imageEdgeInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
  self.haveReadBtn.layer.cornerRadius = self.haveReadBtn.width / 2;
  self.haveReadBtn.layer.masksToBounds = YES;
  self.haveReadBtn.enabled = YES;
  self.haveReadBtn.selected = YES;
}

/** 已阅读按钮点击相应函数 */
- (IBAction)clickOnHaveReadBtn:(UIButton *)clickBtn {
  if (clickBtn.selected) {
    clickBtn.selected=NO;
  } else {
    clickBtn.selected=YES;
  }
  self.block(clickBtn.selected);
}

/** 优顾用户操盘按钮点击响应函数 */
- (IBAction)clickOnProtocolBtn:(UIButton *)clickBtn {
  [SchollWebViewController startWithTitle:@"优顾用户配资协议"
                                  withUrl:@"http://m.youguu.com/mobile/wap_agreement/agreement_borrow.html"];
}


@end
