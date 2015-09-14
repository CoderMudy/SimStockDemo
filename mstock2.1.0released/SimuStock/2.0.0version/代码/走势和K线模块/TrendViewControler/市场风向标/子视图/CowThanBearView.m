//
//  CowThanBearView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CowThanBearView.h"
#import "Circle.h"

@implementation CowThanBearView

- (void)awakeFromNib {
  //添加两个圆
  Circle *circleBlue = [[Circle alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 58, 1.5f, 7, 7)
                                             isSolid:YES
                                               color:[Globle colorFromHexRGB:Color_Blue_but]];
  [self addSubview:circleBlue];
  Circle *circleRed = [[Circle alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 58, 15.5f, 7, 7)
                                            isSolid:YES
                                              color:[Globle colorFromHexRGB:COLOR_COW_BEAR_RED]];
  [self addSubview:circleRed];

  [self requestCowThanBearData];
}

- (void)drawRect:(CGRect)rect {

  CGFloat totalLineWidth = self.width - 53.5f;
  CGFloat originY = 32.5f;
  CGContextRef context = UIGraphicsGetCurrentContext();

  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];

  CGContextSetLineWidth(context, 1.f);

  //上线两条线及中间3条分割线
  for (NSInteger i = 0; i < 5; i++) {
    CGContextMoveToPoint(context, 40, originY + 32 * i);
    CGContextAddLineToPoint(context, 40 + totalLineWidth, originY + 32 * i);
    if (i != 0 && i != 4) {
      CGContextSaveGState(context);
      CGFloat lengths[] = {4, 2};
      CGContextSetLineDash(context, 0, lengths, 2);
      if (i == 2) {
        [[Globle colorFromHexRGB:Color_Yellow] set];
      }
    }
    CGContextStrokePath(context);
    if (i != 0 && i != 4) {
      CGContextRestoreGState(context);
    }
  }

  if (!_cowThanBearData) {
    return;
  }

  NSInteger count = _cowThanBearData.dataArray.count;
  CGFloat spaceWidth = totalLineWidth / (count - 1);

  //计算上证指数最大值
  CGFloat maxScale = [[_cowThanBearData.dataArray.firstObject szzs] floatValue];
  CGFloat minScale = maxScale;

  // item.vote值为牛/熊比的log值，偏牛上线为0.4，牛上线为3
  int maxLog = 0;

  for (NSInteger i = 0; i < count; i++) {
    CowThanBearDataItem *item = _cowThanBearData.dataArray[i];
    if (maxScale < [item.szzs floatValue] && [item.szzs floatValue] != 0.f) {
      maxScale = [item.szzs floatValue];
    }
    if (minScale > [item.szzs floatValue] && [item.szzs floatValue] != 0.f) {
      minScale = [item.szzs floatValue];
    }

    //需要向上取整求最大整数值
    int tempLog = ceilf(fabsf([item.vote floatValue]));
    if (maxLog < tempLog) {
      maxLog = tempLog;
    }
  }

  CGFloat scaleRange = maxScale - minScale;

  CGFloat startX, startY, endX, endY;

  for (NSInteger i = 0; i < count - 1; i++) {
    CowThanBearDataItem *item = _cowThanBearData.dataArray[i];
    CowThanBearDataItem *nextItem = _cowThanBearData.dataArray[i + 1];

    //添加圆圈的半径
    CGFloat radius = 3.5f;
    //如果最后一个是空，则不是今日，不画蓝线
    if ([nextItem.szzs floatValue] != 0.f) {

      //上证蓝线
      [[Globle colorFromHexRGB:Color_Blue_but] set];
      startX = 40 + spaceWidth * i;
      startY = originY + 128 - ([item.szzs floatValue] - minScale) / scaleRange * 128;
      CGContextMoveToPoint(context, startX, startY);
      endX = 40 + spaceWidth * (i + 1);
      endY = originY + 128 - ([nextItem.szzs floatValue] - minScale) / scaleRange * 128;
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextStrokePath(context);

      if (i == (_isToday ? count - 2 : count - 3)) {
        //添加第最后一个蓝色圆形，注意为实心的
        CGContextAddArc(context, endX, endY, radius, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
      }

      //浅蓝色区域
      [[Globle colorFromHexRGB:Color_Blue_but alpha:0.15] set];
      //每根线其实是个长方形
      CGContextBeginPath(context);
      CGContextMoveToPoint(context, startX, startY);
      CGContextAddLineToPoint(context, endX, endY);
      CGContextAddLineToPoint(context, endX, originY + 128);
      CGContextAddLineToPoint(context, startX, originY + 128);
      CGContextFillPath(context);
    }

    //牛熊红线 中线为0 上下±0.4 最高低±3 32为间距
    [[Globle colorFromHexRGB:COLOR_COW_BEAR_RED] set];
    startX = 40 + spaceWidth * i;
    float voteFloat = [item.vote floatValue];
    startY = originY + 64 - voteFloat / (fabsf(voteFloat) <= 0.4 ? 0.4 : 2.6) * 32 -
             (fabsf(voteFloat) <= 0.4 ? 0 : (voteFloat > 0.4 ? 32 : -32));

    //防止上下超界
    if (startY < originY + radius) {
      startY = originY - radius;
    } else if (startY > originY + 128 - radius) {
      startY = originY + 128 - radius;
    }

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startX, startY);
    endX = 40 + spaceWidth * (i + 1);
    float nextVoteFloat = [nextItem.vote floatValue];
    endY = originY + 64 - nextVoteFloat / (fabsf(nextVoteFloat) <= 0.4 ? 0.4 : 2.6) * 32 -
           (fabsf(nextVoteFloat) <= 0.4 ? 0 : (nextVoteFloat > 0.4 ? 32 : -32));

    //防止上下超界
    if (endY < originY + radius) {
      endY = originY - radius;
    } else if (endY > originY + 128 - radius) {
      endY = originY + 128 - radius;
    }

    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);

    //添加圆圈
    [[Globle colorFromHexRGB:Color_White] setFill];
    CGContextAddArc(context, startX, startY, radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);

    if (i == count - 2) {
      //添加第10个红色圆形，注意为实心的
      [[Globle colorFromHexRGB:COLOR_COW_BEAR_RED] set];
      CGContextAddArc(context, endX, endY, radius, 0, 2 * M_PI, 0);
      CGContextDrawPath(context, kCGPathFillStroke);
    }

    //最多显示3个标签
    if (i == 0) {
      _dateLeftLabel.text = item.time;
    }

    if (i == (count - 1) / 2) {
      _dateMidLabel.text = item.time;
    }

    if (i == count - 2) {
      _dateRightLabel.text = nextItem.time; //取最后一个
    }
  }
}

