//
//  WBDetailHeadView.m
//  SimuStock
//
//  Created by jhss on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBDetailHeadView.h"
#import "HomepageViewController.h"

@implementation WBDetailHeadView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  //吧名文字颜色
  [_barNameCoreTextView setTextSize:Font_Height_11_0];
  _barNameCoreTextView.hidden = YES;

  talkStockItem = [[TweetListItem alloc] init];

  self.downLine.directionStatus = @"1";
  [self.downLine setNeedsDisplay];
}

- (void)layoutSubviews {

  CGRect cuttingLineFrame = _verCuttingLine.frame;
  _verCuttingLine.frame =
      CGRectMake(cuttingLineFrame.origin.x, cuttingLineFrame.origin.y, 0.5f,
                 cuttingLineFrame.size.height);

  //昵称自适应长度
  _userGradeView.lblNickName.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_18_0];
  [_userGradeView bindUserListItem:_userItem isOriginalPoster:NO];

  //聊股内容 长按复制
  UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(longPressAction:)];
  longGes.minimumPressDuration = 1.0f;
  [self addGestureRecognizer:longGes];
}

/** 聊股内容长按操作 */
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateBegan) {
    //长按位置
    CGPoint loc = [gesture
        locationInView:[[UIApplication sharedApplication].delegate window]];
    //显示拓展按钮
    [WeiBoExtendButtons
        showButtonWithCopyContent:[_commentCoreTextView getVisibleFTCoreText]
                          offsetY:loc.y
                           bgView:self];
  }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:@"d9d9d9"];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (void)resetSelfBGColor {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (IBAction)clickPrasieButton:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
}

- (IBAction)clickCommentButton:(id)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
}

