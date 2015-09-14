//
//  WeiboCell.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WeiboCell.h"
#import "CellBottomLinesView.h"
#import "HomepageViewController.h"
#import "FTCoreTextView.h"
#import "TweetListItem.h"
#import "UIImageView+WebCache.h"
#import "ShareTStockData.h"
#import "PraiseTStockData.h"
#import "WBCoreDataUtil.h"
#import "WBReplyView.h"
#import "ReplyViewController.h"
#import "WBImageView.h"
#import "WeiBoExtendButtons.h"
#import "ShareController.h"
#import "UITableView+Reload.h"

@implementation WeiboCell

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.exclusiveTouch = YES;
  self.contentView.exclusiveTouch = YES;

  // Initialization code
  [CellBottomLinesView addBottomLinesToCell:self];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  //设定初始高度
  _coreTextFrame = _coreTextView.frame;
  _weiboImageViewFrame = _weiboImageView.frame;
  _wbReplyViewFrame = _wbReplyView.frame;
  _bottomUIViewFrame = _bottomUIView.frame;
  _barNameViewFrame = _barNameView.frame;

  //内容及回复内容文字颜色
  [_coreTextView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [_coreTextView setTextSize:Font_Height_14_0];

  //吧名文字颜色
  [_barNameView setTextColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [_barNameView setTextSize:Font_Height_11_0];

  _whiteUiVIew.layer.cornerRadius = _whiteUiVIew.bounds.size.width / 2.0f;
  _headPicBotton.layer.cornerRadius = _headPicBotton.bounds.size.width / 2.0f;
  [_headPicBotton setBackgroundImage:[SimuUtil imageFromColor:Color_Gray]
                            forState:UIControlStateHighlighted];
  _headPicImageView.layer.cornerRadius = _headPicImageView.bounds.size.width / 2.0f;
  _headPicImageView.clipsToBounds = YES;

  //专门给分享、评论、赞底部view设置的长按手势，用于屏蔽弹出拓展框
  UILongPressGestureRecognizer *shieldLongPress1 =
      [[UILongPressGestureRecognizer alloc] initWithTarget:_bottomUIView action:nil];
  shieldLongPress1.minimumPressDuration = LongPressTime;
  [_bottomUIView addGestureRecognizer:shieldLongPress1];
  //
  UILongPressGestureRecognizer *shieldLongPress2 =
      [[UILongPressGestureRecognizer alloc] initWithTarget:_userGradeView action:nil];
  shieldLongPress2.minimumPressDuration = LongPressTime;
  [_userGradeView addGestureRecognizer:shieldLongPress2];
  //
  UILongPressGestureRecognizer *shieldLongPress3 =
      [[UILongPressGestureRecognizer alloc] initWithTarget:_headPicBotton action:nil];
  shieldLongPress3.minimumPressDuration = LongPressTime;
  [_headPicBotton addGestureRecognizer:shieldLongPress3];

  //长按弹出按钮
  UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(showExtendButtons:)];
  longPress.minimumPressDuration = LongPressTime;
  [self addGestureRecognizer:longPress];

  //赞回调
  [[NSNotificationCenter defaultCenter] addObserverForName:PraiseWeiboSuccessNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *notif) {
                                                  _isPraising = NO;
                                                }];
}

//长按出现拓展按钮
- (void)showExtendButtons:(UILongPressGestureRecognizer *)gesture {

  //长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {

    CGPoint pointInWindow = [gesture locationInView:self.window];

    if ([self.coreTextView performClickOnPoint:pointInWindow]) {
      NSLog(@"long press event deal by coreTextView");
      return;
    }

    if ([self.wbReplyView performClickOnPoint:pointInWindow]) {
      NSLog(@"long press event deal by wbReplyView");
      return;
    }

    if ([SimuUtil isLogined]) {
      //必须每次长按时传入block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      //显示拓展按钮
      [WeiBoExtendButtons showWithTweetListItem:_item offsetY:pointInWindow.y cell:self];
    }
  } else {
    self.highlighted = NO;
    NSLog(@"long press event not deal, gesture state = %ld", (long)gesture.state);
  }
}

#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  //实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];

  //置顶按钮
  [extendButtons setExtendTopButtonClickBlock:^(TweetListItem *item, NSObject *cell) {
    WeiboCell *strongCell = (WeiboCell *)cell;
    if (strongCell.topButtonClickBlock) {
      strongCell.topButtonClickBlock(item);
    }
  }];
  //加精按钮
  [extendButtons setExtendEliteButtonClickBlock:^(BOOL isElite, NSNumber *tid, NSObject *cell) {
    WeiboCell *strongCell = (WeiboCell *)cell;
    strongCell.eliteImageView.hidden = !isElite;
    if (strongCell.eliteButtonClickBlock) {
      strongCell.eliteButtonClickBlock(isElite, tid);
    }
  }];
  //删除按钮
  [extendButtons setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
    WeiboCell *strongCell = (WeiboCell *)cell;
    if (strongCell.deleteButtonClickBlock) {
      strongCell.deleteButtonClickBlock(tid);
    }
  }];
}

