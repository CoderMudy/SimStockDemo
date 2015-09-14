//
//  StockCapitalFlowsPie.m
//  SimuStock
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockCapitalFlowsPie.h"

@implementation StockCapitalFlowsPie

//自定义排序方法
-(NSComparisonResult)comparePerson:(StockCapitalFlowsPie *)pie{
  //默认按年龄排序
  NSComparisonResult result = [[NSNumber numberWithInt:pie.percentage] compare:[NSNumber numberWithInt:self.percentage]];//注意:基本数据类型要进行数据转换
  //如果年龄一样，就按照名字排序
  if (result == NSOrderedSame) {
    result = NSOrderedAscending;
  }
  return result;
}

@end
