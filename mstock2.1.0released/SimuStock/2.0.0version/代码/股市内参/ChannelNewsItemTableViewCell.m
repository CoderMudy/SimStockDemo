//
//  ChannelNewsItemTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChannelNewsItemTableViewCell.h"

#import "SimuUtil.h"

@implementation ChannelNewsItemTableViewCell

- (void)awakeFromNib {
  _point.layer.cornerRadius = 4;
  _point.clipsToBounds = YES;
}

- (void)bindStockNewsData:(StockNewsData *)newsData withMark:(NSInteger)markInt {

  NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:newsData.newsTime / 1000.0];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  if (markInt == StockNewsBull) {
    dateFormatter.dateFormat = @"yyyy-MM-dd";
  } else {
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
  }
  NSString *datatime = [dateFormatter stringFromDate:date];
  _newsTime.text = [SimuUtil changeAbsuluteTimeToRelativeTime:datatime];
  [self updateTitle:newsData.newsTitle];
}
- (void)updateTitle:(NSString *)titleStr {
  CGSize titleSize = [titleStr sizeWithFont:_newsTitle.font];
  CGSize dateSize = [_newsTime.text sizeWithFont:_newsTime.font];
  CGFloat titleWidth = WIDTH_OF_SCREEN - 46;
  CGFloat fontSize = _newsTitle.font.pointSize;
  //标题文字的长度 + 2个字符的空白 + 日期文字的长度 - 2行标题文字的长度
  CGFloat diff = titleSize.width + fontSize * 2 + dateSize.width - titleWidth * 2;
  if (diff > 0) {
    //初始化要删除文字的长度
    NSInteger deleteCharNum = ((int)floor(diff / fontSize));
    NSString *deletedString =
        [titleStr substringWithRange:NSMakeRange(titleStr.length - deleteCharNum, deleteCharNum)];
    CGSize deleteCharWidth = [deletedString sizeWithFont:_newsTitle.font];
    //检查要删除文字的长度是否符合要求，不符合，则增加一个删除字符，再次检查
    while (deleteCharWidth.width < diff) {
      deleteCharNum++;
      deletedString =
          [titleStr substringWithRange:NSMakeRange(titleStr.length - deleteCharNum, deleteCharNum)];
      deleteCharWidth = [deletedString sizeWithFont:_newsTitle.font];
    }

    titleStr = [titleStr substringWithRange:NSMakeRange(0, titleStr.length - deleteCharNum)];
    titleStr = [NSString stringWithFormat:@"%@...", titleStr];
  }
  _newsTitle.text = titleStr;
  if (titleSize.width <= titleWidth) {
    _newsTitleTop.constant = 6;
    _newsTimeBottom.constant = 0;
  } else {
    _newsTitleTop.constant = 7;
    _newsTimeBottom.constant = 5;
  }
}

- (void)bindNewsInChannelItem:(NewsInChannelItem *)item {
  _newsTime.text = [SimuUtil getDateFromCtime:@(item.publishTime)];
  [self updateTitle:item.title];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  [super setHighlighted:highlighted animated:animated];
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:Color_Gray_but];
  } else {
    self.backgroundColor = [UIColor whiteColor];
  }
}

@end
