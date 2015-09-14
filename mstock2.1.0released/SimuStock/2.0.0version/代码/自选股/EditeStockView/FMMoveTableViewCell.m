//
//  FMMoveTableViewCell.m
//  FMFramework
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//

#import "FMMoveTableViewCell.h"
#import "StockPriceRemindClientVC.h"
#import "StockAlarmList.h"

@implementation FMMoveTableViewCell

- (void)prepareForMove {
  [[self textLabel] setText:@""];
  [[self detailTextLabel] setText:@""];
  [[self imageView] setImage:nil];
}

- (void)awakeFromNib {
  self.isSelected = NO;
  [self creatSubView];
  [self.stockBtn setBackgroundImage:[UIImage imageNamed:@"buttonPressDown"]
                           forState:UIControlStateHighlighted];
}

- (void)creatSubView {
  UIView *contentView =
      [[[NSBundle mainBundle] loadNibNamed:@"FMMoveTableCellView"
                                     owner:self
                                   options:nil] lastObject];
  contentView.width = WIDTH_OF_SCREEN;
  [self addSubview:contentView];

  /// 加入分割线
  UIImage *lineImage = [[UIImage imageNamed:@"Edit_Item_Line.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
  UIImageView *lineImageView = [[UIImageView alloc] initWithImage:lineImage];
  lineImageView.frame =
      CGRectMake(0, self.bounds.size.height - lineImage.size.height,
                 WIDTH_OF_SCREEN, lineImage.size.height);
  [self addSubview:lineImageView];
}

- (void)setOnSelectedCallback:(onSelected)onSelectedCallback {
  if (_checkBoxView.onSelectedCallback) {
    _checkBoxView.onSelectedCallback = nil;
  }
  _checkBoxView.onSelectedCallback = onSelectedCallback;
}

- (void)setCheckBoxSelected:(BOOL)isSelected {
  if (_checkBoxView == nil)
    return;
  [_checkBoxView setSelected:isSelected];
}

- (void)bindStockItemInfo:(StockInfo *)stock {
  _stock = stock;
  self.stockCodeLable.text = stock.stockCode;
  self.stockNameLable.text = stock.stockname;
  [self setCheckBoxSelected:stock.isSelected];
  StockAlarmList *alarmList =
      [StockAlarmList stockAlarmListWithUserId:[SimuUtil getUserID]];

  if ([alarmList isSelfStockAlarm:stock.eightstockCode]) {
    [self.stockAlarmButton
        setImage:[UIImage imageNamed:@"提醒他小图标_down02"]
        forState:UIControlStateNormal];
  } else {
    [self.stockAlarmButton setImage:[UIImage imageNamed:@"提醒小图标02"]
                           forState:UIControlStateNormal];
  }

  ///点击股价提醒小铃铛跳转
  [self.stockAlarmButton setOnButtonPressedHandler:^{
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          [StockPriceRemindClientVC
              stockRemindVCWithStockCode:stock.eightstockCode
                           withStockName:stock.stockname
                           withFirstType:stock.firstType
                             withMatchId:@"1"];
        }];

  }];
}

- (IBAction)clickOnstockBtn:(UIButton *)sender {
  [TrendViewController showDetailWithStockCode:_stock.eightstockCode
                                 withStockName:_stock.stockname
                                 withFirstType:_stock.firstType
                                   withMatchId:@"1"];
}

@end
