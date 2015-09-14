#import <Foundation/Foundation.h>
@protocol tztkhVideoProcessdelegate;
@interface tztkhVideoProcess : NSObject<tztSocketDataDelegate>
{
    NSString* _strUserID;
    int     _nP2p;
    NSMutableDictionary* _userInfo;
    
    int _ntztHqReq;
    id <tztkhVideoProcessdelegate> _tztdelegate;
}
@property (nonatomic,retain) NSString* strUserID;
@property (nonatomic,retain) NSMutableDictionary* userInfo;
@property int nP2p;

@property (nonatomic,assign) id<tztkhVideoProcessdelegate> tztdelegate;
//开始视频流程 是否先判断视频流程结果
- (void)onVideoProcess:(BOOL)bCheckVideoResult;
- (void)onGetVideoID;//获取视频资源ID (视频见证申请)
- (void)onGetVideoState; //获取见证视频状态 (视频见证状态)
- (void)onVideoLeave:(int)nType; //断开见证视频
- (void)endOnlineTimer;
- (void)OnRequestVideoState;
@end

@protocol tztkhVideoProcessdelegate<NSObject>
//提示信息 信息  信息类别
- (void)setTipInfo:(NSString*)strTip type:(NSInteger)nType;
//返回错误，断开见证视频
- (void)onLeaveVideo:(NSString*)strTip;
//开始视频 视频地址 端口 视频资源ID
- (void)onStartVideo:(NSString*)strAdd port:(int)nport  videoID:(int)nVideoID;
//开始见证视频 视频资源ID
- (void)onStartCheckVideoID:(int)nCheckVideoID;
//退出视频
- (void)onHideVideo;
//视频见证结果返回 TRUE 见证流程通过  FALSE 见证流程不通过
- (void)onVideoResult:(int)nType;
//按钮控制
- (void)setHiddenBtn:(BOOL)bHidden yyType:(BOOL)bYYKF;
-(void)setWaitCount:(NSString *)strCount; //视频预约排队
-(void)setHiddenStartBtn:(int)nType;
@end
