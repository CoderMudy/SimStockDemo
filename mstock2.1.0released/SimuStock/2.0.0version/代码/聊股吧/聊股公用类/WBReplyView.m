//
//  WBReplyView.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBReplyView.h"
#import "FTCoreTextView.h"
#import "WBImageView.h"
#import "UITableView+Reload.h"

#define SPACE 6.0f

@implementation WBReplyView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self createUI];
  }
  return self;
}

- (void)awakeFromNib {
  [self createUI];
}

- (void)createUI {
  self.userInteractionEnabled = YES;
  
  //小三角
  _littleTriangle = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"聊股回复框小图标"]];
  _littleTriangle.frame = CGRectMake(9, 0.5, 12, 6.5f);
  [self addSubview:_littleTriangle];

  //灰色气泡
  _grayView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 6.5f, WIDTH_OF_VIEW, HEIGHT_OF_VIEW - 6.5f)];
  [_grayView.layer setMasksToBounds:YES];
  [_grayView.layer setCornerRadius:2.5f];
//  _grayView.backgroundColor = [Globle colorFromHexRGB:Color_ReplyBubble];
  [self addSubview:_grayView];

  //回复内容，比气泡小6
  CGRect grayViewFrame = _grayView.frame;
  grayViewFrame.origin.y += SPACE;//保证正中间
  grayViewFrame.origin.x += SPACE;
  grayViewFrame.size.width -= SPACE * 2;
  _coreTextView = [[FTCoreTextView alloc] initWithFrame:grayViewFrame];
  [_coreTextView setTextSize:Font_Height_14_0];
  [_coreTextView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self addSubview:_coreTextView];

  //可点击图片
  _weiboImageView = [[WBImageView alloc] initWithFrame:_coreTextView.frame];
  _weiboImageView.contentMode = UIViewContentModeScaleAspectFit;
  _weiboImageView.userInteractionEnabled = YES;
//  _weiboImageView.imageSizeBlock = ^(CGFloat width, CGFloat height) {
//      //调整图片
//    _item.o_coreTextHeight += (height - 114);
//  };
  [self addSubview:_weiboImageView];
  
    //记录初始frame
  _littleTriangleFrame = _littleTriangle.frame;
  _grayViewFrame = _grayView.frame;
  _coreTextViewFrame = _coreTextView.frame;
  _weiboImageViewFrame = _weiboImageView.frame;
}

#pragma mark -  根据数据刷新内容
- (void)refreshWithTweetListItem:(TweetListItem *)item
                   withTableView:(UITableView *)tableView
           cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self resetAllSubViewsFrame];
  
  _item = item;
  
  //先检测有没有内容，没有直接返回nil
  if (!item.o_content.length > 0 && !item.o_imgs.count > 0) {
    self.hidden = YES;
    return;
  } else {
    self.hidden = NO;
  }

  //先调整自身总的高度
  CGRect frame = self.frame;
  frame.size.height = [WBReplyView heightOfReplyViewWithTweetItem:item];
  self.frame = frame;

  //调整内容高度
