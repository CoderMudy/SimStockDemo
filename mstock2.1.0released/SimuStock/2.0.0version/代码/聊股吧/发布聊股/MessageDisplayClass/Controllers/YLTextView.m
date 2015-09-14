//
//  YLTextView.m
//  MessageDisplay
//
//  Created by Mac on 14/12/16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "YLTextView.h"
#import "Globle.h"

///查询股票是否存在
#import "StockDBManager.h"
///查询用户联系人
#import "MyAttentionInfo.h"

///股票信息
#import "StockUtil.h"

///股票查询
#import "SelectStocksViewController.h"
///股票基本信息

///用户联系人
#import "WeiBoMyContactsVC.h"

#import "CacheUtil.h"

@implementation YLTextView

/// 是否需要标题输入框  是否进入就有文本
- (id)initWithFrame:(CGRect)frame
           andTitle:(BOOL)is_have
         andContent:(NSString *)content
            andType:(YLTypeTextView)type {
  self = [self initWithFrame:frame andTitle:is_have andType:type];
  if (self) {
    self.matchContent = content;
    _Text_contentView.attributedText = [self getAttributedString:content];
  }
  return self;
}

/// 是否需要标题输入框  是否进入就有文本
- (id)initWithFrame:(CGRect)frame
           andTitle:(BOOL)is_have
         andContent:(NSString *)content
        andNickName:(NSString *)nick
          andUserid:(NSString *)userid {
  self = [self initWithFrame:frame andTitle:is_have andType:YLSepcilNone];
  self.userNickName = nick;
  self.userID = userid;
  if (self) {
    self.yl_Object = [[YLDistributObject alloc] initWithnickName:nick andUid:userid];
    _Text_contentView.attributedText = [self getAttributedString:content];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(BOOL)is_have andType:(YLTypeTextView)type {
  self = [super initWithFrame:frame];
  if (self) {
    _strSource = NO;
    _Max_textView = 0;
    [self start:is_have andType:type];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.width = WIDTH_OF_SCREEN;
  [self layoutIfNeeded];
  self.contentSize = self.size;
}

///准备添加标题
- (void)titleBtnClick:(UIButton *)sender {
  sender.hidden = YES;
  _Title_View.hidden = NO;
  [_Title_textField becomeFirstResponder];
}

///获取第一相应时，回调
- (void)YLbecomeFirstResponderAPI {
  if (_YL_delegate && [_YL_delegate respondsToSelector:@selector(TitletextFieldBecomeFirstResponderAPI)]) {
    [_YL_delegate TitletextFieldBecomeFirstResponderAPI];
  }
}

///取消第一相应时，回调
- (void)YLresignFirstResponderAPI {
  if (_Title_textField && [_Title_textField.text length] <= 0) {
    titleBtn.hidden = NO;
    _Title_View.hidden = YES;
  }
}

- (void)start:(BOOL)is_have andType:(YLTypeTextView)type {
  self.bounces = NO;
  if (is_have == YES) {

    ///添加标题
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(10, 13, 80, 26);
    titleBtn.layer.cornerRadius = 13;
    titleBtn.tag = 5000;
    titleBtn.backgroundColor = [Globle colorFromHexRGB:@"689ee3"];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleBtn setTitle:@"添加标题" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn addTarget:self
                  action:@selector(titleBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleBtn];

    _Title_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    _Title_View.hidden = YES;
    _Title_View.userInteractionEnabled = YES;
    _Title_View.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_Title_View];

    _Title_textField = [[YLTextField alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width - 5, 37)];
    _Title_textField.delegate = self;
    _Title_textField.YLdelegate = self;
    _Title_textField.font = [UIFont systemFontOfSize:18];
    _Title_textField.placeholder = @" 请输入标题";
    _Title_textField.returnKeyType = UIReturnKeyDone;
    [_Title_textField setValue:[Globle colorFromHexRGB:@"939393"]
                    forKeyPath:@"_placeholderLabel.textColor"];
    NSString *title = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"YL_DisVCmessageDisplayView_TitletextField"];
    _Title_textField.text = title;
    _Title_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _Title_textField.keyboardType = UIKeyboardTypeDefault;
    [_Title_View addSubview:_Title_textField];
    _Title_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _Title_textField.userInteractionEnabled = YES;
    _Title_textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    _Title_textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_Title_textField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];

    UILabel *label_text = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 50, 35, 40, 10)];
    label_text.text = @"(非必填)";
    label_text.backgroundColor = [UIColor clearColor];
    label_text.textColor = [Globle colorFromHexRGB:@"939393"];
    label_text.font = [UIFont systemFontOfSize:11];
    [_Title_View addSubview:label_text];

    UIView *Dividing_line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.bounds.size.width, 1)];
    Dividing_line.backgroundColor = [Globle colorFromHexRGB:@"#0B6FAF"];
    [_Title_View addSubview:Dividing_line];

    _Text_contentView =
        [[ZBMessageTextView alloc] initWithFrame:CGRectMake(5, 50, self.bounds.size.width - 10, 50)];
    _Text_contentView.placeHolder = @"聊点新鲜事...";
    _Text_contentView.userInteractionEnabled = YES;
    _Text_contentView.placeHolderTextColor = [Globle colorFromHexRGB:@"939393"];
    _Text_contentView.font = [UIFont systemFontOfSize:18];
    _Text_contentView.delegate = self;
    _Text_contentView.textColor = [UIColor blackColor];
    _Text_contentView.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_Text_contentView];
  } else {
    _Text_contentView =
        [[ZBMessageTextView alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, 50)];
    _Text_contentView.placeHolder = @"聊点新鲜事...";
    _Text_contentView.userInteractionEnabled = YES;
    _Text_contentView.placeHolderTextColor = [Globle colorFromHexRGB:@"939393"];
    _Text_contentView.font = [UIFont systemFontOfSize:18];
    _Text_contentView.delegate = self;
    _Text_contentView.textColor = [UIColor blackColor];
    _Text_contentView.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_Text_contentView];
  }
  _Text_contentView.returnKeyType = UIReturnKeyDone;
  _Text_contentView.dataDetectorTypes = UIDataDetectorTypeLink;
  _Text_contentView.textAlignment = NSTextAlignmentLeft;
  _Text_contentView.backgroundColor = [UIColor clearColor];
  _Text_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _Text_contentView.scrollEnabled = NO;

  _Share_imageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(5, _Text_contentView.bottom + 5, 120, 50)];
  _Share_imageView.userInteractionEnabled = YES;
  _Share_imageView.hidden = YES;
  [self addSubview:_Share_imageView];

  UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
  clearButton.frame = CGRectMake(105, -5, 20, 20);
  clearButton.userInteractionEnabled = YES;
  [clearButton setImage:[UIImage imageNamed:@"关闭小按钮"] forState:UIControlStateNormal];
  [clearButton addTarget:self
                  action:@selector(clearButtonClick:)
        forControlEvents:UIControlEventTouchUpInside];
  clearButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
  [_Share_imageView addSubview:clearButton];

  NSString *UserID = [SimuUtil getUserID];
  switch (type) {
  case YLDisVCTextView: {
    NSString *Key = [NSString stringWithFormat:@"YLDistributeVC_%@", UserID];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:Key];
    [self GetSaveText:dic];
  } break;
  case YLReplyVCTextView: {
    NSString *Key = [NSString stringWithFormat:@"YLReplyVC_%@", UserID];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:Key];
    [self GetSaveText:dic];
  } break;
  case YLReviewTextView: {
    NSString *Key = [NSString stringWithFormat:@"YLReviewVC_%@", UserID];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:Key];
    [self GetSaveText:dic];
  } break;
  default:
    break;
  }
  ///剩余字体
  [self Remaining];

  _Text_contentView.contentSize = CGSizeMake(self.width, _Text_contentView.contentSize.height);

  if (self.Share_imageView.image) {
    self.contentSize = CGSizeMake(WIDTH_OF_SCREEN, _Share_imageView.bottom);
  } else {
    self.contentSize = CGSizeMake(WIDTH_OF_SCREEN, _Text_contentView.bottom);
  }
  [self Adjust_Height];
}

