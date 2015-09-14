//
//  PositionData.m
//  SimuStock
//
//  Created by moulin wang on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PositionData.h"
@implementation PositionData
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.num = [dic[@"num"] intValue];
  self.zjye = dic[@"zjye"];
  self.kyzj = dic[@"kyzj"];
  self.djje = dic[@"djje"];
  self.zrsz = dic[@"zrsz"];
  self.zzc = dic[@"zzc"];
  self.ccykje = dic[@"ccykje"];
  self.zxsz = dic[@"zxsz"];
  NSMutableArray *result = dic[@"result"];
  self.resultArr = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *Diction in result) {
    PositionResult *PResult = [[PositionResult alloc] init];
    PResult.stockName = Diction[@"stockName"];
    PResult.stockCode = Diction[@"stockCode"];
    PResult.stockNum = Diction[@"gfye"];
    PResult.stockCategory = Diction[@"zqlb"];
    PResult.latestValue = Diction[@"zxsz"];
    PResult.latestPrice = Diction[@"zxj"];
    PResult.eastKnotNum = Diction[@"djs"];
    PResult.buyAPrice = Diction[@"mrjj"];
    PResult.break_evenPrice = Diction[@"bbj"];
    PResult.buyAmount = Diction[@"mrje"];
    PResult.positionAverage = Diction[@"cbj"];
    PResult.Profitloss = Diction[@"ljyk"];
    PResult.floatProfitLoss = Diction[@"yk"];
    PResult.profitLossRate = Diction[@"ykl"];
    PResult.availableStock = Diction[@"kygf"];
    [self.resultArr addObject:PResult];
  }
}

-(NSArray *)getArray{
  return _resultArr;
}
@end
@implementation PositionResult

@end