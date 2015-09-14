//
//  MessageDisplayDetailViewController.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"
#import "ImageUtil.h"

@implementation MessageStockJsonObject

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end

///发表聊股的共同（父类）
@interface MessageDisplayDetailViewController () {
  NSMutableArray *messages;
}

@end

@implementation MessageDisplayDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithCallBack:(OnReturnObject)callback {
  if (self = [super init]) {
    // 发布聊股 回调函数
    OnReturnObjectCallback = callback;
  }

  return self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self.messageDisplayView.Text_contentView becomeFirstResponder];
  if (self.messageDisplayView.contentSize.height -
          self.messageDisplayView.height >
      0) {
    self.messageDisplayView.contentOffset =
        CGPointMake(0, self.messageDisplayView.contentSize.height -
                           self.messageDisplayView.height);
  }
  ///还原 相册和emoji，复位
  [self ModifyKeyboardState];
}

- (void)viewDidLoad {
  messages = [[NSMutableArray alloc] initWithCapacity:0];
  self.view.backgroundColor = [UIColor whiteColor];
  [super viewDidLoad];
}

- (void)ModifyKeyboardState {
  ///还原 相册和emoji，复位，

  ///键盘变相机
  [self KeyboardToCamera];

  ///键盘变emoji
  [self KeyToEmoji];
}

/// 取消当前界面 按钮触发事件
- (void)leftButtonPress {
  [super leftButtonPress];
}

