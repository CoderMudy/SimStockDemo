//
//  FoldingLine.m
//  SimuStock
//
//  Created by jhss on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FoldingLine.h"
#import "Globle.h"

//线宽
#define FoldingLineWith WIDTH_OF_SCREEN
//线高
#define FoldingLineHeight self.bounds.size.height

#define EdgeInternal 32.0f

#define arrowWith 9.0f

@implementation FoldingLine

- (void)drawRect:(CGRect)rect {

  foldStartPosition = EdgeInternal;

  if ([self.directionStatus isEqualToString:@"1"]) {
    [self drawLeftRoofWithTopPoint:CGPointMake(0.0, self.frame.size.height)
                      withLineJoin:kCGLineJoinBevel
                     withFoldStart:foldStartPosition
                   withLeftOrRight:@"1"];
  } else {
    [self drawLeftRoofWithTopPoint:CGPointMake(0.0, self.frame.size.height)
                      withLineJoin:kCGLineJoinBevel
                     withFoldStart:foldStartPosition
                   withLeftOrRight:@"2"];
  }
}
- (void)showFoldLinePosition:(float)startPosition {
  if (startPosition <= EdgeInternal) {
    leftLine.hidden = YES;
    leftCoverageView.hidden = YES;
    rightLine.hidden = NO;
    rightCoverageView.hidden = NO;
    foldStartPosition = self.frame.size.width - EdgeInternal - arrowWith;
  } else {
    leftLine.hidden = NO;
    rightLine.hidden = YES;
    leftCoverageView.hidden = NO;
    rightCoverageView.hidden = YES;
    foldStartPosition = EdgeInternal;
  }
}

/** 绘制折线 */
- (void)drawLeftRoofWithTopPoint:(CGPoint)paramTopPoint
                    withLineJoin:(CGLineJoin)paramLineJoin
                   withFoldStart:(float)foldStart
                 withLeftOrRight:(NSString *)status {
  [[Globle colorFromHexRGB:@"e3e3e3"] set];
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSetLineJoin(currentContext, paramLineJoin);
  CGContextSetLineWidth(currentContext, 0.5f);
  //左箭头
  CGContextMoveToPoint(currentContext, 0.0f, paramTopPoint.y);

  if ([status isEqualToString:@"1"]) {
    CGContextAddLineToPoint(currentContext, foldStart, paramTopPoint.y);
    CGContextAddLineToPoint(currentContext, foldStart + arrowWith / 2, paramTopPoint.y - arrowWith / 2);
    CGContextAddLineToPoint(currentContext, foldStart + arrowWith, paramTopPoint.y);

    ///画直线
    CGContextAddLineToPoint(currentContext, self.frame.size.width, paramTopPoint.y);
  } else {
    //右箭头
    CGContextAddLineToPoint(currentContext, self.frame.size.width - EdgeInternal - arrowWith, paramTopPoint.y);
    CGContextAddLineToPoint(currentContext, self.frame.size.width - EdgeInternal - arrowWith / 2.0f,
                            paramTopPoint.y - arrowWith / 2.0f);
    CGContextAddLineToPoint(currentContext, self.frame.size.width - EdgeInternal, paramTopPoint.y);
  }
  CGContextAddLineToPoint(currentContext, self.frame.size.width, paramTopPoint.y);
  CGContextStrokePath(currentContext);
}

@end
