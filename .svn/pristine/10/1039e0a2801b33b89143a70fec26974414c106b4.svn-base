//
//  SendCattleToolTip.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SendCattleToolTip.h"
#import "FullScreenLogonViewController.h"
#import "NetShoppingMallBaseViewController.h"

@implementation SendCattleToolTip

- (void)dealloc {
  [self stopTimer:self.lightTimer];
  [self stopTimer:self.touchedTimer];
}

- (void)awakeFromNib {
  [self.okBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_butDown]
                        forState:UIControlStateHighlighted];
  [self.cancleBtn
      setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_butDown]
                forState:UIControlStateHighlighted];
  self.buyBtn.layer.cornerRadius = self.buyBtn.height / 2;
  self.buyBtn.layer.borderWidth = 1;
  self.buyBtn.layer.masksToBounds = YES;
  self.buyBtn.layer.borderColor = ([Globle colorFromHexRGB:@"#F45145"]).CGColor;
  self.sendNumInput.delegate = self;
  [self.buyBtn setBackgroundImage:[SimuUtil imageFromColor:@"#F45145"]
                         forState:UIControlStateHighlighted];
}

+ (void)showTipWithOwnNum:(NSInteger)ownNum
         andDefautSendNum:(NSInteger)sendNum
               andOKBlock:(OKBtnClickBlock)OKBtnClickBlock
           andCancleBlock:(CancleBtnClickBlock)cancleBtnClickBlock
       andBuySuccessBlock:(BuyCattleBlock)buySuccessBlock {
  SendCattleToolTip *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"SendCattleToolTip"
                                     owner:nil
                                   options:nil] firstObject];
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  tip.OKBtnClickBlock = OKBtnClickBlock;
  tip.cancleBtnClickBlock = cancleBtnClickBlock;
  tip.buySuccessBlock = buySuccessBlock;
  [mainWindow addSubview:tip];
  tip.crestNumLabel.text = [@(ownNum) stringValue];
  if (ownNum <= 0) {
    tip.sendNumInput.text = @"1";
  } else {
    tip.sendNumInput.text = [@(sendNum) stringValue];
  }
  tip.touchedDuration = 0;
  tip.isChangedBig = NO;
  /// 牛头的光开始闪动
  [tip startLightTimer];
}

- (IBAction)clickOnBuyBtn:(UIButton *)sender {
  [self.sendNumInput resignFirstResponder];
  [self removeFromSuperview];
  /// 跳转商城
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {

        NetShoppingMallBaseViewController *iSimuStockViewController =
            [[NetShoppingMallBaseViewController alloc]
                initFromSendCattleWithSuccessCallBack:self.buySuccessBlock];
        [AppDelegate pushViewControllerFromRight:iSimuStockViewController];
      }];
}

- (IBAction)clickOnCancleBtn:(UIButton *)sender {
  [self.sendNumInput resignFirstResponder];
  if (self.cancleBtnClickBlock) {
    self.cancleBtnClickBlock();
  }
  [self removeFromSuperview];
}

- (IBAction)clickOnOKBtn:(UIButton *)sender {
  [self.sendNumInput resignFirstResponder];
  if ([self.crestNumLabel.text integerValue] <= 0 ||
      [self.sendNumInput.text integerValue] >
          [self.crestNumLabel.text integerValue]) {
    [NewShowLabel setMessageContent:@"数量不足，请前往购买"];
    return;
  }
  if (self.OKBtnClickBlock) {
    self.OKBtnClickBlock(self.sendNumInput.text);
  }
  [self removeFromSuperview];
}

- (IBAction)clickOnReduceBtn:(UIButton *)sender {
  [self.sendNumInput resignFirstResponder];
  [self reduceSendNum];
}

- (IBAction)clickOnAddBtn:(UIButton *)sender {
  [self.sendNumInput resignFirstResponder];
  [self addSendNum];
}

- (IBAction)longPressOnAddBtn:(UILongPressGestureRecognizer *)sender {
  [self.sendNumInput resignFirstResponder];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.isAdd = YES;
    [self startTouchTimer];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    [self stopTimer:self.touchedTimer];
    self.touchedDuration = 0;
  }
}

- (IBAction)longPressOnReduceBtn:(UILongPressGestureRecognizer *)sender {
  [self.sendNumInput resignFirstResponder];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.isAdd = NO;
    [self startTouchTimer];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    [self stopTimer:self.touchedTimer];
    self.touchedDuration = 0;
  }
}

