//
//  SimuRTBottomToolBar.m
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuRTBottomToolBar.h"

@interface SimuRTBottomToolBar ()

@end

@implementation SimuRTBottomToolBar
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame ContenArray:(NSArray *)array {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    sbtb_infoarray = [[NSMutableArray alloc] initWithArray:array];
    sbtb_buttonarray = [[NSMutableArray alloc] init];
    sbtb_index = 0;
    //创建控件
    [self creatViews];
  }
  return self;
}

//协议中的方法
- (void)selectedButtonToTagWithButton:(UIButton *)btn
                    andPositionResult:(NSObject *)positionRes
                       andFirmCapital:(BOOL)firmCapital {
  if (firmCapital == YES) {
    self.posResult = (PositionResult *)positionRes;
  } else {
    self.stockListData = (WFfirmStockListData *)positionRes;
  }
  [self buttonpressdown:btn];
}
- (void)creatViews {
  [FSExtendButtons sharedExtendButtons].buttonDelegate = self;
  [sbtb_buttonarray removeAllObjects];
  float leftbutton_width = 0;
  float otherbutton_width =
      (self.bounds.size.width - 2 * leftbutton_width) / [sbtb_infoarray count];

  //其他按钮
  int i = 0;
  for (MarketBottomButtonInfo *info in sbtb_infoarray) {
    UIImage *up_image = [UIImage imageNamed:info.notSellectedImageName];
    UIImage *down_image = [UIImage imageNamed:info.sellectedImageName];
    //加入按钮
    UIButton *sttbv_sysmsgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sbtb_buttonarray addObject:sttbv_sysmsgbutton];
    sttbv_sysmsgbutton.backgroundColor = [UIColor clearColor];
    sttbv_sysmsgbutton.frame =
        CGRectMake(leftbutton_width + otherbutton_width * i, 0,
                   otherbutton_width, self.bounds.size.height);
    [sttbv_sysmsgbutton setTitle:info.titleName forState:UIControlStateNormal];
    [sttbv_sysmsgbutton setTitle:info.titleName
                        forState:UIControlStateHighlighted];
    [sttbv_sysmsgbutton setTitleColor:[Globle colorFromHexRGB:@"#616365"]
                             forState:UIControlStateNormal];
    [sttbv_sysmsgbutton setTitleColor:[Globle colorFromHexRGB:@"#146ead"]
                             forState:UIControlStateHighlighted];
    sttbv_sysmsgbutton.titleLabel.font =
        [UIFont systemFontOfSize:Font_Height_10_0];
    [sttbv_sysmsgbutton
        setImageEdgeInsets:UIEdgeInsetsMake(
                               0, (otherbutton_width - up_image.size.width) / 2,
                               10,
                               (otherbutton_width - up_image.size.width) / 2)];
    if (i == 2) {
      [sttbv_sysmsgbutton
          setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height - 15, -10,
                                              2, 10)];
    } else {
      [sttbv_sysmsgbutton
          setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height - 15, -10,
                                              2, 10)];
    }
    [sttbv_sysmsgbutton setImage:up_image forState:UIControlStateNormal];
    [sttbv_sysmsgbutton setImage:down_image forState:UIControlStateHighlighted];
    [sttbv_sysmsgbutton addTarget:self
                           action:@selector(buttonpressdown:)
                 forControlEvents:UIControlEventTouchUpInside];
    sttbv_sysmsgbutton.tag = i;
    [self addSubview:sttbv_sysmsgbutton];
    i++;
  }
  [self resetinterface:0];
}
- (void)resetinterface:(NSInteger)index {
  if (sbtb_infoarray == nil || [sbtb_infoarray count] <= index)
    return;
  int i = 0;
  for (UIButton *button in sbtb_buttonarray) {
    MarketBottomButtonInfo *info = sbtb_infoarray[i];
    UIImage *up_image = [UIImage imageNamed:info.notSellectedImageName];
    UIImage *down_image = [UIImage imageNamed:info.sellectedImageName];
    if (i == index) {
      [button setTitleColor:[Globle colorFromHexRGB:@"#146ead"]
                   forState:UIControlStateNormal];
      [button setImage:down_image forState:UIControlStateNormal];

    } else {
      [button setTitleColor:[Globle colorFromHexRGB:@"#616365"]
                   forState:UIControlStateNormal];
      [button setImage:up_image forState:UIControlStateNormal];
    }
    i++;
  }
}

#pragma mark
#pragma mark 按钮点击相应
- (void)buttonpressdown:(UIButton *)button {
  [self resetinterface:button.tag];
  if (_delegate && [_delegate respondsToSelector:@selector(pressDownIndex:)]) {
    [_delegate pressDownIndex:button.tag];
  }
}

#pragma mark - 在写个按钮点击事件
- (void)buttonPressDownWithNum:(NSInteger)num {
  [self resetinterface:num];
  if (_delegate && [_delegate respondsToSelector:@selector(pressDownIndex:)]) {
    [_delegate pressDownIndex:num];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
