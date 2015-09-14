//
//  MessageDisplayViewController.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayViewController.h"
#import "YLColorToimage.h"
@interface MessageDisplayViewController () {
  double animationDuration;
  CGRect keyboardRect;
}

@end

@implementation MessageDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillShow:)
             name:UIKeyboardWillShowNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillHide:)
             name:UIKeyboardWillHideNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardChange:)
             name:UIKeyboardDidChangeFrameNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardChange:)
             name:UIKeyboardDidShowNotification
           object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self shareFaceView];
}

- (void)dealloc {
  self.messageToolView = nil;
  self.faceView = nil;
  self.shareMenuView = nil;

  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardWillShowNotification
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardWillHideNotification
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardDidChangeFrameNotification
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardDidShowNotification
              object:nil];
}

#pragma mark -keyboard
- (void)keyboardWillHide:(NSNotification *)notification {

  keyboardRect =
      [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  animationDuration =
      [notification
              .userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] -
      0.05f;
}

- (void)keyboardWillShow:(NSNotification *)notification {
  keyboardRect =
      [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  animationDuration =
      [notification
              .userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] -
      0.05f;
}

- (void)keyboardChange:(NSNotification *)notification {
  if ([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
          .origin.y < CGRectGetHeight(self.view.frame)) {
    keyboardRect =
        [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
  }
}

#pragma end

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele {
}

#pragma mark - messageView animation
- (void)messageViewAnimationWithMessageRect:(CGRect)rect
                   withMessageInputViewRect:(CGRect)inputViewRect
                                andDuration:(double)duration
                                   andState:(ZBMessageViewState)state {

  [UIView animateWithDuration:duration
      animations:^{
        self.messageToolView.frame = CGRectMake(
            0.0f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect) -
                      CGRectGetHeight(inputViewRect),
            CGRectGetWidth(self.view.frame), CGRectGetHeight(inputViewRect));

        switch (state) {
        case ZBMessageViewStateShowFace: {
          self.faceView.frame = CGRectMake(
              0.0f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect),
              CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));

          self.shareMenuView.frame =
              CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                         CGRectGetWidth(self.view.frame),
                         CGRectGetHeight(self.shareMenuView.frame));
        } break;
        case ZBMessageViewStateShowNone: {
          self.faceView.frame =
              CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                         CGRectGetWidth(self.view.frame),
                         CGRectGetHeight(self.faceView.frame));

          self.shareMenuView.frame =
              CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                         CGRectGetWidth(self.view.frame),
                         CGRectGetHeight(self.shareMenuView.frame));
        } break;
        case ZBMessageViewStateShowShare: {
          self.shareMenuView.frame = CGRectMake(
              0.0f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect),
              CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));

          self.faceView.frame =
              CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                         CGRectGetWidth(self.view.frame),
                         CGRectGetHeight(self.faceView.frame));
        } break;

        default:
          break;
        }

      }
      completion:^(BOOL finished){

      }];
}
#pragma end

- (void)viewDidLoad {

  self.view.backgroundColor = [UIColor whiteColor];
  [super viewDidLoad];
  [self initilzer];

  animationDuration = 0.25;
}
#pragma mark - 初始化
- (void)initilzer {

  if (_is_addHeight) {
    inputViewHeight = 70;
  } else {
    inputViewHeight = 50;
  }
  self.messageToolView = [[ZBMessageInputView alloc]
      initWithFrame:CGRectMake(0.0f,
                               self.view.frame.size.height - inputViewHeight,
                               self.view.frame.size.width, inputViewHeight)
          andHeight:self.is_addHeight
        andDelegate:self];
  self.messageToolView.delegate = self;
  [self.view addSubview:self.messageToolView];
}

- (void)shareFaceView {
  if (!self.faceView) {
    self.faceView = [[ZBMessageManagerFaceView alloc]
        initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                                 CGRectGetWidth(self.view.frame), 196)];
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];
  }
}

