//
//  ZBMessageInputView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBMessageTextView.h"

///YL自定义高亮按钮
#import "YLClickButton.h"

typedef enum {
  ZBMessageInputViewStyleDefault, // ios7 样式
  ZBMessageInputViewStyleQuasiphysical
} ZBMessageInputViewStyle;

@protocol ZBMessageInputViewDelegate <NSObject>

@required

#pragma mark - Action

- (void)messageStyleButtonClicked:(YLClickButton *)sender;

#pragma end
/**
 *  在键盘的导航条上再加上一个uiview，比例，位置坐标
 */
- (void)addViewInMessageBottonView:(UIView *)view;
@end

@interface ZBMessageInputView : UIView

@property(nonatomic, weak) id<ZBMessageInputViewDelegate> delegate;

///新增加的20像素
@property(nonatomic) BOOL isHeight;


/**
 *  用于键盘上面的导航
 */
@property(nonatomic, retain) UIView *bottomView;


/**
 *  当前输入工具条的样式
 */
@property(nonatomic, assign) ZBMessageInputViewStyle messageInputViewStyle;

/**
 *  相机与拍照
 */
@property(nonatomic, strong) YLClickButton *Camera_pic_Button;

/**
 *  第三方表情按钮
 */
@property(nonatomic, strong) YLClickButton *faceSendButton;

/**
 *  股票代码
 */
@property(nonatomic, strong) YLClickButton *Stock_codingButton;

/**
 *  @对象
 */
@property(nonatomic, strong) YLClickButton *Share_ObjectsButton;

- (id)initWithFrame:(CGRect)frame
        andDelegate:(id<ZBMessageInputViewDelegate>)delegatekey;

- (id)initWithFrame:(CGRect)frame andHeight:(BOOL)isHeight
        andDelegate:(id<ZBMessageInputViewDelegate>)delegatekey;

@end
