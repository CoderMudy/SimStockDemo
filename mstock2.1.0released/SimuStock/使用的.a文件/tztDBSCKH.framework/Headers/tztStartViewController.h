//
//  tztStartViewController.h
//  tztMobile_GTKH
//
//  Created by 张 小龙 on 13-11-28.
//
//

#import <UIKit/UIKit.h>
//#import "tztMutilScrollView.h"
#import "tztImageThreeView.h"
@protocol tztStartViewControllerDelegate<NSObject>
@optional
-(void)OnShowInitVC;
@end
@interface tztStartViewController : UIViewController</*tztMutilScrollViewDelegate,*/tztImageThreeViewDelegate, UIScrollViewDelegate>
{
//    tztMutilScrollView * _pMuScorll;
    id<tztStartViewControllerDelegate> _delegate;
}
@property(nonatomic,retain)/*tztMutilScrollView*/UIScrollView *pMuScorll;
@property(nonatomic, assign)id<tztStartViewControllerDelegate>     delegate;
@end