- (void)shareShareMeun {
  if (!self.shareMenuView) {
    self.shareMenuView = [[UIView alloc]
        initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame),
                                 CGRectGetWidth(self.view.frame), 196)];
    self.shareMenuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shareMenuView];

    UIView *backView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.view.width, 149)];
    backView.backgroundColor = [Globle colorFromHexRGB:@"6c717f"];
    [self.shareMenuView addSubview:backView];

    UIButton *sharePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharePicBtn.backgroundColor = [UIColor whiteColor];
    sharePicBtn.layer.cornerRadius = 5;
    sharePicBtn.layer.borderWidth = 1.0f;
    sharePicBtn.layer.borderColor = [UIColor blackColor].CGColor;
    sharePicBtn.frame = CGRectMake((self.view.width - 280) / 2, 10, 280, 50);
    sharePicBtn.tag = 1000;
    [sharePicBtn addTarget:self
                    action:@selector(shareMenuViewAndButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [sharePicBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [sharePicBtn setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    [sharePicBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]]
                           forState:UIControlStateHighlighted];
    [backView addSubview:sharePicBtn];

    UIButton *shareLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareLocBtn.backgroundColor = [UIColor whiteColor];
    shareLocBtn.layer.cornerRadius = 5;
    shareLocBtn.layer.borderWidth = 1.0f;
    shareLocBtn.layer.borderColor = [UIColor blackColor].CGColor;
    shareLocBtn.frame = CGRectMake((self.view.width - 280) / 2, 70, 280, 50);
    shareLocBtn.tag = 1001;
    [shareLocBtn addTarget:self
                    action:@selector(shareMenuViewAndButton:)
          forControlEvents:UIControlEventTouchUpInside];
    [shareLocBtn setTitle:@"从图库中选择" forState:UIControlStateNormal];
    [shareLocBtn setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    [shareLocBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]]
                           forState:UIControlStateHighlighted];
    [backView addSubview:shareLocBtn];
  }
}

#pragma mark - Action

#pragma mark - ZBMessageInputView Delegate
- (void)messageStyleButtonClicked:(YLClickButton *)sender {
  switch (sender.tag) {
  case 0: {
    [self didSelectedMultipleMediaAction:YES];
  } break;
  case 1: {
    [self didSendFaceAction:YES];
  } break;
  case 2: {
    [self didSendStock_codingAction:YES];
  } break;
  case 3: {
    [self didSendShare_ObjectsAction:YES];
  } break;
  case 4: {
    [self didSelectedMultipleMediaAction:NO];
  } break;
  case 5: {
    [self didSendFaceAction:NO];
  } break;

  default:
    break;
  }
}
#pragma end
#pragma mark - ZBMessageInputView Delegate
- (void)didSelectedMultipleMediaAction:(BOOL)changed {
  [self shareShareMeun];
  if (changed) {
    [self messageViewAnimationWithMessageRect:self.shareMenuView.frame
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowShare];
  } else {
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
  }
}

- (void)didSendFaceAction:(BOOL)sendFace {
  [self shareFaceView];
  if (sendFace) {
    [self messageViewAnimationWithMessageRect:self.faceView.frame
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowFace];
  } else {
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
  }
}

- (void)didSendStock_codingAction:(BOOL)sendFace {
  [self messageViewAnimationWithMessageRect:CGRectZero
                   withMessageInputViewRect:self.messageToolView.frame
                                andDuration:animationDuration
                                   andState:ZBMessageViewStateShowNone];
}
- (void)didSendShare_ObjectsAction:(BOOL)sendFace {
  [self messageViewAnimationWithMessageRect:CGRectZero
                   withMessageInputViewRect:self.messageToolView.frame
                                andDuration:animationDuration
                                   andState:ZBMessageViewStateShowNone];
}

/**
 *  在键盘的导航条上再加上一个uiview，比例，位置坐标
 */
- (void)addViewInMessageBottonView:(UIView *)view {
}

#pragma end

#pragma mark - ZBMessageShareMenuView Delegate
- (void)shareMenuViewAndButton:(UIButton *)sender {
}

#pragma end

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
