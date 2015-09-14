//
//  YLTextField.m
//  SimuStock
//
//  Created by Mac on 15/2/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YLTextField.h"

@implementation YLTextField

- (BOOL)becomeFirstResponder {
  if (_YLdelegate &&
      [_YLdelegate respondsToSelector:@selector(YLbecomeFirstResponderAPI)]) {
    [_YLdelegate YLbecomeFirstResponderAPI];
  }
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
  if (_YLdelegate &&
      [_YLdelegate respondsToSelector:@selector(YLresignFirstResponderAPI)]) {
    [_YLdelegate YLresignFirstResponderAPI];
  }
  return [super resignFirstResponder];
}


@end
