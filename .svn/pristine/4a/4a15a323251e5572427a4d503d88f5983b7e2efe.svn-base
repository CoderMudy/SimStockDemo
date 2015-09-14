//
//  FSExtendButtons.m
//  SimuStock
//
//  Created by moulin wang on 15/3/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FSExtendButtons.h"

#define ViewHeight 36

@interface FSExtendButtons ()
//配资
@property(assign, nonatomic) BOOL firmCapital;
@end

@implementation FSExtendButtons

static FSExtendButtons *fsButtons;
+ (FSExtendButtons *)sharedExtendButtons {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    fsButtons = [[FSExtendButtons alloc] init];
    fsButtons.hidden = YES;
    fsButtons.alpha = 0;
  });
  return fsButtons;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createUI];
  }
  return self;
}

- (void)createUI {
  //设置按钮  3个按钮  行情 买入 卖出
  //框 高72 三角高度 18 宽 37 分割线高度 48
  self.frame = [UIScreen mainScreen].bounds;
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = YES;

  //框内容
  _blueViewAndArrow = [[BlueViewAndArrow alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEW, 45)];
  _blueViewAndArrow.onLeftOrRight = NO;
  [self addSubview:_blueViewAndArrow];
}

#pragma mark - 缩小动画
- (void)hideAndScaleSmall {
  fsButtons.transform = CGAffineTransformMakeScale(1, 1);
  [UIView animateWithDuration:0.1
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        fsButtons.transform = CGAffineTransformMakeScale(0.9, 0.9);
        fsButtons.alpha = 0;

      }
      completion:^(BOOL finished) {
        fsButtons.hidden = YES;
      }];
}

#pragma mark - 放大展现动画
- (void)showAndScaleLarge {
  fsButtons.hidden = NO;
  fsButtons.transform = CGAffineTransformMakeScale(0.9, 0.9);
  [UIView animateWithDuration:0.1
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        fsButtons.transform = CGAffineTransformMakeScale(1, 1);
        fsButtons.alpha = 1;
      }
      completion:^(BOOL finished){
      }];
}

#pragma mark - 触摸回调
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self hideAndScaleSmall];
}

#pragma mark - 添加按钮事件
- (UIButton *)buttonMaker:(NSString *)title
                   action:(ButtonPressed)action
             andButtonTag:(int)tag {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:title forState:UIControlStateNormal];
  button.tag = tag;
  button.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [button setTitleColor:[Globle colorFromHexRGB:Color_White]
               forState:UIControlStateNormal];

  //根据title 计算文字的长度
  CGSize titleSize =
      [title sizeWithFont:[UIFont systemFontOfSize:Font_Height_14_0]
          constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN, CGFLOAT_MAX)];
  button.frame = CGRectMake(_blueWidth, 0, titleSize.width + 18, 36);
  _blueWidth += button.frame.size.width;
  [_blueViewAndArrow addSubview:[self separatorMakerWithStartX:_blueWidth]];
  [button setOnButtonPressedHandler:action];
  [_blueViewAndArrow addSubview:button];
  return button;
}

#pragma mark - 创建分隔符
- (UIView *)separatorMakerWithStartX:(CGFloat)startX {
  UIView *separator =
      [[UIView alloc] initWithFrame:CGRectMake(startX, 6, 1, 24)];
  UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, 24)];
  leftLine.backgroundColor = [Globle colorFromHexRGB:Color_SeparatorLeft];
  UIView *rightLine =
      [[UIView alloc] initWithFrame:CGRectMake(0.5f, 0, 0.5f, 24)];
  rightLine.backgroundColor = [Globle colorFromHexRGB:Color_SeparatorRight];
  [separator addSubview:leftLine];
  [separator addSubview:rightLine];
  return separator;
}

