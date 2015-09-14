//
//  ReplyViewController.h
//  SimuStock
//
//  Created by Mac on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"

@interface ReplyViewController
    : MessageDisplayDetailViewController <YLTextViewDelegate>

///评论主贴ID
@property(nonatomic, retain) NSString *stockID;
///剩余文本 字数
@property(nonatomic, retain) UILabel *numTextLabel;
///是否转发到我的聊股
@property(nonatomic, assign) BOOL isForwarding;

///评论主贴ID
- (id)initWithTstockID:(NSString *)stockID andCallBack:(OnReturnObject)callback;

///正式评论聊股
- (void)Edit_StockComments:(NSString *)string andImage:(UIImage *)shareImage;
@end