- (void)addSendNum {
  if ([self.sendNumInput.text integerValue] >=
      [self.crestNumLabel.text integerValue]) {
    if ([self.crestNumLabel.text isEqualToString:@"0"]) {
      self.sendNumInput.text = @"1";
    } else {
      self.sendNumInput.text = self.crestNumLabel.text;
    }
    return;
  } else {
    self.sendNumInput.text =
        [@([self.sendNumInput.text integerValue] + 1) stringValue];
  }
}

- (void)reduceSendNum {
  if ([self.sendNumInput.text integerValue] <= 1) {
    self.sendNumInput.text = @"1";
    return;
  } else {
    self.sendNumInput.text =
        [@([self.sendNumInput.text integerValue] - 1) stringValue];
  }
}

- (void)sendNumChangedFast {
  self.touchedDuration += 1;
  if (self.isAdd) {
    [self addSendNum];
  } else {
    [self reduceSendNum];
  }
  if (self.touchedDuration % 10 == 0) {
    [self stopTimer:self.touchedTimer];
    [self startTouchTimer];
  }
}

- (void)lightAnimate {
  if (self.lightImageHeight.constant <= 10.f) {
    self.isChangedBig = YES;
  } else if (self.lightImageHeight.constant >= 91.f) {
    self.isChangedBig = NO;
  }
  if (self.isChangedBig) {
    self.lightImageHeight.constant = self.lightImageHeight.constant + 9.1f;
    self.lightImageWidth.constant = self.lightImageWidth.constant + 7.4f;
  } else {
    self.lightImageHeight.constant = self.lightImageHeight.constant - 9.1f;
    self.lightImageWidth.constant = self.lightImageWidth.constant - 7.4f;
  }
  if (self.lightImageHeight.constant >= 54.6f) {
    self.lightImageView.alpha = 1.f;
  } else if (self.lightImageHeight.constant <= 54.6f &&
             self.lightImageHeight.constant >= 27.3f) {
    self.lightImageView.alpha = 0.7f;
  } else {
    self.lightImageView.alpha = 0.f;
  }
}

- (void)startTouchTimer {
  if (self.touchedTimer && [self.touchedTimer isValid]) {
    return;
  }
  if (self.isAdd &&
      [self.sendNumInput.text isEqualToString:self.crestNumLabel.text]) {
    return;
  } else if (!self.isAdd && [self.sendNumInput.text isEqualToString:@"1"]) {
    return;
  }
  self.touchedTimer = [NSTimer
      scheduledTimerWithTimeInterval:(1.f / (10.f + self.touchedDuration))
                              target:self
                            selector:@selector(sendNumChangedFast)
                            userInfo:nil
                             repeats:YES];
}

- (void)startLightTimer {
  if (self.lightTimer && [self.lightTimer isValid]) {
    return;
  }
  self.lightTimer =
      [NSTimer scheduledTimerWithTimeInterval:0.16f
                                       target:self
                                     selector:@selector(lightAnimate)
                                     userInfo:nil
                                      repeats:YES];
}

- (void)stopTimer:(NSTimer *)timer {
  if (timer) {
    if ([timer isValid]) {
      [timer invalidate];
      timer = nil;
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.sendNumInput resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  NSInteger sendNum = [self.sendNumInput.text integerValue];
  if (sendNum == 0) {
    sendNum = 1;
  } else if (sendNum >= [self.crestNumLabel.text integerValue]) {
    NSInteger crestNum = [self.crestNumLabel.text integerValue];
    sendNum = (crestNum == 0 ? 1 : crestNum);
  }
  self.sendNumInput.text = [@(sendNum) stringValue];
  return YES;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if (string.length == 0) {
    return YES;
  }
  NSInteger inputNum = [string integerValue];
  if (![self isNum:string]) {
    return NO;
  }
  if ([[textField.text
          stringByReplacingCharactersInRange:range
                                  withString:string] integerValue] >
      [self.crestNumLabel.text integerValue]) {
    return NO;
  }
  string = [@(inputNum) stringValue];
  [self changeTextField:textField
      shouldChangeCharactersInRange:range
                  replacementString:string];
  return NO;
}

- (void)changeTextField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  UITextRange *selectedRange = [textField selectedTextRange];
  NSInteger pos = [textField offsetFromPosition:textField.endOfDocument
                                     toPosition:selectedRange.end];
  textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];
  UITextPosition *newPos =
      [textField positionFromPosition:textField.endOfDocument offset:pos];
  textField.selectedTextRange =
      [textField textRangeFromPosition:newPos toPosition:newPos];
}

- (BOOL)isNum:(NSString *)string {
  NSScanner *scan = [NSScanner scannerWithString:string];
  int val;
  return ([scan scanInt:&val] && [scan isAtEnd]);
}

@end