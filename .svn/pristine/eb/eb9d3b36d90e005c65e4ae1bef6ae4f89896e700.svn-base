//
//  HomeSimuProfitLineView.m
//  SimuStock
//
//  Created by moulin wang on 14-5-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HomeSimuProfitLineView.h"
#import "SimuUtil.h"

#define LABEL_FONT_SIZE 8
#define DEFAULT_STR @"-00.00%"
#define DEFAULT_VALUE @"0.00%"
@implementation HomeSimuProfitLineView
@synthesize pagedata = spflv_pagedata;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    spflv_pagedata = nil;
    spflv_MyProArray = [[NSMutableArray alloc] init];
    spflv_ArgProArray = [[NSMutableArray alloc] init];
    spflv_pagedata = [[SimuProfitLinePageData alloc] init];
    [self creatcontrol];
  }
  return self;
}

- (void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];
  spflv_MyProArray = [[NSMutableArray alloc] init];
  spflv_ArgProArray = [[NSMutableArray alloc] init];
  spflv_pagedata = [[SimuProfitLinePageData alloc] init];
  [self creatcontrol];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self creatcontrol];
}

static CGFloat BottomScaleHeight = 15.f;
static CGFloat HorizatalScaleSpace = 3.f;

- (void)initRects {
  //设置三个区域
  CGSize labelSize = [self widthForString:DEFAULT_STR fontSize:LABEL_FONT_SIZE];
  CGFloat left = 0;
  CGFloat width = self.width;
  CGFloat horizatalScaleWidth = labelSize.width + 5 + HorizatalScaleSpace;
  spflv_topRect = CGRectMake(left, 0, width, 0);
  spflv_centerRect =
      CGRectMake(left + horizatalScaleWidth, spflv_topRect.origin.y + labelSize.height,
                 width - horizatalScaleWidth - 1, self.height - BottomScaleHeight - labelSize.height);
  spflv_bottomRect = CGRectMake(left + horizatalScaleWidth,
                                spflv_topRect.size.height + spflv_centerRect.size.height + labelSize.height,
                                width - horizatalScaleWidth, BottomScaleHeight);
}

