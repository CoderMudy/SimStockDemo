#ifndef __tztkhWebView_H__
#define __tztkhWebView_H__

#import "tztkhInfosec.h"
@class tztkhWebView;

@interface tztkhInfoViewController : tztkhBaseUIViewController
{
      tztkhWebView* _webView;
}
- (void)onSetWebViewUrl:(NSString*)strUrl;
@end

@interface tztkhWebView : tztHTTPWebView<UINavigationControllerDelegate,UIImagePickerControllerDelegate,tztkhcertdelegate>
{
    NSString * _strTrueURL; //成功继续URL
    NSString * _strFalseURL;//失败返回URL
    NSString * _strTrueJSFunc;//成功调用JSFunc
    NSString * _strFalseJSFunc;//失败调用JSFunc
    //拍照
    UIImagePickerController *currentPickerController;
}

@property(nonatomic, retain)UIView* pBgView;
@property(nonatomic, retain)UILabel* pBgLabel;
@property(assign, nonatomic)UIActivityIndicatorView* loaderView;
@property (nonatomic,retain)NSString * strTrueURL;
@property (nonatomic,retain)NSString * strFalseURL;
@property (nonatomic,retain)NSString * strTrueJSFunc;
@property (nonatomic,retain)NSString * strFalseJSFunc;

- (void)tztSetNextUrl:(BOOL)bsucess;
- (void)tztSetWebViewUrl:(NSString*)strUrl;
//处理webmsg
-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

-(void)ShowIndicator:(int)show ShowText:(NSString *)text webView:(UIWebView*)webView;

@end
#endif


