//
//  HomePageTableViewCell.m
//  SimuStock
//
//  Created by Mac on 14-12-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "Globle.h"
#import "FTCoreTextView.h"
#import "WBImageView.h"
#import "WeiBoExtendButtons.h"
#import "WBCoreDataUtil.h"
#import "SimuPositionPageData.h"
#import "UITableView+Reload.h"
#import "UserGradeView.h"
#import "RoundHeadImage.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
  [self createacontrolmethod];
  self.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  //专门给分享、评论、赞底部view设置的长按手势，用于屏蔽弹出拓展框
  NSArray *forbitLongPressedViews = @[ _shareBtn, _buyBtn, _sellBtn ];
  for (UIView *view in forbitLongPressedViews) {
    UILongPressGestureRecognizer *shieldLongPress1 =
        [[UILongPressGestureRecognizer alloc] initWithTarget:view action:nil];
    shieldLongPress1.minimumPressDuration = LongPressTime;
    [view addGestureRecognizer:shieldLongPress1];
  }
}

- (void)createacontrolmethod {
  //底色白圆
  _whiteRound = [CALayer layer];
  _whiteRound.backgroundColor = [Globle colorFromHexRGB:Color_White].CGColor;
  CGFloat whiteRoundRadius = 12.5;
  _whiteRound.cornerRadius = whiteRoundRadius;
  _whiteRound.frame = CGRectMake(8.5, 10, whiteRoundRadius * 2, whiteRoundRadius * 2);
  [self.layer addSublayer:_whiteRound];

  //蓝色的圆
  _round = [CALayer layer];
  _round.backgroundColor = [Globle colorFromHexRGB:@"#87c8f1"].CGColor;
  CGFloat blueRoundRadius = 11;
  _round.cornerRadius = blueRoundRadius;
  _round.frame = CGRectMake(10, 11.5, blueRoundRadius * 2, blueRoundRadius * 2);
  [self.layer addSublayer:_round];

  //  //买入\卖出\分红派送小标图标等
  _businessimgview.frame = CGRectMake(14.5, 17, 12, 12);
  [self.layer addSublayer:_businessimgview.layer];

  //回复气泡
  _replayBox.backgroundColor = [Globle colorFromHexRGB:@"00eaea"];
  [_replayBox.layer setCornerRadius:2.5];
  _replayBox.hidden = YES;

  //长按弹出按钮
  _longPressGR =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellClickAction:)];
  [self addGestureRecognizer:_longPressGR];
  [self.titleView setBoldTextSize:Font_Height_14_0];
  [self.titleView setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [self.weiBoContentView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.weiBoContentView setTextSize:Font_Height_14_0];
  [self.weiBoReplayView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.weiBoReplayView setTextSize:Font_Height_14_0];
}

//长按出现拓展按钮
- (void)cellClickAction:(UILongPressGestureRecognizer *)gesture {
  //长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {
    CGPoint loc = [gesture locationInView:[[UIApplication sharedApplication].delegate window]];
    if ([SimuUtil isLogined]) {
      //必须每次长按时指向block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      //显示拓展按钮
      [WeiBoExtendButtons showWithTweetListItem:_tweetListItem offsetY:loc.y cell:self];
    }
  }
}
#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  //实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];

  //删除按钮
  [extendButtons setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
    HomePageTableViewCell *strongCell = (HomePageTableViewCell *)cell;
    if (strongCell.deleteBtnBlock) {
      strongCell.deleteBtnBlock(tid);
    }
  }];
}

//分享
- (IBAction)shareBtnClick:(UIButton *)sender {
  _shareBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  [SimuUtil performBlockOnMainThread:^{
    _shareBtn.backgroundColor = [UIColor clearColor];
    [self bidButtonTriggeringMethod:_shareBtn];
  } withDelaySeconds:0.2];
}

//买入/评论
- (IBAction)buyBtnClick:(UIButton *)sender {
  _buyBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  [SimuUtil performBlockOnMainThread:^{
    _buyBtn.backgroundColor = [UIColor clearColor];
    [self bidButtonTriggeringMethod:_buyBtn];
  } withDelaySeconds:0.2];
}

//卖出/点赞
- (IBAction)sellBtnClick:(UIButton *)sender {
  _sellBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  [SimuUtil performBlockOnMainThread:^{
    _sellBtn.backgroundColor = [UIColor clearColor];
    [self bidButtonTriggeringMethod:_sellBtn];
  } withDelaySeconds:0.2];
}

- (void)bidButtonTriggeringMethod:(UIButton *)btn {

  if ([_delegate respondsToSelector:@selector(bidButtonTriggersCallbackMethod:row:)]) {
    [_delegate bidButtonTriggersCallbackMethod:btn.tag row:self.row];
  }
}