///获取缓存数据
- (void)GetSaveText:(NSDictionary *)dic {
  if ([dic count] > 0) {
    NSString *Title = dic[@"Title"];
    if ([Title length] > 0) {
      self.Title_textField.text = Title;
      UIButton *btn = (UIButton *)[self viewWithTag:5000];
      btn.hidden = YES;
      _Title_View.hidden = NO;
    }
    NSString *Content = dic[@"Content"];
    if ([Content length] > 0) {
      self.Text_contentView.text = Content;
    }
    NSData *imageData = dic[@"Image"];
    if ([imageData length] > 0) {
      self.Share_imageView.hidden = NO;
      self.Share_imageView.image = [UIImage imageWithData:imageData];
      float width = [dic[@"Image_Width"] floatValue];
      float heigh = [dic[@"Image_Height"] floatValue];
      if (width > 0 && heigh > 0) {
        if (width > 120) {
          self.Share_imageView.width = 120;
          self.Share_imageView.height = 120 * heigh / width;
        } else {
          self.Share_imageView.width = width;
          self.Share_imageView.height = heigh;
        }
      }
    }
  }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isKindOfClass:[UIScrollView class]] && ![touch.view isKindOfClass:[UITextField class]]) {
    [_Text_contentView becomeFirstResponder];
    if (self.YL_delegate && [_YL_delegate respondsToSelector:@selector(ModifyKeyboardState)]) {
      [self.YL_delegate ModifyKeyboardState];
    }
  }
  if ([touch.view isKindOfClass:[UITextField class]]) {
    [_Title_textField becomeFirstResponder];
  }
  return YES;
}

