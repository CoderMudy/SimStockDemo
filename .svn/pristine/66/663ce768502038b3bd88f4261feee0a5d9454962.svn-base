//
//  WBReplyView.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetListItem.h"

@class FTCoreTextView;
@class WBImageView;
@class TweetListItem;

/** 大回复框，包括内容和图片 */
@interface WBReplyView : UIView {
  /** 回复框上面的小三角 */
  UIImageView *_littleTriangle;
  /** 灰色气泡，所有内容承载视图 */
  UIImageView *_grayView;
  /** 回复内容 */
  FTCoreTextView *_coreTextView;
  /** 图片 */
  WBImageView *_weiboImageView;
  
  /** 初始frame记录 */
  CGRect _littleTriangleFrame;
  CGRect _grayViewFrame;
  CGRect _coreTextViewFrame;
  CGRect _weiboImageViewFrame;
  
  TweetListItem *_item;
}

/** 聊股吧 回复框 */
- (void)refreshWithTweetListItem:(TweetListItem *)item
                   withTableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** 计算回复框高度 */
+ (float)heightOfReplyViewWithTweetItem:(TweetListItem *)item;

/** 当长按FTCoreTextView的可点击部分时，需要触发点击链接事件，返回YES，表示触发点击事件，返回NO，表示不处理该事件 */
- (BOOL) performClickOnPoint:(CGPoint) point;

@end