- (void)timerFiredShareBtn:(NSTimer *)timer {
  [_shareBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
}

//取消按钮的点击状态
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [(UIButton *)self.accessoryView setHighlighted:NO];
  [_sellBtn setHighlighted:NO];
  [_buyBtn setHighlighted:NO];
  [_shareBtn setHighlighted:NO];
}

#pragma mark - cell复用关键字
- (NSString *)reuseIdentifier {
  return _reuseid;
}

///时间显示上方空白的高度
static const CGFloat timeMarginTopHeight = 12;
///时间显示的高度
static const CGFloat timeHeight = 12;

///聊股标题/聊股内容与发送时间之间的距离
static const CGFloat spaceBetweenCtimeAndContent = 12;
///聊股标题与聊股内容之间的距离
static const CGFloat spaceBetweenTitleAndContent = 15;
///聊股内容和图片之间的距离
static const CGFloat spaceBetweenContentAndImage = 15;

///气泡箭头高度
static const CGFloat arrowIVHeight = 7;
///回复气泡箭头距离气泡左边之间的距离
static const CGFloat spaceBetweenArrowIVAndReplayBoxMarginLeft = 10;
///聊股内容/图片与回复气泡之间的距离
static const CGFloat spaceBetweenContentAndReplayBox = 15;
///回复内容与回复气泡上边之间的距离
static const CGFloat spaceBetweenReplayContentAndReplayBoxUp = 5;
///回复内容与回复气跑下边之间的距离
static const CGFloat spaceBetweenReplayContentAndReplayBoxDown = 10;
///回复内容与回复气泡左边之间的距离
static const CGFloat spaceBetweenReplayContentAndReplayBoxLeft = 13;

///放置按钮控件距离上方控件的距离
static const CGFloat spaceBetweenToolBarAndElement = 15;

///聊股控件在cell中的左边距
static const CGFloat spaceBetweenCellMarginLeftAndElement = 43;

static const CGFloat toolBarHeight = 28;
static const CGFloat toolBarHeightMarginBottom = 3;

+ (NSInteger)weiboHeightWithWeibo:(TweetListItem *)weibo
                 withContontWidth:(int)contentWidth
            withReplyContentWidth:(int)replyContentWidth {
  return [HomePageTableViewCell weiboHeightWithWeibo:weibo
                                       withWeiboType:1
                                    withContontWidth:contentWidth
                               withReplyContentWidth:replyContentWidth];
}

+ (NSInteger)weiboHeightWithWeibo:(TweetListItem *)weibo
                    withWeiboType:(NSInteger)type
                 withContontWidth:(int)contentWidth
            withReplyContentWidth:(int)replyContentWidth {
  if (weibo.heightCache[HeightCacheKeyAll]) {
    return [weibo.heightCache[HeightCacheKeyAll] integerValue];
  }

  int height;
  switch (weibo.type) {
  case WeiboTypeOrigianl: { //原创聊股
    if (type == 7) {
      height = [self heightOfCollectWithWeibo:weibo
                             withContontWidth:contentWidth
                        withReplyContentWidth:0];
    } else {
      height = [self heightOfOriginalWithWeibo:weibo withContontWidth:contentWidth];
    }
    height += toolBarHeight + toolBarHeightMarginBottom + spaceBetweenToolBarAndElement;
    break;
  }
  case WeiboTypeForward: { //转发聊股
    if (type == 7) {
      height = [self heightOfCollectWithWeibo:weibo
                             withContontWidth:contentWidth
                        withReplyContentWidth:replyContentWidth];
    } else {
      height = [self heightOfForwardWithWeibo:weibo
                             withContontWidth:contentWidth
                        withReplyContentWidth:replyContentWidth];
    }
    height += toolBarHeight + toolBarHeightMarginBottom + spaceBetweenToolBarAndElement;
    break;
  }
  case WeiboTypeComment: { //评论
    height = [self heightOfCommentWithWeibo:weibo
                           withContontWidth:contentWidth
                      withReplyContentWidth:replyContentWidth];
    break;
  }
  case WeiboTypeAttention: { //关注
    height = [self heightOfOriginalWithWeibo:weibo withContontWidth:contentWidth];
    height += spaceBetweenToolBarAndElement;
  } break;
  case WeiboTypeTrade: { //交易
    height = [self heightOfOriginalWithWeibo:weibo withContontWidth:contentWidth];
    height += toolBarHeight + toolBarHeightMarginBottom + spaceBetweenToolBarAndElement;
  } break;
  case WeiboTypeSystem: { //系统通知
    if (weibo.stype == WeiboSubTypeText) {
      height = [self heightOfOriginalWithWeibo:weibo withContontWidth:contentWidth];
      height += spaceBetweenToolBarAndElement;
    } else {
      height = 0;
    }
    break;
  }
  default:
    height = 0;
    break;
  };
  weibo.heightCache[HeightCacheKeyAll] = @(height);

  return height;
}

