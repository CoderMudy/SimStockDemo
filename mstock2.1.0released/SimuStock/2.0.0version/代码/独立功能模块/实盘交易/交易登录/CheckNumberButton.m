//
//  CheckNumberButton.m
//  SimuStock
//
//  Created by jhss on 14-10-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CheckNumberButton.h"
#import "Globle.h"

@implementation CheckNumberButton
// 55, 25
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _letfView =
        [[UIView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, 20.0f, 20.0f)];
    [_letfView.layer setMasksToBounds:YES];
    [_letfView.layer setCornerRadius:10.0f];
    [_letfView.layer setBorderWidth:1.0f];
    [_letfView.layer setBorderColor:[Globle colorFromHexRGB:@"086dae"].CGColor];
    [self addSubview:_letfView];
    //左对号
    _leftImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(3.5f, 4.0f, 13.0f, 12.0f)];
    [_letfView addSubview:_leftImageView];
    //右标题
    _rightLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(25.0 + 3.0, 6.5, 24.0, 12.0)];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    _rightLabel.text = @"保存";
    _rightLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    [self addSubview:_rightLabel];
    //响应按钮
    _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgButton.frame = CGRectMake(0, 0, 55.0f, 25.0f);
    _bgButton.backgroundColor = [UIColor clearColor];
    [_bgButton addTarget:self
                  action:@selector(selectButton)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgButton];
  }
  return self;
}
- (void)selectButton {
  if (_on == YES) {
    _leftImageView.image = [UIImage imageNamed:@""];
    //取消
    _on = NO;
  } else {
    _leftImageView.image = [UIImage imageNamed:@"对号.png"];
    //选定
    _on = YES;
  }
}
- (void)setOn:(BOOL)on {
  if (on) {
    _leftImageView.image = [UIImage imageNamed:@"对号.png"];
  } else {
    _leftImageView.image = [UIImage imageNamed:@""];
  }
  _on = on;
}
@end
