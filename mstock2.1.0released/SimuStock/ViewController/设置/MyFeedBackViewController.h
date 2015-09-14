//
//  MyFeedBackViewController.h
//  Settings
//
//  Created by jhss on 13-9-10.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "Warning_boxes.h"
#import "NewShowLabel.h"
#import "DataArray.h"
#import "UIPlaceHolderTextView.h"

@interface PaddingUITextField : UITextField

@end

@interface MyFeedBackViewController
    : BaseViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate> {
  /**
   *  反馈信息输入框
   */
  UIPlaceHolderTextView *tvFeedback;

  /**
   *  反馈信息字数倒数器
   */
  UILabel *lblWordCountDown;

  /**
   *  联系方式
   */
  UITextField *tfContactWay;

  BOOL mpvc_adjust;
  CGRect viewRect;
}

@property(strong, nonatomic) UITableView *feedbackTableView;
@property(strong, nonatomic) DataArray *dataArray;
@property(strong, nonatomic) NSMutableArray *visibleArray;
@end
