//
//  WBDetailsCell.m
//  SimuStock
//
//  Created by jhss on 14-11-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBDetailsCell.h"

@implementation WBDetailsCell

- (void)awakeFromNib {
  //点击事件
  //头像
  UITapGestureRecognizer *headGes =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(clickHeadPic)];
  headGes.numberOfTouchesRequired = 1;
  headGes.numberOfTapsRequired = 1;
  [_userHeadPicBGView addGestureRecognizer:headGes];
    //评论中图片
  UITapGestureRecognizer *commentConGes = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(clickCommentCon)];
  commentConGes.numberOfTouchesRequired = 1;
  commentConGes.numberOfTapsRequired = 1;
  [_commentConImageview addGestureRecognizer:commentConGes];
  //回复中昵称
  UITapGestureRecognizer *relayNickGes =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(clickRelayNick)];
  relayNickGes.numberOfTapsRequired = 1;
  relayNickGes.numberOfTouchesRequired = 1;
  [_relayNickNameLabel addGestureRecognizer:relayNickGes];
  //分界线
  UIView *cuttingLine = [CellBottomLinesView addBottomLinesToCell:self];
  [self insertSubview:cuttingLine belowSubview:_verticalLineDown];
  // ftcoretextview可交互
  _commentContentView.userInteractionEnabled = YES;
  _relayContentView.userInteractionEnabled = YES;
  //  //长按弹出按钮
  _longPress = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(cellClickAction:)];
  [self addGestureRecognizer:_longPress];
}
#if 1

//长按出现拓展按钮
- (void)cellClickAction:(UILongPressGestureRecognizer *)gesture {
  //  UIView *gesView = gesture.view;
  //  CGPoint *pointOfCell = [gesView pointInside:_relayButton.frame
  //  withEvent:<#(UIEvent *)#>]
  //长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {
    CGPoint loc = [gesture
        locationInView:[[UIApplication sharedApplication].delegate window]];
    if ([SimuUtil isLogined]) {
      //必须每次长按时指向block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      //显示拓展按钮
      [WeiBoExtendButtons showButtonWithTweetListItem:tweetItem
                                              offsetY:loc.y
                                                 cell:self];
    }
  }
}
#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  //实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];
  //删除按钮
  [extendButtons
      setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
          WBDetailsCell *strongCell = (WBDetailsCell *)cell;
          if (strongCell.deleteBtnBlock) {
            strongCell.deleteBtnBlock(tid);
          }
      }];
}
#endif

- (void)clickHeadPic {
  [HomepageViewController showWithUserId:[_userId stringValue]
                               titleName:_userGradeView.lblNickName.titleLabel.text
                                 matchId:@"1"];
}
- (void)clickCommentCon {
  NSLog(@"commentImageView click");
}
- (void)clickRelayNick {
  [HomepageViewController showWithUserId:[_relayUserId stringValue]
                               titleName:_relayNickNameLabel.text
                                 matchId:@"1"];
}

/** 调整部分控件UI */
- (void)addjustCellContent {
  //头像背景
  [_userHeadPicBGView.layer setMasksToBounds:YES];
  [_userHeadPicBGView.layer setCornerRadius:20.5f];
  [_userHeadPicBGView.layer setBorderWidth:0.5f];
  [_userHeadPicBGView.layer
      setBorderColor:[Globle colorFromHexRGB:Color_Border].CGColor];
  //头像
  [_userHeadImageView.layer setMasksToBounds:YES];
  [_userHeadImageView.layer setCornerRadius:18.5f];
  //回复背景图扩展
  UIImage *bgImage = [UIImage imageNamed:@"聊股回复框小图标"];
  bgImage =
      [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(6.5, 1, 0.5, 11)];
  _relayBGImageview.image = bgImage;
  [_relayButton setBackgroundImage:
                    [UIImage imageFromView:_relayButton
                        withBackgroundColor:[Globle colorFromHexRGB:@"#dee0e1"]]
                          forState:UIControlStateHighlighted];

  //回复框圆边
  [_grayReplyView.layer setMasksToBounds:YES];
  [_grayReplyView.layer setCornerRadius:2.5f];

  UILongPressGestureRecognizer *relayLongPress =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(shieldClick:)];
  [_relayButton addGestureRecognizer:relayLongPress];
}
/** 屏蔽回复按钮长按点击 */
- (void)shieldClick:(UIGestureRecognizer *)ges {
}

