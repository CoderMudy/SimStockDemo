//
//  ReadFromFile.m
//  SimuStock
//
//  Created by jhss on 13-12-31.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ReadFromFile.h"

@implementation ReadFromFile

- (NSString *)readFromTxtFile:(NSString *)fileName {
  NSError *error;
  NSString *textFileContents = [NSString
      stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName
                                                               ofType:@"txt"]
                      encoding:NSUTF8StringEncoding
                         error:&error];
  //去除换行
  textFileContents =
      [textFileContents stringByReplacingOccurrencesOfString:@"\n"
                                                  withString:@""];
  if (textFileContents == nil) {
    NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
  }
  NSArray *lines = [textFileContents componentsSeparatedByString:@"#"];
  //随机选取字符串
  NSInteger index = arc4random() % ([lines count] - 1);
  NSString *oneObj = lines[index];
  return oneObj;
}

@end
