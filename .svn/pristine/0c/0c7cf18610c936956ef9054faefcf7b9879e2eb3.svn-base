//
//  simuleftImagButtonView.h
//  SimuStock
//
//  Created by Mac on 14-7-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimuleftButtonDelegate <NSObject>

- (void)ButtonPressUp:(NSInteger)index;

@end
/*
 *类说明：左侧图片小按钮
 */
@interface SimuleftImagButtonView : UIView {
  //按钮标记
  NSInteger _buttonTag;
  //背景图片
  UIView *_backView;
}
- (id)initWithFrame:(CGRect)frame
          ImageName:(NSString *)image_name
          TitleName:(NSString *)title_name
          TextColor:(NSString *)textCol
                Tag:(NSInteger)tag;
- (void)clearState;
@property(weak, nonatomic) id<SimuleftButtonDelegate> delegate;
@property(weak, nonatomic) UILabel *titlelable;

@end