#pragma mark - UITextField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  return YES;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if (string.length == 0)
    return YES;

  NSInteger existedLength = textField.text.length;
  NSInteger selectedLength = range.length;
  NSInteger replaceLength = string.length;
  if (existedLength - selectedLength + replaceLength > 20) {
    return NO;
  }

  return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
  UITextRange *selectedRange = [textField markedTextRange];
  //获取高亮部分
  UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
  //不是联想输入状态
  if (!position) {
    if (textField.text.length > 20) {
      textField.text = [textField.text substringToIndex:20];
    }
  }
}

- (void)clearButtonClick:(UIButton *)sender {
  _Share_imageView.image = nil;
  self.contentSize = CGSizeMake(self.width, _Text_contentView.bottom);
  _Share_imageView.hidden = YES;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}
#pragma mark 获取xml格式的字符串，用于发布给后台
/// 获取xml格式的字符串，用于发布给后台
- (NSString *)getXMLfromstring:(NSString *)string {
  if (string == nil || [string length] <= 0 || [SimuUtil isBlankString:string]) {
    return nil;
  }
  //正则http链接
  string = [self MatchHttp:string];
  ///替换用户好友的标签
  string = [self replaceDomainXMLFriend:string];
  ///替换股票的标签
  string = [self replaceDomainXMLStock:string];

  ///去空格
  while ([[string componentsSeparatedByString:@"  "] count] > 1) {
    string = [string stringByReplacingOccurrencesOfString:@"  " withString:@" "];
  }
  ///去换行符
  while ([[string componentsSeparatedByString:@"\n\n"] count] > 1) {
    string = [string stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
  }

  return string;
}
//(https?://[^"]+)
- (NSString *)MatchHttp:(NSString *)str {
  __block NSString *string = [NSString stringWithFormat:@"%@", str];

  __block NSString *result = @"";
  NSError *error;

  NSRegularExpression *regex1 =
      [NSRegularExpression regularExpressionWithPattern:@"https?://[^\\s]+" options:0 error:&error];

  [regex1 enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                          //从urlString中截取数据
                          result = [string substringWithRange:match.range];
                          NSString *stockStr =
                              [NSString stringWithFormat:@"<a href=\"%@\" alt=\"网页链接\"/> ", result];
                          string = [string stringByReplacingOccurrencesOfString:result
                                                                     withString:stockStr];
                        }];
  return string;
}

