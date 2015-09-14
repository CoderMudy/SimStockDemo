//
//  InfomationDisplayView.m
//  SimuStock
//
//  Created by moulin wang on 15/4/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InfomationDisplayView.h"
#import "ProcessInputData.h"
#import "StockUtil.h"
#import "UILabel+SetProperty.h"

@interface InfomationDisplayView ()
//不需要公开的
/** 浮动盈亏label */
@property(strong, nonatomic) IBOutlet UILabel *FloatingProfitLoss;
/** 当前资产label */
@property(strong, nonatomic) IBOutlet UILabel *CurrentAssets;
/** 可用资产label */
@property(strong, nonatomic) IBOutlet UILabel *AvailableAssets;
/** 保证金label */
@property(strong, nonatomic) IBOutlet UILabel *BondLabel;
/** 警戒线资金label */
@property(strong, nonatomic) IBOutlet UILabel *CordonAssets;
/** 平仓线资金label */
@property(strong, nonatomic) IBOutlet UILabel *OpenLineAssets;
/** 补充保证金button */
@property(strong, nonatomic) IBOutlet BGColorUIButton *MarginButton;
//平仓表示label
@property(strong, nonatomic) IBOutlet UILabel *openLineLable;
//平仓小图标
@property(strong, nonatomic) IBOutlet UIImageView *openImage;

@end

@implementation InfomationDisplayView

+ (InfomationDisplayView *)theReturnOfTheir {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InfomationDisplayView"
                                                 owner:self
                                               options:nil];
  InfomationDisplayView *view = (InfomationDisplayView *)[array lastObject];
  return view;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  //设置按钮的点击状态
  self.MarginButton.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.MarginButton.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];
}

//数据绑定
- (void)theBindingDataWithInfomationDisplay:
        (WFFirmHeadInfoData *)infomationDisplay {
  if (infomationDisplay == nil ||
      [infomationDisplay.cashAmount isEqualToString:@""]) {
    _FloatingProfitLoss.text = @"--";
    _CurrentAssets.text = @"--";
    _AvailableAssets.text = @"--";
    _BondLabel.text = @"--";
    _CordonAssets.text = @"--";
    _OpenLineAssets.text = @"--";
    self.MarginButton.enabled = NO;
    return;
  }
  self.MarginButton.enabled = YES;
  
  //浮动盈亏 总盈利
  NSString * str = [ProcessInputData convertMoneyString:infomationDisplay.totalProfit];
  NSArray *cashAmountArray = [str componentsSeparatedByString:@"."];
  NSString *firstStr = cashAmountArray[0];
  NSString *lastStr = [@"." stringByAppendingString:cashAmountArray[1]];
  [_FloatingProfitLoss
   setAttributedTextWithFirstString:firstStr
   andFirstFont:[UIFont systemFontOfSize:23.0f]
   andFirstColor:[Globle colorFromHexRGB:@"#df3031"]
   andSecondString:lastStr
   andSecondFont:[UIFont
                  systemFontOfSize:Font_Height_11_0]
   andSecondColor:[Globle colorFromHexRGB:@"#df3031"]];
  
  
  ;
  _FloatingProfitLoss.textColor =[StockUtil getColorByProfit:_FloatingProfitLoss.text];
  //当前资产
  _CurrentAssets.text =
      [ProcessInputData convertMoneyString:infomationDisplay.totalAsset];
  ;
  //可用资产
  _AvailableAssets.text =
      [ProcessInputData convertMoneyString:infomationDisplay.curAmount];

  //保证金
  _BondLabel.text = [ProcessInputData
      convertMoneyString:infomationDisplay.cashAmount];
  //警戒线 金额
  NSString *str1 =
      [ProcessInputData convertMoneyString:infomationDisplay.enableAmount];
  _CordonAssets.text = [NSString
      stringWithFormat:@"≤%@",
                       [ProcessInputData convertDecimalConversionInteger:str1]];
  //平仓线
  NSString *str2 =
      [ProcessInputData convertMoneyString:infomationDisplay.exposureAmount];
  _OpenLineAssets.text = [NSString
      stringWithFormat:@"≤%@",
                          [ProcessInputData convertDecimalConversionInteger:str2]];
  [[_OpenLineAssets superview] setNeedsLayout];
}

#pragma mark - 补充保证金的点击事件
- (IBAction)buttonAction:(UIButton *)sender {
  if (self.infomationDisplayDelegate &&
      [self.infomationDisplayDelegate
          respondsToSelector:@selector(marginButtonDownEvent)]) {
    [self.infomationDisplayDelegate
        marginButtonDownEvent];
  }
}

@end
