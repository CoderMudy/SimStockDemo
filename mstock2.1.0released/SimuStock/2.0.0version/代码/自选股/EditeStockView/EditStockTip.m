//
//  EditStockTip.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EditStockTip.h"
#import "SimuUtil.h"

@implementation EditStockTip

- (void)awakeFromNib {
  [_sureButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_butDown]
                         forState:UIControlStateHighlighted];
  [_cancelButton setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_butDown]
                           forState:UIControlStateHighlighted];
  _contentLabel.numberOfLines = 2;
  _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

+ (void)showEditStockTipWithContent:(NSString *)content
                    andSureCallBack:(sureBtnClickCallBack)sureCallBack
                  andCancleCallBack:(cancleBtnClickCallBack)cancleCallBack {
  EditStockTip *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"EditStockTip" owner:nil options:nil] lastObject];
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  [mainWindow addSubview:tip];
  tip.sureBtnClickBlock = sureCallBack;
  tip.cancleBtnClickBlock = cancleCallBack;
  tip.contentLabel.text = content;
}

+ (void)showEditStockTipWithContent:(NSString *)content
                    andSureCallBack:(sureBtnClickCallBack)sureCallBack {
  [EditStockTip showEditStockTipWithContent:content
                            andSureCallBack:sureCallBack
                          andCancleCallBack:nil];
}

- (IBAction)clickOnCancleBtn:(id)sender {
  if (self.cancleBtnClickBlock) {
    self.cancleBtnClickBlock();
  }
  [self removeFromSuperview];
}

- (IBAction)clickOnSureBtn:(id)sender {
  if (self.sureBtnClickBlock) {
    self.sureBtnClickBlock();
  }
  [self removeFromSuperview];
}

@end