///替换有颜色的的股票，转化成，xml标签格式
- (NSString *)replaceDomainXMLStock:(NSString *)str {
  __block NSString *string = [NSString stringWithFormat:@"%@", str];

  __block NSString *result = @"";
  NSError *error;

  NSRegularExpression *regex1 =
      [NSRegularExpression regularExpressionWithPattern:@"[$][^[$]]+?\\$\\s"
                                                options:0
                                                  error:&error];

  __block int lock_str = 0;
  [regex1 enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                          if (lock_str == 0) {
                            //从urlString中截取数据
                            result = [string substringWithRange:match.range];
                            ///去头去尾，
                            result = [result substringWithRange:NSMakeRange(1, [result length] - 3)];
                            result = [result componentsSeparatedByString:@"("][0];
                            NSArray *array = [self Compliance_stock_Claim:result];

                            if ([array count] > 0) {
                              result = [string substringWithRange:match.range];
                              StockFunds *stockBase = array[0];
                              NSString *stockStr =
                                  [NSString stringWithFormat:@"<stock name=\"%@\" code=\"%@\"/> ", stockBase.name, stockBase.code];
                              lock_str = 1;
                              string = [string stringByReplacingOccurrencesOfString:result
                                                                         withString:stockStr];
                            }
                          }
                        }];

  if (lock_str == 1) {
    string = [self replaceDomainXMLStock:string];
    NSLog(@"DDDEE:%@", string);
  }
  return string;
}

///替换用户的好友列表，转化成，xml标签格式
- (NSString *)replaceDomainXMLFriend:(NSString *)str {
  NSInteger lock_str = 0;
  NSString *result = [str copy];
  NSArray *myAttentionList = [CacheUtil loadMyAttentionList].dataArray;
  __block NSMutableArray *myAttentionArrayM = [@[] mutableCopy];
  __block BOOL isAdd = NO;
  [myAttentionList enumerateObjectsUsingBlock:^(MyAttentionInfoItem *item, NSUInteger idx, BOOL *stop) {
    [myAttentionArrayM addObject:item.userListItem.nickName];
    if ([item.userListItem.nickName isEqualToString:self.userNickName]) {
      isAdd = YES;
    }
  }];
  if (!isAdd && self.userNickName) {
    [myAttentionArrayM addObject:self.userNickName];
  }
  for (NSUInteger i = 0; i < (str.length - 1); i++) {
    NSString *tempStr =
        [str substringWithRange:NSMakeRange(i, ((str.length - i) < 13 ? (str.length - i) : 13))];
    if ([tempStr hasPrefix:@"@"]) {
      for (NSUInteger j = ((str.length - i) < 13 ? (str.length - i) : 13); j > 2; j--) {
        NSString *checkStr = [tempStr substringWithRange:NSMakeRange(0, j)];
        NSString *nickNameStr = [checkStr substringFromIndex:1];
        if ([myAttentionArrayM containsObject:nickNameStr]) {
          NSString *userID = @"";
          if (!isAdd && [self.userNickName isEqualToString:nickNameStr]) {
            userID = self.userID;
          } else {
            userID = [[MyAttentionInfo sharedInstance] isKindOfMyContactWithuserID:nickNameStr];
          }
          NSString *stockStr =
              [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@ \"/> ", userID, nickNameStr];
          lock_str = 1;

          result = [result stringByReplacingOccurrencesOfString:checkStr withString:stockStr];
          i += j;
        }
      }
    }
  }
  if (lock_str == 1) {
    result = [self replaceDomainXMLFriend:result];
  }
  return result;
}

#pragma mark 当用户输入$,跳转到股票查询页面
/// 当用户输入$,跳转到股票查询页面
- (void)showSearchStockPage {
  OnStockSelected callback = ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
    NSLog(@"stockCode:%@,stockName:%@", stockCode, stockName);
    if ([stockCode length] > 0) {

      ///获得光标的位置
      NSRange range = self.Text_contentView.selectedRange;
      NSMutableString *mtStr = [NSMutableString stringWithString:self.Text_contentView.text];
      NSString *stockStr =
          [NSString stringWithFormat:@"%@(%@)$ ", stockName, [StockUtil sixStockCode:stockCode]];
      ;
      if (_strSource == NO) {
        stockStr = [NSString stringWithFormat:@"$%@", stockStr];
      }
      [mtStr insertString:stockStr atIndex:range.location];
      range.location += [stockStr length];
      _Text_contentView.text = mtStr;

      _Text_contentView.attributedText = [self getAttributedString:_Text_contentView.text];
      ///从新定位光标
      self.Text_contentView.selectedRange = range;

      ///调整高度
      [self Adjust_Height];

      ///剩余字数
      [self Remaining];
    }
  };
  SelectStocksViewController *selectStocksVC =
      [[SelectStocksViewController alloc] initStartPageType:BuyStockPage withCallBack:callback];
  [AppDelegate pushViewControllerFromRight:selectStocksVC];
}

