//
//  StockAlarmTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15-4-19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockAlarmTableViewCell.h"
#import "Globle.h"
#import "SimuUtil.h"
#import "StockUtil.h"

@implementation StockAlarmTableViewCell

- (void)awakeFromNib {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
  self.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
  self.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
}

- (void)bindStockAlarmMessage:(StockAlarmEntity *)stockAlarmData {
  _timeLabel.text = stockAlarmData.sendTime;
  _stockNameLabel.text = stockAlarmData.stockname;

  //股票代码统一显示为6位
  _stockCodeLabel.text = [StockUtil sixStockCode:stockAlarmData.stockcode];
  _alarmContentLabel.width = WIDTH_OF_SCREEN - 36;
  _alarmContentLabel.text = stockAlarmData.msg;

  [_alarmContentLabel sizeToFit];
}

+ (CGFloat)cellHeightWithStockAlarmMessage:(StockAlarmEntity *)stockAlarmData {
  static StockAlarmTableViewCell *cell;
  if (cell == nil) {
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([StockAlarmTableViewCell class])
                                         owner:nil
                                       options:nil][0];
    cell.width = WIDTH_OF_SCREEN;
  }

  [cell bindStockAlarmMessage:stockAlarmData];

  return 45 + cell.alarmContentLabel.height;
}

@end