- (void)refreshCellWithItem:(TweetListItem *)item
              withTableView:(UITableView *)tableView
      cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  tweetItem = item;
  //下半部分origin.y
  NSInteger upView_y = self.commentContentView.frame.origin.y;
  if (item.heightCache[HeightCacheKeyContent]) {
    _commentContentView.hidden = NO;
    upView_y =
        upView_y + [item.heightCache[HeightCacheKeyContent] floatValue] + 7.0f;
  } else {
    _commentContentView.hidden = YES;
  }

  //设置图片
  __weak TweetListItem *weakWeibo = item;
  NSString *imageUrl = item.imgs && item.imgs.count > 0 ? item.imgs[0] : nil;
  if (imageUrl) {
    UIImage *image = [_commentConImageview
            loadImageWithUrl:imageUrl
        onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
            if (downloadImage) {
              [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
              [tableView reloadVisibleRowWithIndexPath:indexPath];
            }
        }];
    _commentConImageview.image =
        image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image) {
      item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
    }
    int imageViewWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    _commentConImageview.frame =
        CGRectMake(_commentConImageview.frame.origin.x, upView_y,
                   imageViewWidth, imageHeight);
    upView_y = upView_y + imageHeight + 7.0f;
  } else {
    _commentConImageview.hidden = YES;
  }

  //回复nick
  CGRect o_nickFrame = self.relayNickNameLabel.frame;
  CGSize o_nickSize = [self.relayNickNameLabel.text
      sizeWithFont:[UIFont systemFontOfSize:13.0f]];
  self.relayNickNameLabel.frame =
      CGRectMake(o_nickFrame.origin.x, o_nickFrame.origin.y, o_nickSize.width,
                 o_nickFrame.size.height);
  //回复部分
  //帖子删除情况
  float o_nickHeight = 0;
  if (item.o_nick && [item.o_nick length] > 0) {
    self.relayNickNameLabel.hidden = NO;
    self.relayFloorNumLabel.hidden = NO;
    o_nickHeight = 0.0f;
  } else if ([item.o_content isEqualToString:@"已经被作者删除"]) {
    self.relayNickNameLabel.hidden = YES;
    self.relayFloorNumLabel.hidden = YES;
    o_nickHeight = 25.0f;
  } else {
    self.relayFloorNumLabel.hidden = YES;
    self.relayNickNameLabel.hidden = YES;
    self.relayBGView.hidden = YES;
    o_nickHeight = 0.0f;
  }
  //气泡（初始位置y）
  _relayBGView.frame = CGRectMake(_relayBGView.frame.origin.x, upView_y,
                                  _relayBGView.frame.size.width, 0);
  //回复文本
  NSInteger bubbleHeight = 0;
  CGFloat o_contentHeight =
      item.heightCache[HeightCacheKeySourceContent]
          ? [item.heightCache[HeightCacheKeySourceContent] floatValue]
          : 0.0f;
  if (o_contentHeight > 0) {
    self.relayContentView.hidden = NO;
    CGRect o_commentFrame = _relayContentView.frame;
    self.relayContentView.frame =
        CGRectMake(o_commentFrame.origin.x, 34.0f - o_nickHeight,
                   self.relayContentView.frame.size.width, o_contentHeight);
    //回复文本
    [self.relayContentView setTextSize:14.0f];
    [self.relayContentView
        setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
    self.relayContentView.text = item.o_content;
    [self.relayContentView fitToSuggestedHeight];
    upView_y = upView_y + 34.0f - o_nickHeight + o_contentHeight + 7.0f;
    bubbleHeight = 44.0f - o_nickHeight + o_contentHeight;
  } else {
    bubbleHeight = 44.0f - o_nickHeight;
    self.relayContentView.hidden = YES;
    upView_y = upView_y + 34.0f;
  }

  //回复图片
  NSString *replyImageUrl =
      item.o_imgs && item.o_imgs.count > 0 ? item.o_imgs[0] : nil;
  if (replyImageUrl) {
    UIImage *image = [_relayConImageView
            loadImageWithUrl:replyImageUrl
        onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
            if (downloadImage) {
              [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
              [tableView reloadVisibleRowWithIndexPath:indexPath];
            }
        }];
    _relayConImageView.image =
        image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image) {
      item.heightCache[replyImageUrl] = @(image.size.height / ThumbnailFactor);
    }
    int imageViewWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    _relayConImageView.frame = CGRectMake(_relayConImageView.frame.origin.x,
                                          upView_y - _relayBGView.origin.y,
                                          imageViewWidth, imageHeight);

    //有评论
    if (o_contentHeight > 0) {
      bubbleHeight = bubbleHeight + 7.0f + imageHeight;
    } else {
      bubbleHeight = imageHeight + bubbleHeight;
    }
  } else {
    _relayConImageView.hidden = YES;
  }

  _relayBGView.frame =
      CGRectMake(_relayBGView.frame.origin.x, _relayBGView.frame.origin.y,
                 _relayBGView.frame.size.width, bubbleHeight);
  //回复框是否显示
  if (replyImageUrl || o_contentHeight > 1) {
    _relayBGView.hidden = NO;
  } else {
    _relayBGView.hidden = YES;
  }
}
#if 1 //既然用系统按下态，就注释吧...
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:@"d9d9d9"];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}
#endif
-(void)bindTweetListItem:(TweetListItem *)item withIndexPath:(NSIndexPath *)indexPath withTweetArr:(NSMutableArray *)tweetListsArray withHostId:(NSString *)hostUserId
{
  //首线条控制长度
  if (indexPath.row == 0 && [tweetListsArray count] < 2) {
    self.verticalLineDown.hidden = YES;
    self.verticalLineUp.hidden = YES;
  } else if (indexPath.row == 0) { //多行，第一行
    self.verticalLineDown.hidden = NO;
    self.verticalLineUp.hidden = YES;
  }
  //最后一行隐藏连接线
  else if ([tweetListsArray count] % 20 != 0 &&
           indexPath.row == [tweetListsArray count] - 1) {
    self.verticalLineDown.hidden = YES;
    self.verticalLineUp.hidden = NO;
  } else {
    self.verticalLineUp.hidden = NO;
    self.verticalLineDown.hidden = NO;
  }
  [self addjustCellContent];
 //考虑楼层位数
  NSString *floorStr = [NSString stringWithFormat:@"%ld", (long)item.floor];
  self.userGradeView.width = (215 - floorStr.length * 7);
  [self.userGradeView
   bindUserListItem:item.userListItem
   isOriginalPoster:([hostUserId
                      isEqualToString:[item.uid stringValue]])];
  [self.userHeadImageView setImageWithURL:[NSURL URLWithString:item.userListItem.headPic]
   placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
  self.commentTimeLabel.text = [SimuUtil getDateFromCtime:item.ctime];
  if (item.floor > 0) {
    self.commentFloorLabel.text =
    [NSString stringWithFormat:@"%ld 楼", (long)item.floor];
    self.commentFloorLabel.hidden = NO;
  } else {
    self.commentFloorLabel.hidden = YES;
  }
  self.relayButton.tag = indexPath.row + 1000;
  
  self.userId = item.userListItem.userId;
  self.relayUserId = item.o_uid;
  if (item.heightCache[HeightCacheKeyContent]) {
    //评论文本
    [self.commentContentView
     setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
    [self.commentContentView setTextSize:14.0f];
    self.commentContentView.text = item.content;
    [self.commentContentView fitToSuggestedHeight];
  }
  //评论中图片
  if (item.imgs && [item.imgs count] > 0) {
    self.commentConImageview.hidden = NO;
  } else {
    self.commentConImageview.hidden = YES;
  }
  //回复部分
  if ((item.o_content && [item.o_content length] > 0) ||
      (item.o_imgs && [item.o_imgs count] > 0)) {
    self.relayBGView.hidden = NO;
    self.relayBGImageview.hidden = NO;
    self.relayConImageView.hidden = NO;
    self.relayFloorNumLabel.hidden = NO;
    self.grayReplyView.hidden = NO;
    self.relayNickNameLabel.hidden = NO;
    self.relayContentView.hidden = NO;
    self.relayTimeLabel.hidden = YES;
    self.relayTimeLabel.text = [SimuUtil getDateFromCtime:item.o_ctime];
    if (item.o_floor > 0) {
      self.relayFloorNumLabel.text =
      [NSString stringWithFormat:@"%ld 楼", (long)item.o_floor];
    }
    self.relayNickNameLabel.text = item.o_nick;
  } else {
    self.relayBGView.hidden = YES;
    self.relayBGImageview.hidden = YES;
    self.relayConImageView.hidden = YES;
    self.grayReplyView.hidden = YES;
    self.relayTimeLabel.hidden = YES;
    self.relayFloorNumLabel.hidden = YES;
    self.relayNickNameLabel.hidden = YES;
    self.relayContentView.hidden = YES;
  }
  
}

@end