#pragma mark - cell复用关键字
- (NSString *)reuseIdentifier {
  return _reuseId;
}

#pragma mark 为用户名添加点击效果及设置用户评级控件
- (void)addHeadPicAndUserNameLabelActionWithUid:(NSNumber *)uid
                                       nickName:(NSString *)nickName
                                        vipType:(UserVipType)vipType {
  _uid = uid;
  _nickName = nickName;
  _vipType = vipType;
  _userGradeView.width = WIDTH_OF_SCREEN - 97;
  [_userGradeView bindUserListItem:_item.userListItem isOriginalPoster:NO];
}

#pragma mark 头像点击事件
- (IBAction)headPicButton:(UIButton *)sender {
  _headPicBotton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
  dispatch_after(time, dispatch_get_main_queue(), ^{
    _headPicBotton.backgroundColor = [UIColor clearColor];
    [HomepageViewController showWithUserId:[_uid stringValue] titleName:_nickName matchId:MATCHID];
  });
}

#pragma mark 用户名点击事件
- (IBAction)nickButtonClick:(UIButton *)sender {
  [SimuUtil performBlockOnMainThread:^{
    [HomepageViewController showWithUserId:[_uid stringValue] titleName:_nickName matchId:MATCHID];
  } withDelaySeconds:0.2];
}

///发送时间控件与来自xxx聊股吧俯视图之间的距离。
static const CGFloat spaceBetweenCtimeLabelAndPalaceView = 2;
#pragma mark - ⭐️刷新数据方法
- (void)refreshCellInfoWithItem:(TweetListItem *)item
                  withTableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //取得tid，供回调方法使用
  _item = item;

  [self resetAllSubViewsFrame];

  //加精
  _eliteImageView.hidden = !(item.elite == 1);

  //新发的聊股由于是本地刷新的，没有tid，所以屏蔽所有操作
  if (!item.tstockid) {
    _shareButton.enabled = NO;
    _commentButton.enabled = NO;
    _praiseButton.enabled = NO;
  } else {
    _shareButton.enabled = YES;
    _commentButton.enabled = YES;
    _praiseButton.enabled = YES;
  }
  //设定头像
  NSString *headPicStr = item.userListItem.headPic;

  [_headPicImageView setImageWithURL:[NSURL URLWithString:headPicStr]
                    placeholderImage:[UIImage imageNamed:@"用户默认头像"]];

  //给头像和用户名添加点击事件
  [self addHeadPicAndUserNameLabelActionWithUid:item.uid
                                       nickName:item.userListItem.nickName
                                        vipType:item.userListItem.vipType];

  //标题，h:14+11px
  item.title = [SimuUtil stringReplaceSpaceAndNewlinew:item.title];
  if (item.title.length > 0) {
    _titleLabel.text = item.title;
    _titleLabel.hidden = NO;
  } else {
    _titleLabel.hidden = YES;
  }

  item.content = [SimuUtil stringReplaceSpace:(item.content.length > 0 ? item.content : @"")];
  _coreTextView.text = item.content;
  [_coreTextView fitToSuggestedHeight];

  //设置图片
  __weak TweetListItem *weakWeibo = item;
  NSString *imageUrl = item.imgs[0];
  UIImage *image = [_weiboImageView loadImageWithUrl:imageUrl
                                onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                  if (downloadImage) {
                                    [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                    [tableView reloadVisibleRowWithIndexPath:indexPath];
                                  }
                                }];
  self.weiboImageView.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];
  if (image) {
    item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
  }

  [_wbReplyView refreshWithTweetListItem:item
                           withTableView:tableView
                   cellForRowAtIndexPath:indexPath];

  CGFloat titleHeight = [item.heightCache[HeightCacheKeyTitle] floatValue];
  CGFloat contentHeight = [item.heightCache[HeightCacheKeyContent] floatValue];
  CGFloat sourceContentHeight = [item.heightCache[HeightCacheKeySourceAll] floatValue];
  CGFloat wbImageViewHeight = [[ImageUtil imageHeightFromUrl:imageUrl withWeibo:item] floatValue];

  [self resetCoreTextViewFrame:titleHeight];
  [self resetWBImageViewFrame:titleHeight + contentHeight + 6.0f withImage:image];
  [self resetWBReplyViewFrame:titleHeight + contentHeight + 12.0f + wbImageViewHeight];
  [self resetBottomViewsFrame:titleHeight + contentHeight + sourceContentHeight + wbImageViewHeight];

  //计算发帖日期
  _ctimeLabel.text = [SimuUtil getDateFromCtime:item.ctime];
  //重置来自xxx的把控件父视图
  [self resetBarNameViewFrame];

  //*************设置按钮文字显示**************
  //分享
  NSInteger shareNum = item.share;
  if (shareNum > 0) {
    [_shareButton setTitle:[NSString stringWithFormat:@"%ld", (long)shareNum]
                  forState:UIControlStateNormal];
  } else {
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
  }

  //评论
  NSInteger commentNum = item.comment;
  if (commentNum > 0) {
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)item.comment]
                    forState:UIControlStateNormal];
  } else {
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
  }

  //赞
  NSInteger praiseNum = item.praise;
  if (praiseNum > 0) {
    [_praiseButton setTitle:[NSString stringWithFormat:@"%ld", (long)item.praise]
                   forState:UIControlStateNormal];
  } else {
    [_praiseButton setTitle:@"赞" forState:UIControlStateNormal];
  }
  //赞的图标
  BOOL isPraised = item.isPraised;
  if (isPraised) {
    [_praiseButton setImage:[UIImage imageNamed:@"赞小图标_down"] forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[Globle colorFromHexRGB:Color_PraiseRed]
                        forState:UIControlStateNormal];
    _praiseButton.userInteractionEnabled = NO;
  } else {
    [_praiseButton setImage:[UIImage imageNamed:@"赞小图标_up"] forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                        forState:UIControlStateNormal];
    _praiseButton.userInteractionEnabled = YES;
  }
}

