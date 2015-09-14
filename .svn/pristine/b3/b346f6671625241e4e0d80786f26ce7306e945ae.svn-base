//
//  tztBaseUIViewController.h
//  tztphonekh
//
//  Created by yangares on 14-1-10.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztkhTitleView.h"

@interface tztkhBaseUIViewController : UIViewController <tztkhTitleViewdelegate,UIPopoverControllerDelegate>
{
     tztkhTitleView* _tztkhTitleView;
     id _tztdelegate;
     UIPopoverController *_popoverVC;
}
@property(nonatomic)BOOL    bRunByURL;
@property (nonatomic, retain) tztkhTitleView *tztkhTitleView;
@property (nonatomic, retain) UIPopoverController *popoverVC;
@property (nonatomic,retain) id  tztdelegate;
- (void)tztinitsubview;
-(void)PopViewControllerDismiss;
-(void) PopViewController:(UIViewController*)pVC rect:(CGRect)rect;
@end