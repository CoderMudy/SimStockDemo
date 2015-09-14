//
//  TupleVal.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TupleValue.h"

@implementation TupleValue

- (instancetype)initWithFirst:(NSNumber *)firstNumber
                       second:(NSNumber *)secondNumber {
  if (self = [super init]) {
    self.firstNumber = firstNumber;
    self.secondNumber = secondNumber;
  }
  return self;
}

@end