#pragma mark - 调整高度
- (void)resetBarNameViewFrame {
  CGSize ctimesize = [_ctimeLabel.text sizeWithFont:[UIFont systemFontOfSize:11]];
  CGRect ctimeLabelFrame = _ctimeLabel.frame;

  //来自xxx的吧
  _barNameView.text = _item.clickableBarName;
  [_barNameView fitToSuggestedHeight];

  //重置_barNameView的x坐标
  CGRect barNameViewFrame = _barNameView.frame;
  barNameViewFrame.origin.x = ctimeLabelFrame.origin.x + ctimesize.width + spaceBetweenCtimeLabelAndPalaceView;
  _barNameView.frame = barNameViewFrame;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    CGRect barNameFrame = _barNameView.frame;
    barNameFrame.origin.y = ctimeLabelFrame.origin.y - 3;
    NSLog(@"y坐标：%lf", barNameFrame.origin.y);
    _barNameView.frame = barNameFrame;
  }
}

//重新调整coreTextView位置
- (void)resetCoreTextViewFrame:(CGFloat)offsetY {
  CGRect frame = _coreTextView.frame;
  frame.origin.y += offsetY;
  _coreTextView.frame = frame;
}

//重新调整图片高度
- (void)resetWBImageViewFrame:(CGFloat)offsetY withImage:(UIImage *)image {
  int imageViewWidth = image ? image.size.width / ThumbnailFactor : 114;
  int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
  CGRect frame = _weiboImageView.frame;
  frame.origin.y += offsetY;
  frame.size.width = imageViewWidth;
  frame.size.height = imageHeight;
  _weiboImageView.frame = frame;
}

//重新调整replyBoxView位置
- (void)resetWBReplyViewFrame:(CGFloat)offsetY {
  CGRect frame = _wbReplyView.frame;
  frame.origin.y += offsetY;
  _wbReplyView.frame = frame;
}

//重新调整两排按钮位置
- (void)resetBottomViewsFrame:(CGFloat)offsetY {
  CGRect bottomFrame = _bottomUIView.frame;
  bottomFrame.origin.y += offsetY;
  _bottomUIView.frame = bottomFrame;
}

#pragma mark 重新调整所有子控件
- (void)resetAllSubViewsFrame {
  _coreTextView.frame = _coreTextFrame;
  _weiboImageView.frame = _weiboImageViewFrame;
  _wbReplyView.frame = _wbReplyViewFrame;
  _bottomUIView.frame = _bottomUIViewFrame;
}

#pragma mark - ⭐️按钮回调
#pragma mark 分享
- (IBAction)shareButtonClick:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  //分享不需要权限检测
  //李群分享
  _shareButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
  //__weak WeiboCell *weakself = self;
  [SimuUtil performBlockOnMainThread:^{
    _shareButton.backgroundColor = [UIColor clearColor];
  } withDelaySeconds:0.2];
  [self shareTStock:nil];
}

