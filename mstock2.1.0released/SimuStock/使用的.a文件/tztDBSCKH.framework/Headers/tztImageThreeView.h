//
//  tztImageThreeView.h
//  tztMobile_GTKH
//
//  Created by 张 小龙 on 13-11-28.
//
//

#import <UIKit/UIKit.h>
@protocol tztImageThreeViewDelegate<NSObject>
@optional
-(void)OnShowInitVC;
@end
@interface tztImageThreeView : UIView
{
    id<tztImageThreeViewDelegate> _delegate;
}
@property(nonatomic, assign)id<tztImageThreeViewDelegate>     delegate;
@end