+ (CGFloat)theHeightOfTheCell:(TweetListItem *)tweetListItem {
  CGFloat height = 0.0;
  NSString *contentStr = @"";
  NSMutableArray *arr = nil;
  if ([tweetListItem.contentArr count] == 2) {
    if ([tweetListItem.contentArr[0] count] < 2) {
      return 0.0;
    }
    if (![tweetListItem.contentArr[0][0] isEqualToString:@"<stock"]) {
      return 0.0;
    }
    arr = tweetListItem.contentArr[1];
  } else if ([tweetListItem.contentArr count] == 3) {
    if ([tweetListItem.contentArr[0] count] < 2) {
      return 0.0;
    }
    if (![tweetListItem.contentArr[1][0] isEqualToString:@"<font"]) {
      return 0.0;
    }
    if ([tweetListItem.contentArr[1][1] count] != 0) {
      NSDictionary *dic = tweetListItem.contentArr[1][1][0];
      NSString *textStr = dic[@"text"];
      CGFloat sizeFloat = 0.0;
      if ([dic[@"size"] rangeOfString:@"px"].length > 0) {
        sizeFloat = [dic[@"size"] integerValue] / 2;
      } else {
        sizeFloat = [dic[@"size"] integerValue] * 0.9;
      }
      CGSize labelsize = [SimuUtil sizeCalculatedFieldfsize:CGSizeMake(310 - (24.0 + 18.0 + 44.0) / 2, 2000)
                                                       font:[UIFont systemFontOfSize:sizeFloat]
                                                        str:textStr];
      height += labelsize.height + 6.0;
    }
    arr = tweetListItem.contentArr[2];
  }
  int lineSpacing = 0;
  for (NSString *str in arr) {
    if ([contentStr isEqualToString:@""]) {
      contentStr = [contentStr stringByAppendingString:str];
    } else {
      contentStr = [contentStr stringByAppendingFormat:@"\n%@", str];
      lineSpacing += 4.0;
    }
  }
  CGSize labelsize = [SimuUtil sizeCalculatedFieldfsize:CGSizeMake(310 - (24.0 + 18.0 + 44.0) / 2, 2000)
                                                   font:[UIFont systemFontOfSize:15]
                                                    str:contentStr];
  height += 12 + 12 + 14 + 3 + labelsize.height + 16.0 / 2 + 30.0 / 2 + lineSpacing + 9.0;
  return height;
}

/** 返回聊股标题高度*/
+ (NSInteger)weiboTitleHeightWithWeibo:(TweetListItem *)weibo withContontWidth:(int)contentWidth {
  if (weibo.heightCache[HeightCacheKeyTitle]) {
    return [weibo.heightCache[HeightCacheKeyTitle] integerValue];
  }
  int titleHight =
      (int)[FTCoreTextView heightWithText:weibo.title width:contentWidth font:Font_Height_14_0];
  weibo.heightCache[HeightCacheKeyTitle] = @(titleHight);
  return titleHight;
}

/** 返回转发聊股内容高度*/
+ (NSInteger)weiboReplayContentHeightWithWeibo:(TweetListItem *)weibo
                              withContontWidth:(int)contentWidth {
  if (weibo.heightCache[HeightCacheKeySourceContent]) {
    return [weibo.heightCache[HeightCacheKeySourceContent] integerValue];
  }
  int o_contentHeight =
      (int)[FTCoreTextView heightWithText:weibo.o_content width:contentWidth font:Font_Height_14_0];
  weibo.heightCache[HeightCacheKeySourceContent] = @(o_contentHeight);
  return o_contentHeight;
}

/** 返回聊股内容高度*/
+ (NSInteger)weiboContentHeightWithWeibo:(TweetListItem *)weibo withContontWidth:(int)contentWidth {
  if (weibo.heightCache[HeightCacheKeyContent]) {
    return [weibo.heightCache[HeightCacheKeyContent] integerValue];
  }
  int contentHight =
      (int)[FTCoreTextView heightWithText:weibo.content width:contentWidth font:Font_Height_14_0];
  weibo.heightCache[HeightCacheKeyContent] = @(contentHight);
  return contentHight;
}

