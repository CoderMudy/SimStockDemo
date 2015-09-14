//
//  MatchSelectUniversityViewController.h
//  SimuStock
//
//  Created by Jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 比赛改版；搜索高校页面 */
#import "BaseViewController.h"
#import "PinYin4Objc.h"
#import "ExtendedTextField.h"
#import "DataArray.h"
#import "HanyuPinyinOutputFormat.h"
#import "UniversityInfoData.h"
#import "SearchNotFoundView.h"
#import "BaseTableViewController.h"

/** 点击cell的回调 */
typedef void (^OnClickUniversityName)(NSString *);

@interface UniversityTableAdapter : BaseTableAdapter

@property(nonatomic, weak) UIViewController *container;

- (id)initWithViewController:(UIViewController *)viewController;

@end

@interface MatchSelectUniversityViewController
    : BaseViewController <UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {

  /** 显示学校名字的列表 */
  UITableView *universityNameTableVC;
  /** 系统搜索栏 */
  UISearchBar *searchBar;
  /** 搜索按钮 */
  UIButton *searchButton;
  //搜索输入框
  ExtendedTextField *inputUniversityNameTF;
  /** 是否过滤 */
  BOOL isFilter;
  /** 汉语拼音框架 */
  HanyuPinyinOutputFormat *outPutFormat;
  //右侧索引
  UISearchDisplayController *searchDisplay;
  ///缓存数据
  UniversityInfoData *cacheDataItem;

  //记录tableView头里的内容
  NSArray *headArrayKeys;

  /** 高校名字 key */
  NSMutableDictionary *schoolNameDict;
  /** 根据输入内容 搜索后得到的字典 */
  NSMutableDictionary *filterDict;
  //保存转化后的拼音字典
  NSMutableDictionary *pinyinDict;

  UniversityTableAdapter *_tableAdatper;
}
/** 用户选择一个高校后，通知观察者 */
@property(copy, nonatomic) OnClickUniversityName onClickUniversityName;
/** 没有搜索到高校的小牛视图 */
@property(strong, nonatomic) SearchNotFoundView *notFoundView;

/** 高校名称首字母的数组 */
- (NSArray *)sectionKeys;

/** 高校名称"首字母-->数组" */
- (NSDictionary *)sectionDictionary;

@end
