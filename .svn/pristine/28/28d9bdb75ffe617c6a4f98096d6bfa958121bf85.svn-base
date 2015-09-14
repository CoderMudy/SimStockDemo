//
//  WFSearchBankViewController.h
//  SimuStock
//
//  Created by moulin wang on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

#import "PinYin4Objc.h"
#import "ExtendedTextField.h"
#import "DataArray.h"

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

/** 点击按钮的回调函数 */
typedef void (^OnCellSelected)(NSString *bankName,int bankID);
/**
 *  遵守几个 tableview  搜索条 索引条
 *
 */
@interface WFSearchBankViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          UITextFieldDelegate, UISearchBarDelegate,
                          UISearchDisplayDelegate> {
  /** 展示银行列表的tableview */
  UITableView *bankInfoTabelView;
  /** 所有银行数组 */
  DataArray *bankInfoArray;
  /** 银行key */
  NSMutableDictionary *bankNameDict;

  /** 根据输入内容 搜索后得到的字典 */
  NSMutableDictionary *filterDict;
  //保存转化后的拼音字典
  NSMutableDictionary *pinyinDict;

  /** 输入搜索银行的输入框 */
  ExtendedTextField *inputConteactBankTF;
  /** 系统搜索栏 */
  UISearchBar *searchBar;
  /** 侧栏搜索栏 */
  UISearchDisplayController *searchDisplay;

  /** 搜索按钮 */
  UIButton *searchButton;

  /** 是否过滤 */
  BOOL isFilter;

  /** 索引字母 */
  UILabel *charLable;

  /** block回调 */
  OnCellSelected onContactsSelechedBankCallback;

  /** 汉语拼音框架 */
  HanyuPinyinOutputFormat *outPutFormat;

  /** 防止Cell重复点击 */
  BOOL isClicking;

  //记录当前界面第一个组
  NSInteger currentSection;
}
//带有block的方法 回调用的
- (void)bankWithCallback:(OnCellSelected)callback;

@end
