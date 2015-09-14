#import <UIKit/UIKit.h>
#import "tztkhVideoProcess.h"

@interface tztkhVideoViewController : tztkhBaseUIViewController<videoObjectDelegate,recordvideoObjectDelegate,tztkhVideoProcessdelegate>
{
    NSString* _strUserID;
    NSMutableDictionary* _userInfo;
    BOOL _bFirstState; //先判断视频状态
}
@property (nonatomic,retain) NSString* strUserID;
@property (nonatomic,retain) NSMutableDictionary* userInfo;
@property BOOL bFirstState;
- (void)endSendRequest;
@end
