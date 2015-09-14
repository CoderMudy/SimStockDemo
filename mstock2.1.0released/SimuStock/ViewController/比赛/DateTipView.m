//
//  DateTipView.m
//  SimuStock
//
//  Created by jhss on 14-5-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "DateTipView.h"
#import "Globle.h"

@implementation DateTipView
@synthesize backButton;
@synthesize confirmButton;
@synthesize currentDateString = _currentDateString;

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)dateTitle
    withCurrentTime:(NSString *)currentDateString {
  self = [super initWithFrame:frame];
  if (self) {
    // CGRect frame = self.frame;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    ;
    //白底
    UIView *whiteView =
        [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 250) / 2,
                                                 (frame.size.height - 320) / 2,
                                                 250, 185 + 136)];
    whiteView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = whiteView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5];
    [self addSubview:whiteView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 160, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = dateTitle;
    _titleLabel.textColor = [UIColor blackColor];
    [whiteView addSubview:_titleLabel];

    //绿色分割线
    UILabel *greenLine =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 250, 2)];
    greenLine.backgroundColor = [Globle colorFromHexRGB:@"3cc1cb"];
    [whiteView addSubview:greenLine];
    //老虎机(左移40)
    _datePickerView =
        [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 42, 250, 216)];
    _datePickerView.width = 250; //这句给我留着
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    [_datePickerView
        setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //定义最小日期
    _formattter_mindate = [[NSDateFormatter alloc] init];
    [_formattter_mindate setDateFormat:@"yyyy-MM-dd"];

    NSDate *selectedDate =
        [_formattter_mindate dateFromString:currentDateString];
    self.currentDateString = currentDateString;
    // formattter_mindate = nil;
    //最大日期
    // NSDate *maxDate = [formattter_mindate dateFromString:@"2020-12-12"];
    //设置默认选择时间为今天
    //[datePickerView setMinimumDate:minDate];
    //[datePickerView setMaximumDate:maxDate];
    [_datePickerView setDate:selectedDate animated:YES];
    [_datePickerView addTarget:self
                        action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
    [whiteView addSubview:_datePickerView];
    //按钮背景
    UIView *btnBGView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 125 + 136, 250, 60)];
    btnBGView.backgroundColor = [Globle colorFromHexRGB:@"d1d1d1"];
    [whiteView addSubview:btnBGView];
    //返回按钮
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 136 + 136, 100, 34);
    backButton.backgroundColor = [Globle colorFromHexRGB:@"afb3b5"];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    CALayer *backButtonLayer = backButton.layer;
    [backButtonLayer setMasksToBounds:YES];
    [backButtonLayer setCornerRadius:17];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_18_0];
    [backButton addTarget:self
                   action:@selector(touchdown1:)
         forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self
                   action:@selector(outSide1:)
         forControlEvents:UIControlEventTouchUpOutside];
    [backButton addTarget:self
                   action:@selector(backPreviousPage:)
         forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:backButton];
    //确认按钮
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(135, 136 + 136, 100, 34);
    [confirmButton setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    CALayer *confirmButtonLayer = confirmButton.layer;
    [confirmButtonLayer setMasksToBounds:YES];
    [confirmButtonLayer setCornerRadius:17];
    [confirmButton addTarget:self
                      action:@selector(touchdown2:)
            forControlEvents:UIControlEventTouchDown];
    [confirmButton addTarget:self
                      action:@selector(outSide2:)
            forControlEvents:UIControlEventTouchUpOutside];
    [confirmButton addTarget:self
                      action:@selector(changePage:)
            forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font =
        [UIFont boldSystemFontOfSize:Font_Height_18_0];
    [whiteView addSubview:confirmButton];
  }
  return self;
}
//修改日期
- (void)dateChanged:(id)sender {
  UIDatePicker *control = (UIDatePicker *)sender;
  NSDate *_date = control.date;
  //定义显示格式
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  self.currentDateString = [formatter stringFromDate:_date];
}
- (NSString *)getSelectedDateTime {
  return self.currentDateString;
}
- (void)touchdown1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"83888b"]];
}
- (void)outSide1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
}
//取消（返回)
- (void)backPreviousPage:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
}
- (void)touchdown2:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
}
- (void)outSide2:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
}
//切换到单项比赛页(确定按钮)
- (void)changePage:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
}
- (void)resetTitle:(NSString *)title date:(NSString *)dateStr {
  _titleLabel.text = title;
  NSDate *selectedDate = [_formattter_mindate dateFromString:dateStr];
  self.currentDateString = dateStr;
  [_datePickerView setDate:selectedDate animated:YES];
}

@end
