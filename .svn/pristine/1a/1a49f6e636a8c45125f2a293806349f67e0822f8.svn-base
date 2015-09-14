//
//  WeiBoMyContactsVC.h
//  SimuStock
//
//  Created by jhss on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "PinYin4Objc.h"
#import "ExtendedTextField.h"

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#define ALPHA_ARRAY                                                            \
  @[                                                                           \
    @"A",                                                                      \
    @"B",                                                                      \
    @"C",                                                                      \
    @"D",                                                                      \
    @"E",                                                                      \
    @"F",                                                                      \
    @"G",                                                                      \
    @"H",                                                                      \
    @"I",                                                                      \
    @"J",                                                                      \
    @"K",                                                                      \
    @"L",                                                                      \
    @"M",                                                                      \
    @"N",                                                                      \
    @"O",                                                                      \
    @"P",                                                                      \
    @"Q",                                                                      \
    @"R",                                                                      \
    @"S",                                                                      \
    @"T",                                                                      \
    @"U",                                                                      \
    @"V",                                                                      \
    @"W",                                                                      \
    @"X",                                                                      \
    @"Y",                                                                      \
    @"Z"                                                                       \
  ]

/**
 点击按钮的回调函数
 */
typedef void (^OnContactsSelected)(NSString *userId, NSString *userNickname);
/**  */
@interface WeiBoMyContactsVC
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          UITextFieldDelegate, UISearchDisplayDelegate,
                          UISearchBarDelegate> {
  /** 联系人列表 */
  UITableView *WBMyContactsTableView;
  /** 联系人 */
  NSArray *WBMyContactsArray;
  /** 联系人姓名key */
  NSMutableDictionary *nameDict;
  NSMutableDictionary *filterDict;
  NSMutableDictionary *pinyinDict;
  /** 联系人输入栏 */
  ExtendedTextField *inputContactTF;
  /** 系统搜索栏 */
  UISearchBar *searchBar;
  /** 侧栏索引 */
  UISearchDisplayController *searchDisplay;
  /** 搜索按钮 */
  UIButton *searchButton;
  /** 是否过滤过 */
  BOOL isFilter;
  /** 索引字母 */
  UILabel *charLabel;
  /** 最近联系人 */
  NSString *recentContacts;
  /** 最近联系人列表 */
  UITableView *recentContactTableview;
  /** 最近联系人 */
  NSMutableArray *recentContactArr;
  /** block回调 */
  OnContactsSelected onContactsSelectedCallback;
  /** 汉语拼音框架 */
  HanyuPinyinOutputFormat *outputFormat;
  /** 防止重复点击cell */
  BOOL isClicking;
}

/** 联系人切换 */
//- (id)initWithCallBack:(OnContactsSelected)callback;
/** 联系人数据 */
//- (void)getAttentionData;
- (void)FriendsWithCallBack:(OnContactsSelected)callback;
@end