///跳转用户联系人界面
- (void)showUserFriends {
  WeiBoMyContactsVC *wb = [[WeiBoMyContactsVC alloc] init];
  [AppDelegate pushViewControllerFromRight:wb];
  [wb FriendsWithCallBack:^(NSString *userID, NSString *userNickname) {
    NSLog(@"userid:%@,username:%@", userID, userNickname);
    if ([userNickname length] > 0) {
      ///获得光标的位置
      NSRange range = self.Text_contentView.selectedRange;

      NSMutableString *mtStr = [NSMutableString stringWithString:self.Text_contentView.text];
      NSMutableString *Name;
      if (_strSource == NO) {
        Name = [NSMutableString stringWithFormat:@"@%@ ", userNickname];
      } else {
        Name = [NSMutableString stringWithFormat:@"%@ ", userNickname];
      }
      [mtStr insertString:Name atIndex:range.location];
      range.location += [Name length];
      self.Text_contentView.text = mtStr;

      _Text_contentView.attributedText = [self getAttributedString:mtStr];
      ///从新定位光标的位置
      self.Text_contentView.selectedRange = range;

      ///调整高度
      [self Adjust_Height];

      ///剩余字数
      [self Remaining];
    }
  }];
}

///调整uitextview 高度
- (void)Adjust_Height {
  ///调整高度
  CGRect frame = _Text_contentView.frame;

  frame.size.height = [self heightForTextView:_Text_contentView WithText:_Text_contentView.text];
  if (frame.size.height < 50) {
    frame.size.height = 50;
  }
  [UIView animateWithDuration:.2
                   animations:^{
                     ///获得光标的位置
                     _Text_contentView.frame = frame;
                     if (_Share_imageView.hidden == NO) {
                       _Share_imageView.hidden = NO;
                       _Share_imageView.top = _Text_contentView.bottom + 5;
                       self.contentSize = CGSizeMake(self.width, _Share_imageView.bottom + 5);
                     } else {
                       _Share_imageView.hidden = YES;
                       self.contentSize = CGSizeMake(self.width, _Text_contentView.bottom);
                     }

                   }];
}
- (float)heightForTextView:(UITextView *)textView WithText:(NSString *)strText {
  float fPadding = 18.0; // 8.0px x 2

  CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);

  CGSize size = [strText sizeWithFont:textView.font
                    constrainedToSize:constraint
                        lineBreakMode:NSLineBreakByWordWrapping];

  float fHeight = size.height + 36.0;

  return fHeight;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  NSLog(@"textViewShouldBeginEditing");
  return YES;
}
- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"]) {
    return NO;
  }

  if (_Max_textView > 0) {
    if (text.length == 0)
      return YES;

    NSInteger existedLength = textView.text.length;
    //    NSInteger selectedLength = range.length;
    //    NSInteger replaceLength = text.length;
    if (existedLength >= 300) {
      return NO;
    }
  }
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

  UITextRange *selectedRange = [textView markedTextRange];
  //获取高亮部分
  UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
  //不是联想输入状态
  if (!position) {
    [self Remaining];
    ///调整高度
    [self Adjust_Height];
  }
}

