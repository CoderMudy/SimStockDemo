//
//  SimuStockInfoData.m
//  SimuStock
//
//  Created by Mac on 13-9-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuStockInfoData.h"

//************************************************************************************************************

@implementation DrawVolumeElement

- (id)initWithStartPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
                   color:(UIColor *)color {
  if (self = [super init]) {
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.color = color;
  }
  return self;
}

@end

@implementation SMinDateElement
/*
 *功能：初始化
 *参数：price：价格   volum：量
 */
- (id)initWithPrice:(int64_t)price volume:(int64_t)volume {
  if (self = [super init]) {
    self.price = price;
    self.volume = volume;
  }
  return self;
}

@end

/*
 *类说明：股票信息
 */
@implementation SimuStockInfoItem

- (id)init {
  self = [super init];
  if (self) {
    self.stockname = @"--";
    self.stockcode = @"--";
    self.time = @"--";
    self.closeprice = @"--";
    self.openprice = @"--";
    self.highestprice = @"--";
    self.lowestprice = @"--";
    self.newprice = @"--";
    self.totalAtuom = @"--";
    self.totalVolum = @"--";
    self.corVolume = @"--";
    self.corHands = @"--";
    self.outHands = @"--";
    self.inHands = @"--";
    self.perate = @"--";

    self.buyPrice1 = @"--";
    self.sellPrice1 = @"--";
    self.buyAmount1 = @"--";
    self.sellAmount1 = @"--";

    self.buyPrice2 = @"--";
    self.sellPrice2 = @"--";
    self.buyAmount2 = @"--";
    self.sellAmount2 = @"--";

    self.buyPrice3 = @"--";
    self.sellPrice3 = @"--";
    self.buyAmount3 = @"--";
    self.sellAmount3 = @"--";

    self.buyPrice4 = @"--";
    self.sellPrice4 = @"--";
    self.buyAmount4 = @"--";
    self.sellAmount4 = @"--";

    self.buyPrice5 = @"--";
    self.sellPrice5 = @"--";
    self.buyAmount5 = @"--";
    self.sellAmount5 = @"--";
  }
  return self;
}

@end

/*
 *
 */
@implementation SimuStockInfoPageData
- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

@end
