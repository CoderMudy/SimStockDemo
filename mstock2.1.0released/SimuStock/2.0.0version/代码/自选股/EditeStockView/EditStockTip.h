//
//  EditStockTip.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sureBtnClickCallBack)();
typedef void (^cancleBtnClickCallBack)();

@interface EditStockTip : UIView

/** 提示内容Label */
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UIButton *sureButton;
@property(weak, nonatomic) IBOutlet UIButton *cancelButton;

@property(copy, nonatomic) sureBtnClickCallBack sureBtnClickBlock;
@property(copy, nonatomic) cancleBtnClickCallBack cancleBtnClickBlock;


/** 取消按钮响应函数 */
- (IBAction)clickOnCancleBtn:(id)sender;
/** 确定按钮响应函数 */
- (IBAction)clickOnSureBtn:(id)sender;

+ (void)showEditStockTipWithContent:(NSString *)content
                    andSureCallBack:(sureBtnClickCallBack)sureCallBack
                  andCancleCallBack:(cancleBtnClickCallBack)cancleCallBack;

+ (void)showEditStockTipWithContent:(NSString *)content
                    andSureCallBack:(sureBtnClickCallBack)sureCallBack;

@end
