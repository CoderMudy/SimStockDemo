//
//  realTradeComboxView.h
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Commbox
    : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
  UITableView *tv;            //下拉列表
  NSMutableArray *tableArray; //下拉列表数据
  UITextField *textField;     //文本输入框
  BOOL showList;              //是否弹出下拉列表
  CGFloat tabheight;          // table下拉列表的高度
  CGFloat frameHeight;        // frame的高度
  UIImageView *imageView;
}

@property(nonatomic, strong) UITableView *tv;
@property(nonatomic, strong) NSArray *tableArray;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, copy) void (^comboxTouch)(Commbox *touchCombox);
@property(nonatomic, copy) void (^selectedCallBack)(NSInteger selindex);

- (void)reset:(NSArray *)array;
- (void)visibleShow;

@end
