//
//  TimerUtil.h
//  SimuStock
//
//  Created by Mac on 15/5/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

///定时器定时到达时调用的block
typedef void (^TimerCallBack)();

/**
 * 定时器小控件，能接收间隔时间和执行的block块，传入的间隔时间为0，则停止执行定时器
 */
@interface TimerUtil : NSObject

/** 定时期 */
@property(nonatomic, strong) NSTimer *iKLTimer;

/** 定时器间隔时间 */
@property(nonatomic, assign) NSTimeInterval timeinterval;

///定时器定时到达时调用的block
@property(nonatomic, copy) TimerCallBack timerCallBack;

/** 初始化定时器，单位为秒，传入0，则停止执行定时器 */
- (id)initWithTimeInterval:(NSTimeInterval)timeinterval
          withTimeCallBack:(TimerCallBack)timerCallBack;

///定时器停止
- (void)stopTimer;

///定时器启动
- (void)resumeTimer;

@end
