//
//  MakingShareAction.m
//  SimuStock
//
//  Created by jhss on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MakingShareAction.h"
#import "NewShowLabel.h"
#import "MPNotificationView.h"
#import "ShareImageProvider.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TaskIdUtil.h"
#import "GetGoldWrapper.h"
#import "DoTaskStatic.h"

@implementation MakingShareAction

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}
//分享图片存在不同
- (void)shareTitle:(NSString *)title
           content:(NSString *)content
             image:(UIImage *)image
    withOtherImage:(UIImage *)otherImage
      withShareUrl:(NSString *)_shareUrl
     withOtherInfo:(NSString *)otherInfo {
  //分享内容字数过多时，截取
  if ([content length] > 300) {
    content = [content substringToIndex:300];
  }
  if ([otherInfo length] > 300) {
    otherInfo = [otherInfo substringToIndex:300];
  }
  //初始化对象
  _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  //加入分享的图片
  id<ISSCAttachment> shareImage = nil;
  SSPublishContentMediaType shareType = SSPublishContentMediaTypeImage;
  //绘制大图（发布页面使用图，分享后的效果图仍然是image）
  UIImage *bigImage = [ShareImageProvider bigImageFromImage:image];

  id<ISSCAttachment> bigShareImage;
  if (bigImage) {
    bigShareImage = [ShareSDK jpegImageWithImage:image quality:1.0];
  }
  //分享之前显示的效果图
  if (bigImage) {
    //除微信以外的分享
    bigShareImage = [ShareSDK jpegImageWithImage:bigImage quality:1.0];
  }
  //分享之后的效果图
  if (image) {
    shareImage = [ShareSDK pngImageWithImage:image];
    shareType = SSPublishContentMediaTypeImage;
  }
  //加入分享的图片
  id<ISSCAttachment> otherShareImage = nil;
  if (otherImage) {
    //关于微信的分享,详情页截图
    otherShareImage = [ShareSDK jpegImageWithImage:otherImage quality:1.0];
  }
  //修改腾讯官博
  __block NSString *newContent = content;
  newContent =
      [newContent stringByReplacingOccurrencesOfString:@"@优顾炒股官方" withString:@"@youguu-com"];

  //定制微信好友信息
  //  [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
  //                                       content:content
  //                                         title:title
  //                                           url:_shareUrl
  //                                    thumbImage:shareImage
  //                                         image:shareImage
  //                                  musicFileUrl:nil
  //                                       extInfo:nil
  //                                      fileData:nil
  //                                  emoticonData:nil];
  NSRange showStrRange = [content rangeOfString:_shareUrl];
  NSString *showStr;
  if (showStrRange.length > 0) {
    showStr = [content substringToIndex:showStrRange.location];
  } else {
    showStr = content;
  }
  if ([showStr length] <= 6) {
    showStr = @"#优顾炒股#";
  }
  publishContent = [ShareSDK content:showStr
                      defaultContent:@""
                               image:bigShareImage
                               title:title
                                 url:_shareUrl
                         description:@""
                           mediaType:SSPublishContentMediaTypeNews];

  id<ISSCAttachment> iconImage =
      [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"icon"] quality:1.0];
  id<ISSCAttachment> shareIconImage =
      [ShareSDK jpegImageWithImage:[UIImage imageNamed:@"shareIcon"] quality:1.0];

  if (_shareModuleType == ShareModuleTypeWeibo) {
    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];
    [self ShareInfoWithWeiXinSessionUnitWithTitle:title
                                      WithContent:[otherInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                          WithUrl:_shareUrl
                                        WithImage:iconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:[otherInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                   WithContent:[otherInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                       WithUrl:_shareUrl
                                     WithImage:iconImage
                                 withIconImage:iconImage];
    [self ShareInfoWithQQUnitWithTitle:title
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"分享了一条聊股"
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeStaticWap) {
    publishContent = [ShareSDK content:content
                        defaultContent:@""
                                 image:nil
                                 title:title
                                   url:_shareUrl
                           description:@""
                             mediaType:SSPublishContentMediaTypeText];
    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:@"优顾炒股"
                                      WithContent:otherInfo
                                          WithUrl:_shareUrl
                                        WithImage:iconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:otherInfo
                                   WithContent:otherInfo
                                       WithUrl:_shareUrl
                                     WithImage:iconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:@"优顾炒股"
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"优顾炒股"
                            WithContent:otherInfo
                                WithUrl:_shareUrl
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeStockMatchCreate) {
    _shareModuleType = ShareModuleTypeStockMatch;
    publishContent = [ShareSDK content:content
                        defaultContent:@""
                                 image:shareImage
                                 title:title
                                   url:_shareUrl
                           description:@""
                             mediaType:SSPublishContentMediaTypeImage];
    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];
    //图片形式
    [publishContent addWeixinSessionUnitWithType:@(SSPublishContentMediaTypeImage)
                                         content:content
                                           title:title
                                             url:_shareUrl
                                      thumbImage:shareImage
                                           image:shareImage
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addWeixinTimelineUnitWithType:@(SSPublishContentMediaTypeImage)
                                          content:content
                                            title:title
                                              url:_shareUrl
                                       thumbImage:shareImage
                                            image:shareImage
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    [self ShareInfoWithQQUnitWithTitle:@"优顾炒股"
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"优顾炒股"
                            WithContent:otherInfo
                                WithUrl:_shareUrl
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeStockMatchRank) {
    _shareModuleType = ShareModuleTypeStaticWap;
    //比赛排行分享
    publishContent = [ShareSDK content:content
                        defaultContent:@""
                                 image:nil
                                 title:title
                                   url:_shareUrl
                           description:@""
                             mediaType:SSPublishContentMediaTypeText];

    [self ShareInfoWithSinaWeiBo:content withImage:nil];
    [self ShareInfoWithTencentWeiBo:newContent withImage:nil];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:@"炒股比赛火热进行中"
                                      WithContent:content
                                          WithUrl:_shareUrl
                                        WithImage:iconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:title
                                   WithContent:content
                                       WithUrl:_shareUrl
                                     WithImage:iconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:@"炒股比赛火热进行中"
                           WithContent:title
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"炒股比赛火热进行中"
                            WithContent:content
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeHomePage) {
    //主页分享
    publishContent = [ShareSDK content:content
                        defaultContent:@""
                                 image:shareImage
                                 title:title
                                   url:_shareUrl
                           description:@""
                             mediaType:SSPublishContentMediaTypeImage];

    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:@"分享了一位炒股牛人"
                                      WithContent:content
                                          WithUrl:_shareUrl
                                        WithImage:shareImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:@"分享了一位炒股牛人"
                                   WithContent:otherInfo
                                       WithUrl:_shareUrl
                                     WithImage:shareImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:@"分享了一位炒股牛人"
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareImage];
    [self ShareInfoWithQQSpaceWithTitle:@"分享了一位炒股牛人"
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeStockMatch) {

    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];

    content = [content stringByReplacingOccurrencesOfString:@"#优顾炒股#" withString:@""];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:title
                                      WithContent:content
                                          WithUrl:_shareUrl
                                        WithImage:shareIconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:content
                                   WithContent:content
                                       WithUrl:_shareUrl
                                     WithImage:shareIconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:title
                           WithContent:content
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:title
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeUserEvaluating) {
    [self ShareInfoWithSinaWeiBo:content withImage:nil];
    [self ShareInfoWithTencentWeiBo:newContent withImage:nil];

    content = [content stringByReplacingOccurrencesOfString:@"#优顾炒股#" withString:@""];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:@"优顾交易评级报告"
                                      WithContent:content
                                          WithUrl:_shareUrl
                                        WithImage:shareIconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:content
                                   WithContent:content
                                       WithUrl:_shareUrl
                                     WithImage:shareIconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:@"优顾交易评级报告"
                           WithContent:content
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"优顾交易评级报告"
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeTrade) {

    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:@"炒股牛人最新交易"
                                      WithContent:otherInfo
                                          WithUrl:_shareUrl
                                        WithImage:iconImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:otherInfo
                                   WithContent:otherInfo
                                       WithUrl:_shareUrl
                                     WithImage:iconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:@"炒股牛人最新交易"
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareIconImage];
    [self ShareInfoWithQQSpaceWithTitle:@"炒股牛人最新交易"
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareIconImage];
  } else if (_shareModuleType == ShareModuleTypeMarket) {

    [self ShareInfoWithSinaWeiBo:content withImage:shareImage];
    [self ShareInfoWithTencentWeiBo:newContent withImage:shareImage];

    [self ShareInfoWithWeiXinSessionUnitWithTitle:title
                                      WithContent:otherInfo
                                          WithUrl:_shareUrl
                                        WithImage:otherShareImage];
    [self ShareInfoWithWeiXinTimeLineWithTitle:title
                                   WithContent:otherInfo
                                       WithUrl:_shareUrl
                                     WithImage:iconImage
                                 withIconImage:iconImage];

    [self ShareInfoWithQQUnitWithTitle:title
                           WithContent:otherInfo
                               WithUrl:_shareUrl
                             WithImage:shareImage];
    [self ShareInfoWithQQSpaceWithTitle:title
                            WithContent:otherInfo
                                WithUrl:INHERIT_VALUE
                              WithImage:shareImage];
  }
  //分享的 底ViewControoler
  id<ISSContainer> container = [ShareSDK container];

  //可以 设置 sharesdk 弹出的底ViewController
  id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                       allowCallback:YES
                                                       authViewStyle:SSAuthViewStyleFullScreenPopup
                                                        viewDelegate:nil
                                             authManagerViewDelegate:_appDelegate.jhssViewDelegate];
  //隐藏sharesdk标识
  [authOptions setPowerByHidden:YES];
  //隐藏sharesdk标识
  [authOptions setPowerByHidden:YES];
  //要分享的列表
  NSArray *shareList = nil;
  if ([WXApi isWXAppSupportApi] && [TencentOAuth iphoneQQInstalled]) {
    shareList = [ShareSDK getShareListWithType:ShareTypeWeixiTimeline, ShareTypeWeixiSession, ShareTypeQQ,
                                               ShareTypeSinaWeibo, ShareTypeTencentWeibo, nil];
  } else if (![WXApi isWXAppSupportApi] && [TencentOAuth iphoneQQInstalled]) {
    shareList = [ShareSDK getShareListWithType:ShareTypeQQ, ShareTypeSinaWeibo, ShareTypeTencentWeibo, nil];
  } else if ([WXApi isWXAppSupportApi] && ![TencentOAuth iphoneQQInstalled]) {
    shareList =
        [ShareSDK getShareListWithType:ShareTypeWeixiTimeline, ShareTypeWeixiSession, ShareTypeSinaWeibo, ShareTypeTencentWeibo, nil];
  } else {
    shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo, nil];
  }