/** 原创聊股cell高度*/
+ (int)heightOfOriginalWithWeibo:(TweetListItem *)weibo withContontWidth:(int)contentWidth {

  int height = timeMarginTopHeight + timeHeight + spaceBetweenCtimeAndContent;
  if (weibo.title && ![weibo.title isEqualToString:@""]) {
    CGFloat titleHight = [self weiboTitleHeightWithWeibo:weibo withContontWidth:contentWidth];
    height += titleHight + spaceBetweenTitleAndContent;
  }
  if (weibo.content) {
    CGFloat contentHight = [self weiboContentHeightWithWeibo:weibo withContontWidth:contentWidth];
    height += contentHight;
  }

  if (weibo.imgs && weibo.imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:weibo.imgs[0] withWeibo:weibo];
    height += spaceBetweenContentAndImage + [imageHeight integerValue];
  }

  //  NSLog(@"关注高度：：：：：%d", height);
  return height;
}

/** 收藏聊股cell高度*/
+ (int)heightOfCollectWithWeibo:(TweetListItem *)weibo
               withContontWidth:(int)contentWidth
          withReplyContentWidth:(int)replyContentWidth {

  int height = timeMarginTopHeight + timeHeight + spaceBetweenCtimeAndContent;
  height += 20;
  if (weibo.title && ![weibo.title isEqualToString:@""]) {
    CGFloat titleHight = [self weiboTitleHeightWithWeibo:weibo withContontWidth:contentWidth];
    height += titleHight + spaceBetweenTitleAndContent;
  }
  if (weibo.content) {
    CGFloat contentHight = [self weiboContentHeightWithWeibo:weibo withContontWidth:contentWidth];
    height += contentHight;
  }

  if (weibo.imgs && weibo.imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:weibo.imgs[0] withWeibo:weibo];
    height += spaceBetweenContentAndImage + [imageHeight integerValue];
  }

  //  NSLog(@"关注高度：：：：：%d", height);
  if (weibo.type == 2) {
    height += spaceBetweenContentAndReplayBox;
    height += spaceBetweenReplayContentAndReplayBoxUp;

    CGFloat contentHight = [FTCoreTextView heightWithText:weibo.o_content
                                                    width:replyContentWidth
                                                     font:Font_Height_14_0];

    height += contentHight;
    if (weibo.o_imgs && weibo.o_imgs.count > 0) {
      NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:weibo.o_imgs[0] withWeibo:weibo];
      height += spaceBetweenContentAndImage + [imageHeight integerValue];
    }
  }
  return height;
}

/** 转发聊股cell高度*/

+ (int)heightOfForwardWithWeibo:(TweetListItem *)weibo
               withContontWidth:(int)contentWidth
          withReplyContentWidth:(int)replyContentWidth {
  int height = [self heightOfOriginalWithWeibo:weibo withContontWidth:contentWidth]; //原创

  height += spaceBetweenContentAndReplayBox;
  height += spaceBetweenReplayContentAndReplayBoxUp;

  CGFloat contentHight =
      [FTCoreTextView heightWithText:weibo.o_content width:replyContentWidth font:Font_Height_14_0];

  height += contentHight;
  if (weibo.o_imgs && weibo.o_imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:weibo.o_imgs[0] withWeibo:weibo];
    height += spaceBetweenContentAndImage + [imageHeight integerValue];
  }
  return height;
}

/** 评论cell高度*/
+ (int)heightOfCommentWithWeibo:(TweetListItem *)weibo
               withContontWidth:(int)contentWidth
          withReplyContentWidth:(int)replyContentWidth {

  int height = [self heightOfForwardWithWeibo:weibo
                             withContontWidth:contentWidth
                        withReplyContentWidth:replyContentWidth];
  if (!weibo.o_content || [weibo.o_content isEqualToString:@""]) {
    height -= spaceBetweenReplayContentAndReplayBoxUp;
  }
  return height;
}

//系统通知中参加何种炒股大赛
+ (NSString *)participateInTheContestStocks:(NSMutableArray *)arr {
  NSString *conStr = @"";
  if (arr.count == 3) {
    for (int i = 0; i < 3; i++) {
      switch (i) {
      case 0: {
        conStr = [conStr stringByAppendingString:arr[i]];
      } break;
      case 1: {
        NSMutableDictionary *dictionary = arr[i];
        NSString *str = dictionary[@"text"];
        if (str) {
          conStr = [conStr stringByAppendingString:str];
        }
      } break;
      case 2: {
        conStr = [conStr stringByAppendingString:arr[i]];
      } break;

      default:
        break;
      }
    }
  }

  return conStr;
}

- (void)hideAllSubViews {
  self.placeButtonView.hidden = YES;
  self.titleView.hidden = YES;
  self.weiboImgs.hidden = YES;
  self.replayImgs.hidden = YES;
  self.replayBox.hidden = YES;
  self.weiBoContentView.hidden = YES;
  self.weiBoReplayView.hidden = YES;
  self.arrowImgView.hidden = YES;
}

