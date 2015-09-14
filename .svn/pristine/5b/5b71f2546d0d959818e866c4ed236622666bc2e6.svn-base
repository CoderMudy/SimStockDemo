//
//  Image_TextButton.m
//  SimuStock
//
//  Created by Mac on 15-3-3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "Image_TextButton.h"
#import "Globle.h"
#import "UIImage+ColorTransformToImage.h"

@implementation Image_TextButton

- (id)initWithImage:(NSString *)imageStr
           withText:(NSString *)text
       withTextFont:(float)textFont
      withTextColor:(NSString *)textColor
  withHighLighColor:(NSString *)highlightColor
  withTextAlignment:(NSInteger)alignmentType
          withFrame:(CGRect)btnFrame {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    UIImage *iconImage = [UIImage imageNamed:imageStr];
    //左侧icon图标
    iconImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, iconImage.size.width / 2.0f,
                                 iconImage.size.height / 2.0f)];
    iconImageView.image = iconImage;
    //右侧按钮名称
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:textFont]];
    buttonNameLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          iconImage.size.width / 2.0f + 5.0f,
                          (iconImage.size.height / 2.0f - textSize.height) /
                              2.0f,
                          textSize.width, textSize.height)];
    [buttonNameLabel setFont:[UIFont systemFontOfSize:10.0f]];
    buttonNameLabel.textAlignment = alignmentType;
    buttonNameLabel.text = text;
    buttonNameLabel.backgroundColor = [UIColor clearColor];
    buttonNameLabel.textColor = [Globle colorFromHexRGB:textColor];
    //上部透明按钮
    _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageTextBtn.frame =
        CGRectMake(0, 0, iconImage.size.width / 2.0f + textSize.width + 5,
                   iconImage.size.height / 2.0f);
    _imageTextBtn.backgroundColor = [UIColor clearColor];
    UIImage *highLightImage =
        [UIImage imageFromView:_imageTextBtn
            withBackgroundColor:[Globle colorFromHexRGB:@"dee0e1"]];
    //右对齐时，重调frame
    if (alignmentType == NSTextAlignmentRight) {
      buttonNameLabel.frame =
          CGRectMake(btnFrame.size.width - textSize.width,
                     (iconImage.size.height / 2.0f - textSize.height) / 2.0f,
                     textSize.width, textSize.height);
      iconImageView.frame = CGRectMake(btnFrame.size.width - textSize.width -
                                           5.0f - iconImage.size.width / 2.0f,
                                       0, iconImage.size.width / 2.0f,
                                       iconImage.size.height / 2.0f);
      _imageTextBtn.frame =
          CGRectMake(btnFrame.size.width - textSize.width - 5.0f -
                         iconImage.size.width / 2.0f,
                     0, iconImage.size.width / 2.0f + textSize.width + 5,
                     iconImage.size.height / 2.0f);
    }
    [_imageTextBtn setBackgroundImage:highLightImage
                             forState:UIControlStateHighlighted];
    self.bounds = _imageTextBtn.bounds;
    [self addSubview:iconImageView];
    [self addSubview:buttonNameLabel];
    [self insertSubview:_imageTextBtn atIndex:0];
  }
  return self;
}
- (void)refreshImageTextButtonWithText:(NSString *)text
                          WithTextFont:(float)textFont
                             withImage:(NSString *)imageStr
                     withTextAlignment:(NSInteger)alignmentType
                             withFrame:(CGRect)btnFrame {
  UIImage *image = [UIImage imageNamed:imageStr];
  CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:textFont]];
  buttonNameLabel.frame =
      CGRectMake(image.size.width / 2.0f + 5.0f,
                 (image.size.height / 2.0f - textSize.height) / 2.0f,
                 textSize.width, textSize.height);
  _imageTextBtn.frame =
      CGRectMake(0, 0, image.size.width / 2.0f + textSize.width + 5,
                 image.size.height / 2.0f);
  //右对齐时，重调frame
  if (alignmentType == NSTextAlignmentRight) {
    buttonNameLabel.frame =
        CGRectMake(btnFrame.size.width - textSize.width,
                   (image.size.height / 2.0f - textSize.height) / 2.0f,
                   textSize.width, textSize.height);
    iconImageView.frame = CGRectMake(
        btnFrame.size.width - textSize.width - 5.0f - image.size.width / 2.0f,
        0, image.size.width / 2.0f, image.size.height / 2.0f);
    _imageTextBtn.frame = CGRectMake(
        btnFrame.size.width - textSize.width - 5.0f - image.size.width / 2.0f,
        0, image.size.width / 2.0f + textSize.width + 5,
        image.size.height / 2.0f);
  }
  buttonNameLabel.text = text;
}
@end
