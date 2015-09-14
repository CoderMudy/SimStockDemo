//
//  DateTipView.h
//  SimuStock
//
//  Created by jhss on 14-5-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateTipView : UIView {
  NSString *_currentDateString;
  UILabel *_titleLabel;
  NSDateFormatter *_formattter_mindate;
  UIDatePicker *_datePickerView;
}
@property(strong, nonatomic) UIButton *backButton;
@property(strong, nonatomic) UIButton *confirmButton;
@property(copy, nonatomic) NSString *currentDateString;
- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)dateTitle
    withCurrentTime:(NSString *)currentDateString;
- (NSString *)getSelectedDateTime;
- (void)resetTitle:(NSString*)title
              date:(NSString *)dateStr;
@end