/**个人主页数据绑定（原创，转发，评论，关注，交易，系统通知）*/
- (void)bindHomeData:(TweetListItem *)shareChatHomeData
            withTableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  _tweetListItem = shareChatHomeData;

  //发送时间
  self.ctimeLabel.text = [SimuUtil getDateFromCtime:@([_tweetListItem.ctime longLongValue])];
  self.ctimeLabel.frame = CGRectMake((24.0 + 18.0 + 44.0) / 2, 12, 200, 14);

  switch (_tweetListItem.type) {
  case WeiboTypeOrigianl: {
    int height;
    height = [self bindWeiboOriginalWithTableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.type == 7) {
      /// 收藏，因为是收藏的是别人的原创聊股，所以返回字段的type也是 1 即
      /// WeiboTypeOrigianl
    } else {
      self.businessimgview.image = [UIImage imageNamed:@"我的聊股_发表小图标.png"];
    }
    _tweetListItem.heightCache[HeightCacheKeyAll] =
        @(height + toolBarHeight + toolBarHeightMarginBottom + spaceBetweenToolBarAndElement);
    self.placeButtonView.hidden = NO;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    [self.sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 8)];

    //    NSLog(@"original cellid: %@,  height: %@", _tweetListItem.tstockid,
    //          _tweetListItem.heightCache[HeightCacheKeyAll]);
  } break;
  case WeiboTypeForward: { //转发
    int height;
    height = [self bindWeiboForwardWithTableView:tableView cellForRowAtIndexPath:indexPath];
    _tweetListItem.heightCache[HeightCacheKeyAll] =
        @(height + toolBarHeight + toolBarHeightMarginBottom + spaceBetweenToolBarAndElement);
    if (self.type == 7) {
      /// 收藏，因为是收藏的是别人的原创聊股，所以返回字段的type也是 1 即
      /// WeiboTypeOrigianl
    } else {
      self.businessimgview.image = [UIImage imageNamed:@"我的聊股_聊股小图标.png"];
    }
    self.placeButtonView.hidden = NO;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    [self.sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 8)];
    //    NSLog(@"forward cellid: %@,  height: %@", _tweetListItem.tstockid,
    //          _tweetListItem.heightCache[HeightCacheKeyAll]);

  } break;
  case WeiboTypeComment: { //评论
    int height = [self bindWeiboCommentWithTableView:tableView cellForRowAtIndexPath:indexPath];
    _tweetListItem.heightCache[HeightCacheKeyAll] = @(height + timeMarginTopHeight);

    self.businessimgview.image = [UIImage imageNamed:@"我的聊股_聊股小图标.png"];
    self.placeButtonView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleGray;

    [self.sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 8)];
    //    NSLog(@"Comment cellid: %@,  height: %@", _tweetListItem.tstockid,
    //          _tweetListItem.heightCache[HeightCacheKeyAll]);
  } break;
  case WeiboTypeAttention: { //关注
    [self bindWeiboOriginalWithTableView:tableView cellForRowAtIndexPath:indexPath];
    self.businessimgview.image = [UIImage imageNamed:@"主页关注图标"];
    self.placeButtonView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
  } break;

  case WeiboTypeTrade: { //交易
    [self bindWeiboOriginalWithTableView:tableView cellForRowAtIndexPath:indexPath];

    switch (_tweetListItem.stype) {
    case WeiboSubTypeBuy: {
      self.businessimgview.image = [UIImage imageNamed:@"买入"];

    } break;
    case WeiboSubTypeSell: {
      self.businessimgview.image = [UIImage imageNamed:@"卖出"];
    } break;
    case WeiboSubTypeDividend: {
      self.businessimgview.image = [UIImage imageNamed:@"分红派送小标"];
    } break;

    default:
      break;
    }
    self.businessimgview.frame = CGRectMake(14, 16.5, 13, 13);

    self.placeButtonView.hidden = NO;
    self.selectionStyle = UITableViewCellSelectionStyleGray;

  } break;

  case WeiboTypeSystem: { //系统通知
    if (_tweetListItem.stype != WeiboSubTypeText) {
      return;
    }
    //取消选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self bindWeiboOriginalWithTableView:tableView cellForRowAtIndexPath:indexPath];
    self.placeButtonView.hidden = YES;
    self.businessimgview.image = [UIImage imageNamed:@"系统通知图标"];

  } break;
  default:
    break;
  }
}

