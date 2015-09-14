//
//  SystemMessageTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell {
  SystemMsgData *_systemMsgData;
}

- (void)awakeFromNib {
  [_messageSystemView setTextColor:[Globle colorFromHexRGB:@"#5a5a5a"]];
}

static const CGFloat heightUserInfo = 54;

+ (int)cellHeightWithSystemMsg:(SystemMsgData *)message
                  withMsgWidth:(int)msgWidth
                  withFontSize:(float)fontSize {
  CGFloat height = 0;
  CGFloat msgHeight = 0;

  if (message.mMsgContent && [message.mMsgContent length] > 0) {
    msgHeight = [FTCoreTextView heightWithText:message.mMsgContent
                                         width:msgWidth
                                          font:fontSize];
    height = heightUserInfo + msgHeight;
  } else {
    height = heightUserInfo;
  }
  return height;
}

- (void)bindTraceMessage:(SystemMsgData *)systemMsgData {
  _systemMsgData = systemMsgData;
  NSString *stringContent = [self delegeteEnter:systemMsgData.mMsgContent];
  _messageSystemView.text = stringContent;
  [_messageSystemView fitToSuggestedHeight];
  self.msgHeight.constant =
      [FTCoreTextView heightWithText:stringContent
                               width:self.messageSystemView.width
                                font:Font_Height_14_0];
  _titleLabel.text = _systemMsgData.mTitle;
  _ctimeLabel.text = _systemMsgData.mstrTime;
}
///过滤回车
- (NSString *)delegeteEnter:(NSString *)stringContent {
  ///去换行符
  while ([[stringContent componentsSeparatedByString:@"\n"] count] > 1) {
    stringContent = [stringContent stringByReplacingOccurrencesOfString:@"\n"
                                                             withString:@""];
  }
  return stringContent;
}
@end