//  NSString *userNameStr;
//  if (!item.o_uid) {
//    userNameStr = @"";
//  } else {
//    userNameStr =
//        [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/>:",
//                                   [item.o_uid stringValue], item.o_nick];
//  }
//  
//  NSString *context =
//  [NSString stringWithFormat:@"%@%@", userNameStr, (item.o_content.length > 0 ? item.o_content : @"" )];
  NSString *context =
  [NSString stringWithFormat:@"%@", (item.o_content.length > 0 ? item.o_content : @"" )];
  context = [SimuUtil stringReplaceSpace:context];
  CGFloat coreTextHeight = [FTCoreTextView heightWithText:context width:WBReplyViewWidth font:Font_Height_14_0];
  _coreTextView.text = context;
  [_coreTextView fitToSuggestedHeight];

  //调整图片高度
  CGFloat wbImageViewHeight = 0;
  if (item.o_imgs.count > 0) {
    _weiboImageView.hidden = NO;
    __weak TweetListItem *weakWeibo = item;
    NSString* imageUrl = item.o_imgs[0];
    UIImage *image = [_weiboImageView loadImageWithUrl:imageUrl onImageReadyCallback:^(UIImage *downloadImage, NSString* imageUrl) {
      if (downloadImage) {
        [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
        [tableView reloadVisibleRowWithIndexPath:indexPath];
      }
    }];
    _weiboImageView.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image) {
      item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
    }
    
    int imageWidth = image ? image.size.width / ThumbnailFactor : 114;
    wbImageViewHeight = image ? image.size.height / ThumbnailFactor : 114;
    CGRect wbImageViewFrame = _weiboImageView.frame;
    wbImageViewFrame.origin.y += (coreTextHeight + SPACE);
    wbImageViewFrame.size.width = imageWidth;
    wbImageViewFrame.size.height = wbImageViewHeight;
    _weiboImageView.frame = wbImageViewFrame;
    wbImageViewHeight += SPACE;//底部留6宽度
  } else {
    _weiboImageView.image = nil;
    _weiboImageView.imageUrl = nil;
    _weiboImageView.hidden = YES;
  }

  //调整气泡高度
  CGRect grayViewFrame = _grayView.frame;
  grayViewFrame.size.height += (coreTextHeight + wbImageViewHeight);
  _grayView.frame = grayViewFrame;
  
  //构建长方形区域
  CGRect rect = CGRectMake(1, 12, 1, 1);
  CGImageRef imageRef =
  CGImageCreateWithImageInRect(_littleTriangle.image.CGImage, rect);
  UIImage *bubleImage = [UIImage imageWithCGImage:imageRef];
  [_grayView setImage:bubleImage];
  CGImageRelease(imageRef);
}


#pragma mark - 类方法
+ (NSNumber *) imageHeight:(TweetListItem*) item{
  if (item.o_imgs.count>0 && item.o_imgs[0]) {
    if (item.heightCache[item.o_imgs[0]]) {
      return item.heightCache[item.o_imgs[0]];
    }else{
      return @114;
    }
  }else{
    return @0;
  }
}

+ (float)heightOfReplyViewWithTweetItem:(TweetListItem *)item {
  if (!item.o_content.length > 0 && !item.o_imgs.count > 0) {
    return 0;
  }
  //可变文本
  //调整内容高度
  NSString *userNameStr;
  if (!item.o_uid) {
    userNameStr = @"";
  } else {
    userNameStr =
    [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/>:",
     [item.o_uid stringValue], item.o_nick];
  }
  NSString *context =
  [NSString stringWithFormat:@"%@%@", userNameStr, (item.o_content.length > 0) ? item.o_content : @""];
  context = [SimuUtil stringReplaceSpace:context];
  float height = [FTCoreTextView heightWithText:context width:WBReplyViewWidth font:Font_Height_14_0];
  height += 18.0f;//固定上下灰边
  
  //图片高度
  if (item.o_imgs && [item.o_imgs count] > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.o_imgs[0] withWeibo:item];
    height += ([imageHeight floatValue] + SPACE);
  }
//  NSLog(@"🐍高度：%f", height);
  return height;
}

  ///重置所有frame
- (void)resetAllSubViewsFrame
{
  _littleTriangle.frame = _littleTriangleFrame;
  _grayView.frame = _grayViewFrame;
  _coreTextView.frame = _coreTextViewFrame;
  _weiboImageView.frame = _weiboImageViewFrame;
}

-(BOOL) performClickOnPoint:(CGPoint) pointInWindow{
  if (!_coreTextView) {
    return NO;
  }
  CGPoint pointInSelf = [self.window convertPoint:pointInWindow toView:self];
  if ([self pointInside:pointInSelf withEvent:nil]){
    return [_coreTextView performClickOnPoint:pointInWindow];
  }
  return NO;
}

@end