///算剩余的字数
- (void)Remaining {
  NSLog(@"YLtextview的宽度：%f", self.width);
  NSString *string = _Text_contentView.text;
  if (_Max_textView > 0) {
    if ([string length] > _Max_textView) {
      string = [string substringToIndex:_Max_textView];
    }
  }
  if ([_YL_delegate respondsToSelector:@selector(YLTextViewDidChange:)]) {
    [_YL_delegate YLTextViewDidChange:[string length]];
  }

  ///获得光标的位置
  NSRange range = _Text_contentView.selectedRange;

  NSMutableAttributedString *attributedText = [self getAttributedString:string];
  _Text_contentView.attributedText = attributedText;

  _Text_contentView.selectedRange = range;
}

- (NSRange)isKindOfMyContactWithNickName:(NSString *)nickname {

  if ((self.yl_Object && [nickname hasPrefix:self.yl_Object.nickName])) {
    NSRange range = [nickname rangeOfString:self.yl_Object.nickName];
    return range;
  }

  MyAttentionInfo *myfriends = [MyAttentionInfo sharedInstance];
  NSRange result_range = NSMakeRange(0, 0);
  for (MyAttentionInfoItem *item in myfriends.myAttentionsArray.dataArray) {
    //此处最好转化下，容易出错
    NSString *oneUserNickName = item.userListItem.nickName;
    if ([nickname hasPrefix:oneUserNickName]) {
      NSRange range = [nickname rangeOfString:oneUserNickName];
      if (range.length > result_range.length) {
        result_range = range;
      }
    }
  }
  return result_range;
}

///获取 符合正则表达式 NSMutableAttributedString
- (NSMutableAttributedString *)getAttributedString:(NSString *)string {
  if (string == nil || [string length] <= 0) {
    return nil;
  }
  string = [self replaceDomain:string];

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

  NSError *error;

  /// 检测@对象并设置颜色
  NSArray *myAttentionList = [CacheUtil loadMyAttentionList].dataArray;
  __block NSMutableArray *myAttentionArrayM = [@[] mutableCopy];
  __block BOOL isAdd = NO;
  [myAttentionList enumerateObjectsUsingBlock:^(MyAttentionInfoItem *item, NSUInteger idx, BOOL *stop) {
    [myAttentionArrayM addObject:item.userListItem.nickName];
    if ([item.userListItem.nickName isEqualToString:self.userNickName]) {
      isAdd = YES;
    }
  }];
  if (!isAdd && self.userNickName) {
    [myAttentionArrayM addObject:self.userNickName];
  }
  for (NSUInteger i = 0; i < (string.length - 1); i++) {
    NSString *tempStr =
        [string substringWithRange:NSMakeRange(i, ((string.length - i) < 13 ? (string.length - i) : 13))];
    if ([tempStr hasPrefix:@"@"]) {
      for (NSUInteger j = ((string.length - i) < 13 ? (string.length - i) : 13); j > 2; j--) {
        NSString *checkStr = [tempStr substringWithRange:NSMakeRange(0, j)];
        if ([myAttentionArrayM containsObject:[checkStr substringFromIndex:1]]) {
          [attributedString addAttribute:NSForegroundColorAttributeName
                                   value:[Globle colorFromHexRGB:@"086DAE"]
                                   range:NSMakeRange(i, j)];
          i += j;
        }
      }
    }
  }

  // http+:[^\\s]* 这是检测网址的正则表达式
  //  NSRegularExpression *regex =
  //      [NSRegularExpression regularExpressionWithPattern:@"@[[^@]*]{3,12}"
  //                                                options:0
  //                                                  error:&error];
  [attributedString addAttribute:NSFontAttributeName
                           value:_Text_contentView.font
                           range:NSMakeRange(0, [string length])];

  //  [regex enumerateMatchesInString:string
  //                          options:0
  //                            range:NSMakeRange(0, [string length])
  //                       usingBlock:^(NSTextCheckingResult *match,
  //                                    NSMatchingFlags flags, BOOL *stop) {
  //
  //                         //从urlString中截取用户联系人数据
  //                         NSString *result =
  //                             [string substringWithRange:match.range];
  //                         //                         NSLog(@"结果:%@",
  //                         result);
  //                         ///去头去尾，
  //                         result = [result
  //                             substringWithRange:NSMakeRange(1, [result
  //                             length] -
  //                                                                   1)];
  //
  //                         NSRange Str_range =
  //                             [self isKindOfMyContactWithNickName:result];
  //
  //                         if (Str_range.length > 0) {
  //                           //把this的字体颜色变为红色
  //                           UIColor *str_color =
  //                               [Globle colorFromHexRGB:@"086DAE"];
  //
  //                           Str_range = NSMakeRange(match.range.location,
  //                                                   Str_range.length + 1);
  //
  //                           [attributedString
  //                               addAttribute:NSForegroundColorAttributeName
  //                                      value:str_color
  //                                      range:Str_range];
  //
  //                           [attributedString
  //                           addAttribute:NSFontAttributeName
  //                                                    value:_Text_contentView.font
  //                                                    range:match.range];
  //                         }
  //                       }];

  ///$股票代码
  NSRegularExpression *regex1 =
      [NSRegularExpression regularExpressionWithPattern:@"[$][^[$]]+?\\$\\s"
                                                options:0
                                                  error:&error];
  [regex1 enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                          //从urlString中截取数据
                          NSString *result = [string substringWithRange:match.range];
                          ///去头去尾，
                          result = [result substringWithRange:NSMakeRange(1, [result length] - 3)];
                          result = [result componentsSeparatedByString:@"("][0];
                          NSArray *array = [self Compliance_stock_Claim:result];
                          if ([array count] > 0) {
                            //把this的字体颜色变为红色
                            UIColor *str_color = [Globle colorFromHexRGB:@"f5a60d"];
                            [attributedString addAttribute:NSForegroundColorAttributeName
                                                     value:str_color
                                                     range:match.range];

                            [attributedString addAttribute:NSFontAttributeName
                                                     value:_Text_contentView.font
                                                     range:match.range];
                          }
                        }];

  ///$比赛标题
  NSRegularExpression *regex2 =
      [NSRegularExpression regularExpressionWithPattern:@"#[^#]+?\\#\\s" options:0 error:&error];
  [regex2 enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                          //从urlString中截取数据
                          NSString *result = [string substringWithRange:match.range];
                          if ([result isEqualToString:self.matchContent]) {
                            //把this的字体颜色变为红色
                            UIColor *str_color = [Globle colorFromHexRGB:@"086DAE"];
                            [attributedString addAttribute:NSForegroundColorAttributeName
                                                     value:str_color
                                                     range:match.range];
                            [attributedString addAttribute:NSFontAttributeName
                                                     value:_Text_contentView.font
                                                     range:match.range];
                          }
                        }];

  return attributedString;
}