/** 原创聊股数据绑定*/
- (int)bindWeiboOriginalWithTableView:(UITableView *)tableView
                cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  //隐藏子views
  [self hideAllSubViews];

  CGFloat height = timeMarginTopHeight;

  if (self.type == 7) {
    _round.hidden = YES;
    _whiteRound.hidden = YES;

    [_headImageView bindUserListItem:_tweetListItem.userListItem];

    if (_tweetListItem.userListItem.userName) {
      _userNameView.width = WIDTH_OF_SCREEN - 90;
      [_userNameView bindUserListItem:_tweetListItem.userListItem isOriginalPoster:NO];
    }

    height += _userNameView.height + _userNameView.top;
    _ctimeLabel.top = height;
    _ctimeLabel.left = _userNameView.left;
  }

  height += timeHeight + spaceBetweenCtimeAndContent;

  if (_tweetListItem.title == nil || [@"" isEqualToString:_tweetListItem.title]) {
    self.titleView.hidden = YES;
  } else {
    self.titleView.text = _tweetListItem.title;
    [self.titleView fitToSuggestedHeight];
    self.titleView.hidden = NO;

    CGRect titleFrame = self.titleView.frame;
    CGFloat titleHight = [HomePageTableViewCell weiboTitleHeightWithWeibo:_tweetListItem
                                                         withContontWidth:(int)titleFrame.size.width];
    titleFrame.origin.y = height + 5;
    self.titleView.frame = titleFrame;
    //加入聊股标题高度
    height += titleHight + spaceBetweenTitleAndContent;
  }

  if (_tweetListItem.content == nil || [@"" isEqualToString:_tweetListItem.content]) {
    self.weiBoContentView.hidden = YES;
  } else {
    self.weiBoContentView.text = _tweetListItem.content;
    [self.weiBoContentView fitToSuggestedHeight];
    self.weiBoContentView.backgroundColor = [UIColor clearColor];
    self.weiBoContentView.hidden = NO;

    CGRect contentFrame = self.weiBoContentView.frame;
    contentFrame.origin.y = height;
    self.weiBoContentView.frame = contentFrame;
    CGFloat contentHight = [HomePageTableViewCell weiboContentHeightWithWeibo:_tweetListItem
                                                             withContontWidth:(int)contentFrame.size.width];
    //加入聊股内容高度
    height += contentHight;
  }

  if (_tweetListItem.imgs && [_tweetListItem.imgs count] > 0) {
    height += spaceBetweenContentAndImage;

    __weak TweetListItem *weakWeibo = _tweetListItem;
    NSString *imageUrl = _tweetListItem.imgs[0];
    UIImage *image = [self.weiboImgs loadImageWithUrl:_tweetListItem.imgs[0]
                                 onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                   if (downloadImage) {
                                     [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                     [tableView reloadVisibleRowWithIndexPath:indexPath];
                                   }
                                 }];
    int imageWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    if (image) {
      _tweetListItem.heightCache[imageUrl] = @(imageHeight);
    }

    self.weiboImgs.frame = CGRectMake(spaceBetweenCellMarginLeftAndElement, height, imageWidth, imageHeight);
    self.weiboImgs.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    //加入聊股图片高度
    height += imageHeight;
    self.weiboImgs.hidden = NO;
  } else {
    self.weiboImgs.hidden = YES;
  }

  //加入下方toolBar与上方控件之间的距离
  [self initToolBar:height + spaceBetweenToolBarAndElement];

  return height;
}