#pragma mark
#pragma mark 创建需要得控件
- (void)creatcontrol {

  [self initRects];

  CGSize labelSize = [self widthForString:DEFAULT_STR fontSize:LABEL_FONT_SIZE];
  CGFloat horizatalScaleWidth = labelSize.width + 5;

  //计算最大显示天数
  spflv_showDays = spflv_centerRect.size.width / WIDTH_X + 1;

  CGPoint m_pos = spflv_centerRect.origin;
  m_pos.x -= horizatalScaleWidth + HorizatalScaleSpace;
  m_pos.y -= labelSize.height;
  CGFloat m_height = spflv_centerRect.size.height / 4;

  if (spflv_verScaleLable1 == nil) {
    spflv_verScaleLable1 =
        [[UILabel alloc] initWithFrame:CGRectMake(m_pos.x, m_pos.y, horizatalScaleWidth, labelSize.height)];
    spflv_verScaleLable1.backgroundColor = [UIColor clearColor];
    spflv_verScaleLable1.text = @"";
    spflv_verScaleLable1.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_verScaleLable1.textAlignment = NSTextAlignmentRight;
    spflv_verScaleLable1.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_verScaleLable1];
  } else {
    spflv_verScaleLable1.frame = CGRectMake(m_pos.x, m_pos.y, horizatalScaleWidth, labelSize.height);
  }

  if (spflv_verScaleLable2 == nil) {
    spflv_verScaleLable2 =
        [[UILabel alloc] initWithFrame:CGRectMake(m_pos.x, m_pos.y + m_height, horizatalScaleWidth, labelSize.height)];
    spflv_verScaleLable2.backgroundColor = [UIColor clearColor];
    spflv_verScaleLable2.text = @"";
    spflv_verScaleLable2.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_verScaleLable2.textAlignment = NSTextAlignmentRight;
    spflv_verScaleLable2.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_verScaleLable2];
  } else {
    spflv_verScaleLable2.frame =
        CGRectMake(m_pos.x, m_pos.y + m_height, horizatalScaleWidth, labelSize.height);
  }

  if (spflv_verScaleLable3 == nil) {
    spflv_verScaleLable3 =
        [[UILabel alloc] initWithFrame:CGRectMake(m_pos.x, m_pos.y + 2 * m_height, horizatalScaleWidth, labelSize.height)];
    spflv_verScaleLable3.backgroundColor = [UIColor clearColor];
    spflv_verScaleLable3.text = @"0.00";
    spflv_verScaleLable3.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_verScaleLable3.textAlignment = NSTextAlignmentRight;
    spflv_verScaleLable3.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_verScaleLable3];
  } else {
    spflv_verScaleLable3.frame =
        CGRectMake(m_pos.x, m_pos.y + 2 * m_height, horizatalScaleWidth, labelSize.height);
  }

  if (spflv_verScaleLable4 == nil) {
    spflv_verScaleLable4 =
        [[UILabel alloc] initWithFrame:CGRectMake(m_pos.x, m_pos.y + 3 * m_height, horizatalScaleWidth, labelSize.height)];
    spflv_verScaleLable4.backgroundColor = [UIColor clearColor];
    spflv_verScaleLable4.text = @"";
    spflv_verScaleLable4.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_verScaleLable4.textAlignment = NSTextAlignmentRight;
    spflv_verScaleLable4.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_verScaleLable4];
  } else {
    spflv_verScaleLable4.frame =
        CGRectMake(m_pos.x, m_pos.y + 3 * m_height, horizatalScaleWidth, labelSize.height);
  }

  if (spflv_verScaleLable5 == nil) {
    spflv_verScaleLable5 =
        [[UILabel alloc] initWithFrame:CGRectMake(m_pos.x, m_pos.y + 4 * m_height, horizatalScaleWidth, labelSize.height)];
    spflv_verScaleLable5.backgroundColor = [UIColor clearColor];
    spflv_verScaleLable5.text = @"";
    spflv_verScaleLable5.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_verScaleLable5.textAlignment = NSTextAlignmentRight;
    spflv_verScaleLable5.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_verScaleLable5];
  } else {
    spflv_verScaleLable5.frame =
        CGRectMake(m_pos.x, m_pos.y + 4 * m_height, horizatalScaleWidth, labelSize.height);
  }

  //创建横向刻度坐标
  CGSize dateStringSize = [self widthForString:@"20150908" fontSize:LABEL_FONT_SIZE];
  CGPoint ver_pos = spflv_bottomRect.origin;
  ver_pos.x += 1;
  CGFloat ver_width = dateStringSize.width + 1;
  CGFloat ver_height = spflv_bottomRect.size.height;
  CGFloat ver_sepwidth = spflv_bottomRect.size.width / 3;
  if (spflv_horScaleLable1 == nil) {
    spflv_horScaleLable1 =
        [[UILabel alloc] initWithFrame:CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height)];
    spflv_horScaleLable1.backgroundColor = [UIColor clearColor];
    spflv_horScaleLable1.text = @"";
    spflv_horScaleLable1.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_horScaleLable1.textAlignment = NSTextAlignmentLeft;
    spflv_horScaleLable1.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_horScaleLable1];
  } else {
    spflv_horScaleLable1.frame = CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height);
  }

  ver_pos.x += ver_sepwidth - ver_width / 2 - 1;
  if (spflv_horScaleLable2 == nil) {
    spflv_horScaleLable2 =
        [[UILabel alloc] initWithFrame:CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height)];
    spflv_horScaleLable2.backgroundColor = [UIColor clearColor];
    spflv_horScaleLable2.text = @"";
    spflv_horScaleLable2.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_horScaleLable2.textAlignment = NSTextAlignmentLeft;
    spflv_horScaleLable2.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_horScaleLable2];
  } else {
    spflv_horScaleLable2.frame = CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height);
  }

  ver_pos.x += ver_sepwidth;
  if (spflv_horScaleLable3 == nil) {
    spflv_horScaleLable3 =
        [[UILabel alloc] initWithFrame:CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height)];
    spflv_horScaleLable3.backgroundColor = [UIColor clearColor];
    spflv_horScaleLable3.text = @"";
    spflv_horScaleLable3.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_horScaleLable3.textAlignment = NSTextAlignmentLeft;
    spflv_horScaleLable3.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_horScaleLable3];
  } else {
    spflv_horScaleLable3.frame = CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height);
  }

  ver_pos.x = spflv_centerRect.origin.x + spflv_centerRect.size.width - ver_width - 1;
  if (spflv_horScaleLable4 == nil) {
    spflv_horScaleLable4 =
        [[UILabel alloc] initWithFrame:CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height)];
    spflv_horScaleLable4.backgroundColor = [UIColor clearColor];
    spflv_horScaleLable4.text = @"";
    spflv_horScaleLable4.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    spflv_horScaleLable4.textAlignment = NSTextAlignmentRight;
    spflv_horScaleLable4.textColor = [Globle colorFromHexRGB:@"#575757"];
    [self addSubview:spflv_horScaleLable4];
  } else {
    spflv_horScaleLable4.frame = CGRectMake(ver_pos.x, ver_pos.y, ver_width, ver_height);
  }
}

