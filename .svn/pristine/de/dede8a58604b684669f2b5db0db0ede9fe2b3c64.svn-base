//
//  InviteFriendTableViewCell.m
//  SimuStock
//
//  Created by moulin wang on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "InviteFriendTableViewCell.h"
#import "SimuUtil.h"
#import "MyAttentionInfoItem.h"
#import "MyAttentionInfo.h"
#import <TencentOpenAPI/TencentOAuth.h>

@implementation InviteFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self createView];
  }
  return self;
}

- (void)createView {
  _shareView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH_OF_SCREEN, 388.0 / 2)];
  _shareView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self addSubview:_shareView];
  // image

  NSMutableArray *imageArr = nil;
  NSMutableArray *nameArr = nil; //名字
  NSMutableArray *tagArr = nil;

  // clang-format off
  if (![WXApi isWXAppSupportApi] && ![TencentOAuth iphoneQQInstalled]) {
    imageArr = [@[ @"新浪微博图标", @"腾讯微博图标", @"短信图标" ] mutableCopy];
    nameArr = [@[ @"新浪微博", @"腾讯微博", @"短信" ] mutableCopy];
    tagArr = [@[ @4404, @4405, @4406 ] mutableCopy];
  } else if (![WXApi isWXAppSupportApi] && [TencentOAuth iphoneQQInstalled]) {
    imageArr = [@[ @"QQ好友", @"新浪微博图标", @"腾讯微博图标", @"短信图标" ] mutableCopy];
    nameArr = [@[ @"QQ好友", @"新浪微博", @"腾讯微博", @"短信" ] mutableCopy];
    tagArr = [@[ @4402, @4404, @4405, @4406 ] mutableCopy];
  } else if ([WXApi isWXAppSupportApi] && ![TencentOAuth iphoneQQInstalled]) {
    imageArr = [@[
      @"微信好友图标",
      @"微信朋友圈图标",
      @"新浪微博图标",
      @"腾讯微博图标",
      @"短信图标"
    ] mutableCopy];
    nameArr = [@[ @"微信好友", @"微信朋友圈", @"新浪微博", @"腾讯微博", @"短信" ] mutableCopy];
    tagArr = [@[ @4400, @4401, @4404, @4405, @4406 ] mutableCopy];
  } else {
    imageArr = [@[
      @"微信好友图标",
      @"微信朋友圈图标",
      @"QQ好友",
      @"新浪微博图标",
      @"腾讯微博图标",
      @"短信图标"
    ] mutableCopy];
    nameArr = [
        @[ @"微信好友",
           @"微信朋友圈",
           @"QQ好友",
           @"新浪微博",
           @"腾讯微博",
           @"短信" ] mutableCopy];
    tagArr = [@[ @4400, @4401, @4402, @4404, @4405, @4406 ] mutableCopy];
  }
  // clang-format on
  if ([[SimuUtil getsystemVersions] integerValue] < 7.0f) {
    [tagArr removeLastObject];
    [nameArr removeLastObject];
    [imageArr removeLastObject];
  }
  for (int i = 0; i < [nameArr count]; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [((NSNumber *)tagArr[i])intValue];
    [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"点击背景图"] forState:UIControlStateHighlighted];
    [btn addTarget:self
                  action:@selector(shareButtonTriggeringMethod:)
        forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:btn];

    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = nameArr[i];
    nameLab.numberOfLines = 1;

    nameLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    [_shareView addSubview:nameLab];

    CGFloat buttonWidth = 115 / 320.f * WIDTH_OF_SCREEN;

    if (i < 4) {
      btn.frame = CGRectMake(31.5 / 2 + i * ((buttonWidth + 39.0) / 2), 17.0 / 2, buttonWidth / 2,
                             buttonWidth / 2);
      if (i == 1) {
        nameLab.frame = CGRectMake(31.5 / 2 + i * ((buttonWidth + 39.0) / 2 - 35.0 / 4),
                                   17.0 / 2 + buttonWidth / 2 + 14.0 / 2, 150.0 / 2, 30.0 / 2);
      } else {
        nameLab.frame = CGRectMake(31.5 / 2 + i * ((buttonWidth + 39.0) / 2),
                                   17.0 / 2 + buttonWidth / 2 + 14.0 / 2, buttonWidth / 2, 30.0 / 2);
      }

    } else {
      btn.frame = CGRectMake(31.5 / 2 + (i - 4) * ((buttonWidth + 39.0) / 2), 205.0 / 2,
                             buttonWidth / 2, buttonWidth / 2);
      nameLab.frame = CGRectMake(31.5 / 2 + (i - 4) * ((buttonWidth + 39.0) / 2),
                                 388.0 / 2 - 23.0 / 2 - 30.0 / 2, 120.0 / 2, 30.0 / 2);
    }
  }

  //底色
  _whiteView = [[UIView alloc] initWithFrame:CGRectMake(35.0 / 2, (119.0 - 80.0) / 4, 80.0 / 2, 80.0 / 2)];
  _whiteView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [_whiteView.layer setMasksToBounds:YES];
  _whiteView.userInteractionEnabled = YES;
  [_whiteView.layer setCornerRadius:80.0 / 4];
  [self addSubview:_whiteView];

  _userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0 / 2, 3.0 / 2, 74.0 / 2, 74.0 / 2)];
  _userHeadImageView.backgroundColor = [Globle colorFromHexRGB:@"#87c8f1"];
  _userHeadImageView.image = [UIImage imageNamed:@"用户默认头像"];
  CALayer *layer = _userHeadImageView.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:74.0 / 4];
  _userHeadImageView.tag = 101;
  [_whiteView addSubview:_userHeadImageView];

  _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(130.0 / 2, (119.0 - 60.0) / 4, 150.0, 60.0 / 2)];
  _nameLab.textColor = [Globle colorFromHexRGB:@"454545"];
  _nameLab.highlightedTextColor = [Globle colorFromHexRGB:@"454545"];
  _nameLab.backgroundColor = [UIColor clearColor];
  _nameLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _nameLab.numberOfLines = 1;
  [self addSubview:_nameLab];

  _concernBut = [UIButton buttonWithType:UIButtonTypeCustom];
  _concernBut.frame = CGRectMake(WIDTH_OF_SCREEN - 95.0, (119.0 / 2 - 27.0) / 2, 80, 27);
  _concernBut.tag = 4444;
  [_concernBut setTitleEdgeInsets:UIEdgeInsetsMake(6, 40, 6, 5)];
  _concernBut.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _btnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 15, 13)];
  [_btnIcon setImage:[UIImage imageNamed:@"红心小图标"]];
  [_concernBut addSubview:_btnIcon];
  [_concernBut.layer setMasksToBounds:YES];
  _concernBut.layer.cornerRadius = 27.0 / 2;
  [_concernBut.layer setBorderColor:[[Globle colorFromHexRGB:@"#fc7679"] CGColor]]; //描边颜色
  [_concernBut.layer setBorderWidth:0.5];                                           //描边粗细
  [_concernBut setTitle:@"关注" forState:UIControlStateNormal];
  [_concernBut setTitleColor:[Globle colorFromHexRGB:@"#454545"] forState:UIControlStateNormal];
  [_concernBut setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateDisabled];
  _concernBut.titleLabel.font = [UIFont systemFontOfSize:14];
  [_concernBut addTarget:self
                  action:@selector(shareButtonTriggeringMethod:)
        forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_concernBut];
  //菊花控件
  _attentionIndicatorView =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 70.0, (119.0 / 2 - 27.0) / 2, 30, 30)];
  _attentionIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [self addSubview:_attentionIndicatorView];
  //分割线
  _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 119.0 / 2, WIDTH_OF_SCREEN, 0.5)];
  _topLineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];

  [self addSubview:_topLineView];
  _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 119.0 / 2 + 0.5, WIDTH_OF_SCREEN, 0.5)];
  _bottomLineView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_bottomLineView];
  //关注
  _conRequest = [[ConcernedRequest alloc] init];
  _conRequest.delegate = self;
}
- (void)shareButtonTriggeringMethod:(UIButton *)btn {

  //灰色禁止点击
  if (![WXApi isWXAppSupportApi]) {
    if (btn.tag == 4401 || btn.tag == 4400) {
      return;
    }
  }
  if (![TencentOAuth iphoneQQInstalled]) {
    if (btn.tag == 4402 || btn.tag == 4403) {
      return;
    }
  }

  if (btn.tag == 4444) {
    if (self.userID) {
      //是否关注判断
      NSInteger flag;
      if ([_concernBut.titleLabel.text isEqualToString:@"关注"]) {
        flag = 1;
      } else {
        flag = 0;
      }
      [_conRequest shareButtonInviteFriendCallbackUserID:self.userID status:flag];
    }
  } else if (btn.tag == 4410 || btn.tag == 4411) {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(shareButtonInviteFriendCallbackMethod:row:)]) {
      [_delegate shareButtonInviteFriendCallbackMethod:btn.tag row:self.rowInt];
    }
  } else {
    if (_delegate && [_delegate respondsToSelector:@selector(shareButtonInviteFriendCallbackMethod:)]) {
      [_delegate shareButtonInviteFriendCallbackMethod:btn.tag];
    }
  }

  NSLog(@"btn.tag=%ld", (long)btn.tag);
}
#pragma mark-------ConcernedRequestDelegate---------
- (void)refreshButton:(NSInteger)refresh {
  if (refresh == 1) //点击刷新
  {
    //菊花显示
    if (![_attentionIndicatorView isAnimating]) {
      [_attentionIndicatorView startAnimating];
      _concernBut.hidden = YES;
    }
  } else if (refresh == 2) //关注成功
  {
    if ([_attentionIndicatorView isAnimating]) {
      [_attentionIndicatorView stopAnimating];
      if ([_concernBut.titleLabel.text isEqualToString:@"关注"]) {
        [_concernBut setTitle:@"取消" forState:UIControlStateNormal];
        [_btnIcon setImage:[UIImage imageNamed:@"灰心小图标"]];
        [_concernBut.layer setBorderColor:[Globle colorFromHexRGB:@"b4b4b4"].CGColor];
        [_concernBut setTitleColor:[Globle colorFromHexRGB:@"939393"]
                          forState:UIControlStateNormal];
        [self payAttentionWithUserID:self.userID withIsAttention:@"1"];
      } else {
        [_concernBut setTitle:@"关注" forState:UIControlStateNormal];
        [_btnIcon setImage:[UIImage imageNamed:@"红心小图标"]];
        [_concernBut.layer setBorderColor:[Globle colorFromHexRGB:@"fc7679"].CGColor];
        [_concernBut setTitleColor:[Globle colorFromHexRGB:@"454545"]
                          forState:UIControlStateNormal];
        [self payAttentionWithUserID:self.userID withIsAttention:@"0"];
      }
      _concernBut.hidden = NO;
    }
  } else if (refresh == 3) //关注失败
  {
    if ([_attentionIndicatorView isAnimating]) {
      [_attentionIndicatorView stopAnimating];
      _concernBut.hidden = NO;
    }
  }
}
- (void)payAttentionWithUserID:(NSString *)in_userID withIsAttention:(NSString *)isAttention {
  //首先本地数据变化保存下，刷新列表
  MyAttentionInfoItem *_item = [[MyAttentionInfoItem alloc] init];
  //保存下更新数据
  if ([isAttention integerValue] == 0) {
    _item.mIsAttention = @"0";
  } else {
    _item.mIsAttention = @"1";
  }
  if (in_userID == nil || [in_userID length] == 0)
    return;
  //先更新下当前页面数据，再请求网络,回传的数据才刷新
  if ([isAttention integerValue] == 1) {
    _item.userListItem.nickName = _nameLab.text;
    _item.userListItem.userId = @([in_userID integerValue]);
    [[MyAttentionInfo sharedInstance] addItemToAttentionArray:_item];
    _updateAttentionStatus(YES);
  } else {
    [[MyAttentionInfo sharedInstance] deleteItemFromAttentionArray:[NSString stringWithFormat:@"%@", in_userID]];
    _updateAttentionStatus(NO);
  }
}

- (void)dealloc {
  if (_conRequest) {
    _conRequest.delegate = nil;
  }
}
@end