#pragma mark 评论
- (IBAction)commentButtonClick:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (_isCommenting) {
    return;
  }

  _isCommenting = YES;
  __weak WeiboCell *weakself = self;

  _commentButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];

  [SimuUtil performBlockOnMainThread:^{

    _commentButton.backgroundColor = [UIColor clearColor];

    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      ReplyViewController *replyVC =
          [[ReplyViewController alloc] initWithTstockID:[_item.tstockid stringValue]
                                            andCallBack:^(TweetListItem *item) {
                                              //评论数+1
                                              [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)++_item.comment]
                                                              forState:UIControlStateNormal];
                                              if (!isLogined) {
                                                [weakself refreshButtonsStatus];
                                              }
                                              //同步全部、加精数据
                                              if (_updateStatusBlock) {
                                                _updateStatusBlock(_item);
                                              }
                                            }];
      [AppDelegate pushViewControllerFromRight:replyVC];
    }];
  } withDelaySeconds:0.2];

  [SimuUtil performBlockOnGlobalThread:^{
    _isCommenting = NO;
  } withDelaySeconds:1];
}

#pragma mark 赞
- (IBAction)praiseButtonClick:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {

    if (!_item.isPraised) {
      _praiseButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    } else {
      _praiseButton.backgroundColor = [UIColor clearColor];
      return;
    }

    //如果正在赞，返回
    if (_isPraising) {
      [NewShowLabel setMessageContent:@"正在发送赞"];
      _praiseButton.backgroundColor = [UIColor clearColor];
      return;
    }

    __weak WeiboCell *weakself = self;

    _isPraising = YES;

    [SimuUtil performBlockOnMainThread:^{
      _praiseButton.backgroundColor = [UIColor clearColor];
      [weakself refreshButtonsStatus];
      [PraiseTStockData requestPraiseTStockData:_item];
    } withDelaySeconds:0.2];
  }];
}

#pragma mark - ✨登录后刷新所有按钮状态
- (void)refreshButtonsStatus {
  //必须刷新整个tableView
  //让所有item都得重刷一次状态，block实现
  if (_refreshPraisedBlock) {
    _refreshPraisedBlock();
  }

  //由于上述block会在子线程执行，所以必须再次查询本地数据库
  //如果已经点赞，禁用并返回
  _item.isPraised = [WBCoreDataUtil fetchPraiseTid:_item.tstockid];
  if (_item.isPraised) {
    _praiseButton.userInteractionEnabled = NO;
  }
}

#pragma mark - 网络请求
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)stopLoading {
  _isPraising = NO;
}

- (void)shareTStock:(ShareTStockData *)obj {
  //截屏0
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  UIImage *shareImage = [makingScreenShot makingScreenShotWithFrame:self.bounds
                                                           withView:self
                                                           withType:MakingScreenShotType_TrendPage_Half];
  [[[ShareController alloc] init] shareWeibo:_item withShareImage:shareImage];
}

- (void)bindPraiseTStockData:(PraiseTStockData *)obj {
  [_praiseButton setImage:[UIImage imageNamed:@"赞小图标_down"] forState:UIControlStateNormal];
  [_praiseButton setTitle:[NSString stringWithFormat:@"%ld", (long)++_item.praise]
                 forState:UIControlStateNormal];
  [_praiseButton setTitleColor:[Globle colorFromHexRGB:Color_PraiseRed]
                      forState:UIControlStateNormal];
  _item.isPraised = YES;
  _item.praise += 1;
  _isPraising = NO;

  [NewShowLabel setMessageContent:@"赞成功"];
  _praiseButton.userInteractionEnabled = NO;

  //同步全部、加精数据
  if (_updateStatusBlock) {
    _updateStatusBlock(_item);
  }
}

#pragma mark - 对外
#pragma mark 重新设置精华图标按钮
- (void)resetEliteButton:(BOOL)isElite {
  _eliteImageView.hidden = !isElite;
}

#pragma mark 获取cell总高度方法

+ (CGFloat)heightWithTweetListItem:(TweetListItem *)item {
  item.heightCache[HeightCacheKeyTitle] = (item.title.length > 0) ? @25 : @0.0f;
  item.heightCache[HeightCacheKeyContent] =
      @([FTCoreTextView heightWithText:item.content width:288 font:Font_Height_14_0]);

  NSString *imageUrl = item.imgs.count > 0 && item.imgs[0] ? item.imgs[0] : nil;
  CGFloat imageHeight = [[ImageUtil imageHeightFromUrl:imageUrl withWeibo:item] floatValue];

  CGFloat sourceHeight = [WBReplyView heightOfReplyViewWithTweetItem:item];
  item.heightCache[HeightCacheKeySourceAll] = @(sourceHeight);
  return 102.0f + [item.heightCache[HeightCacheKeyTitle] floatValue] +
         [item.heightCache[HeightCacheKeyContent] floatValue] + sourceHeight + imageHeight;
}

#pragma mark - 重设cell选中和未选中状态颜色
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:Color_WeiboButtonPressDown];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}

#pragma mark - cell左右滑动背景色还原
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}
@end
