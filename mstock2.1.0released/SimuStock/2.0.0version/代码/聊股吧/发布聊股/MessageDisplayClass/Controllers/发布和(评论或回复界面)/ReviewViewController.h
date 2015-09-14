//
//  ReviewViewController.h
//  SimuStock
//
//  Created by Mac on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"

@interface ReviewViewController
    : MessageDisplayDetailViewController <YLTextViewDelegate>

///评论主贴ID
@property(nonatomic, retain) NSString *stockID;
///评论回复的ID
@property(nonatomic, retain) NSString *sourceID;
///剩余文本 字数
@property(nonatomic, retain) UILabel *numTextLabel;
///是否转发到我的聊股
@property(nonatomic, assign) BOOL isForwarding;

///回复对象
@property(nonatomic, retain) TweetListItem * midTweetObject;

///评论主贴ID  sourceid (回复id)
- (id)initWithTstockID:(NSString *)stockID
           andSourceid:(NSString *)sourceid
           andCallBack:(OnReturnObject)callback;

///评论主贴ID  sourceid (回复id) tweetObject(回复对象)
- (id)initWithTstockID:(NSString *)stockID
           andSourceid:(NSString *)sourceid
      andTweetListItem:(TweetListItem *)tweetObject
           andCallBack:(OnReturnObject)callback;
@end
