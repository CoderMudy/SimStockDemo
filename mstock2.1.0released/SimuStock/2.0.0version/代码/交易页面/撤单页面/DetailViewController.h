//
//  ViewController.h
//  NewTableViewDemo
//
//  Created by 杜甲 on 14-1-11.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWMultiColumnTableView.h"
#import "Globle.h"
#import "BaseViewController.h"
@interface DetailViewController : BaseViewController<EWMultiColumnTableViewDataSource>
{
    //内容的数组
    NSMutableArray* data;
    NSMutableArray* sectionHeaderData;
    
    CGFloat colWidth;        //数据区每列的宽度
    CGFloat rightColWidth;//右侧表的列宽
    NSInteger numberOfSections; //数据有几个分区
    
    NSInteger numberOfColumns;  //数据的列数
    EWMultiColumnTableView* tbView;  //表格视图
    
}
/** 表示符 */
@property(copy, nonatomic) NSString *viewIndentifier;
/** 加个初始化方法 */
-(id)initWithIdentifier:(NSString *)indentifier;
@end
