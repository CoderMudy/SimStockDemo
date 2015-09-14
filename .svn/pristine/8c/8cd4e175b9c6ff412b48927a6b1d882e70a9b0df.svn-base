//
//  WBImageView.m
//  SimuStock
//
//  Created by jhss on 14-12-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBImageView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation WBImageView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self doInit];
  }
  return self;
}

- (void)awakeFromNib {
  [self doInit];
}

- (void)doInit {
  self.userInteractionEnabled = YES;
  self.clipsToBounds = YES;
  self.hidden = NO;
  self.contentMode = UIViewContentModeScaleAspectFit;
  UITapGestureRecognizer *a =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(BtnClick:)];
  [self addGestureRecognizer:a];
}

- (UIImage *)loadImageWithUrl:(NSString *)imageUrl
         onImageReadyCallback:(OnDownloadImageFinished)onImageReadyCallback {
  //发表时的假数据是本地的image
  if (imageUrl && [imageUrl isKindOfClass:[UIImage class]]) {
    self.hidden = NO;
    self.image = (UIImage *)imageUrl;
    self.userInteractionEnabled = NO;
    return (UIImage *)imageUrl;
  }

  if (!imageUrl || imageUrl.length == 0) {
    self.hidden = YES;
    return nil;
  }

  self.imageUrl = imageUrl;
  self.hidden = NO;
  NSLog(@"load image: %@", imageUrl);
  return [ImageUtil loadImageFromUrl:imageUrl
                 withOnReadyCallback:onImageReadyCallback];
}

- (void)BtnClick:(UITapGestureRecognizer *)imageTap {
  // 1.封装图片数据
  // 替换为中等尺寸图片(可以显示一组图片)
  NSMutableArray *photos = [[NSMutableArray alloc] init];
  MJPhoto *photo = [[MJPhoto alloc] init];
  if ([self.imageUrl rangeOfString:@"_crop"].length > 0) {
    NSArray *array = [_imageUrl componentsSeparatedByString:@"_crop"];
    self.imageUrl = [NSString stringWithFormat:@"%@%@", array[0],
                                               array[1]];
  }
  photo.url = [NSURL URLWithString:self.imageUrl];
  photo.srcImageView = self;
  [photos addObject:photo];
  // 2.显示相册
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.photos = photos;
  [browser show];
}


@end
