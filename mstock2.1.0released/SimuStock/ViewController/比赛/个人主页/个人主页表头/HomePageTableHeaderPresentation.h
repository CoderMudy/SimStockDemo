//
//  HomePageTableHeaderPresentation.h
//  SimuStock
//
//  Created by Jhss on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageTableHeaderView.h"
#import "HomePageTableHeaderData.h"

@interface HomePageTableHeaderPresentation : NSObject
/** 表格头部 */
@property(strong, nonatomic) HomePageTableHeaderView *tableHeaderView;
/** 头部数据 */
@property(strong, nonatomic) HomePageTableHeaderData *tableHeaderData;

- (id)initWithTableHeaderView:(HomePageTableHeaderView *)tableHeaderView
          withTableHeaderData:(HomePageTableHeaderData *)tableHeaderData;

/** 返回表头的高度 */
- (CGFloat)returnTheHeaderHeight;
/** 隐藏或显示子Views，子类必须实现此方法 */
- (void)resetTableHeaderViews;

//刷新 数据
- (void)refreshTableHeaderInfoData:
    (HomePageTableHeaderData *)refreshTableHeaderData;

- (void)removeAllViews;

@end

/** 如果是用户自己的主页则没有（2）按钮视图 */
@interface HomePageUserPersonalView : HomePageTableHeaderPresentation

@end

/** 如果是他人的主页现实的视图 **/
@interface HomePageUserOthersView : HomePageTableHeaderPresentation

@end
