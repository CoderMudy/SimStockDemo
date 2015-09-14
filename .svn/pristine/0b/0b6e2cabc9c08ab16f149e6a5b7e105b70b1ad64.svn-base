//
//  PaymentDetailsClientView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PaymentDetailsClientView.h"
#import "SchollWebViewController.h"
#import "UIButton+Hightlighted.h"

@implementation PaymentDetailsClientView

- (void)awakeFromNib {
  self.messageVerificationCodeTF.enabled = NO;

  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateNormal];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateSelected];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateHighlighted];

  [self.haveReadBtn setBackgroundImage:[SimuUtil imageFromColor:@"#AFB3b5"]
                              forState:UIControlStateNormal];
  [self.haveReadBtn setBackgroundImage:[SimuUtil imageFromColor:@"#055081"]
                              forState:UIControlStateHighlighted];
  [self.haveReadBtn setBackgroundImage:[SimuUtil imageFromColor:@"#71BB46"]
                              forState:UIControlStateSelected];
  self.haveReadBtn.imageEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
  self.haveReadBtn.layer.cornerRadius = self.haveReadBtn.width / 2;
  self.haveReadBtn.layer.masksToBounds = YES;
  self.haveReadBtn.enabled = YES;
  self.haveReadBtn.selected = YES;

  [self.confirmBtn buttonWithNormal:Color_WFOrange_btn
               andHightlightedColor:Color_WFOrange_btnDown];
  self.confirmBtn.layer.cornerRadius = self.confirmBtn.height / 2;
  self.confirmBtn.layer.masksToBounds = YES;
}

/** 易宝支付服务协议跳转 */
- (IBAction)yiBaoPaymentAgreement:(UIButton *)sender {
  ///跳转的web链接待定
  [SchollWebViewController startWithTitle:@"易宝一键支付服务协议"
                                  withUrl:@"http://www.youguu.com/opms/html/"
                                  @"article/32/2015/0616/2717.html"];
}

/** 已阅读按钮点击相应函数 */
- (IBAction)clickOnHaveReadBtn:(UIButton *)clickBtn {
  if (clickBtn.selected) {
    clickBtn.selected = NO;
  } else {
    clickBtn.selected = YES;
  }
}

/** 隐藏键盘 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /** 使键盘消失 */
  [self endEditing:YES];
}

@end
