//
//  WFIdentityInformation.m
//  SimuStock
//
//  Created by moulin wang on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFIdentityInformation.h"
#import "SimuUtil.h"
@implementation WFIdentityInformation

- (void)awakeFromNib {
  self.identityLabelName.text = [SimuUtil getUserCertName];
//  self.identityNumberLabel.text = [SimuUtil getUserCertNo];
  self.identityNumberLabel.text = [self settingIdcardNumber:[SimuUtil getUserCertNo]];
}

/** 设置身份证号中的出生年月用*代替 */
-(NSString *)settingIdcardNumber:(NSString *)idCardNumber
{
  NSString *str=nil;
  if (idCardNumber.length == 15) {
    str = [idCardNumber stringByReplacingCharactersInRange:NSMakeRange(6, 6) withString:@"******"];
  }
  if (idCardNumber.length == 18) {
     str = [idCardNumber stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
  }
  return str;
}





@end
