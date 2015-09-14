//
//  MessageDisplayViewController.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBMessageInputView.h"
#import "ZBMessageManagerFaceView.h"

static CGFloat inputViewHeight = 70.0f;

typedef NS_ENUM(NSInteger, ZBMessageViewState) {
  ZBMessageViewStateShowFace,//emoji表情界面
  ZBMessageViewStateShowShare,//
  ZBMessageViewStateShowNone,
};

@interface MessageDisplayViewController
    : BaseViewController <ZBMessageInputViewDelegate,
                          ZBMessageManagerFaceViewDelegate>

@property(nonatomic, strong) ZBMessageInputView *messageToolView;

@property(nonatomic, strong) ZBMessageManagerFaceView *faceView;

@property(nonatomic, strong) UIView *shareMenuView;

@property(nonatomic, assign) CGFloat previousTextViewContentHeight;
///(YL)新添加的 需不需要在自定义键盘上加20像素
@property(nonatomic) BOOL is_addHeight;

- (void)messageViewAnimationWithMessageRect:(CGRect)rect
                   withMessageInputViewRect:(CGRect)inputViewRect
                                andDuration:(double)duration
                                   andState:(ZBMessageViewState)state;

/** 相机相册*/
- (void)didSelectedMultipleMediaAction:(BOOL)changed;
/** emoji表情*/
- (void)didSendFaceAction:(BOOL)sendFace;
/** 选择股票*/
- (void)didSendStock_codingAction:(BOOL)sendFace;
/** 选择@对象*/
- (void)didSendShare_ObjectsAction:(BOOL)sendFace;
@end