- (void)setPagedata:(SimuProfitLinePageData *)pagedata {
  if (pagedata == nil)
    return;
  spflv_myNickNameLable.text = [SimuUtil getUserNickName];
  [spflv_pagedata.DataArray removeAllObjects];
  //反转日期
  NSArray *reverseDataArray = [[pagedata.DataArray reverseObjectEnumerator] allObjects];
  [spflv_pagedata.DataArray addObjectsFromArray:reverseDataArray];
  [self computerinitImportScare];
  [self computerLinePos];
  [self setNeedsDisplay];
}
#pragma mark
#pragma mark 画图函数

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawFrameLine:context];
  if (nil != spflv_pagedata) {
    [self drawMyTrendLine:context];
    [self drawAvgTrendLine:context];
  }
}
//划出边框和分割线
- (void)drawFrameLine:(CGContextRef)context {
  CGContextBeginPath(context);
  //设置画笔粗细
  CGContextSetLineWidth(context, 1);
  //设置画笔颜色
  CGContextSetRGBStrokeColor(context, 0.83, 0.83, 0.83, 1);
  //画ju xing
  CGContextAddRect(context, spflv_centerRect);
  //执行绘画
  CGContextStrokePath(context);

  //划出横向价格线
  //设置画笔颜色
  CGContextSetRGBStrokeColor(context, 0.83, 0.83, 0.83, 1);
  //设置画笔粗细
  CGContextSetLineWidth(context, 1.5);
  //设置画笔类型
  CGFloat a[2] = {2, 2};
  CGContextSetLineDash(context, 2, a, 2);
  CGFloat m_x = spflv_centerRect.origin.x;
  CGFloat m_y = spflv_centerRect.origin.y;
  CGFloat m_nHight = spflv_centerRect.size.height / 4;
  CGFloat m_nWidth = spflv_centerRect.size.width;
  for (int i = 0; i < 5; i++) {
    CGPoint pt1 = CGPointMake(m_x, m_y + i * m_nHight);
    CGPoint pt2 = CGPointMake(m_x + m_nWidth, m_y + i * m_nHight);
    CGContextMoveToPoint(context, pt1.x, pt1.y);
    CGContextAddLineToPoint(context, pt2.x, pt2.y);
    CGContextStrokePath(context);
  }

  //画纵向加个线
  m_nWidth = spflv_centerRect.size.width / 3;
  m_nHight = spflv_centerRect.size.height;
  //设置画笔颜色
  CGContextSetRGBStrokeColor(context, 0.83, 0.83, 0.83, 1);
  //  CGContextSetLineDash(context,0,nil,0);
  //设置画笔宽度
  CGContextSetLineWidth(context, 1.0);
  for (int i = 1; i < 3; i++) {
    CGPoint pt1 = CGPointMake(m_x + i * m_nWidth, m_y);
    CGPoint pt2 = CGPointMake(m_x + i * m_nWidth, m_y + m_nHight);
    CGContextMoveToPoint(context, pt1.x, pt1.y);
    CGContextAddLineToPoint(context, pt2.x, pt2.y);
    CGContextStrokePath(context);
  }
  CGContextSetLineDash(context, 0, nil, 0);
}

//划出我的盈利走势线
- (void)drawMyTrendLine:(CGContextRef)context {
  if (spflv_MyProArray == nil || [spflv_MyProArray count] == 0)
    return;
  CGContextBeginPath(context);
  //设置画笔粗细
  CGContextSetLineWidth(context, 2.0);
  //设置画笔颜色
  CGContextSetRGBStrokeColor(context, 101.0 / 255.0, 209.0 / 255.0, 242.0 / 255.0, 1);

  UIColor *color =
      [UIColor colorWithRed:101.0 / 255.0 green:209.0 / 255.0 blue:242.0 / 255.0 alpha:0.3];
  CGPoint pos3 = CGPointMake(0, spflv_centerRect.origin.y + spflv_centerRect.size.height);
  for (int i = 0; i < [spflv_MyProArray count] - 1; i++) {
    CGContextSetLineWidth(context, 1.0);
    CGPoint pos1 = [spflv_MyProArray[i] CGPointValue];
    CGPoint pos2 = [spflv_MyProArray[i + 1] CGPointValue];
    CGContextMoveToPoint(context, pos1.x, pos1.y);
    CGContextAddLineToPoint(context, pos2.x, pos2.y);
    CGContextStrokePath(context);
    //画出曲线颜色填充
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, pos1.x, pos1.y);
    CGContextAddLineToPoint(context, pos2.x, pos2.y);
    CGContextAddLineToPoint(context, pos2.x, pos3.y);
    CGContextAddLineToPoint(context, pos1.x, pos3.y);
    CGContextSetFillColorWithColor(context, color.CGColor);
    // 绘制当前路径区域
    CGContextFillPath(context);

    CGContextRestoreGState(context);
  }
}