- (NSString *)replaceDomain:(NSString *)str {
  __block NSString *string = [NSString stringWithFormat:@"%@", str];

  __block NSString *result = @"";
  NSError *error;

  NSRegularExpression *regex1 =
      [NSRegularExpression regularExpressionWithPattern:@"[$][^[$]]*[$]" options:0 error:&error];

  __block int lock_str = 0;
  [regex1 enumerateMatchesInString:string
                           options:0
                             range:NSMakeRange(0, [string length])
                        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                          if (lock_str == 0) {
                            //从urlString中截取数据
                            result = [string substringWithRange:match.range];
                            ///去头去尾，
                            result = [result substringWithRange:NSMakeRange(1, [result length] - 2)];
                            result = [result componentsSeparatedByString:@"("][0];
                            NSArray *array = [self Compliance_stock_Claim:result];

                            if ([array count] > 0) {
                              result = [string substringWithRange:match.range];
                              StockFunds *stockBase = array[0];
                              NSString *stockStr =
                                  [NSString stringWithFormat:@"$%@(%@)$", stockBase.name, [StockUtil sixStockCode:stockBase.stockCode]];
                              if ([result length] != [stockStr length]) {
                                lock_str = 1;
                                string = [string stringByReplacingOccurrencesOfString:result
                                                                           withString:stockStr];
                              }
                            }
                          }
                        }];
  if (lock_str == 1) {
    string = [self replaceDomain:string];
  }
  return string;
}
///是否 是符合规定的股票(股票代码和股票名称)
- (NSArray *)Compliance_stock_Claim:(NSString *)stockCode {
  return [StockDBManager searchFromDataBaseWithName:stockCode withRealTradeFlag:YES];
}

@end