- (void)requestCowThanBearData {
  __weak CowThanBearView *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    CowThanBearView *strongSelf = weakSelf;
    if (strongSelf) {
      //
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    CowThanBearView *strongSelf = weakSelf;
    if (strongSelf) {
      //绑定数据重新绘图
      [strongSelf bindCowThanBearData:(CowThanBearData *)object]; //需要前移数据时调用
      [strongSelf setNeedsDisplay];
    }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [NewShowLabel setMessageContent:obj.message];
  };

  [CowThanBearData requsetCowThanBearData:callback];
}

- (void)bindCowThanBearData:(CowThanBearData *)data {
  //先赋值，然后判断是否需要左移数据
  _cowThanBearData = data;

  //交易日的下午4点之后才会有新日期
  NSDate *date = [SimuUtil serverDateUTC0];
  NSDateFormatter *mmddFormatter = [[NSDateFormatter alloc] init];
  [mmddFormatter setDateFormat:@"MM/dd"];
  NSString *serverMMDD = [mmddFormatter stringFromDate:date];

  //如果服务器返回的时间和今日的时间不一致，则上证指数数据全部左移
  _isToday = [serverMMDD isEqualToString:[data.dataArray.lastObject time]];
  if (!_isToday) {
    NSMutableArray *newDataArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSInteger count = data.dataArray.count;

    for (NSInteger i = 0; i < count; i++) {
      CowThanBearDataItem *item = [[CowThanBearDataItem alloc] init];
      if (i == count - 1) {
        item.szzs = @(0);
      } else {
        item.szzs = [data.dataArray[i + 1] szzs];
      }
      item.time = [data.dataArray[i] time];
      item.vote = [data.dataArray[i] vote];
      [newDataArray addObject:item];
    }

    [_cowThanBearData.dataArray removeAllObjects];
    [_cowThanBearData.dataArray addObjectsFromArray:newDataArray];
  }
}
@end