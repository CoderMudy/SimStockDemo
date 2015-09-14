//
//  ShareController.m
//  SimuStock
//
//  Created by Mac on 15/2/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShareController.h"
#import "MakingShareAction.h"
#import "WeiboUtil.h"
#import "WeiboText.h"
#import "StockTradeList.h"

@implementation ShareController

- (void)sendAddShareNumRequestWithWeibo:(TweetListItem *)homeData {
  NSDictionary *userInfo = @{ @"data" : homeData };
  //广播分享成功，分享数加1
  [[NSNotificationCenter defaultCenter]
      postNotificationName:ShareWeiboSuccessNotification
                    object:self
                  userInfo:userInfo];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {

  };
  callback.onFailed = ^{};

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {};

  [StockTradeList requestShareStockTradeWithTid:homeData.tstockid
                                   withCallback:callback];
}

///分享微博
- (void)shareWeibo:(TweetListItem *)homeData
    withShareImage:(UIImage *)shareImage {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //链接
  NSString *shareUrl = [[NSMutableString alloc]
      initWithFormat:@"%@/mobile/wap_share/tweet.html?tid=%@", wap_address,
                     homeData.tstockid];
  NSString *selfUserID = [SimuUtil getUserID];
  if (shareImage) {
    //图片截取成功，做分享
    MakingShareAction *shareAction = [[MakingShareAction alloc] init];
    shareAction.shareModuleType = ShareModuleTypeWeibo;
    shareAction.shareUserID = selfUserID;
    //分享内容拼接
    NSMutableString *allContent = [[NSMutableString alloc] init];
    if (homeData.title && [homeData.title length] > 0) {
      [allContent appendString:homeData.title];
    } else {
      NSArray *array = [WeiboUtil parseWeiboRichContext:homeData.content];
      for (WeiboText *str in array) {
        [allContent appendString:str.content];
      }
    }

    shareAction.sharedSuccessdBlock = ^{
        //分享成功后刷新分享数据
        [self sendAddShareNumRequestWithWeibo:homeData];
    };
    [shareAction
            shareTitle:@"分享了一条聊股"
               content:[NSString
                           stringWithFormat:
                               @"#优顾炒股#%@【分享自@优顾炒股官方】", shareUrl]
                 image:shareImage
        withOtherImage:nil
          withShareUrl:shareUrl
         withOtherInfo:allContent];
  }
}

/** 分享股票买卖微博 */
- (void)shareTradeWithWeibo:(TweetListItem *)homeData {
  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  shareAction.sharedSuccessdBlock = ^{
      //分享成功后刷新分享数据
      [self sendAddShareNumRequestWithWeibo:homeData];
  };

  shareAction.shareModuleType = ShareModuleTypeTrade;
  NSString *shareUrl = [[NSMutableString alloc]
      initWithFormat:@"%@/wap/transaction.shtml?tid=%@", wap_address,
                     homeData.tstockid];

  NSString *nickname = homeData.userListItem.nickName;
  NSString *trade = homeData.stype == WeiboSubTypeBuy ? @"买入" : @"卖出";
  NSDictionary *dict = homeData.contentArr[0][1][1];
  NSString *stockcode = dict[@"code"];
  if (stockcode.length == 8) {
    stockcode = [stockcode substringFromIndex:2];
  }
  NSString *stockname =
      [NSString stringWithFormat:@"%@(%@)", dict[@"name"], stockcode];
  //买入
  [shareAction
          shareTitle:[NSString stringWithFormat:@"【%@】%@股票%@ ",
                                                nickname, trade, stockname]
             content:[NSString stringWithFormat:@"#优顾炒股#【%@】%@股票%@ %@ "
                                                @"(分享自@优顾炒股官方)",
                                                nickname, trade, stockname,
                                                shareUrl]
               image:nil
      withOtherImage:nil
        withShareUrl:shareUrl
       withOtherInfo:[NSString stringWithFormat:@"【%@】%@股票%@ ",
                                                nickname, trade, stockname]];
}