#pragma mark -构建分享界面
  //分享界面 选项
  id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"图文分享"
                                                            oneKeyShareList:nil
                                                             qqButtonHidden:YES
                                                      wxSessionButtonHidden:YES
                                                     wxTimelineButtonHidden:YES
                                                       showKeyboardOnAppear:NO
                                                          shareViewDelegate:_appDelegate.jhssViewDelegate
                                                        friendsViewDelegate:_appDelegate.jhssViewDelegate
                                                      picViewerViewDelegate:nil];

  //弹出分享菜单
  [ShareSDK showShareActionSheet:container
                       shareList:shareList
                         content:publishContent
                   statusBarTips:YES
                     authOptions:authOptions
                    shareOptions:shareOptions
                          result:^(ShareType type, SSResponseState state,
                                   id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            NSDictionary *shareTypeToTextMap = @{
                              @(ShareTypeSinaWeibo) : @"新浪微博",
                              @(ShareTypeTencentWeibo) : @"腾讯微博",
                              @(ShareTypeWeixiSession) : @"微信好友",
                              @(ShareTypeWeixiTimeline) : @"朋友圈",
                              @(ShareTypeQQSpace) : @"QQ空间",
                              @(ShareTypeQQ) : @"QQ"
                            };
                            NSString *supportShareTypeText = shareTypeToTextMap[@(type)];
                            if (supportShareTypeText == nil) {
                              return;
                            }
                            if (state == SSPublishContentStateBegan) {
                              NSLog(@"开始。。。。");
                            }

                            if (state == SSPublishContentStateSuccess) {
                              NSLog(@"完成......");
                              // BLOCK
                              if (_sharedSuccessdBlock) {
                                _sharedSuccessdBlock();
                              }
                              //                          if (self.delegate) {
                              //                            //回传统计
                              //                            [self.delegate refreshShareNumber];
                              //                          }

                              //发送分享成功的状态栏通知
                              [MPNotificationView notifyWithText:[supportShareTypeText stringByAppendingString:@"分享成功"]
                                                     andDuration:1.5];
                              [ShareStatic sendShareSuccessToServerWithShareType:type
                                                                      withModule:_shareModuleType];
                              if ([[SimuUtil getFirstShare] isEqualToString:@""]) {
                                //首次分享任务
                                [DoTaskStatic doTaskWithTaskType:TASK_FIRST_SHARE];
                                [SimuUtil setFirstShare:TASK_FIRST_SHARE];
                              } else {
                                NSLog(@"首次分享任务完成");
                              }
                            } else if (state == SSPublishContentStateFail) {
                              NSLog(@"失败.....");
                              [MPNotificationView notifyWithText:[supportShareTypeText stringByAppendingString:@"分享失败"]
                                                     andDuration:1.5];

                              if ([error errorCode] == -24002) {
                                [NewShowLabel setMessageContent:@"未" @"安装QQ或QQ版本过" @"低，分享失败"];
                              } else if ([error errorCode] == -22003) {
                                [NewShowLabel setMessageContent:@"未" @"安装微信或微信版" @"本过低，无法分" @"享"];
                              } else if ([error errorCode] == 20003) {
                                //账号被封
                                [NewShowLabel setMessageContent:@"您" @"的帐号存在异常，" @"暂时无法访问。"];
                              } else
                                [NewShowLabel setMessageContent:[error errorDescription]];
                              NSLog(@"分享失败,错误码:%ld,错误描述:%@",
                                    (long)[error errorCode], [error errorDescription]);
                            } else if (state == SSPublishContentStateBegan) {

                            } else {
                              //取消
                            }
                          }];
}

