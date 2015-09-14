//
//  TweetListItem.m
//  SimuStock
//
//  Created by jhss on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TweetListItem.h"

#import "ContentAnalytical.h"
#import "CacheUtil.h"
#import "ImageUtil.h"

@implementation TweetListItem

- (id)init {
  if (self = [super init]) {
    _heightCache = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"⚠️TweetListItem未找到键：%@", key);
}

- (void)setValue:(id)value forKey:(NSString *)key {
  //⚠️ 不要注释此方法，否则最热分页会废掉
}

- (void)jsonToObject:(NSDictionary *)obj {

  //  NSLog(@"聊股数据：%@",obj);
  self.uid = obj[@"uid"];
  self.tstockid = obj[@"tstockid"];
  self.tweetId = obj[@"tweetId"];
  self.timelineid = obj[@"timelineid"];
  //股吧ID
  self.barId = obj[@"barId"];
  if (!self.barId) {
    self.barId = obj[@"barID"];
  }
  //聊股类型
  self.type = [obj[@"type"] integerValue];
  self.stype = [obj[@"stype"] integerValue];
  self.share = [obj[@"share"] integerValue];
  self.praise = [obj[@"praise"] integerValue];
  self.comment = [obj[@"comment"] integerValue];
  self.elite = [obj[@"elite"] integerValue];

  //大赛id
  self.matchId = obj[@"matchid"];
  //楼号
  self.floor = [obj[@"floor"] integerValue];
  //发帖时间
  self.ctime = obj[@"ctime"];
  //聊股吧名
  self.barName = obj[@"barName"];

  //聊股内容
  self.content = obj[@"content"];

  //聊股图片
  self.imgs = obj[@"imgs"];

  //转发聊股正文
  NSDictionary *o_dic = obj[@"source"];
  NSNumber *o_uid = o_dic[@"o_uid"];
  self.o_uid = o_uid;
  NSString *o_content = o_dic[@"o_content"];
  NSString *o_nick = o_dic[@"o_nick"];
  self.o_floor = [o_dic[@"o_floor"] integerValue];
  self.o_nick = o_dic[@"o_nick"];
  if (o_nick && [o_nick length] > 0) {
    if (o_content) {
      self.o_content =
          [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/> : %@", [o_uid stringValue], o_nick, o_content];
    } else {
      self.o_content =
          [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/> :", [o_uid stringValue], o_nick];
    }
    self.o_content2 = o_content;
  } else {
    self.o_content = o_content;
  }
  //转发聊股图片
  self.o_imgs = o_dic[@"o_imgs"];

  //聊股标题
  self.title = obj[@"title"];

  //判断字符串是否包含
  if (self.type == WeiboTypeAttention) {
    self.content = [self.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  }

  self.contentArr = [[NSMutableArray alloc] init];

  NSArray *contentArr = [self.content componentsSeparatedByString:@"\n"];
  NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
  ContentAnalytical *tool = [[ContentAnalytical alloc] init];

  for (NSString *str in contentArr) {
    NSMutableArray *contentArr = [tool getMarkContent:str];
    if (contentArr) {
      [self.contentArr addObject:contentArr];
    } else {
      if (![str isEqualToString:@""]) {
        [mutableArr addObject:str];
      }
    }
  }
  [self.contentArr addObject:mutableArr];
}

- (void)setContent:(NSString *)context andImage:(UIImage *)image {
  /// 是否有图片
  if (image) {
    self.stype = 2;
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat expectWidth = screen.bounds.size.width * [screen scale] / 1.5f;
    CGFloat factor = expectWidth / image.size.width;
    self.imgs = @[ [ImageUtil imageWithImage:image scaleFactor:factor] ];
  } else {
    self.stype = 1;
  }
  self.content = context;
  self.uid = @([[SimuUtil getUserID] longLongValue]);
  //获取系统当前的时间戳
  NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval a = [dat timeIntervalSince1970] * 1000;

  self.ctime = @(a);

  //根据uid从userLists中查找匹配用户数据进行绑定
  self.userListItem = [[UserListItem alloc] init];
  self.userListItem.userId = self.uid;
  self.userListItem.nickName = [SimuUtil getUserNickName];
  self.userListItem.headPic = [SimuUtil getUserImageURL];

  self.userListItem.signature = [SimuUtil getUserSignature];
  self.userListItem.userName = [SimuUtil getUserName];
  self.userListItem.vipType = (UserVipType)[[SimuUtil getUserVipType] integerValue];

  /** 用户评级数据 */
  self.userListItem.rating = [[CacheUtil myInfomation] rating];
  self.userListItem.stockFirmFlag = [[CacheUtil myInfomation] stockFirmFlag];
}

#pragma mark(YuLing)(发聊股，评论，回复)三个返回对象的初始化函数
///发聊股
- (id)initWithDistributeStockBarID:(NSString *)barId
                          andTitle:(NSString *)title
                        andContext:(NSString *)context
                          andImage:(UIImage *)image {
  self = [self init];
  if (self) {
    ///发布原创聊股
    self.type = 1;
    self.title = title;
    self.barId = @([barId longLongValue]);
    [self setContent:context andImage:image];
  }
  return self;
}

///评论
- (id)initWithReplyStocktalkId:(NSString *)talkId
                    andContext:(NSString *)context
                      andImage:(UIImage *)image {
  self = [self init];
  if (self) {
    ///评论聊股
    self.type = 3;
    [self setContent:context andImage:image];
  }
  return self;
}

///回复
- (id)initWithReviewStocktalkId:(NSString *)talkId
                     andContext:(NSString *)context
                       andImage:(UIImage *)image
                    andReviewID:(NSString *)reviewid
                 andTweetObject:(TweetListItem *)tweetObject {
  self = [self init];
  if (self) {
    ///回复评论聊股
    self.type = 4;
    [self setContent:context andImage:image];

    ///回复部分
    if (tweetObject) {
      self.o_type = tweetObject.type;
      self.o_stype = tweetObject.stype;
      self.o_floor = tweetObject.floor;
      self.o_position = tweetObject.position;
      self.o_nick = tweetObject.userListItem.nickName;
      self.o_content = tweetObject.content;
      self.o_tstockid = tweetObject.tstockid;
      self.o_ctime = tweetObject.ctime;
      self.o_uid = tweetObject.uid;
      self.o_imgs = [[NSArray alloc] initWithArray:tweetObject.imgs];
      self.o_sound = tweetObject.sound;
    }
  }
  return self;
}

- (NSString *)clickableBarName {
  NSString *barName = [SimuUtil stringReplaceSpace:self.barName];
  if (barName.length == 0) {
    return @"";
  } else {
    return [NSString
        stringWithFormat:@"<font text='|' color='#5a5a5a' " @"size='22px'/> <font text='来自:' " @"color='#5a5a5a' size='22px'/> " @"<stockbar id=\"%lld\" text=\"%@\"/>",
                         [self.barId longLongValue], barName];
  }
}

@end

@implementation TweetList

- (void)jsonToObject:(NSDictionary *)dic {

  self.tweetListArray = [[NSMutableArray alloc] init];

  NSDictionary *resultDict = dic[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultDict[@"userList"];
  [userListWrapper jsonToMap:userLists];

  NSArray *tweetLists = resultDict[@"tweetList"];

  //再绑定所有股聊消息
  for (NSDictionary *tweetListDic in tweetLists) {
    TweetListItem *tweetListItem = [[TweetListItem alloc] init];
    [tweetListItem jsonToObject:tweetListDic];

    //根据uid从userLists中查找匹配用户数据进行绑定
    NSString *uid = [SimuUtil changeIDtoStr:tweetListDic[@"uid"]];
    tweetListItem.userListItem = [userListWrapper getUserById:uid];

    [self praseTalkContent:tweetListItem.content withWeibo:tweetListItem];
    [self praseTalkContent:tweetListItem.o_content withWeibo:tweetListItem];
    [self praseTalkContent:tweetListItem.title withWeibo:tweetListItem];
    [self.tweetListArray addObject:tweetListItem];
  }
}

- (void)praseTalkContent:(NSString *)talkContent withWeibo:(TweetListItem *)tweetListItem {

  //判断字符串是否包含
  if (tweetListItem.type != WeiboTypeTrade) {
    return;
  }

  tweetListItem.contentArr = [[NSMutableArray alloc] init];

  NSArray *contentArr = [talkContent componentsSeparatedByString:@"\n"];
  NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
  ContentAnalytical *tool = [[ContentAnalytical alloc] init];

  for (NSString *str in contentArr) {
    NSMutableArray *contentArr = [tool getMarkContent:str];
    if (contentArr) {
      [tweetListItem.contentArr addObject:contentArr];
    } else {
      if (![str isEqualToString:@""]) {

        [mutableArr addObject:str];
      }
    }
  }
  [tweetListItem.contentArr addObject:mutableArr];
}

- (NSArray *)getArray {
  return _tweetListArray;
}

/** 获得聊股首条内容详情页 */
+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                                    withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@istock/newTalkStock/getTStock?tweetId=%@", istock_address, talkID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//请求评论列表信息
+ (void)getTalkStockListsContentWithTweetdic:(NSDictionary *)dic
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString
          stringWithFormat:@"%@istock/newTalkStock/" @"getCommentList?tweetId={tweetid}&fromId={" @"fromId}&reqNum={reqNum}&order={order}", istock_address];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//请求全部股聊信息
+ (void)requestGetBarNewTweetListDataWithBarId:(NSNumber *)barId
                                    withFromId:(NSNumber *)fromId
                                    withReqNum:(NSInteger)reqNum
                                  withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/"
                      @"getBarNewTweetList?barId={barId}&fromId={" @"fromId}&reqNum={reqNum}"];

  NSDictionary *dic = @{
    @"barId" : [barId stringValue],
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//请求加精列表信息
+ (void)requestGetEliteListDataWithBarId:(NSNumber *)barId
                              withFromId:(NSNumber *)fromId
                              withReqNum:(NSInteger)reqNum
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/"
                      @"getEliteList?barId={barId}&fromId={" @"fromId}&reqNum={reqNum}"];

  NSDictionary *dic = @{
    @"barId" : [barId stringValue],
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//我的动态
+ (void)requestGetMyFollowListWithFromId:(NSNumber *)fromId
                              withReqNum:(NSInteger)reqNum
                            withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [istock_address stringByAppendingString:@"istock/newTalkStock/"
                                  @"getMyFollowList?fromId={fromId}&" @"reqNum={reqNum}"];

  NSDictionary *dic = @{
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//行情聊股分页
+ (void)requestGetStockTopicTweetListWithParams:(NSDictionary *)dic
                                   withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address stringByAppendingString:@"istock/newTalkStock/"
                                  @"getStockTopicTweetList?stockCode={stockCode}&"
                                  @"fromId={fromId}&reqNum={reqNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

///比赛聊股分页
+ (void)requestGetSubjectTweetListWithParams:(NSDictionary *)dic
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/"
                      @"getSubjectTweetList?title={title}&fromId={" @"fromId}&reqNum={reqNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

///收藏聊股分页
+ (void)requestGetFaverateTweetListWithFromId:(NSNumber *)fromId
                                   withReqNum:(NSInteger)reqNum
                                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address stringByAppendingString:@"istock/newTalkStock/"
                                  @"collectList?fromId={fromId}&reqNum={reqNum}"];
  NSDictionary *dic = @{
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//热门分页
+ (void)requestHotListWithFormId:(NSNumber *)fromId
                      withReqNum:(NSInteger)reqNum
                    withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address
      stringByAppendingString:@"istock/newTalkStock/hotlist?fromId={fromId}&reqNum={reqNum}"];
  NSDictionary *dic = @{
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

//只看楼主
+ (void)justLookAtTheBuildingLordListsContentWithTweetDic:(NSDictionary *)dic
                                             withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@istock/newTalkStock/" @"floorcommentlist?tweetId={tweetId}&fromId={" @"fromId}&reqNum={reqNum}&order={order}", istock_address];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TweetList class]
             withHttpRequestCallBack:callback];
}

@end

@implementation WeiboContentWrapper
- (void)jsonToObject:(NSDictionary *)dict {
  [super jsonToObject:dict];

  NSDictionary *resultDict = dict[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  NSArray *userLists = resultDict[@"userList"];
  [userListWrapper jsonToMap:userLists];

  //再绑定所有股聊消息
  TweetListItem *talkListItem = [[TweetListItem alloc] init];
  talkListItem.barId = resultDict[@"barId"];
  talkListItem.tstockid = resultDict[@"tstockid"];
  talkListItem.tweetId = resultDict[@"tweetId"];
  talkListItem.barName = resultDict[@"barName"];
  talkListItem.ctime = resultDict[@"ctime"];
  if (resultDict[@"elite"]) {
    talkListItem.elite = [resultDict[@"elite"] intValue];
  } else {
    talkListItem.elite = 0;
  }
  talkListItem.content = resultDict[@"content"];
  talkListItem.type = [resultDict[@"type"] integerValue];
  talkListItem.praise = [resultDict[@"praise"] integerValue];
  talkListItem.collect = [resultDict[@"collect"] integerValue];
  talkListItem.comment = [resultDict[@"comment"] integerValue];
  talkListItem.imgs = resultDict[@"imgs"];
  talkListItem.repost = [resultDict[@"repost"] integerValue];
  talkListItem.share = [resultDict[@"share"] integerValue];
  talkListItem.stype = [resultDict[@"stype"] integerValue];
  talkListItem.title = resultDict[@"title"];
  //判空
  if (resultDict[@"source"]) {
    [talkListItem setValuesForKeysWithDictionary:resultDict[@"source"]];
    talkListItem.o_content = resultDict[@"source"][@"o_content"];
    talkListItem.o_ctime = resultDict[@"source"][@"o_ctime"];
    talkListItem.o_imgs = resultDict[@"source"][@"o_imgs"];
    talkListItem.o_nick = resultDict[@"source"][@"o_nick"];
    talkListItem.o_stype = [resultDict[@"source"][@"o_stype"] integerValue];
    talkListItem.o_tstockid = resultDict[@"source"][@"o_tstockid"];
    talkListItem.o_type = [resultDict[@"source"][@"o_type"] integerValue];
    talkListItem.o_uid = resultDict[@"source"][@"o_uid"];
  }

  NSString *uid = [SimuUtil changeIDtoStr:resultDict[@"uid"]];

  talkListItem.userListItem = [userListWrapper getUserById:uid];

  self.weibo = talkListItem;
}

+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                                    withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@istock/newTalkStock/getTStock?tweetId=%@", istock_address, talkID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WeiboContentWrapper class]
             withHttpRequestCallBack:callback];
}

@end