//
//  SingleCapitaldetailsCell.m
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SingleCapitaldetailsCell.h"
#import "SimuUtil.h"
#import "WFProductContract.h"
#import "ProcessInputData.h"
#import "UILabel+SetProperty.h"
#import "UIButton+Hightlighted.h"
#import "StockUtil.h"
/////分割线
//#import "SeperatorLine.h"
@implementation SingleCapitaldetailsCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;
  _RenewalBtn.clipsToBounds = YES;
  _RenewalBtn.layer.cornerRadius = _RenewalBtn.height / 2.0;
  [_RenewalBtn buttonWithNormal:Color_WFOrange_btn
           andHightlightedColor:Color_WFOrange_btnDown];
  self.NumberLabel.adjustsFontSizeToFitWidth = YES;
}
- (void)setFontSizeThatFits:(UILabel *)label {
  CGFloat fontSizeThatFits;

  [label.text sizeWithFont:label.font
               minFontSize:5.0 //最小字体
            actualFontSize:&fontSizeThatFits
                  forWidth:label.bounds.size.width
             lineBreakMode:NSLineBreakByWordWrapping];

  label.font = [label.font fontWithSize:fontSizeThatFits];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}
/** 跳转配资续约页面 */
- (IBAction)popUpRenewalView:(UIButton *)sender {
  if (_delegate && [_delegate respondsToSelector:@selector(reneWalbtnClick:)]) {
    [_delegate reneWalbtnClick:sender.tag];
  }
}

///基本数据初始化赋值
- (void)giveWithCellUIData:(WFContractInfo *)wfcontract {
  if (wfcontract) {
    NSString *profit =
        [ProcessInputData convertMoneyString:wfcontract.totalProfit];
    self.ProfitLabel.text = profit;
    if (wfcontract.verifyStatus == 1) {
      self.Labelsign1.text = @"浮动盈亏";
      self.Labelsign2.text = @"到期日";
      self.Labalsign3.text = @"当前资产";
      self.Labelsign4.text = @"可用资金";
      self.RenewalBtn.hidden = NO;
      self.RenewalBtn.enabled = YES;
      [self.RenewalBtn setTitle:@"续约" forState:UIControlStateNormal];
      self.RenewalBtn.normalBGColor =
          [Globle colorFromHexRGB:Color_WFOrange_btn];
      self.RenewalBtn.highlightBGColor =
          [Globle colorFromHexRGB:Color_WFOrange_btnDown];

      NSString *Amount =
          [ProcessInputData convertMoneyString:wfcontract.Amount];
      ///借钱总资本
      self.NumberLabel.textColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
      self.NumberLabel.attributedText =
          [self getApplicantsLabel:[Amount doubleValue]];
      self.ProfitLabel.textColor = [StockUtil getColorByProfit:profit];
      self.MaturityDateLabel.textColor = [Globle colorFromHexRGB:Color_Black];
      self.AvailableFundsLabel.textColor = [Globle colorFromHexRGB:Color_Black];
      self.CurrentAssetsLabel.textColor = [Globle colorFromHexRGB:Color_Black];
      if (wfcontract.contractEndDate) {
        self.MaturityDateLabel.text = wfcontract.contractEndDate;
      }
      NSString *availabelStr =
          [ProcessInputData convertMoneyString:wfcontract.curAmount];
      self.AvailableFundsLabel.text = availabelStr;
      [self setFontSizeThatFits:self.AvailableFundsLabel];
      [self
          ChangleLabelTextFont:self.AvailableFundsLabel
                    andbigfont:self.AvailableFundsLabel.font
                  andsmallFont:[UIFont systemFontOfSize:self.AvailableFundsLabel
                                                            .font.pointSize -
                                                        3.0f]
                      andColor:self.AvailableFundsLabel.textColor
                       andText:availabelStr];
    } else {
      self.Labelsign1.text = @"操盘金额";
      self.Labelsign2.text = @"配资金额";
      self.Labalsign3.text = @"保证金";
      self.Labelsign4.text = @"状态";
      self.RenewalBtn.hidden = YES;
      self.NumberLabel.font = [UIFont systemFontOfSize:13];
      ///借钱总资本
      self.NumberLabel.textColor = [UIColor blackColor];
      self.NumberLabel.text = wfcontract.Amount;
      self.ProfitLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
      self.MaturityDateLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
      self.AvailableFundsLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
      self.CurrentAssetsLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
      self.AvailableFundsLabel.text = wfcontract.curAmount;
      NSString *contractEndDate =
          [ProcessInputData convertMoneyString:wfcontract.contractEndDate];
      [self ChangleLabelTextFont:self.MaturityDateLabel
                      andbigfont:self.MaturityDateLabel.font
                    andsmallFont:[UIFont systemFontOfSize:10]
                        andColor:self.MaturityDateLabel.textColor
                         andText:contractEndDate];
    }
    NSString *totalAssetStr =
        [ProcessInputData convertMoneyString:wfcontract.totalAsset];

    self.CurrentAssetsLabel.text = totalAssetStr;
    [self setFontSizeThatFits:self.ProfitLabel];
    [self setFontSizeThatFits:self.CurrentAssetsLabel];

    [self ChangleLabelTextFont:self.ProfitLabel
                    andbigfont:self.ProfitLabel.font
                  andsmallFont:[UIFont systemFontOfSize:self.ProfitLabel.font
                                                            .pointSize -
                                                        3.0]
                      andColor:self.ProfitLabel.textColor
                       andText:self.ProfitLabel.text];

    [self ChangleLabelTextFont:self.CurrentAssetsLabel
                    andbigfont:self.CurrentAssetsLabel.font
                  andsmallFont:[UIFont systemFontOfSize:self.CurrentAssetsLabel
                                                            .font.pointSize -
                                                        3.0]
                      andColor:self.CurrentAssetsLabel.textColor
                       andText:self.CurrentAssetsLabel.text];
  }
}
////缩小文本小数位数的大小
- (void)ChangleLabelTextFont:(UILabel *)label
                  andbigfont:(UIFont *)bigfont
                andsmallFont:(UIFont *)sfont
                    andColor:(UIColor *)color
                     andText:(NSString *)string {
  NSArray *arrStr = [string componentsSeparatedByString:@"."];
  if ([arrStr count] == 2) {
    NSString *str1 = [arrStr objectAtIndex:0];
    NSString *str2 =
        [NSString stringWithFormat:@".%@", [arrStr objectAtIndex:1]];
    [label setAttributedTextWithFirstString:str1
                               andFirstFont:bigfont
                              andFirstColor:color
                            andSecondString:str2
                              andSecondFont:sfont
                             andSecondColor:color];
  } else {
    label.text = string;
  }
}

- (NSAttributedString *)getApplicantsLabel:(double)amount {
  NSString *text = nil;
  if (amount >= 10000) {
    text = [NSString stringWithFormat:@"%.0lf万", amount / 10000];
  } else if (amount >= 1000) {
    text = [NSString stringWithFormat:@"%.0lf千", amount / 1000];
  } else {
    if (!amount) {
      amount = 0;
    }
    text = [NSString stringWithFormat:@"%.0f", amount];
  }
  NSMutableAttributedString *result =
      [[NSMutableAttributedString alloc] initWithString:text];

  [result addAttribute:NSFontAttributeName
                 value:[UIFont systemFontOfSize:12]
                 range:NSMakeRange([text length] - 1, 1)];
  [result addAttribute:NSForegroundColorAttributeName
                 value:[Globle colorFromHexRGB:@"FB8114"]
                 range:NSMakeRange([text length] - 1, 1)];

  return result;
}

@end
