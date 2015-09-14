//
//  NSDictionary+JsonDicToParaDic.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation NSDictionary (JsonDicToParaDic)

- (NSDictionary *)transformJsonDicToParaDicWithCodeString:
        (NSString *)codeString {
  // NSJSONWritingPrettyPrinted: Pass 0 if you don't care about the readability
  // of the generated string
  NSError *error;
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];

  if (!jsonData) {
    NSLog(@"Got an error: %@", error);
    return nil;
  }
  NSString *jsonString =
      [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

  NSDictionary *parameters = @{ @"code" : codeString, @"json" : jsonString };
  return parameters;
}

@end
