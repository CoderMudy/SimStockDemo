//
//  HorizontalS5B5View.m
//  SimuStock
//
//  Created by Mac on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HorizontalS5B5View.h"
#import "StockUtil.h"

@implementation HorizontalS5B5View

- (void)initViews {

  [_sellPriceLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"--";
        label.adjustsFontSizeToFitWidth = YES;
      }];

  [_sellAmountLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"--";
        label.adjustsFontSizeToFitWidth = YES;
      }];

  [_buyPriceLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"--";
        label.adjustsFontSizeToFitWidth = YES;
      }];

  [_buyAmountLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"--";
        label.adjustsFontSizeToFitWidth = YES;
      }];
}

#pragma mark - 设置买5卖5档数据
- (void)bindS5B5Data:(StockQuotationInfo *)quotationInfo
         priceFormat:(NSString *)priceFormat {

  PacketTableData *tableData = nil;
  PacketTableData *headData = nil;

  for (PacketTableData *data in quotationInfo.dataArray) {
    if ([data.tableName isEqualToString:@"Top5Quotation"])
      tableData = data;
    else if ([data.tableName isEqualToString:@"CurStatus"]) {
      headData = data;
    }
  }

  if (!tableData || [tableData.tableItemDataArray count] == 0)
    return;
  if (!headData || [headData.tableItemDataArray count] == 0)
    return;

  NSDictionary *dic = tableData.tableItemDataArray[0];
  NSDictionary *dicPrice = headData.tableItemDataArray[0];

  NSArray *sellPriceKeys = @[
    @"sellPrice5",
    @"sellPrice4",
    @"sellPrice3",
    @"sellPrice2",
    @"sellPrice1"
  ];
  CGFloat _lastClosePrice = [dicPrice[@"closePrice"] floatValue];
  [_sellPriceLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        NSString *price = [NSString
            stringWithFormat:priceFormat, [dic[sellPriceKeys[idx]] floatValue]];
        label.text = price;
        if (![price isEqualToString:@"0.00"]) {
          label.textColor =
              [StockUtil getColorByFloat:(price.floatValue - _lastClosePrice)];
        }
        label.adjustsFontSizeToFitWidth = YES;
      }];

  NSArray *buyPriceKeys = @[
    @"buyPrice1",
    @"buyPrice2",
    @"buyPrice3",
    @"buyPrice4",
    @"buyPrice5"
  ];
  [_buyPriceLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        NSString *price = [NSString
            stringWithFormat:priceFormat, [dic[buyPriceKeys[idx]] floatValue]];
        label.text = price;
        if (![price isEqualToString:@"0.00"]) {
          label.textColor =
              [StockUtil getColorByFloat:(price.floatValue - _lastClosePrice)];
        }
        label.adjustsFontSizeToFitWidth = YES;
      }];

  NSArray *sellAmountKeys = @[
    @"sellAmount5",
    @"sellAmount4",
    @"sellAmount3",
    @"sellAmount2",
    @"sellAmount1"
  ];

  [_sellAmountLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = [NSString
            stringWithFormat:@"%lld", [dic[sellAmountKeys[idx]] longLongValue]];
        label.adjustsFontSizeToFitWidth = YES;
      }];

  NSArray *buyAmountKeys = @[
    @"buyAmount1",
    @"buyAmount2",
    @"buyAmount3",
    @"buyAmount4",
    @"buyAmount5"
  ];
  [_buyAmountLabels
      enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = [NSString
            stringWithFormat:@"%lld", [dic[buyAmountKeys[idx]] longLongValue]];
        label.adjustsFontSizeToFitWidth = YES;
      }];

  _lblCurPrice.text = [NSString
      stringWithFormat:priceFormat, [dicPrice[@"curPrice"] floatValue]];

  //  //普通股
  //  if (self.isIndexStock == NO) {
  //    //昨收价格
  //    _lastClosePrice = [dicPrice[@"closePrice"] floatValue];
  //    //设置当前价
  //
  //  }
}

@end
