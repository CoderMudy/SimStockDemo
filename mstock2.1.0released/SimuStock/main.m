//
//  main.m
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "AppDelegate.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    @try {
      return UIApplicationMain(argc, argv, nil,
                               NSStringFromClass([AppDelegate class]));
    } @catch (NSException *exception) {
      NSLog(@"%@", exception);
      [exception raise];
    }
  }
}