/** 绑定聊正文页面顶部视图信息 */
static const CGFloat spaceBetweenCommenttimeLabelAndPalaceView = 2;
- (NSInteger)bindWBDetailHeadViewInfo:(TweetListItem *)item
                   withWbButtomTabBar:(WBButtomTabBar *)wbButtomTabBar {
  talkStockItem = item;
  self.userItem = item.userListItem;
  [self.userGradeView bindUserListItem:item.userListItem isOriginalPoster:NO];
  self.userId = item.userListItem.userId;
  self.commentTimeLabel.text = [SimuUtil getDateFromCtime:item.ctime];
  CGSize commentTimesize =
      [self.commentTimeLabel.text sizeWithFont:[UIFont systemFontOfSize:11]];
  CGRect commentTimeLabelFrame = self.commentTimeLabel.frame;

  if (item.clickableBarName &&
      !([item.clickableBarName isEqualToString:@""])) {
    self.barNameCoreTextView.hidden = NO;
    //来自xxx的吧
    [self.barNameCoreTextView setTextSize:Font_Height_11_0];
    self.barNameCoreTextView.text = item.clickableBarName;
    [self.barNameCoreTextView fitToSuggestedHeight];

    //重置_barNameCoreTextView的x坐标
    CGRect barNameCoreTextViewFrame = self.barNameCoreTextView.frame;
    barNameCoreTextViewFrame.origin.x =
        commentTimeLabelFrame.origin.x + commentTimesize.width +
        spaceBetweenCommenttimeLabelAndPalaceView;
    self.barNameCoreTextView.frame = barNameCoreTextViewFrame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      CGRect barNameFrame = self.barNameCoreTextView.frame;
      barNameFrame.origin.y = commentTimeLabelFrame.origin.y;
      self.barNameCoreTextView.frame = barNameFrame;
    }
  }
  //评论按钮title
  NSString *commentStr =
      [NSString stringWithFormat:@"评论  %ld", (long)item.comment];
  [self.commentButton setTitle:commentStr forState:UIControlStateNormal];
  //赞按钮title
  NSString *praiseStr =
      [NSString stringWithFormat:@"赞   %ld", (long)item.praise];
  [self.prasieButton setTitle:praiseStr forState:UIControlStateNormal];
  //赞的状态
  if (![SimuUtil isLogined]) {
    item.isPraised = NO;
  } else {
    item.isPraised = [WBCoreDataUtil fetchPraiseTid:item.tstockid];
  }
  //是否加精
  if (item.elite > 0) {
    self.eliteImageView.hidden = NO;
  } else {
    self.eliteImageView.hidden = YES;
  }
  if (item.isPraised) {
    wbButtomTabBar.praiseImageView.image =
        [UIImage imageNamed:@"菜单栏赞小图标_down"];
    wbButtomTabBar.praiseButton.userInteractionEnabled = NO;
  } else {
    //底部赞按钮
    wbButtomTabBar.praiseImageView.image =
        [UIImage imageNamed:@"菜单栏赞小图标"];
  }
  [self.headImageView bindUserListItem:item.userListItem];
  NSInteger origin_y = 64.0f;
  if (item.title && [item.title length] > 0) {
    //标题高度
    CGRect titleViewFrame = self.titleLabel.frame;
    CGSize titleSize =
        [item.title sizeWithFont:[UIFont systemFontOfSize:15.0f]
               constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 30, 100)
                   lineBreakMode:NSLineBreakByTruncatingTail];
    self.titleLabel.frame =
        CGRectMake(titleViewFrame.origin.x, titleViewFrame.origin.y,
                   titleViewFrame.size.width, titleSize.height);
    self.titleLabel.text = item.title;
    origin_y = origin_y + titleSize.height;
  }
  //评论高度
  CGRect commentViewFrame = self.commentCoreTextView.frame;
  self.commentCoreTextView.frame = CGRectMake(
      commentViewFrame.origin.x, origin_y, (WIDTH_OF_SCREEN - 30), 0);

  [self.commentCoreTextView setTextSize:14.0f];
  [self.commentCoreTextView
      setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  self.commentCoreTextView.text = item.content;
  [self.commentCoreTextView fitToSuggestedHeight];
  NSInteger commentHeight = self.commentCoreTextView.frame.size.height;
  origin_y = origin_y + commentHeight;
  //图片高度
  __weak TweetListItem *weakWeibo = item;
  __weak UIImageView *weakImageView = self.commentImageView;
  NSString *imageUrl = item.imgs[0];

  if (imageUrl) {
    UIImage *image = [self.commentImageView
            loadImageWithUrl:imageUrl
        onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
          if (downloadImage) {
            NSLog(@"🐔图片宽度:%f 图片高度:%f",
                  downloadImage.size.width, downloadImage.size.height);
            [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
            weakImageView.image = downloadImage;
          }
        }];
    self.commentImageView.image =
        image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image) {
      item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
    }
    origin_y = origin_y + 5.0f;
    int imageViewWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    self.commentImageView.frame = CGRectMake(
        commentViewFrame.origin.x, origin_y, imageViewWidth, imageHeight);
    origin_y = origin_y + imageHeight;
  } else {
    self.commentImageView.hidden = YES;
  }
  //如果有回复框
  if ((item.o_content && [item.o_content length] > 0) ||
      (item.o_imgs && [item.o_imgs count] > 0)) {
    origin_y = origin_y + 5.0f;
    if (!item.o_content) {
      item.o_content = @"";
    }
    NSString *replyContent;
    if ([[item.userListItem.userId stringValue]
            isEqualToString:[item.o_uid stringValue]]) {
      item.o_nick = item.userListItem.nickName;
    }
    if (item.o_nick) {
      replyContent =
          [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/> : %@",
                                     item.o_uid, item.o_nick, item.o_content];
    } else {
      replyContent = item.o_content;
    }
    if (replyView) {
      [replyView removeFromSuperview];
    }
    replyView = [WBReplyBox
        createReplyBoxOfTitleWithTitle:replyContent
                        withReplyImage:item.o_imgs[0]
                              withTSid:[item.tstockid stringValue]
                              withRect:CGRectMake(
                                           commentViewFrame.origin.x, origin_y,
                                           commentViewFrame.size.width, 15.0f)
                              withItem:item];
    [self addSubview:replyView];
    if (item.o_nick) {
      //回复框加手势
      UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(clickReplyScale:)];
      [replyView addGestureRecognizer:tapGes];
    }
    origin_y = origin_y + replyView.frame.size.height;
  }
  return origin_y;
}
- (void)clickReplyScale:(UIGestureRecognizer *)ges {
  if (ges.state == UIGestureRecognizerStateEnded) {
    UIView *tapView = ges.view;
    CGPoint pointInWindow = [ges locationInView:tapView];
    //坐标转换
    pointInWindow = [tapView convertPoint:pointInWindow toView:WINDOW];
    FTCoreTextView *tapFTView;
    for (UIView *view in tapView.subviews) {
      if ([view isKindOfClass:[FTCoreTextView class]]) {
        tapFTView = (FTCoreTextView *)view;
      }
    }
    if ([tapFTView performClickOnPoint:pointInWindow]) {
      NSLog(@"long press event deal by coreTextView");
      return;
    }
  }
  [WBDetailsViewController showTSViewWithTStockId:talkStockItem.o_tstockid];
}
@end
