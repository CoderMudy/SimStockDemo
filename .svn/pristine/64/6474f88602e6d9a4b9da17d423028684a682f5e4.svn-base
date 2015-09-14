//
//  Image_TextButton.h
//  SimuStock
//
//  Created by Mac on 15-3-3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Image_TextButton : UIView {
  //左侧icon图标
  UIImageView *iconImageView;
  /** 封装按钮的名称 */
  UILabel *buttonNameLabel;
}
/** 顶部按钮 */
@property(nonatomic, strong) UIButton *imageTextBtn;
/** 聊股初始化 */
- (id)initWithImage:(NSString *)imageStr
           withText:(NSString *)text
       withTextFont:(float)textFont
      withTextColor:(NSString *)textColor
  withHighLighColor:(NSString *)highlightColor
  withTextAlignment:(NSInteger)alignmentType
          withFrame:(CGRect)btnFrame;
/** 刷新按钮显示 */
- (void)refreshImageTextButtonWithText:(NSString *)text
                          WithTextFont:(float)textFont
                             withImage:(NSString *)imageStr
                     withTextAlignment:(NSInteger)alignmentType
                             withFrame:(CGRect)btnFrame;

@end