//我的盈利曲线颜色填充
- (void)drawMyQuenFillColor:(CGContextRef)context {
}

//划出盈利均线走势
- (void)drawAvgTrendLine:(CGContextRef)context {
  if (spflv_ArgProArray == nil || [spflv_ArgProArray count] == 0)
    return;
  CGContextBeginPath(context);
  //设置画笔粗细
  CGContextSetLineWidth(context, 1.0);
  //设置画笔颜色
  CGContextSetRGBStrokeColor(context, 237.0 / 255.0, 155.0 / 255.0, 19.0 / 255.0, 1);

  for (int i = 0; i < [spflv_ArgProArray count] - 1; i++) {
    CGPoint pos1 = [spflv_ArgProArray[i] CGPointValue];
    CGPoint pos2 = [spflv_ArgProArray[i + 1] CGPointValue];
    CGContextMoveToPoint(context, pos1.x, pos1.y);
    CGContextAddLineToPoint(context, pos2.x, pos2.y);
    CGContextStrokePath(context);
  }
}

#pragma mark
#pragma mark 计算相关数据

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (CGSize)widthForString:(NSString *)value fontSize:(float)fontSize {
  return [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
           constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
               lineBreakMode:NSLineBreakByCharWrapping]; //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
}

//数据初始计算相关数据
- (void)computerinitImportScare {
  if ([spflv_pagedata.DataArray count] == 0) {
    spflv_isMove = NO;
    return;
  }
  //计算显示天数
  if ([spflv_pagedata.DataArray count] <= spflv_showDays) {
    //显示数据小于可显示数据天数，则图像不可移动
    spflv_isMove = NO;
  } else {
    //显示数据大于可显示数据天数，则图像不移动
    spflv_isMove = YES;
  }
  //取出最大数值
  SimuPointData *elment = spflv_pagedata.DataArray[[spflv_pagedata.DataArray count] - 1];
  CGFloat m_maxScare = elment.MyProfit;
  CGFloat m_minScare = elment.MyProfit;
  ;
  //计算起始位置和相关刻度
  if (spflv_isMove == YES) {
    //图像可以移动
    spflv_endIndex = [spflv_pagedata.DataArray count];
    spflv_startIndex = [spflv_pagedata.DataArray count] - spflv_showDays;
    if (spflv_startIndex < 0)
      spflv_startIndex = 0;
    for (NSInteger i = spflv_startIndex; i < spflv_endIndex; i++) {
      SimuPointData *obj = spflv_pagedata.DataArray[i];
      if (obj) {
        if (m_maxScare < obj.MyProfit) {
          m_maxScare = obj.MyProfit;
        }
        if (m_maxScare < obj.AvgProfit) {
          m_maxScare = obj.AvgProfit;
        }
        if (m_minScare > obj.MyProfit) {
          m_minScare = obj.MyProfit;
        }
        if (m_minScare > obj.AvgProfit) {
          m_minScare = obj.AvgProfit;
        }
      }
    }
    //计算刻度值 (由0到1 自上而下)
    m_maxScare = m_maxScare + (m_maxScare - m_minScare) / 10.0;
    m_minScare = m_minScare - (m_maxScare - m_minScare) / 10.0;
    if (m_maxScare == m_minScare) {
      if (m_maxScare == 0) {
        m_maxScare = 0.1;
        m_minScare = -0.1;
      }
    }
    CGFloat m_heightScare = (m_maxScare - m_minScare) / 4;
    for (int i = 0; i < 5; i++) {
      spflv_scarl[i] = m_maxScare - m_heightScare * i;
    }

  } else {
    //图像不可移动
    //计算开始和结束位置
    spflv_startIndex = 0;
    spflv_endIndex = [spflv_pagedata.DataArray count];

    for (SimuPointData *obj in spflv_pagedata.DataArray) {
      if (m_maxScare < obj.MyProfit) {
        m_maxScare = obj.MyProfit;
      }
      if (m_maxScare < obj.AvgProfit) {
        m_maxScare = obj.AvgProfit;
      }
      if (m_minScare > obj.MyProfit) {
        m_minScare = obj.MyProfit;
      }
      if (m_minScare > obj.AvgProfit) {
        m_minScare = obj.AvgProfit;
      }
    }
    //计算刻度值 (由0到1 自上而下)
    m_maxScare = m_maxScare + (m_maxScare - m_minScare) / 10.0;
    m_minScare = m_minScare - (m_maxScare - m_minScare) / 10.0;
    if (m_maxScare == m_minScare) {
      if (m_maxScare == 0) {
        m_maxScare = 0.1;
        m_minScare = -0.1;
      }
    }
    CGFloat m_heightScare = (m_maxScare - m_minScare) / 4;
    for (int i = 0; i < 5; i++) {
      spflv_scarl[i] = m_maxScare - m_heightScare * i;
    }
  }
}