/**转发聊股数据绑定 */
- (int)bindWeiboForwardWithTableView:(UITableView *)tableView
               cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = [self bindWeiboOriginalWithTableView:tableView cellForRowAtIndexPath:indexPath];

  //气泡初始高度
  CGFloat o_height = spaceBetweenReplayContentAndReplayBoxUp;

  //设置回复内容位置
  if ((_tweetListItem.o_content == nil || [_tweetListItem.o_content isEqualToString:@""])) {
    self.weiBoReplayView.hidden = YES;
  } else {
    self.weiBoReplayView.text = _tweetListItem.o_content;

    CGRect weiBoReplayViewFrame = self.weiBoReplayView.frame;
    CGFloat weiBoReplayViewHeight =
        [HomePageTableViewCell weiboReplayContentHeightWithWeibo:_tweetListItem
                                                withContontWidth:(int)weiBoReplayViewFrame.size.width];

    weiBoReplayViewFrame.origin.y = spaceBetweenReplayContentAndReplayBoxUp;
    weiBoReplayViewFrame.origin.x = spaceBetweenReplayContentAndReplayBoxLeft;
    weiBoReplayViewFrame.size.height = weiBoReplayViewHeight;
    self.weiBoReplayView.frame = weiBoReplayViewFrame;

    //加入回复聊股高度
    o_height += weiBoReplayViewHeight;
    self.weiBoReplayView.hidden = NO;
  }

  //设置回复图片位置
  if (_tweetListItem.o_imgs && [_tweetListItem.o_imgs count] > 0) {
    o_height += spaceBetweenContentAndImage;

    __weak TweetListItem *weakWeibo = _tweetListItem;
    NSString *imageUrl = _tweetListItem.o_imgs[0];
    UIImage *image = [self.replayImgs loadImageWithUrl:imageUrl
                                  onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                    if (downloadImage) {
                                      [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                      [tableView reloadVisibleRowWithIndexPath:indexPath];
                                    }
                                  }];
    int imageWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    if (image) {
      _tweetListItem.heightCache[imageUrl] = @(imageHeight);
    }
    self.replayImgs.frame =
        CGRectMake(spaceBetweenReplayContentAndReplayBoxLeft, o_height, imageWidth, imageHeight);
    self.replayImgs.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    //加入回复聊股图片高度
    o_height += imageHeight;

    self.replayImgs.hidden = NO;
  } else {
    self.replayImgs.hidden = YES;
  }

  //回复气泡最后高度
  //设置回复气泡位置(y坐标，size高度)
  CGRect replayBoxFrame = self.replayBox.frame;
  replayBoxFrame.origin.y = height + spaceBetweenContentAndReplayBox;
  replayBoxFrame.size.height = o_height + spaceBetweenReplayContentAndReplayBoxDown;
  self.replayBox.frame = replayBoxFrame;
  self.replayBox.hidden = NO;

  //构建长方形区域
  CGRect rect = CGRectMake(1, 12, 1, 1);
  CGImageRef imageRef = CGImageCreateWithImageInRect([self.arrowImgView.image CGImage], rect);
  UIImage *bubbleImage = [UIImage imageWithCGImage:imageRef];
  self.replayBox.frame = replayBoxFrame;
  [self.replayBox.layer setMasksToBounds:YES];
  [self.replayBox.layer setCornerRadius:2.5f];
  [self.replayBox setImage:bubbleImage];
  CGImageRelease(imageRef);

  //回复气泡小箭头位置调整
  CGRect arrowImgViewFrame = self.arrowImgView.frame;
  arrowImgViewFrame.origin.y = height + spaceBetweenContentAndReplayBox - arrowIVHeight;
  arrowImgViewFrame.origin.x = spaceBetweenCellMarginLeftAndElement + spaceBetweenArrowIVAndReplayBoxMarginLeft;
  self.arrowImgView.frame = arrowImgViewFrame;
  self.arrowImgView.hidden = NO;

  //加入聊股跟转发之间的距离再加入下方toolBar与上方控件之间的距离
  height += spaceBetweenContentAndReplayBox + o_height;
  [self initToolBar:height + spaceBetweenToolBarAndElement];
  return height;
}

/** 评论数据绑定 */
- (int)bindWeiboCommentWithTableView:(UITableView *)tableView
               cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  //隐藏子views
  [self hideAllSubViews];

  CGFloat height = timeMarginTopHeight + timeHeight + spaceBetweenCtimeAndContent;

  if (_tweetListItem.title == nil || [@"" isEqualToString:_tweetListItem.title]) {
    self.titleView.hidden = YES;
  } else {
    self.titleView.text = _tweetListItem.title;
    [self.titleView fitToSuggestedHeight];
    self.titleView.hidden = NO;

    CGRect titleFrame = self.titleView.frame;
    CGFloat titleHight = [HomePageTableViewCell weiboTitleHeightWithWeibo:_tweetListItem
                                                         withContontWidth:(int)titleFrame.size.width];
    titleFrame.origin.y = height + 5;
    self.titleView.frame = titleFrame;
    //加入评论标题高度
    height += titleHight + spaceBetweenTitleAndContent;
  }

  if (_tweetListItem.content == nil || [@"" isEqualToString:_tweetListItem.content]) {
    self.weiBoContentView.hidden = YES;
  } else {
    self.weiBoContentView.text = _tweetListItem.content;
    [self.weiBoContentView fitToSuggestedHeight];
    self.weiBoContentView.backgroundColor = [UIColor clearColor];
    self.weiBoContentView.hidden = NO;

    CGRect contentFrame = self.weiBoContentView.frame;
    contentFrame.origin.y = height;
    self.weiBoContentView.frame = contentFrame;
    CGFloat contentHight = [HomePageTableViewCell weiboContentHeightWithWeibo:_tweetListItem
                                                             withContontWidth:(int)contentFrame.size.width];
    //加入聊股内容高度
    height += contentHight;
  }

  if (_tweetListItem.imgs && [_tweetListItem.imgs count] > 0) {
    height += spaceBetweenContentAndImage;

    __weak TweetListItem *weakWeibo = _tweetListItem;
    NSString *imageUrl = _tweetListItem.imgs[0];
    UIImage *image = [self.weiboImgs loadImageWithUrl:_tweetListItem.imgs[0]
                                 onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                   if (downloadImage) {
                                     [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                     [tableView reloadVisibleRowWithIndexPath:indexPath];
                                   }
                                 }];
    int imageWidth = image ? image.size.width / ThumbnailFactor : 114;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    if (image) {
      _tweetListItem.heightCache[imageUrl] = @(imageHeight);
    }

    self.weiboImgs.frame = CGRectMake(spaceBetweenCellMarginLeftAndElement, height, imageWidth, imageHeight);
    self.weiboImgs.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    //加入聊股图片高度
    height += imageHeight;
    self.weiboImgs.hidden = NO;
  } else {
    self.weiboImgs.hidden = YES;
  }

  return height + 3;
}

