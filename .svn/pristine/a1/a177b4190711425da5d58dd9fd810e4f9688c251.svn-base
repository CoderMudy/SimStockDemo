//
//  MakingShareAction.h
//  SimuStock
//
//  Created by jhss on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "ShareStatic.h"

/** 分享成功回调block */
typedef void (^sharedSuccessdBlock)();

/** 统计分享 */
@protocol ShareStatDelegate <NSObject>

- (void)refreshShareNumber;

@end
/** 分享接收类 */
@interface MakingShareAction : NSObject <ISSShareViewDelegate> {
  AppDelegate *_appDelegate;
  /** 分享内容 */
  NSMutableString *lastContent;
  /** 分享截图的网址 */
  NSMutableString *shareUrl;
  /** 自定义分享内容 */
  id<ISSContent> publishContent;
}
///分享页面类型
@property(assign, nonatomic) ShareModuleType shareModuleType;
@property(copy, nonatomic) NSString *share_code;
@property(copy, nonatomic) NSString *to_position;
@property(copy, nonatomic) NSString *shareUserID;
@property(copy, nonatomic) NSString *shareStockCode;
/** 回传分享统计 */
//@property(strong, nonatomic) id<ShareStatDelegate> delegate;
/** 分享成功回调block */
@property(nonatomic, copy) sharedSuccessdBlock sharedSuccessdBlock;
/** 分享接收函数 */
- (void)shareTitle:(NSString *)title
           content:(NSString *)content
             image:(UIImage *)image
    withOtherImage:(UIImage *)otherImage
      withShareUrl:(NSString *)_shareUrl
     withOtherInfo:(NSString *)otherInfo;

@end