//移动过程中，计算刻度和起始位置
- (void)computerMoveScare {
  SimuPointData *elment = spflv_pagedata.DataArray[spflv_startIndex];
  CGFloat m_maxScare = elment.MyProfit;
  CGFloat m_minScare = elment.MyProfit;
  ;
  for (NSInteger i = spflv_startIndex; i < spflv_endIndex; i++) {
    SimuPointData *obj = spflv_pagedata.DataArray[i];
    if (obj) {
      if (m_maxScare < obj.MyProfit) {
        m_maxScare = obj.MyProfit;
      }
      if (m_maxScare < obj.AvgProfit) {
        m_maxScare = obj.AvgProfit;
      }
      if (m_minScare > obj.MyProfit) {
        m_minScare = obj.MyProfit;
      }
      if (m_minScare > obj.AvgProfit) {
        m_minScare = obj.AvgProfit;
      }
    }
  }
  //计算刻度值 (由0到1 自上而下)
  m_maxScare = m_maxScare + (m_maxScare - m_minScare) / 10.0;
  m_minScare = m_minScare - (m_maxScare - m_minScare) / 10.0;
  if (m_maxScare == m_minScare) {
    if (m_maxScare == 0) {
      m_maxScare = 0.1;
      m_minScare = -0.1;
    }
  }
  CGFloat m_heightScare = (m_maxScare - m_minScare) / 4;
  for (int i = 0; i < 5; i++) {
    spflv_scarl[i] = m_maxScare - m_heightScare * i;
  }
}

//图像移动
- (void)moveQuenLine:(NSInteger)move_number {
  if (spflv_isMove == NO)
    return;
  if (move_number > 0) {
    //图像向左移动
    //计算显示天数
    NSInteger rightpod = [spflv_pagedata.DataArray count] - spflv_showDays;
    spflv_startIndex += move_number;
    if (spflv_startIndex > rightpod) {
      spflv_startIndex = rightpod;
    }
    spflv_endIndex = spflv_startIndex + spflv_showDays;
  } else if (move_number < 0) {
    //图像向右移动
    spflv_startIndex += move_number;
    if (spflv_startIndex < 0) {
      spflv_startIndex = 0;
    }
    spflv_endIndex = spflv_startIndex + spflv_showDays;
  }
  //计算刻度
  [self computerMoveScare];
  //划出图像
  [self computerLinePos];
  //重新绘制
  [self setNeedsDisplay];
}

- (void)setTextColor:(UILabel *)label andFloatData:(CGFloat)floatData {
  if (floatData > 0)
    label.textColor = [Globle colorFromHexRGB:@"#ca332a"];
  else if (floatData < 0)
    label.textColor = [Globle colorFromHexRGB:@"#5a8a02"];
  else
    label.textColor = [Globle colorFromHexRGB:Color_Black];
}

