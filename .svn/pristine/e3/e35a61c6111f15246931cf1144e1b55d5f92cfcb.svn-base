//
//  simuleftImagButtonView.m
//  SimuStock
//
//  Created by Mac on 14-7-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuleftImagButtonView.h"
#import "SimuUtil.h"

@interface SimuleftImagButtonView () {
}
@end

@implementation SimuleftImagButtonView

@synthesize delegate = _delegate;
@synthesize titlelable = _titlelable;

- (id)initWithFrame:(CGRect)frame
          ImageName:(NSString *)image_name
          TitleName:(NSString *)title_name
          TextColor:(NSString *)textCol
                Tag:(NSInteger)tag {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    //底部图片

    [self creatButtonWithFrame:frame
                     ImageName:image_name
                 withTitleName:title_name
                 withTextColor:textCol
                       withTag:tag];
  }
  return self;
}

- (void)awakeFromNib {
  //赋值
  [super awakeFromNib];
  [self creatButtonWithFrame:self.bounds
                   ImageName:@"加资金图标.png"
               withTitleName:@"资金"
               withTextColor:@"#d23f30"
                     withTag:100];
}

/** 创建控件 */
- (void)creatButtonWithFrame:(CGRect)frame
                   ImageName:(NSString *)image_name
               withTitleName:(NSString *)title_name
               withTextColor:(NSString *)textCol
                     withTag:(NSInteger)tag {
  _buttonTag = tag;
  UIView *backview = [[UIView alloc] initWithFrame:self.bounds];
  backview.backgroundColor = [Globle colorFromHexRGB:@"e0e1e3"];
  [self addSubview:backview];
  backview.hidden = YES;
  _backView = backview;

  //左侧图片
  // if(image_name)
  //{
  UIImage *image = [UIImage imageNamed:image_name];
  UIImageView *iamgevew = [[UIImageView alloc]
      initWithFrame:CGRectMake(
                        7, (self.bounds.size.height - image.size.height) / 2,
                        image.size.width - 1, image.size.height - 1)];
  iamgevew.image = image;
  iamgevew.layer.cornerRadius = iamgevew.width * 0.5;
  iamgevew.layer.masksToBounds = YES;
  [self addSubview:iamgevew];
  //}
  //标题
  UILabel *lable = [[UILabel alloc]
      initWithFrame:CGRectMake(
                        iamgevew.frame.origin.x + iamgevew.frame.size.width + 4,
                        0, self.bounds.size.width - 27, frame.size.height)];
  lable.backgroundColor = [UIColor clearColor];
  lable.textColor = [Globle colorFromHexRGB:textCol];
  lable.textAlignment = NSTextAlignmentLeft;
  lable.font = [UIFont systemFontOfSize:Font_Height_13_0];
  lable.text = title_name;
  [self addSubview:lable];
  _titlelable = lable;

  //按钮
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = [UIColor clearColor];
  [button setBackgroundImage:[UIImage imageNamed:@"点击背景图.png"]
                    forState:UIControlStateHighlighted];
  button.frame = self.bounds;
  [button addTarget:self
                action:@selector(pressup:)
      forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:button];
}

- (void)pressdown:(UIButton *)button {
  _backView.hidden = NO;
}
- (void)pressup:(UIButton *)button {
  _backView.hidden = YES;
  if (_delegate && [_delegate respondsToSelector:@selector(ButtonPressUp:)]) {
    [_delegate ButtonPressUp:_buttonTag];
  }
}

#pragma mark
#pragma mark 对外接口
- (void)clearState {
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