/** 获取可分享的列表 */
- (NSArray *)shareListsWithSina:(id<ISSShareActionSheetItem>)sinaList
                  withTencentWB:(id<ISSShareActionSheetItem>)tencentWB
                    withQQSpace:(id<ISSShareActionSheetItem>)qqSpace {
  NSArray *shareLists = nil;
  if ([WXApi isWXAppSupportApi] && [TencentOAuth iphoneQQInstalled]) {
    shareLists =
        [ShareSDK customShareListWithType:sinaList, tencentWB, SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline), SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
  } else if (![WXApi isWXAppSupportApi] && [TencentOAuth iphoneQQInstalled]) {
    shareLists = [ShareSDK customShareListWithType:sinaList, tencentWB, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
  } else if ([WXApi isWXAppSupportApi] && ![TencentOAuth iphoneQQInstalled]) {
    shareLists =
        [ShareSDK customShareListWithType:SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession), sinaList, tencentWB, nil];
  } else {
    shareLists = [ShareSDK customShareListWithType:shareLists, tencentWB, nil];
  }
  return shareLists;
}
/** 创建分享对象 */
- (id<ISSContent>)createPublishContentWithContent:(NSString *)content
                                        withImage:(id<ISSCAttachment>)image
                                        withTitle:(NSString *)title
                                          withUrl:(NSString *)url
                                    withMediaType:(SSPublishContentMediaType)mediaType {
  id<ISSContent> localPublishContent = [ShareSDK content:content
                                          defaultContent:@""
                                                   image:image
                                                   title:title
                                                     url:url
                                             description:@""
                                               mediaType:mediaType];
  return localPublishContent;
}
/** 新浪微博平台 */
- (void)ShareInfoWithSinaWeiBo:(NSString *)content withImage:(id<ISSCAttachment>)image {
  [publishContent addSinaWeiboUnitWithContent:content image:image];
}
/** 腾讯微博平台 */
- (void)ShareInfoWithTencentWeiBo:(NSString *)content withImage:(id<ISSCAttachment>)image {
  [publishContent addTencentWeiboUnitWithContent:content image:image];
}
/** 微信好友平台 */
- (id<ISSContent>)ShareInfoWithWeiXinSessionUnitWithTitle:(NSString *)title
                                              WithContent:(NSString *)content
                                                  WithUrl:(NSString *)wxShareUrl
                                                WithImage:(id<ISSCAttachment>)wxImage {
  [publishContent addWeixinSessionUnitWithType:@(SSPublishContentMediaTypeNews)
                                       content:content
                                         title:title
                                           url:wxShareUrl
                                    thumbImage:wxImage
                                         image:wxImage
                                  musicFileUrl:nil
                                       extInfo:nil
                                      fileData:nil
                                  emoticonData:nil];
  return publishContent;
}
/** 微信朋友圈平台 */
- (void)ShareInfoWithWeiXinTimeLineWithTitle:(NSString *)title
                                 WithContent:(NSString *)content
                                     WithUrl:(NSString *)wxShareUrl
                                   WithImage:(id<ISSCAttachment>)wxImage
                               withIconImage:(id<ISSCAttachment>)iconImage {
  [publishContent addWeixinTimelineUnitWithType:@(SSPublishContentMediaTypeNews)
                                        content:content
                                          title:title
                                            url:wxShareUrl
                                     thumbImage:iconImage
                                          image:iconImage
                                   musicFileUrl:nil
                                        extInfo:nil
                                       fileData:nil
                                   emoticonData:nil];
}
/** qq平台 */
- (void)ShareInfoWithQQUnitWithTitle:(NSString *)title
                         WithContent:(NSString *)content
                             WithUrl:(NSString *)qqShareUrl
                           WithImage:(id<ISSCAttachment>)qqImage {

  [publishContent addQQUnitWithType:@(SSPublishContentMediaTypeNews)
                            content:content
                              title:title
                                url:qqShareUrl
                              image:qqImage];
}
/** qq空间平台 */
- (void)ShareInfoWithQQSpaceWithTitle:(NSString *)title
                          WithContent:(NSString *)content
                              WithUrl:(NSString *)qqShareUrl
                            WithImage:(id<ISSCAttachment>)qqImage {
  [publishContent addQQSpaceUnitWithTitle:title
                                      url:INHERIT_VALUE
                                     site:nil
                                  fromUrl:nil
                                  comment:INHERIT_VALUE
                                  summary:content
                                    image:qqImage
                                     type:nil
                                  playUrl:nil
                                     nswb:nil];
}

@end
