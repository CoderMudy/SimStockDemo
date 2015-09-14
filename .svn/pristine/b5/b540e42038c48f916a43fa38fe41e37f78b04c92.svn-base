//
//  YLImageToTitleButton.m
//  SimuStock
//
//  Created by Mac on 15/1/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YLImageToTitleButton.h"
#import "Globle.h"
@implementation YLImageToTitleButton

- (id)initWithFrame:(CGRect)frame
        andImageAry:(NSArray *)imageAry
        andTitleAry:(NSString *)title {
  if (self = [super initWithFrame:frame]) {
    [self setUserInteractionEnabled:TRUE];
    _actionView = [[UIControl alloc] initWithFrame:self.bounds];
    [_actionView setBackgroundColor:[UIColor clearColor]];
    [_actionView addTarget:self
                    action:@selector(appendHighlightedColor)
          forControlEvents:UIControlEventTouchDown];
    [_actionView addTarget:self
                    action:@selector(removeHighlightedColor)
          forControlEvents:UIControlEventTouchCancel |
                           UIControlEventTouchUpInside |
                           UIControlEventTouchDragOutside |
                           UIControlEventTouchUpOutside];
    [self addSubview:_actionView];
    [self sendSubviewToBack:_actionView];
    self.imgAry = imageAry;

    _imageBut =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageAry[0]]];
    _imageBut.frame = CGRectMake((self.width - 20) / 2, 6, 20, 20);
    _imageBut.userInteractionEnabled = NO;
    [self addSubview:_imageBut];

    _lblTitle =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.width, 13)];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.font = [UIFont boldSystemFontOfSize:12];
    _lblTitle.textColor = [Globle colorFromHexRGB:@"#444444"];
    _lblTitle.userInteractionEnabled = NO;
    _lblTitle.text = title;
    [self addSubview:_lblTitle];
  }
  return self;
}
- (void)addTarget:(id)target action:(SEL)action {
  _actionView.tag = self.tag;
  [_actionView addTarget:target
                  action:action
        forControlEvents:UIControlEventTouchUpInside];
}

//选择状态
- (void)appendHighlightedColor {
  self.backgroundColor = [Globle colorFromHexRGB:Color_Pressed_Gray];
  _lblTitle.textColor = [Globle colorFromHexRGB:@"000000"];
}

//未被选中状态
- (void)removeHighlightedColor {
  self.backgroundColor = [UIColor clearColor];
  _lblTitle.textColor = [Globle colorFromHexRGB:@"#444444"];
}


@end