#pragma mark - 网络部分
//点击行情  跳转页面
- (void)downHangQingToPersonageSharesWithButton:(UIButton *)button {
  if (self.firmCapital == YES) {
    [TrendViewController showDetailWithStockCode:self.posRes.stockCode
                                   withStockName:self.posRes.stockName
                                     withMatchId:@"1"
                                      withISFirm:YES];
  } else {
    [TrendViewController showDetailWithStockCode:self.stockListData.stockCode
                                   withStockName:self.stockListData.stockName
                                     withMatchId:@"1"
                                      withISFirm:YES];
  }
}
//点击 买入 跳转
- (void)downMaiRuToViewWitnButtonTag:(UIButton *)button {
  if (_buttonDelegate &&
      [_buttonDelegate
          respondsToSelector:@selector(selectedButtonToTagWithButton:
                                                   andPositionResult:
                                                      andFirmCapital:)]) {
    if (self.firmCapital == YES) {
      [self.buttonDelegate selectedButtonToTagWithButton:button
                                       andPositionResult:self.posRes
                                          andFirmCapital:self.firmCapital];
    } else {
      [self.buttonDelegate selectedButtonToTagWithButton:button
                                       andPositionResult:self.stockListData
                                          andFirmCapital:self.firmCapital];
    }
  }
}
//点击 卖出 跳转
- (void)downMaiChuToViewWitnButtonTag:(UIButton *)button {
  if (_buttonDelegate &&
      [_buttonDelegate
          respondsToSelector:@selector(selectedButtonToTagWithButton:
                                                   andPositionResult:
                                                      andFirmCapital:)]) {
    if (self.firmCapital == YES) {
      [self.buttonDelegate selectedButtonToTagWithButton:button
                                       andPositionResult:self.posRes
                                          andFirmCapital:self.firmCapital];
    } else {
      [self.buttonDelegate selectedButtonToTagWithButton:button
                                       andPositionResult:self.stockListData
                                          andFirmCapital:self.firmCapital];
    }
  }
}

/************** 创建扩展框 ****************/
+ (void)showWithTweetListItem:(NSObject *)obj
                      offsetY:(CGRect)rect
                       andNum:(NSInteger)num
                      andSale:(NSString *)sale
                      andBool:(BOOL)firmCapital {
  if (!obj) {
    return;
  }
  fsButtons.firmCapital = firmCapital;
  if (firmCapital) {
    //用来取出positionData.resultArr数组里的 PositionResult
    //里面保存的是证券的info
    //用来取出positionData.resultArr数组里的 PositionResult
    //里面保存的是证券的info
    DataArray *position = (DataArray *)obj;
    fsButtons.posRes = position.array[num];
  } else {
    fsButtons.capitalDataArray = (DataArray *)obj;
    fsButtons.stockListData = fsButtons.capitalDataArray.array[num];
  }
  //选中Cell是第几行Cell 即 Cell的indexPath.row
  fsButtons.number = num;
  
  //取出sale
  fsButtons.sale = sale;

  //创建 扩展矿
  [fsButtons refreshButtonsFormWeiboCell];
  //重新设置宽度 和箭头
  [fsButtons resetBlueViewAndArrowsFrameWithOffsetY:rect.origin.y];
  [fsButtons showAndScaleLarge];
}

- (void)refreshButtonsFormWeiboCell {
  //第一步 先清空
  [_blueView removeAllSubviews];
  if (![self.sale isEqualToString:@"sale"]) {
    //实现按钮点击后 回调事件的Block
    ButtonPressed eliteButtonBlock = ^{
      //先把按钮 消失
      [self hideAndScaleSmall];
      //跳转 到行情界面的方法
      [self downHangQingToPersonageSharesWithButton:_button1];
    };
    //添加 行情按钮
    _button1 =
        [self buttonMaker:@"行情" action:eliteButtonBlock andButtonTag:0];
    //买入 按钮
    ButtonPressed maiRuButtonBlock = ^{
      [self hideAndScaleSmall];
      //跳转 到买入界面的方法
      [self downMaiRuToViewWitnButtonTag:_button2];
    };
    //创建按钮
    _button2 =
        [self buttonMaker:@"买入" action:maiRuButtonBlock andButtonTag:1];
    //卖出 按钮
    ButtonPressed maiChuButtonBlock = ^{
      [self hideAndScaleSmall];
      //跳转 到卖出界面的方法
      [self downMaiChuToViewWitnButtonTag:_button3];
    };
    //创建 卖出按钮
    _button3 =
        [self buttonMaker:@"卖出" action:maiChuButtonBlock andButtonTag:2];
  }
}

#pragma mark - ⭐️重设蓝框和箭头位置
- (void)resetBlueViewAndArrowsFrameWithOffsetY:(CGFloat)offsetY {
  // cell高度计算提示框应该出现的位置

  // blueView
  CGRect blueViewFrame = _blueViewAndArrow.frame;
  blueViewFrame.origin.y = offsetY - 36;
  if (blueViewFrame.origin.y < 0) {
    blueViewFrame.origin.y = 10;
  }else{
    blueViewFrame.origin.y = blueViewFrame.origin.y + 15;
  }
  _blueViewAndArrow.frame = blueViewFrame;
  [_blueViewAndArrow reDrawRectWithWidth:_blueWidth];
  _blueWidth = 0;
}

@end
