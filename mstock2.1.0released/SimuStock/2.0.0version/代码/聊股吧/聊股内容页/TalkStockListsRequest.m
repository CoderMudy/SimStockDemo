//
//  TalkStockListsRequest.m
//  SimuStock
//
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation TalkStockHeadContentRequest
- (void)jsonToObject:(NSDictionary *)dict {
  NSLog(@"dict = %@",dict);
  [super jsonToObject:dict];
  self.dataArray = [[NSMutableArray alloc]init];
  TalkStockContentItem *item = [[TalkStockContentItem alloc]init];
  NSDictionary *resultDict = dict[@"result"];
  item.mTalkBaId = [resultDict[@"barId"] stringValue];
  item.mCollectNum = [resultDict[@"collect"] stringValue];
  item.mCommentNum = [resultDict[@"comment"] stringValue];
  item.mContent = resultDict[@"content"];
  item.mReleaseTime = [resultDict[@"ctime"]stringValue];
  item.mPraiseNum = [resultDict[@"praise"] stringValue];
  item.mRepostNum = [resultDict[@"repost"] stringValue];;
  item.mShareNum = resultDict[@"share"];
  item.mStype = [resultDict[@"stype"]stringValue];
  item.mTalkStockId = [resultDict[@"tstockid"]stringValue];
  item.mType = [resultDict[@"type"]stringValue];
  item.mUid = [resultDict[@"uid"]stringValue];
  item.mItems = [[NSMutableArray alloc]init];
  NSArray *userLists = resultDict[@"userList"];
  if ([userLists count] > 0) {
    for (NSDictionary *subDict in userLists) {
      UserListItem *subItem = [[UserListItem alloc]init];
      subItem.mHeadPic = subDict[@"headPic"];
      subItem.mNickName = subDict[@"nickName"];
      subItem.mRating = subDict[@"rating"];
      subItem.mSignature = subDict[@"signature"];
      subItem.mStockFirmFlag = [subDict[@"stockFirmFlag"]stringValue];
      subItem.mUserId = [subDict[@"userId"]stringValue];
      subItem.mUserName = subDict[@"userName"];
      subItem.mVipType = [subDict[@"vipType"]stringValue];
      [item.mItems addObject:subItem];
    }
  }
  [self.dataArray addObject:item];
}

+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                           withCallback:(HttpRequestCallBack *)callback
{
  NSString *url = [NSString stringWithFormat:@"%@istock/newTalkStock/getTStock?tweetId=%@", istock_address, talkID];
  JsonFormatRequester *request = [[JsonFormatRequester alloc]init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[TalkStockHeadContentRequest class]
             withHttpRequestCallBack:callback];
}
@end

@implementation TalkStockListsRequest
- (void)jsonToObject:(NSDictionary *)dict
{
  NSLog(@"list_dict =%@", dict);
  [super jsonToObject:dict];
  self.tweetListArray = [[NSMutableArray alloc]init];
  self.userListArray = [[NSMutableArray alloc]init];
  NSDictionary *resultDict = dict[@"result"];
  NSArray *tweetLists = resultDict[@"tweetList"];
  for (NSDictionary *subDict in tweetLists) {
    TweetListItem *item = [[TweetListItem alloc]init];
    item.mBarId = [subDict[@"barId"]stringValue];;
    item.mContent = subDict[@"content"];
    item.mCTime = [subDict[@"ctime"]stringValue];
    item.mFloor = [subDict[@"floor"]stringValue];
    item.mStype = [subDict[@"stype"]stringValue];
    item.mTimeLineId = [subDict[@"timelineid"]stringValue];
    item.mTStockId = [subDict[@"tstockid"]stringValue];
    item.mType = [subDict[@"type"]stringValue];
    item.mUid = [subDict[@"uid"]stringValue];
    [self.tweetListArray addObject:item];
  }
  NSArray *userLists = resultDict[@"userList"];
  for (NSDictionary *subDict in userLists) {
    UserListItem *item = [[UserListItem alloc]init];
    item.mHeadPic = subDict[@"headPic"];
    item.mNickName = subDict[@"nickName"];
    item.mRating = subDict[@"rating"];
    item.mSignature = subDict[@"signature"];
    item.mStockFirmFlag = [subDict[@"stockFirmFlag"]stringValue];
    item.mUserId = [subDict[@"userId"]stringValue];
    item.mUserName = subDict[@"userName"];
    item.mVipType = [subDict[@"vipType"]stringValue];
    [self.userListArray addObject:item];
  }
}
+ (void)getTalkStockListsContentWithTweetId:(NSString *)tweetId
                                 withFromId:(NSString *)fromId
                                 withReqNum:(NSString *)reqNum
                                  withOrder:(NSString *)order
                               withCallback:(HttpRequestCallBack *)callback
{
  NSString *url = [NSString stringWithFormat:@"%@istock/newTalkStock/getCommentList?tweetId={tweetid}&fromId={fromId}&reqNum={reqNum}&order={order}", istock_address];
  NSDictionary *dict = @{@"tweetid":tweetId, @"fromId":fromId, @"reqNum":reqNum, @"order":order};
  JsonFormatRequester *request = [[JsonFormatRequester alloc]init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dict
              withRequestObjectClass:[TalkStockListsRequest class]
             withHttpRequestCallBack:callback];
}

@end
