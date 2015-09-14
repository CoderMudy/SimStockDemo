//
//  GetVerificationCode.h
//  SimuStock
//
//  Created by jhss on 14-11-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetVerificationCode : NSObject {
  NSInteger time;
  NSTimer *_getTimer;
}
@property(strong, nonatomic) UIButton *getAuthBtn;
@property(copy, nonatomic) NSString *TPphoneNumber;

/**计时*/
- (void)changeButton;

/**定时器关闭与开启*/
- (void)stopTime;

- (void)authReset;

@end
