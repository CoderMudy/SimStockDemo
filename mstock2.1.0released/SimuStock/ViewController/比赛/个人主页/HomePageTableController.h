//
//  HomePageTableController.h
//  SimuStock
//
//  Created by Mac on 15/2/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataArray.h"
#import "HomePageTableViewCell.h"
#import "BaseViewController.h"

typedef void (^deleteOneCellBlock)();

@protocol HomePageTableControllerProtocol <NSObject>
///动画回调，（scrollViewDidScroll:）
- (void)homescrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface HomePageTableController
    : NSObject <UITableViewDataSource, UITableViewDelegate,
                HomePageTableViewCellDelegate>
@property(nonatomic, weak)
    id<HomePageTableControllerProtocol> scollViewdelegate;

///表格视图用于显示盈利信息
@property(nonatomic, weak) UITableView *tableView;

///聊股数据
@property(nonatomic, weak) DataArray *dataArray;

@property(nonatomic, weak) UIViewController *viewController;

@property(nonatomic, weak) UIView *clientView;

//聊股内容部分(目前仅用于区别收藏与其它)
/** 聊股类型
 1：原创
 2：转发
 3：评论
 4：回复
 6：赞
 7：收藏
 8：分享
 9：关注
 10：交易
 13：系统通知 */
@property(nonatomic) NSInteger type;

/// 删除聊股后的回调
@property(copy, nonatomic) deleteOneCellBlock deleteOneCellCallBack;

- (id)initWithTable:(UITableView *)tableView
      withDataArray:(DataArray *)dataArray
 withViewController:(UIViewController *)viewController
     withClientView:(UIView *)clientView;
@end
