//
//  ViewController.h
//  YouTuiSDKDemo
//
//  Created by FreeGeek on 14-10-20.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTuiSDK.h"
#import "SinaCallBack.h"
#import "RennCallBack.h"
#import "TcWbCallBack.h"
#import "QQCallBack.h"
@interface ViewController : UIViewController<MailCallBackDelegate,MessageCallBackDelegate>
{
    NSArray * titleArray;
    NSArray * imageArray;
    NSArray * pointArray;
    NSString * activityName;
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
@property (strong , nonatomic) IBOutlet UISwitch * Switch;
@property (strong , nonatomic) YouTuiSDK * YTsdk;
@property (strong , nonatomic) RennCallBack * RennCB;
@property (strong , nonatomic) SinaCallBack * SinaCB;
@property (strong , nonatomic) TcWbCallBack * TcWbCB;
@property (strong , nonatomic) QQCallBack * QQCB;
@property (strong , nonatomic) IBOutlet UILabel * pointLabel;
@property (strong , nonatomic) IBOutlet UIView * TCShareView;
@property (weak   , nonatomic) IBOutlet UIButton * cancelButton;
@property (weak   , nonatomic) IBOutlet UIButton * ShareButton;
//腾讯分享UI中的图片和文本
@property (weak   , nonatomic) IBOutlet UIImageView * TCShareImageView;
@property (weak   , nonatomic) IBOutlet UITextView * TCShareTextView;
-(void)ShowTcWbShareMessgaeUI;
@end

