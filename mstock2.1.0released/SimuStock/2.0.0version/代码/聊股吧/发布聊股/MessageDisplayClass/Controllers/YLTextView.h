//
//  YLTextView.h
//  MessageDisplay
//
//  Created by Mac on 14/12/16.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBMessageTextView.h"
#import "YLDistributObject.h"
#import "YLTextField.h"
@protocol YLTextViewDelegate <NSObject>

@required

@optional

/**
 *  当前文本内容的length，随时检测 YLTextViewDidChange
 *
 *  @param Text_contentView 输入框对象
 */
- (void)YLTextViewDidChange:(NSInteger)length;

/**
 *  点击空白，让text_contentView 获取键盘，代理让自定义键盘
 *
 *  @param Text_contentView 输入框对象
 */
- (void)ModifyKeyboardState;

/// Title_textField 获得第一相应的，回调
- (void)TitletextFieldBecomeFirstResponderAPI;

@end

typedef enum {
  YLDisVCTextView,   //发布聊股
  YLReplyVCTextView, //发表评论
  YLReviewTextView,  //发表回复
  YLSepcilNone       //@对象@个股，不做数据保存
} YLTypeTextView;

@interface YLTextView : UIScrollView <UITextViewDelegate, UITextFieldDelegate, YLTextFieldDelegate> {
  ///添加标题
  UIButton *titleBtn;
}
@property(nonatomic, weak) id<YLTextViewDelegate> YL_delegate;

@property(nonatomic, strong) UIView *Title_View;

@property(nonatomic, strong) NSString *userNickName;
@property(nonatomic, strong) NSString *userID;
///发送聊股,的标题
@property(nonatomic, strong) YLTextField *Title_textField;
///发送聊股,的具体文本内容
@property(nonatomic, strong) ZBMessageTextView *Text_contentView;
///输入文本字数的限制，0为不做限制
@property(nonatomic) int Max_textView;

@property(nonatomic, retain) YLDistributObject *yl_Object;
/////低层图片
//@property(nonatomic, strong) UIView *D_View;
///发送聊股,时分享的图片
@property(nonatomic, strong) UIImageView *Share_imageView;

///比赛标题
@property(nonatomic, strong) NSString *matchContent;
///@和$字符的来源 yes(用户键盘打上去的),no(自动生成)
@property(nonatomic) BOOL strSource;

/// 是否需要标题输入框
- (id)initWithFrame:(CGRect)frame andTitle:(BOOL)is_have andType:(YLTypeTextView)type;

/// 是否需要标题输入框  是否进入就有文本
- (id)initWithFrame:(CGRect)frame
           andTitle:(BOOL)is_have
         andContent:(NSString *)content
            andType:(YLTypeTextView)type;

/// 是否需要标题输入框  是否进入就有文本
- (id)initWithFrame:(CGRect)frame
           andTitle:(BOOL)is_have
         andContent:(NSString *)content
        andNickName:(NSString *)nick
          andUserid:(NSString *)userid;
#pragma mark 获取xml格式的字符串，用于发布给后台
/// 获取xml格式的字符串，用于发布给后台
- (NSString *)getXMLfromstring:(NSString *)string;

/// 正则表达，筛选，改变颜色
- (NSMutableAttributedString *)getAttributedString:(NSString *)string;

/// 当用户输入$,跳转到股票查询页面
- (void)showSearchStockPage;
///跳转用户联系人界面
- (void)showUserFriends;
///调整uitextview 高度
- (void)Adjust_Height;

///算剩余的字数
- (void)Remaining;
@end
