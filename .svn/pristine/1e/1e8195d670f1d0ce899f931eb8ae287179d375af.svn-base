// qqq
//  MessageDisplayDetailViewController.h
//  MessageDisplay
//
//  Created by yuling@发布聊股分类 on 14-5-16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageDisplayViewController.h"
#import "YLTextView.h"
#import "BaseRequester.h"
#import "JsonFormatRequester.h"
#import "TweetListItem.h"
#import "NetLoadingWaitView.h"
#import "UploadRequestController.h"

///发表聊股的共同（父类）
@interface MessageStockJsonObject : JsonRequestObject

@end

/**
 点击按钮的回调函数
 */
typedef void (^OnReturnObject)(TweetListItem *tweetItemObject);

@interface MessageDisplayDetailViewController
    : MessageDisplayViewController <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    YLTextViewDelegate> {
@public
  /** block回调 */
  OnReturnObject OnReturnObjectCallback;
}
///进入就有文本
@property(nonatomic, strong) NSString *Str_Content;
@property(nonatomic, strong) YLTextView *messageDisplayView;

#pragma mark - 发布聊股父类方法
///正式发布聊股
- (void)Edit_PathUrl:(NSString *)url andDic:(NSDictionary *)dic;
///获取上传表单的字典dic
- (NSDictionary *)getDataWithDictionary_StockBar:(NSString *)barid
                                     andSourceID:(NSString *)sourceID
                                     andComments:(NSString *)string
                                        andTitle:(NSString *)title
                                        andImage:(UIImage *)shareImage;
///当点击左边退出按钮是保存的数据(dic)
- (NSDictionary *)saveDataWithDic;
@end
