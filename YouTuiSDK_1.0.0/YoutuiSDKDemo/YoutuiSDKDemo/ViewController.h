//
//  ViewController.h
//  YouTuiSDKDemo
//
//  Created by FreeGeek on 14-10-20.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTuiSDK.h"
#import "Header.h"
@interface ViewController : UIViewController<TcWbAuthDelegate,TcWbRequestDelegate,       //腾讯微博代理
                                            RenRenLoginDelegate,RenRenServiveDelegate,   //人人网代理
                                            QQAuthDelegate,WxandQQDelegate,              //QQ和微信代理
                                            MailCallBackDelegate,                        //邮件代理
                                            MessageCallBackDelegate>                     //短信代理
{
    NSArray * titleArray;
    NSArray * imageArray;
    NSArray * pointArray;
    NSString * activityName;
    BOOL  isTcWbAuth;
    NSUserDefaults * defaults;
    UIWebView * PointStoreWebview;
    UIButton * deleteViewButton;
    
    NSString * ShareMessage;
    NSString * ShareURL;
    NSString * ShareVideoURL;
    NSString * ShareImageURL;
    NSString * ShareTitle;
    UIImage * ShareImage;
}
@property (nonatomic , strong) YouTuiSDK * YTsdk;
@property (nonatomic , strong) IBOutlet UILabel * pointLabel;
@property (strong , nonatomic) IBOutlet UIView * TCShareView;
@property (weak , nonatomic) IBOutlet UIButton * cancelButton;
@property (weak , nonatomic) IBOutlet UIButton * ShareButton;
//腾讯分享UI中的图片和文本
@property (weak ,nonatomic) IBOutlet UIImageView * TCShareImageView;
@property (weak , nonatomic) IBOutlet UITextView * TCShareTextView;

@end