//计算显示位置 (我的曲线)
- (void)computerLinePos {
  [spflv_MyProArray removeAllObjects];
  [spflv_ArgProArray removeAllObjects];
  if ([spflv_pagedata.DataArray count] == 0) {
    spflv_verScaleLable1.text = @"";
    spflv_verScaleLable2.text = @"";
    spflv_verScaleLable3.text = @"0.00%";
    spflv_verScaleLable4.text = @"";
    spflv_verScaleLable5.text = @"";

    spflv_horScaleLable2.text = @"";
    spflv_horScaleLable3.text = @"";
    spflv_horScaleLable4.text = @"";

    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    spflv_horScaleLable1.text = [dateFormatter stringFromDate:nowDate];
    return;
  }
  //计算区域高度
  CGFloat m_height = spflv_centerRect.size.height;
  CGPoint m_pos = spflv_centerRect.origin;

  for (NSInteger i = spflv_startIndex; i < spflv_endIndex; i++) {
    //我的盈利曲线点位置
    SimuPointData *elment = spflv_pagedata.DataArray[i];
    CGFloat pos_x = m_pos.x + (i - spflv_startIndex) * WIDTH_X;
    CGFloat pos_y = m_pos.y + m_height -
                    m_height * (elment.MyProfit - spflv_scarl[4]) / (spflv_scarl[0] - spflv_scarl[4]);
    CGPoint pos = CGPointMake(pos_x, pos_y);
    [spflv_MyProArray addObject:[NSValue valueWithCGPoint:pos]];
    //均线盈利曲线点位置
    pos_y = m_pos.y + m_height -
            m_height * (elment.AvgProfit - spflv_scarl[4]) / (spflv_scarl[0] - spflv_scarl[4]);
    pos = CGPointMake(pos_x, pos_y);
    [spflv_ArgProArray addObject:[NSValue valueWithCGPoint:pos]];
  }
  //重新设定纵向标签内容
  spflv_verScaleLable1.text = [NSString stringWithFormat:@"%2.2f%%", spflv_scarl[0] * 100];
  spflv_verScaleLable2.text = [NSString stringWithFormat:@"%2.2f%%", spflv_scarl[1] * 100];
  spflv_verScaleLable3.text = [NSString stringWithFormat:@"%2.2f%%", spflv_scarl[2] * 100];
  spflv_verScaleLable4.text = [NSString stringWithFormat:@"%2.2f%%", spflv_scarl[3] * 100];
  spflv_verScaleLable5.text = [NSString stringWithFormat:@"%2.2f%%", spflv_scarl[4] * 100];
  //重新设定纵向标签内容颜色
  [self setTextColor:spflv_verScaleLable1 andFloatData:spflv_scarl[0]];
  [self setTextColor:spflv_verScaleLable2 andFloatData:spflv_scarl[1]];
  [self setTextColor:spflv_verScaleLable3 andFloatData:spflv_scarl[2]];
  [self setTextColor:spflv_verScaleLable4 andFloatData:spflv_scarl[3]];
  [self setTextColor:spflv_verScaleLable5 andFloatData:spflv_scarl[4]];
  //重新定义起始日期标签

  spflv_horScaleLable1.text = @"";
  spflv_horScaleLable2.text = @"";
  spflv_horScaleLable3.text = @"";
  spflv_horScaleLable4.text = @"";

  NSInteger dataCount = [spflv_pagedata.DataArray count];
  //设定横向第一个时间
  if (spflv_startIndex < dataCount) {
    SimuPointData *elment = spflv_pagedata.DataArray[spflv_startIndex];
    spflv_horScaleLable1.text = elment.Date;
  } else
    return;
  //设定横向第二个时间
  if (spflv_startIndex + spflv_showDays / 3 < dataCount) {
    SimuPointData *elment = spflv_pagedata.DataArray[spflv_startIndex + spflv_showDays / 3];
    spflv_horScaleLable2.text = elment.Date;
  } else
    return;
  //设定横向第三个时间
  if (spflv_startIndex + spflv_showDays / 3 * 2 < dataCount) {
    SimuPointData *elment = spflv_pagedata.DataArray[spflv_startIndex + spflv_showDays / 3 * 2];
    spflv_horScaleLable3.text = elment.Date;
  } else
    return;
  //设定横向第四个时间
  if (spflv_startIndex + spflv_showDays - 1 < dataCount) {
    SimuPointData *elment = spflv_pagedata.DataArray[spflv_startIndex + spflv_showDays - 1];
    spflv_horScaleLable4.text = elment.Date;
  } else
    return;
}

#pragma mark
#pragma mark 移动消息回调

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  spflv_lastPos = [[touches anyObject] locationInView:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:self];
  if (fabs(pt.x - spflv_lastPos.x) > 6) {
    //大于6个像素
    [self moveQuenLine:-(pt.x - spflv_lastPos.x) / 2];
    spflv_lastPos = pt;
  }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