/** 分享股票分红微博 */
- (void)shareTradeDividendWithWeibo:(TweetListItem *)homeData {
  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  shareAction.sharedSuccessdBlock = ^{
      //分享成功后刷新分享数据
      [self sendAddShareNumRequestWithWeibo:homeData];
  };
  shareAction.shareModuleType = ShareModuleTypeTrade;
  NSString *shareUrl = [[NSMutableString alloc]
      initWithFormat:@"%@/wap/transaction.shtml?tid=%@", wap_address,
                     [homeData.tstockid stringValue]];

  NSString *nickname = homeData.userListItem.nickName;
  NSDictionary *dict = homeData.contentArr[0][1][1];
  NSString *stockcode = dict[@"code"];
  if (stockcode.length == 8) {
    stockcode = [stockcode substringFromIndex:2];
  }
  NSString *stockname =
      [NSString stringWithFormat:@"%@(%@)", dict[@"name"], stockcode];
  //分红数据
  if ([homeData.contentArr count] == 2) {
    NSArray *profitArray = homeData.contentArr[1];
    for (NSString *subStr in profitArray) {
      if ([subStr hasPrefix:@"送转股数"]) {
        //分红分享
        [shareAction
                shareTitle:[NSString stringWithFormat:@"【%@】%@ ", nickname,
                                                      stockname]
                   content:[NSString stringWithFormat:
                                         @"【%@】持仓的股票%@"
                                         @"分红，具体方案：%@"
                                         @"。派现金额共%@"
                                         @"元，送转股份共%@股",
                                         nickname, stockname,
                                         [profitArray[0] substringFromIndex:5],
                                         [profitArray[2] substringFromIndex:5],
                                         [profitArray[1] substringFromIndex:5]]
                     image:nil
            withOtherImage:nil
              withShareUrl:shareUrl
             withOtherInfo:
                 [NSString
                     stringWithFormat:@"【%@】持仓的股票%@"
                                      @"分红，具体方案：%@"
                                      @"。派现金额共%@"
                                      @"元，送转股份共%@股",
                                      nickname, stockname,
                                      [profitArray[0] substringFromIndex:5],
                                      [profitArray[2] substringFromIndex:5],
                                      [profitArray[1] substringFromIndex:5]]];
        break;
      }
    }
    //分红分享
    [shareAction
            shareTitle:[NSString
                           stringWithFormat:@"【%@】%@ ", nickname, stockname]
               content:[NSString stringWithFormat:
                                     @"【%@】持仓的股票%@"
                                     @"分红，具体方案：%@"
                                     @"。派现金额共%@元。",
                                     nickname, stockname,
                                     [profitArray[0] substringFromIndex:5],
                                     [profitArray[2] substringFromIndex:5]]
                 image:nil
        withOtherImage:nil
          withShareUrl:shareUrl
         withOtherInfo:
             [NSString stringWithFormat:@"【%@】持仓的股票%@"
                                        @"分红，具体方案：%@"
                                        @"。派现金额共%@元。",
                                        nickname, stockname,
                                        [profitArray[0] substringFromIndex:5],
                                        [profitArray[2] substringFromIndex:5]]];
  } else if ([homeData.contentArr count] == 3) {
    NSArray *homeTradeArray = homeData.contentArr[2];
    //分红分享
    for (NSString *subStr in homeTradeArray) {
      if ([subStr hasPrefix:@"送转股数"]) {
        //分红分享
        [shareAction
                shareTitle:[NSString stringWithFormat:@"【%@】%@ ", nickname,
                                                      stockname]
                   content:[NSString
                               stringWithFormat:
                                   @"【%@】持仓的股票%@"
                                   @"分红，具体方案：%@"
                                   @"。派现金额共%@"
                                   @"元，送转股份共%@股",
                                   nickname, stockname,
                                   [homeTradeArray[0] substringFromIndex:5],
                                   [homeTradeArray[2] substringFromIndex:5],
                                   [homeTradeArray[1] substringFromIndex:5]]
                     image:nil
            withOtherImage:nil
              withShareUrl:shareUrl
             withOtherInfo:[NSString
                               stringWithFormat:
                                   @"【%@】持仓的股票%@"
                                   @"分红，具体方案：%@"
                                   @"。派现金额共%@"
                                   @"元，送转股份共%@股",
                                   nickname, stockname,
                                   [homeTradeArray[0] substringFromIndex:5],
                                   [homeTradeArray[2] substringFromIndex:5],
                                   [homeTradeArray[1] substringFromIndex:5]]];
        break;
      }
    }

    [shareAction
            shareTitle:[NSString
                           stringWithFormat:@"【%@】%@ ", nickname, stockname]
               content:[NSString stringWithFormat:
                                     @"【%@】持仓的股票%@"
                                     @"分红，具体方案：%@"
                                     @"。派现金额共%@元。",
                                     nickname, stockname,
                                     [homeTradeArray[0] substringFromIndex:5],
                                     [homeTradeArray[2] substringFromIndex:5]]
                 image:nil
        withOtherImage:nil
          withShareUrl:shareUrl
         withOtherInfo:[NSString stringWithFormat:
                                     @"【%@】持仓的股票%@"
                                     @"分红，具体方案：%@"
                                     @"。派现金额共%@元。",
                                     nickname, stockname,
                                     [homeTradeArray[0] substringFromIndex:5],
                                     [homeTradeArray[2] substringFromIndex:5]]];
  }
}

@end
