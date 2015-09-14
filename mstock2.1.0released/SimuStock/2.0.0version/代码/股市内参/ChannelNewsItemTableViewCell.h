//
//  ChannelNewsItemTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsChannelList.h"
#import "StockNewsList.h"

@interface ChannelNewsItemTableViewCell : UITableViewCell
///资讯符号
@property(weak, nonatomic) IBOutlet UIButton* point;
///新闻标题
@property(weak, nonatomic) IBOutlet UILabel* newsTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsTitleTop;
///新闻时间
@property(weak, nonatomic) IBOutlet UILabel* newsTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsTimeBottom;

///数据绑定
- (void)bindNewsInChannelItem:(NewsInChannelItem*)item;

- (void)bindStockNewsData:(StockNewsData *)newsData withMark:(NSInteger)markInt;

@end