///右边按钮按下  delegate代理
- (void)rightButtonPress {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect
                   withMessageInputViewRect:(CGRect)inputViewRect
                                andDuration:(double)duration
                                   andState:(ZBMessageViewState)state {

  [super messageViewAnimationWithMessageRect:rect
                    withMessageInputViewRect:inputViewRect
                                 andDuration:duration
                                    andState:state];

  self.messageDisplayView.frame = CGRectMake(
      0.0f, 0.0f, WIDTH_OF_SCREEN, self.messageToolView.frame.origin.y -
                              (self.view.height - self.clientView.height));
}
/**
 *  在键盘的导航条上再加上一个uiview，比例，位置坐标
 */
- (void)addViewInMessageBottonView:(UIView *)view {
}
#pragma mark - ZBMessageFaceViewDelegate
/**
 *  点击相册大按钮
 */
- (void)didSelectedMultipleMediaAction:(BOOL)changed {
  [super didSelectedMultipleMediaAction:changed];
}

- (void)didSendFaceAction:(BOOL)sendFace {
  [super didSendFaceAction:sendFace];
}

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele {
  ///获得光标的位置
  NSRange range = self.messageDisplayView.Text_contentView.selectedRange;
  NSMutableString *mtStr = [NSMutableString
      stringWithString:self.messageDisplayView.Text_contentView.text];
  [mtStr insertString:faceStr atIndex:range.location];
  range.location += [faceStr length];
  self.messageDisplayView.Text_contentView.text = mtStr;
  [self.messageDisplayView getAttributedString:mtStr];

  ///从新定位光标
  self.messageDisplayView.Text_contentView.selectedRange = range;
  [self.messageDisplayView Adjust_Height];
  ///剩余字体
  [self.messageDisplayView Remaining];
}

- (void)didSendStock_codingAction:(BOOL)sendFace {

  [super didSendStock_codingAction:sendFace];

  self.messageDisplayView.strSource = NO;
  ///查询股票 并获取股票代码名称
  [self.messageDisplayView showSearchStockPage];
}
- (void)didSendShare_ObjectsAction:(BOOL)sendFace {

  [super didSendShare_ObjectsAction:sendFace];
  self.messageDisplayView.strSource = NO;
  ///查询用户的联系好友
  [self.messageDisplayView showUserFriends];
}

#pragma mark - ZBMessageShareMenuView Delegate

- (void)shareMenuViewAndButton:(UIButton *)sender {
  NSInteger index = sender.tag - 1000;

  NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  // 判断是否支持相机
  if ([UIImagePickerController
          isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    switch (index) {
    case 0: //相机
    {
      //                    隐藏状态拦
      [[UIApplication sharedApplication] setStatusBarHidden:NO];
      sourceType = UIImagePickerControllerSourceTypeCamera;
    } break;
    case 1: //相册
    {
      //                    //                    隐藏状态拦
      [[UIApplication sharedApplication] setStatusBarHidden:NO];
      [[UIApplication sharedApplication]
          setStatusBarStyle:UIStatusBarStyleDefault];
      sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } break;
    case 3: //取消
    default:
      return;
    }
  }

  // 跳转到相机或相册页面
  UIImagePickerController *imagePickerController =
      [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = NO;
  imagePickerController.delegate = self;
  imagePickerController.sourceType = sourceType;
  if (SYSTEM_VERSION < 7.0) {
    imagePickerController.navigationBar.tintColor =
        [Globle colorFromHexRGB:Color_Blue_but];
  }
  [self.navigationController presentViewController:imagePickerController
                                          animated:YES
                                        completion:^{
                                        }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [AppDelegate navigationController:self.navigationController
             willShowViewController:self];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  [AppDelegate navigationController:navigationController
             willShowViewController:viewController];
}
#pragma mark - image picker delegte
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:NO
                             completion:^{

                             }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:YES
                             completion:^{
                             }];

  UIImage *image = info[UIImagePickerControllerOriginalImage];
  if (!image) {
    return;
  }

  self.messageDisplayView.Share_imageView.size =
      CGSizeMake(120, image.size.height * 120 / image.size.width);

  self.messageDisplayView.Share_imageView.top =
      self.messageDisplayView.Text_contentView.bottom + 5;

  self.messageDisplayView.contentSize = CGSizeMake(
      self.view.width, self.messageDisplayView.Share_imageView.bottom);
  if (self.messageDisplayView.contentSize.height -
          self.messageDisplayView.height >
      0) {
    self.messageDisplayView.contentOffset =
        CGPointMake(0, self.messageDisplayView.contentSize.height -
                           self.messageDisplayView.height);
  }

  self.messageDisplayView.Share_imageView.hidden = NO;
  //    [self.messageDisplayView Adjust_Height];
  self.messageDisplayView.Share_imageView.image = image;
  //  [self.messageDisplayView Adjust_Height];
}

/// Title_textField 获得第一相应的，回调
- (void)TitletextFieldBecomeFirstResponderAPI {
  [self ModifyKeyboardState];
}
#pragma mark - ZBMessageInputView Delegate
- (void)messageStyleButtonClicked:(YLClickButton *)sender {
  [self.view endEditing:NO];
  [super messageStyleButtonClicked:sender];
  switch (sender.tag) {
  case 0: {
    ///相机变键盘
    [self CameraToKeyboard];
    if (self.messageToolView.faceSendButton.tag == 5) {
      ///键盘变emoji
      [self KeyToEmoji];
    }
  } break;
  case 1: {
    /// emoji 变键盘
    [self emojiToKeyboard];
    if (self.messageToolView.Camera_pic_Button.tag == 4) {
      ///键盘变 相机
      [self KeyboardToCamera];
    }
  } break;
  case 2: {
  } break;
  case 3: {
  } break;
  case 4: {
    [self.messageDisplayView.Text_contentView becomeFirstResponder];
    ///键盘 变相机
    [self KeyboardToCamera];
    if (self.messageToolView.faceSendButton.tag == 5) {
      ///键盘变，emoji
      [self KeyToEmoji];
    }
  } break;
  case 5: {
    [self.messageDisplayView.Text_contentView becomeFirstResponder];
    ///键盘，变emoji
    [self KeyToEmoji];
    if (self.messageToolView.Camera_pic_Button.tag == 4) {
      ///键盘变相机
      [self KeyboardToCamera];
    }
  } break;

  default:
    break;
  }
}

///相机图片，变键盘
- (void)CameraToKeyboard {
  self.messageToolView.Camera_pic_Button.tag = 4;
  [self.messageToolView.Camera_pic_Button
                 addimage:[UIImage imageNamed:@"键盘小图标.png"]
        andImageWithFrame:CGRectMake(
                              (self.messageToolView.frame.size.width / 4 - 28) /
                                  2,
                              12, 28, 26)
                 andColor:nil
      andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"]
                 forState:UIControlStateHighlighted];
}

/// emoji ,变键盘
- (void)emojiToKeyboard {
  self.messageToolView.faceSendButton.tag = 5;
  [self.messageToolView.faceSendButton
                 addimage:[UIImage imageNamed:@"键盘小图标.png"]
        andImageWithFrame:CGRectMake(
                              (self.messageToolView.frame.size.width / 4 - 28) /
                                  2,
                              12, 28, 26)
                 andColor:nil
      andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"]
                 forState:UIControlStateHighlighted];
}

///键盘，变相机
- (void)KeyboardToCamera {
  self.messageToolView.Camera_pic_Button.tag = 0;
  [self.messageToolView.Camera_pic_Button
                 addimage:[UIImage imageNamed:@"相机小图标.png"]
        andImageWithFrame:CGRectMake(
                              (self.messageToolView.frame.size.width / 4 - 28) /
                                  2,
                              12, 28, 26)
                 andColor:nil
      andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"]
                 forState:UIControlStateHighlighted];
}

///键盘 ，变emoji
- (void)KeyToEmoji {
  self.messageToolView.faceSendButton.tag = 1;
  [self.messageToolView.faceSendButton
                 addimage:[UIImage imageNamed:@"插入表情小图标.png"]
        andImageWithFrame:CGRectMake(
                              (self.messageToolView.frame.size.width / 4 - 28) /
                                  2,
                              12, 28, 26)
                 andColor:nil
      andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"]
                 forState:UIControlStateHighlighted];
}

#pragma mark - 发布聊股父类方法
///正式发布聊股
- (void)Edit_PathUrl:(NSString *)url andDic:(NSDictionary *)dic {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"POST_From"
                 withRequestParameters:dic
                withRequestObjectClass:[MessageStockJsonObject class]
               withHttpRequestCallBack:callback];

  /// 存储数据，下次重新请求
  [[UploadRequestController sharedManager] addCoredata:url
                                             andMethod:@"POST_From"
                                                andDic:dic];

  callback.onSuccess = ^(NSObject *object) {
    NSLog(@"聊股，发布成功");
    [[UploadRequestController sharedManager] deletePathUrl:url
                                                 andMethod:@"POST_From"
                                                    andDic:[dic JSONString]];
  };
}
///获取上传表单的字典dic
- (NSDictionary *)getDataWithDictionary_StockBar:(NSString *)barid
                                     andSourceID:(NSString *)sourceID
                                     andComments:(NSString *)string
                                        andTitle:(NSString *)title
                                        andImage:(UIImage *)shareImage {
  NSMutableDictionary *dicionary = [[NSMutableDictionary alloc] init];
  if (title && [title length] > 0) {
    dicionary[@"title"] = title;
  }
  if (barid && [barid length] > 0) {
    dicionary[@"barId"] = barid;
  }
  if (sourceID && [sourceID length] > 0) {
    dicionary[@"sourceid"] = sourceID;
  }
  if (string) {
    dicionary[@"content"] = string;
  }
  if (shareImage) {
    shareImage = [ImageUtil imageForUploadFromImage:shareImage];
    NSData *picFile = UIImageJPEGRepresentation(shareImage, 0.8);

    JhssPostData *postData = [[JhssPostData alloc] init];
    postData.data = picFile;
    postData.contentType = @"image/jpeg";
    postData.filename = @"pic.jpg";

    dicionary[@"img"] = postData;
  }
  return dicionary;
}

///当点击左边退出按钮是保存的数据(dic)
- (NSDictionary *)saveDataWithDic {
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  NSString *title = self.messageDisplayView.Title_textField.text;
  if (title && [title length] > 0) {
    dic[@"Title"] = title;
  }
  NSString *content = self.messageDisplayView.Text_contentView.text;
  if (content && [content length] > 0) {
    ///去换行符
    while ([[content componentsSeparatedByString:@"\n\n"] count] > 1) {
      content = [content stringByReplacingOccurrencesOfString:@"\n\n"
                                                   withString:@"\n"];
    }
    dic[@"Content"] = content;
  }
  UIImage *image = self.messageDisplayView.Share_imageView.image;
  if (image) {
    NSData *imageData =
        UIImageJPEGRepresentation(image, 100); // UIImage对象转换成NSData
    dic[@"Image"] = imageData;

    dic[@"Image_Width"] = [NSString stringWithFormat:@"%f", image.size.width];
    dic[@"Image_Height"] = [NSString stringWithFormat:@"%f", image.size.height];
  }
  return dic;
}
@end