/** 初始化工具栏：分享、评论、赞*/
- (void)initToolBar:(CGFloat)offsetY {

  switch (_tweetListItem.type) {

  case WeiboTypeOrigianl:
  case WeiboTypeForward: { //原创和转发类型：toolBar按钮图标替换及标题显示设置
    //分享数
    if (_tweetListItem.share > 0) {
      [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.share]
                     forState:UIControlStateNormal];
    } else {
      [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    }

    //评论数
    if (_tweetListItem.comment > 0) {
      [self.buyBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.comment]
                   forState:UIControlStateNormal];
    } else {
      [self.buyBtn setTitle:@"评论" forState:UIControlStateNormal];
    }

    //点赞数
    if (_tweetListItem.praise > 0) {
      [self.sellBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.praise]
                    forState:UIControlStateNormal];
    } else {
      [self.sellBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
    //是否点过赞
    _tweetListItem.isPraised = [WBCoreDataUtil fetchPraiseTid:@([_tweetListItem.tstockid longLongValue])];
    if (_tweetListItem.isPraised) {
      self.sellBtn.userInteractionEnabled = NO;
      [self.sellBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.praise]
                    forState:UIControlStateNormal];
      [self.sellBtn setImage:[UIImage imageNamed:@"赞小图标_down"] forState:UIControlStateNormal];
      //设置点赞数字体颜色(红色)
      [self.sellBtn setTitleColor:[Globle colorFromHexRGB:@"#F36C6C"]
                         forState:UIControlStateNormal];

    } else {
      self.sellBtn.userInteractionEnabled = YES;
      [self.sellBtn setImage:[UIImage imageNamed:@"赞小图标_up.png"] forState:UIControlStateNormal];
      //设置点赞数字体颜色（蓝色）
      [self.sellBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                         forState:UIControlStateNormal];
    }

    [self.buyBtn setImage:[UIImage imageNamed:@"评论小图标1"] forState:UIControlStateNormal];

    //重置评论按钮和赞按钮titleLabel的frame
    [self.sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 8)];
    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
  } break;

  case WeiboTypeTrade: { //交易类型：toolBar按钮图标替换及标题显示设置

    NSDictionary *dic = _tweetListItem.contentArr[0][1][1];
    NSString *stockcode = dic[@"code"];
    stockcode = [stockcode substringFromIndex:2];
    if ([SimuPositionPageData isStockSellable:stockcode]) {
      [self.sellBtn setImage:[UIImage imageNamed:@"卖出蓝色图标"] forState:UIControlStateNormal];
      //设置点赞数字体颜色（蓝色）
      [self.sellBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                         forState:UIControlStateNormal];
      [self.sellBtn setBackgroundImage:[UIImage imageNamed:@"点击背景图.png"]
                              forState:UIControlStateHighlighted];
      self.sellBtn.userInteractionEnabled = YES;
    } else {
      [self.sellBtn setImage:[UIImage imageNamed:@"卖出_不能操作状态"]
                    forState:UIControlStateNormal];
      //设置点赞数字体颜色（灰色）
      [self.sellBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                         forState:UIControlStateNormal];
      [self.sellBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
      self.sellBtn.userInteractionEnabled = NO;
    }
    //分享个数
    if (_tweetListItem.share > 0) {
      [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.share]
                     forState:UIControlStateNormal];
    } else {
      [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    }

    //重置买入卖出按钮titleLabel的frame
    [self.sellBtn setTitle:@"卖出" forState:UIControlStateNormal];
    [self.sellBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 16, 8, 8)];

    [self.buyBtn setTitle:@"买入" forState:UIControlStateNormal];
    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(8, 16, 8, 8)];
    [self.buyBtn setImage:[UIImage imageNamed:@"买入蓝色图标"] forState:UIControlStateNormal];
  } break;

  default:
    break;
  }

  //重置cell的toolBar的位置
  CGRect placeButtonViewFrame = self.placeButtonView.frame;
  placeButtonViewFrame.origin.y = offsetY;
  self.placeButtonView.frame = placeButtonViewFrame;
}

//#pragma mark - 重设cell选中和未选中状态颜色
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//  if (highlighted) {
//    self.backgroundColor = [Globle
//    colorFromHexRGB:Color_WeiboButtonPressDown];
//  } else {
//    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
//  }
//}

#pragma mark - cell左右滑动背景色还原
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}
@end
