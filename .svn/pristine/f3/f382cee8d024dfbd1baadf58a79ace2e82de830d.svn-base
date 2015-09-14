//
//  SendCattleToolTip.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCattleToolTip : UIView <UITextFieldDelegate>

typedef void (^OKBtnClickBlock)(NSString *sendNum);
typedef void (^CancleBtnClickBlock)();
typedef void (^BuyCattleBlock)();

/** 牛头的光宽度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lightImageWidth;
/** 牛头的光高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lightImageHeight;

/** 牛头的光 */
@property(weak, nonatomic) IBOutlet UIImageView *lightImageView;

/** 牛头的光是否变大 */
@property(assign, nonatomic) BOOL isChangedBig;
/** 牛头的光闪动计时器 */
@property(strong, nonatomic) NSTimer *lightTimer;

/** 拥有的徽记数量Lable */
@property(weak, nonatomic) IBOutlet UILabel *crestNumLabel;
/** 要送的徽记数量Lable */
@property(weak, nonatomic) IBOutlet UITextField *sendNumInput;

/** 取消按钮 */
@property(weak, nonatomic) IBOutlet UIButton *cancleBtn;
/** 确定按钮 */
@property(weak, nonatomic) IBOutlet UIButton *okBtn;
/** 前往购买按钮 */
@property(weak, nonatomic) IBOutlet UIButton *buyBtn;
/** 减少按钮 */
@property(weak, nonatomic) IBOutlet UIButton *reduceBtn;
/** 增加按钮 */
@property(weak, nonatomic) IBOutlet UIButton *addBtn;

/** 购买按钮响应函数 */
- (IBAction)clickOnBuyBtn:(UIButton *)sender;

/** 取消按钮响应函数 */
- (IBAction)clickOnCancleBtn:(UIButton *)sender;
/** 确认按钮响应函数 */
- (IBAction)clickOnOKBtn:(UIButton *)sender;

/** 减少按钮响应函数 */
- (IBAction)clickOnReduceBtn:(UIButton *)sender;
/** 增加按钮响应函数 */
- (IBAction)clickOnAddBtn:(UIButton *)sender;

/** 减少按钮长按手势响应函数 */
- (IBAction)longPressOnReduceBtn:(UILongPressGestureRecognizer *)sender;
/** 增加按钮长按手势响应函数 */
- (IBAction)longPressOnAddBtn:(UILongPressGestureRecognizer *)sender;

/** 长按手势定时器 */
@property(strong, nonatomic) NSTimer *touchedTimer;
/** 长按时，是否是增加赠送徽记数 */
@property(assign, nonatomic) BOOL isAdd;
/** 长按的时间 */
@property(assign, nonatomic) NSInteger touchedDuration;

/** 取消按钮回调Block */
@property(copy, nonatomic) CancleBtnClickBlock cancleBtnClickBlock;
/** 确定按钮回调Block */
@property(copy, nonatomic) OKBtnClickBlock OKBtnClickBlock;
/** 买牛成功回调Block */
@property(copy, nonatomic) BuyCattleBlock buySuccessBlock;

/**
 弹出送牛弹出框
 参数：
 ownNum：当前用户可以赠送的牛人徽记数
 sendNum：默认赠送的数量
 */
+ (void)showTipWithOwnNum:(NSInteger)ownNum
         andDefautSendNum:(NSInteger)sendNum
               andOKBlock:(OKBtnClickBlock)OKBtnClickBlock
           andCancleBlock:(CancleBtnClickBlock)cancleBtnClickBlock
       andBuySuccessBlock:(BuyCattleBlock)buySuccessBlock;

@end
