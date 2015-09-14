//
//  HomeTradeDeatilTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomeTradeDeatilTableViewCell.h"
#import "WeiboUtil.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "MakingShareAction.h"

@implementation HomeTradeDeatilTableViewCell

- (void)awakeFromNib {

  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  //取消选中效果
  UIView *backView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView = backView;
  self.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
  self.backgroundColor = [Globle colorFromHexRGB:@"f7f7f7"];

  _backBlueImageView.layer.cornerRadius = 12;
  _backBlueImageView.layer.masksToBounds = YES;

  _backWhiteView.layer.cornerRadius = 14;
  _backWhiteView.layer.masksToBounds = YES;
  _bigGrayWidth.constant = 1;

  _buyBtn.tag = 7300;
  _sellBtn.tag = 7301;
  _shareBtn.tag = 7303;
  [_buyBtn addTarget:self
                action:@selector(bidButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [_sellBtn addTarget:self
                action:@selector(bidButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [_shareBtn addTarget:self
                action:@selector(bidButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];

  _lineHeight.constant = 0.5f;
  _whiteLineHeight.constant = .5f;

  //设置股票信息字体
  [_coreTextView setTextColor:[Globle colorFromHexRGB:@"454545"]];
  [_coreTextView setTextSize:15];
}
//点击分享，买入，卖出  按钮
- (void)bidButtonTriggeringMethod:(UIButton *)btn {
  //代理方法
  [_delegate bidButtonTriggersCallbackMethod:btn.tag row:self.row];
}
- (void)bindTradeData:(TweetListItem *)homeData {

  //时间
  _timeLabel.text = [SimuUtil getDateFromCtime:[NSNumber numberWithLongLong:[homeData.ctime longLongValue]]];
  //股票信息
  homeData.content = [SimuUtil stringReplaceSpace:(homeData.content.length > 0 ? homeData.content : @"")];
  _coreTextView.text = homeData.content;
  [_coreTextView fitToSuggestedHeight];
  _coreTextViewHeight.constant = _coreTextView.height;
  if (homeData.type == 10) {
    switch (homeData.stype) {
    case 8: {
      _pictureType.image = [UIImage imageNamed:@"买入"];

    } break;
    case 16: {
      _pictureType.image = [UIImage imageNamed:@"卖出"];

    } break;
    case 32: {
      _pictureType.image = [UIImage imageNamed:@"分红派送小标"];
    } break;
    default:
      break;
    }
    //判断按钮是否可点击
    NSString *stockCode =
        [WeiboUtil getAttrValueWithSource:homeData.content withElement:@"stock" withAttr:@"code"];

    if ([SimuPositionPageData isStockSellable:stockCode]) {
      _sellBtn.enabled = YES;
      [_sellBtn setImage:[UIImage imageNamed:@"卖出蓝色图标"] forState:UIControlStateNormal];
      [_sellBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                     forState:UIControlStateNormal];
      [_sellBtn setBackgroundImage:[UIImage imageNamed:@"点击背景图"]
                          forState:UIControlStateHighlighted];
    } else {
      _sellBtn.enabled = NO;
      [_sellBtn setImage:[UIImage imageNamed:@"卖出_不能操作状态"] forState:UIControlStateNormal];
      [_sellBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateNormal];
      [_sellBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    }
  }
}

- (void)hiddenButtons:(BOOL)hidden {
  _buyBtn.hidden = hidden;
  _sellBtn.hidden = hidden;
  _shareBtn.hidden = hidden;
}

+ (void)bidButtonTriggersCallbackMethod:(NSInteger)tag
                                    row:(NSInteger)row
                             shareImage:(UIImage *)shareImage
                          shareUserName:(NSString *)userName
                               homeData:(TweetListItem *)homeData {
  //获得股票编码
  NSString *stockCode =
      [WeiboUtil getAttrValueWithSource:homeData.content withElement:@"stock" withAttr:@"code"];
  //获得股票名称
  NSString *stockName =
      [WeiboUtil getAttrValueWithSource:homeData.content withElement:@"stock" withAttr:@"name"];
  switch (tag) {
  case 7300: {
    //买入
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      //已登录买入
      [simuBuyViewController buyStockWithStockCode:stockCode
                                     withStockName:stockName
                                       withMatchId:@"1"];
    }];
  } break;
  case 7301: {
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      //已登录卖出
      if ([SimuPositionPageData isStockSellable:stockCode]) {
        [simuSellViewController sellStockWithStockCode:stockCode
                                         withStockName:stockName
                                           withMatchId:@"1"];
      }
    }];
  } break;

  case 7303: //分享
  {
    if (1) {

      MakingShareAction *shareAction = [[MakingShareAction alloc] init];
      //      shareAction.delegate = self;
      shareAction.shareModuleType = ShareModuleTypeTrade;
      //      TweetListItem *homeData = self.dataArray.array[row];
      //      tempRow = row;
      if (stockCode.length == 8) {
        stockCode = [stockCode substringFromIndex:2];
      }
      NSString *stockname = [NSString stringWithFormat:@"%@(%@)", stockName, stockCode];
      NSString *shareUrl =
          [[NSMutableString alloc] initWithFormat:@"%@/wap/transaction.shtml?tid=%@", wap_address, homeData.tstockid];
      if (homeData.stype == 8) {
        //买入
        [shareAction
                shareTitle:[NSString stringWithFormat:@"【%@】买入股票%@ ", userName, stockname]
                   content:[NSString stringWithFormat:@"#优顾炒股#【%@" @"】买入股票%@ %@ " @"(分享自@优顾炒股官方)", userName, stockname, shareUrl]
                     image:shareImage
            withOtherImage:nil
              withShareUrl:shareUrl
             withOtherInfo:[NSString stringWithFormat:@"【%@】买入股票%@ ", userName, stockname]];
      } else if (homeData.stype == 16) {
        //卖出
        [shareAction
                shareTitle:[NSString stringWithFormat:@"【%@】卖出股票%@ ", userName, stockname]
                   content:[NSString stringWithFormat:@"#优顾炒股#【%@" @"】卖出股票%@ %@ " @"(分享自@优顾炒股官方)", userName, stockname, shareUrl]
                     image:shareImage
            withOtherImage:nil
              withShareUrl:shareUrl
             withOtherInfo:[NSString stringWithFormat:@"【%@】卖出股票%@ ", userName, stockname]];
      } else if (homeData.stype == 32) {
        //分红数据
        if ([homeData.contentArr count] == 2) {
          NSArray *profitArray = (homeData.contentArr)[1];
          for (NSString *subStr in profitArray) {
            if ([subStr hasPrefix:@"送转股数"]) {
              //分红分享
              [shareAction
                      shareTitle:[NSString stringWithFormat:@"【%@】%@ ", userName, stockname]
                         content:[NSString stringWithFormat:
                                               @"【%@】持仓的股票%@"
                                               @"分红，具体方案：%@" @"。派现金额共%@" @"元，送转股份共%@股",
                                               userName, stockname, [profitArray[0] substringFromIndex:5],
                                               [profitArray[2] substringFromIndex:5], [profitArray[1] substringFromIndex:5]]
                           image:shareImage
                  withOtherImage:nil
                    withShareUrl:shareUrl
                   withOtherInfo:
                       [NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                  @"分红，具体方案：%@。派现金额共%@" @"元，送转股份共%@股",
                                                  userName, stockname, [profitArray[0] substringFromIndex:5],
                                                  [profitArray[2] substringFromIndex:5], [profitArray[1] substringFromIndex:5]]];
              return;
            }
          }
          //分红分享
          [shareAction shareTitle:[NSString stringWithFormat:@"【%@】%@ ", userName, stockname]
                          content:[NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                             @"分红，具体方案：%@"
                                                             @"。派现金额共%@" @"元。",
                                                             userName, stockname, [profitArray[0] substringFromIndex:5],
                                                             [profitArray[1] substringFromIndex:5]]
                            image:shareImage
                   withOtherImage:nil
                     withShareUrl:shareUrl
                    withOtherInfo:[NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                             @"分红，具体方案：%@"
                                                             @"。派现金额共%@元。",
                                                             userName, stockname, [profitArray[0] substringFromIndex:5],
                                                             [profitArray[1] substringFromIndex:5]]];
        } else if ([homeData.contentArr count] == 3) {
          NSArray *tradeProfitArray = (homeData.contentArr)[2];
          //分红分享
          for (NSString *subStr in tradeProfitArray) {
            if ([subStr hasPrefix:@"送转股数"]) {
              //分红分享
              [shareAction
                      shareTitle:[NSString stringWithFormat:@"【%@】%@ ", userName, stockname]
                         content:[NSString stringWithFormat:
                                               @"【%@】持仓的股票%@"
                                               @"分红，具体方案：%@" @"。派现金额共%@" @"元，送转股份共%@股",
                                               userName, stockname, [tradeProfitArray[0] substringFromIndex:5],
                                               [tradeProfitArray[2] substringFromIndex:5], [tradeProfitArray[1] substringFromIndex:5]]
                           image:shareImage
                  withOtherImage:nil
                    withShareUrl:shareUrl
                   withOtherInfo:
                       [NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                  @"分红，具体方案：%@。派现金额共%@" @"元，送转股份共%@股",
                                                  userName, stockname, [tradeProfitArray[0] substringFromIndex:5],
                                                  [tradeProfitArray[2] substringFromIndex:5], [tradeProfitArray[1] substringFromIndex:5]]];
              break;
            }
          }
          [shareAction shareTitle:[NSString stringWithFormat:@"【%@】%@ ", userName, stockname]
                          content:[NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                             @"分红，具体方案：%@"
                                                             @"。派现金额共%@" @"元。",
                                                             userName, stockname, [tradeProfitArray[0] substringFromIndex:5],
                                                             [tradeProfitArray[2] substringFromIndex:5]]
                            image:shareImage
                   withOtherImage:nil
                     withShareUrl:shareUrl
                    withOtherInfo:[NSString stringWithFormat:@"【%@】持仓的股票%@"
                                                             @"分红，具体方案：%@"
                                                             @"。派现金额共%@元。",
                                                             userName, stockname, [tradeProfitArray[0] substringFromIndex:5],
                                                             [tradeProfitArray[2] substringFromIndex:5]]];
        }
      }
    }
  }
  }
}

+ (CGFloat)cellHeightWithTweetListItem:(TweetListItem *)item withShowButtons:(BOOL)showButtons {
  item.heightCache[HeightCacheKeyContent] =
      @([FTCoreTextView heightWithText:item.content width:271 font:Font_Height_14_0]);
  CGFloat otherHeight = showButtons ? 80.f : 50.f;
  return otherHeight + [item.heightCache[HeightCacheKeyContent] floatValue];
}

@end
