//
//  simuselMonyeButView.m
//  SimuStock
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuselMonyeButView.h"
#import "SimuUtil.h"

@implementation simuselMonyeButView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    smbv_lableArray = [[NSMutableArray alloc] init];
    buttonArray = [NSMutableArray array];
    smbv_corIndexSel = -1;
    smbv_maxcanIndex = -1;
    smbv_width = frame.size.width / 4;
    smbv_buttonVasible = NO;
    [self creatViews];
  }
  return self;
}

- (void)awakeFromNib {
  smbv_lableArray = [[NSMutableArray alloc] init];
  buttonArray = [NSMutableArray array];
  smbv_corIndexSel = -1;
  smbv_maxcanIndex = -1;
  smbv_width = self.frame.size.width / 4;
  smbv_buttonVasible = NO;
  [self creatViews];
}

//创建控件
- (void)creatViews {
  NSArray *array = @[ @"¥2万", @"¥5万", @"¥10万", @"¥20万" ];
  int i = 0;
  for (NSString *obj in array) {
    UILabel *lable = [[UILabel alloc]
        initWithFrame:CGRectMake(i * smbv_width - 0.5 * i, 0, smbv_width,
                                 self.bounds.size.height)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = obj;
    lable.font = [UIFont systemFontOfSize:Font_Height_12_0];
    lable.textColor = [Globle
        colorFromHexRGB:Color_Gray]; //[Globle colorFromHexRGB:Color_Blue_but];
    lable.layer.borderColor = [[Globle colorFromHexRGB:@"#31bce9"] CGColor];
    lable.layer.borderWidth = 0.5;
    [self addSubview:lable];
    [smbv_lableArray addObject:lable];
    //按钮创建
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = lable.frame;
    [button addTarget:self
                  action:@selector(pressButtonDown:)
        forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
                  action:@selector(pressButtonup:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [self addSubview:button];
    [buttonArray addObject:button];
    i++;
  }
}

#pragma mark
#pragma mark 按钮响应函数
//按下按钮
- (void)pressButtonDown:(UIButton *)button {
  if (smbv_maxcanIndex < button.tag)
    return;
  if (smbv_buttonVasible == NO)
    return;
  smbv_buttonVasible = NO;
  [self performSelector:@selector(changeButtonVisible)
             withObject:nil
             afterDelay:0.4];

  if (smbv_lableArray == Nil || [smbv_lableArray count] == 0)
    return;
  smbv_corIndexSel = button.tag;
  if ([smbv_lableArray count] < smbv_corIndexSel + 1)
    return;
  int i = 0;
  for (UILabel *lable in smbv_lableArray) {
    if (i <= smbv_maxcanIndex) {
      lable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    } else {
      lable.textColor = [Globle colorFromHexRGB:Color_Gray];
    }
    lable.backgroundColor = [UIColor clearColor];
    i++;
  }
  UILabel *lable = smbv_lableArray[smbv_corIndexSel];
  lable.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
  lable.textColor = [UIColor whiteColor];
  //回调代理
  if (_delegate &&
      [_delegate respondsToSelector:@selector(moneyButtonPressDown:)]) {
    [_delegate moneyButtonPressDown:smbv_corIndexSel];
  }
}
//抬起按钮
- (void)pressButtonup:(UIButton *)button {
}
- (void)changeButtonVisible {
  smbv_buttonVasible = YES;
}

#pragma mark
#pragma mark 对外接口
- (void)setTotolMoney:(int64_t)totolfund {
  smbv_buttonVasible = YES;
  if (totolfund >= 200000) {
    smbv_maxcanIndex = 3;
  } else if (totolfund >= 100000) {
    smbv_maxcanIndex = 2;
  } else if (totolfund >= 50000) {
    smbv_maxcanIndex = 1;
  } else if (totolfund >= 20000) {
    smbv_maxcanIndex = 0;
  } else {
    smbv_buttonVasible = NO;
    smbv_maxcanIndex = -1;
  }
  int i = 0;
  for (UILabel *obj in smbv_lableArray) {
    if (i <= smbv_maxcanIndex) {
      obj.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    }
    i++;
  }
}

#pragma mark
#pragma mark 对外接口
//清除所有数据
- (void)clearAllData {
  smbv_maxcanIndex = 0;
  int i = 0;
  for (UILabel *lable in smbv_lableArray) {
    if (i <= smbv_maxcanIndex && false) {
      lable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
    } else {
      lable.textColor = [Globle colorFromHexRGB:Color_Gray];
    }
    lable.backgroundColor = [UIColor clearColor];
    i++;
  }
}

- (void)widthLabel {
  CGFloat width = self.width / 4;
  for (int i = 0; i < smbv_lableArray.count; i++) {
    UILabel *label = smbv_lableArray[i];
    label.frame =
        CGRectMake(i * width - 0.5 * i, 0, width, self.bounds.size.height);
    UIButton *btn = buttonArray[i];
    btn.frame = label.frame;
  }
}

@end
