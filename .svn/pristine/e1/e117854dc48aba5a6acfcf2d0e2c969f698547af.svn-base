//
//  WeiboText.h
//  SimuStock
//
//  Created by Mac on 14/11/27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 微博内容显示的类型 */
typedef NS_ENUM(NSUInteger, WeiboTextType) {
  /** 文字类型*/
  WeiboTextType_Text = 0,

  /** 用户类型*/
  WeiboTextType_User = 1,

  /** @用户类型*/
  WeiboTextType_AtUser = 2,

  /** 股票类型*/
  WeiboTextType_Stock = 3,

  /** html链接类型*/
  WeiboTextType_HtmlLink = 4,

  /** 图标类型 */
  WeiboTextType_ICON = 5,

  /** 位置类型*/
  WeiboTextType_LocationPre = 7,

  /** 位置类型*/
  WeiboTextType_LocationIcon = 8,

  /** 位置类型*/
  WeiboTextType_LocationText = 9,

  /** 比赛类型*/
  WeiboTextType_Match = 10,

  /** topic类型*/
  WeiboTextType_Topic = 11,

  /** topic类型*/
  WeiboTextType_Font = 12,

  /** 股吧类型*/
  WeiboTextType_StockBar = 13,
};

extern const NSString *URL_SHOW_CONTEXT;

@interface WeiboText : NSObject

/** 类型 */
@property(nonatomic, assign) WeiboTextType type;

/** tag: stock, match, user, atUser */
@property(nonatomic, strong) NSString *tag;

/** 内容 */
@property(nonatomic, strong) NSString *content;

/** 是否可以点击 */
@property(nonatomic, assign) BOOL isClickable;

- (void)onClick;

@end

@interface UrlWeiboText : WeiboText
/** url */
@property(nonatomic, strong) NSString *url;

/** 标题 */
@property(nonatomic, strong) NSString *title;
@end

@interface StockWeiboText : WeiboText
/** 股票代码 */
@property(nonatomic, strong) NSString *stockCode;
/** 股票名称 */
@property(nonatomic, strong) NSString *stockName;

@end

@interface UserWeiboText : WeiboText
/** 用户id */
@property(nonatomic, strong) NSString *uid;
/** 用户昵称 */
@property(nonatomic, strong) NSString *nickname;

@end

@interface AtUserWeiboText : WeiboText
/** 用户id */
@property(nonatomic, strong) NSString *uid;
/** 用户昵称 */
@property(nonatomic, strong) NSString *nickname;

@end

@interface FontWeiboText : WeiboText
/** 是否加粗 */
@property(nonatomic, assign) BOOL isBold;

/** 是否加粗 */
@property(nonatomic, assign) float textSize;
/** 指定颜色 */
@property(nonatomic, strong) UIColor *textColor;

@end

@interface MatchWeiboText : WeiboText
/** 比赛id */
@property(nonatomic, strong) NSString *matchId;
/** 比赛名称 */
@property(nonatomic, strong) NSString *matchName;
/** 是否是有奖比赛 */
@property(nonatomic, strong) NSString *isReward;
/** 是否是高校比赛 */
@property(nonatomic, strong) NSString *isSenior;
/** 是否跳转URL */
@property(nonatomic, strong) NSString *wapJump;
/** 比赛跳转的URL */
@property(nonatomic, strong) NSString *mainURL;
/** 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛） */
@property(nonatomic, strong) NSString *matchType;
/** 网络请求的次数，防止无限制请求网络 */
@property(nonatomic, assign) NSInteger requestCount;

@end

@interface StockBarWeiboText : WeiboText
/** 股吧id */
@property(nonatomic, strong) NSNumber *barId;
/** 股吧名称 */
@property(nonatomic, strong) NSString *barName;

@end

@interface TopicWeiboText : WeiboText
/** topic */
@property(nonatomic, strong) NSString *topic;

@end