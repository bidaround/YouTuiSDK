//
//  ViewController.m
//  YouTuiSDKDemo
//
//  Created by FreeGeek on 14-10-20.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "FreeGeekSheet.h"
#import "GiftTalkSheetView.h"
@interface ViewController ()<FreeGeekDelegate,GiftTalkSheetDelegate>
{
    UIView * BlackView;
    UITableView * table;
    NSDictionary * dataDict;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    _RennCB = [[RennCallBack alloc]init];
    _SinaCB = [[SinaCallBack alloc]init];
    _TcWbCB = [[TcWbCallBack alloc]init];
    _QQCB   = [[QQCallBack alloc]init];
    //新浪平台初始化 http://open.weibo.com/
    [YouTuiSDK connectSinaWithAppKey:SinaWBAppKey];

    //腾讯微博平台初始化 http://dev.t.qq.com/
    [_YTsdk connectTcWbWithAppKey:TCWBAppKey andSecret:TCWBAppSecret andRedirectUri:TCWBURL];
    
    //微信平台初始化  https://open.weixin.qq.com/
    [_YTsdk connectWxWithAppKey:WXAppKey WithDescription:@"youtuiShare-ios"];

    //QQ平台初始化 http://open.qq.com/
    [_YTsdk connectQQWithAppId:QQAppID Delegate:_QQCB Uri:QQURI];

    //人人网平台初始化  http://dev.renren.com/
    [_YTsdk connectRennWithAppId:RennAPPID ApiKey:RennAPIKEY SecretKey:RennSecretKey];

    defaults = [NSUserDefaults standardUserDefaults];
    //获取用户积分
    [self checkUserPoint:nil];
    
    /**
     *  这里是获取友推后台设置的分享内容,开发者根据实际情况设置参数.
     */
    NSDictionary * ShareContentDict = [[YouTuiSDK GetShareContent] objectForKey:@"object"];
    ShareTitle = [ShareContentDict objectForKey:@"shareTitle"];                 //分享标题
    ShareURL = [ShareContentDict objectForKey:@"shareLink"];                    //分享链接
    ShareMessage = [ShareContentDict objectForKey:@"shareDescription"];         //分享描述
    ShareImageURL = [ShareContentDict objectForKey:@"sharePicUrl"];             //分享图片URL
    ShareVideoURL = @"http://v.youku.com/v_show/id_XNjk4NjczMzg0.html";         //分享视频URL
    ShareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ShareImageURL]]];    //分享图片
    NSLog(@"微信是否已安装:%hhd",[YouTuiSDK WxIsAppOnstalled]);
    NSLog(@"新浪是否已安装:%hhd",[YouTuiSDK SinaIsAppInstalled]);
    NSLog(@"QQ是否已安装:%hhd",[YouTuiSDK QQisInstalled]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TcWbLogin:) name:@"TCWBAUTH" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowTcWbShareMessgaeUI) name:@"TCWBSHAREUI" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    titleArray = [[NSArray alloc]init];
    imageArray = [[NSArray alloc]init];
    pointArray = [[NSArray alloc]init];
    
    titleArray = @[@"微信",@"微信朋友圈",@"新浪微博",@"QQ",@"QQ空间",@"腾讯微博",@"人人网",@"短信",@"邮件",@"复制链接"];
    imageArray = @[@"wechatR",@"wechatf",@"sinaR",@"qqR",@"qqzone",@"tcwbR",@"rennR",@"sms",@"email",@"mark"];
}
-(void)GetYouTuiSharePoint
{
    //获取友推平台设置的分享获得积分项
    //http://youtui.mobi/activity/list ->推广管理->推广列表->修改->分享积分奖励设置
    
    if (dataDict == nil)
    {
        dataDict = [[YouTuiSDK GetPointRule] objectForKey:@"object"];
        NSLog(@"空");
    }
    
    //如果获取到活动标题,就改变展示视图的取消按钮方法...直接跳到积分商城
    activityName = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"activityName"]];
    if (dataDict == nil)
    {
        pointArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    }
    else
    {
        pointArray = @[[dataDict objectForKey:@"channel3"],   //微信分享积分
                       [dataDict objectForKey:@"channel10"],  //微信朋友圈分享积分
                       [dataDict objectForKey:@"channel0"],   //新浪微博分享积分
                       [dataDict objectForKey:@"channel5"],   //QQ分享积分
                       [dataDict objectForKey:@"channel2"],   //QQ空间分享积分
                       [dataDict objectForKey:@"channel1"],   //腾讯微博分享积分
                       [dataDict objectForKey:@"channel4"],   //人人网分享积分
                       [dataDict objectForKey:@"channel7"],   //短信分享积分
                       [dataDict objectForKey:@"channel8"],   //邮件分享积分
                       [dataDict objectForKey:@"channel9"]];  //复制链接分享积分
    }

}

#pragma mark ----------UI三样式
/**
 *  展示控件
 *
 *  @param Title                       分享控件的标题
 *  @param titleArray                  分享按钮的标题数组
 *  @param imageArray                  分享按钮的图片数组
 *  @param PointArray                  分享奖励的积分数组
 *  @param ShowRedDot                  是否展示右上角的小红点
 *  @param ActivityName                检测用户后台是否设置了推广活动  设置nil则使用默认的取消按钮
 *  @param Middle                      YES:展示居中视图    NO:展示底部视图
 *
 */
//ActionSheet样式一
-(IBAction)ActionSheetTypeFirst:(id)sender
{
    if (_Switch.on)         //开启积分奖励开关
    {
        [self GetYouTuiSharePoint];
    }
    else
    {
        pointArray = nil;
        activityName = nil;
    }
    GiftTalkSheetView * GiftTalk = [[GiftTalkSheetView alloc]initWithTitleArray:titleArray
                                                                     ImageArray:imageArray
                                                                     PointArray:pointArray
                                                                   ActivityName:activityName
                                                                       Delegate:self];
    [GiftTalk ShowInView:self.view];
}
//ActionSheet样式二
-(IBAction)ActionSheetTypeSecond:(id)sender
{
    BOOL ShowRedDot;
    if (_Switch.on)     //开启积分奖励开关
    {
        [self GetYouTuiSharePoint];
        ShowRedDot = YES;
    }
    else
    {
        pointArray = nil;
        activityName = nil;
        ShowRedDot = NO;
    }
    FreeGeekSheet * FreegeekUI = [[FreeGeekSheet alloc]initWithTitle:@"分享到"
                                                            Delegate:self
                                                          titleArray:titleArray
                                                          imageArray:imageArray
                                                          PointArray:pointArray
                                                          ShowRedDot:ShowRedDot
                                                        ActivityName:activityName
                                                              Middle:NO];
    [FreegeekUI ShowInView:self.view];
    
}
//ActionSheet样式三
-(IBAction)ActionSheetTypeThird:(id)sender
{
    BOOL ShowRedDot;
    if (_Switch.on)
    {
        ShowRedDot = YES;
        [self GetYouTuiSharePoint];
    }
    else
    {
        pointArray = nil;
        activityName = nil;
    }
    FreeGeekSheet * FreegeekUI = [[FreeGeekSheet alloc]initWithTitle:@"分享到"
                                                            Delegate:self
                                                          titleArray:titleArray
                                                          imageArray:imageArray
                                                          PointArray:pointArray
                                                          ShowRedDot:ShowRedDot
                                                        ActivityName:activityName
                                                              Middle:YES];
    [FreegeekUI ShowInView:self.view];
}

-(void)GiftTalkShareButtonAction:(NSInteger *)buttonIndex
{
    [self ShareButtonAction:buttonIndex];
}

/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
-(void)GiftTalkGoToPointStore
{
    [self goToPointStoreAction];
}
-(void)FreeGeekgoToPointStore
{
    [self goToPointStoreAction];
}


#pragma mark ----------分享UI按钮----------
//点击分享界面按钮执行的各个平台的分享方法
-(void)ShareButtonAction:(NSInteger *)buttonIndex
{
    switch ((int)buttonIndex)
    {
        case 0:
        {
            //微信分享
            [self WxShare];
        }
            break;
        case 1:
        {
            //微信朋友圈分享
            [self WxFriendShare];
        }
            break;
        case 2:
        {
            //新浪微博
            [self SinaShare];
        }
            break;
        case 3:
        {
            //QQ分享
            [self QQShare];
        }
            break;
        case 4:
        {
            //QQ空间分享
            [self QQZoneShare];
        }
            break;
        case 5:
        {
            //腾讯微博分享
            [self TcWbShare];
        }
            break;
        case 6:
        {
            //人人网分享
            [self RennShare];
        }
            break;
        case 7:
        {
            //短信分享
            [self MessageShare];
        }
            break;
        case 8:
        {
            //邮件分享
            [self EmailShare];
        }
            break;
        case 9:
        {
            //复制链接
            [YouTuiSDK CopyLinkWithLink:@"https://open.weixin.qq.com/cgi-bin/frame?t=resource/res_main_tmpl&verify=1&lang=zh_CN&target=res/app_download_ios"];
            [self ShowAlertTitle:nil andMessage:@"复制链接成功"];
        }
            break;

    }
}
-(void)TapAction
{
    [_TCShareTextView resignFirstResponder];
}

-(void)CancelShare
{
    [BlackView removeFromSuperview];
    [_TCShareView removeFromSuperview];
}

-(void)ShowAlertTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
}

#pragma mark ----------第三方授权

-(IBAction)WxLogin:(id)sender
{
    /**
     *  微信第三方授权登陆
     *  State:  第三方程序本身用来标识其请求的唯一性
     */
    [YouTuiSDK WxLoginWithState:@"123"];
}

//QQ第三方登陆
-(IBAction)QQLogin:(id)sender
{
    /**
     *  QQ授权登陆
     *  AppId               QQ开放平台申请的AppId
     *  PermissionsArray    授权信息列数组
     */
    [_QQCB.YTsdk QQAuthorizeAppId:QQAppID Delegate:_QQCB];
}
//QQ登出
-(IBAction)QQLogout:(id)sender
{
    [YouTuiSDK QQLogoutDeleaget:self];
}
//腾讯微博第三方登陆
-(IBAction)TcWbLogin:(id)sender
{
    [_TcWbCB.YTsdk TcWbLoginWithDelegate:_TcWbCB andRootController:self];
}
//腾讯微博登出
-(IBAction)TcWbLogout:(id)sender
{
    [_TcWbCB.YTsdk TcWbOnLogout];
}
//新浪微博第三方授权登陆
-(IBAction)SinaLogin:(id)sender
{
    /**
     *  授权回调URI
     */
    [_YTsdk SinaWbLogin:SinaWBURI];
}
//新浪微博登出
-(IBAction)SinaLogout:(id)sender
{
    [_YTsdk SinaWbLogoutWithToken:_SinaCB.TokenStr Delegate:_SinaCB WithTag:@"user"];
}
//人人网第三方登陆
-(IBAction)RennLogin:(id)sender
{
    [_YTsdk RennLoginWithDelegate:_RennCB];
}
//人人网登出
-(IBAction)RennLogout:(id)sender
{
    [_YTsdk RennLogoutWithDelegate:_RennCB];
}



#pragma mark ----------短信代理回调----------
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString * StateMsg = [[NSString alloc]init];
    switch (result)
    {
        case MessageComposeResultSent:
        {
            StateMsg = @"短信发送成功";
            /**
             *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
             */
            [YouTuiSDK SharePointisShare:YES];
        }
            break;
        case MessageComposeResultCancelled:
        {
            StateMsg = @"短信取消发送";
        }
            break;
        case MessageComposeResultFailed:
        {
            StateMsg = @"短信发送失败";
        }
            break;
            
        default:
            break;
    }
    [self ShowAlertTitle:@"提示" andMessage:StateMsg];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------邮件代理回调----------
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString * stateMsg = [[NSString alloc]init];
    switch (result)
    {
        case MFMailComposeResultSent:
        {
          stateMsg = @"邮件发送成功";
            /**
             *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
             */
            [YouTuiSDK SharePointisShare:YES];
        }
            break;
        case MFMailComposeResultCancelled:
        {
            stateMsg = @"邮件取消发送";
        }
            break;
        case MFMailComposeResultSaved:
        {
            stateMsg = @"邮件已被保存";
        }
            break;
        case MFMailComposeResultFailed:
        {
            stateMsg = @"邮件发送失败";
        }
        default:
            break;
    }
    [self ShowAlertTitle:@"提示" andMessage:stateMsg];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------友推积分系统----------
//刷新积分
-(IBAction)checkUserPoint:(id)sender
{
    /**
     *  获取当前用户积分数
     *  AppUserId   开发者自行设置的用户id
     */
    NSDictionary * dict = [[_YTsdk addUserPointAppUserId:AppUserID] JSONValue];
    _pointLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"object"]];
    [self viewDidAppear:YES];
}

//积分明细
-(IBAction)PointDetail:(id)sender
{
    /**
     *  获取当前用户的积分明细
     *  AppUserId   开发者自行设置的用户id
     */
   NSString * message = [_YTsdk checkUserPointAppUserId:AppUserID];
   [self ShowAlertTitle:@"积分明细" andMessage:message];
}

//领取自定义积分
-(IBAction)AddCustomPoint:(id)sender
{
    /**
     *  获取自定义积分
     *  CustomPoint   友推后台设置的自定义积分奖励
     */
    NSString * message = [_YTsdk CustomPoint:@"发帖子"];
    [self ShowAlertTitle:@"领取自定义积分" andMessage:message];
}
//领取签到积分
-(IBAction)GetLoginPoint:(id)sender
{
    /**
     *  领取签到积分
     */
    NSString * message = [_YTsdk GetloginPoint];
    [self ShowAlertTitle:nil andMessage:message];
}

-(IBAction)PointStore:(id)sender
{
    [self goToPointStoreAction];
}
/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
-(void)goToPointStoreAction
{
    PointStoreWebview = [[UIWebView alloc]init];
    PointStoreWebview.backgroundColor = [UIColor grayColor];
    PointStoreWebview.frame = CGRectMake(0,20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20);
    
    //UIWebView加载积分商城的NSURLRequest
    [PointStoreWebview loadRequest:[YouTuiSDK getPointStoreRequest]];
    [self.view addSubview:PointStoreWebview];
    deleteViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteViewButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    deleteViewButton.frame = CGRectMake(PointStoreWebview.frame.size.width - 30,0, 30, 30);
    [deleteViewButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [PointStoreWebview addSubview:deleteViewButton];
}

//赠送积分  ---扣除本用户积分,增加受赠用户积分
-(IBAction)GivePoint:(id)sender
{
    /**
     *  赠送积分
     *  GetPoint    赠送积分数
     *  AppUserId   开发者自行设置的受赠用户AppUserId
     */
   NSString * message = [_YTsdk GetPoint:@"5" appUserId:@"11111"];
    [self ShowAlertTitle:nil andMessage:message];
}

//扣除积分
-(IBAction)deletePoint:(id)sender
{
    /**
     *  扣除指定用户积分
     *  AppUserId       受扣除积分用户AppUserId
     *  reducePoint     扣除的积分数
     *  reason          扣除积分的理由
     */
    NSString * message = [_YTsdk reduceUserPointAppUserId:AppUserID reducePoint:@"5" reason:@"扣你积分不带理由"];
    [self ShowAlertTitle:nil andMessage:message];
}

-(void)buttonAction
{
    [PointStoreWebview removeFromSuperview];
    PointStoreWebview = nil;
    [deleteViewButton removeFromSuperview];
    deleteViewButton = nil;
}

#pragma mark 各平台分享方法
//微信分享
-(void)WxShare
{
    [_YTsdk WxShareMusicTitle:@"Back at One"
                  Description:@"Brian McKnight"
                        Image:[UIImage imageNamed:@"musicImage"]
                     MusicUrl:@"http://y.qq.com/#type=song&mid=001qrEDN17Wthk&from=smartbox"
                 MusicDataUrl:@"http://stream20.qqmusic.qq.com/325090.mp3"
                         Type:0];

}

//微信朋友圈分享
-(void)WxFriendShare
{
    [_YTsdk WxShareVideoTitle:ShareMessage
                  Description:ShareTitle
                        image:ShareImage
                     VideoUrl:ShareVideoURL
                         Type:1];
}

//新浪微博分享
-(void)SinaShare
{
    [YouTuiSDK SinaWbShareMessage:ShareMessage
                            Image:ShareImage
                              Url:ShareURL];
}

//QQ分享
-(void)QQShare
{
    [_YTsdk QQShareAudioTitle:ShareTitle
                  Description:ShareMessage
                     ImageUrl:ShareImageURL
                          Url:ShareURL
                     MusicURL:@"http://stream20.qqmusic.qq.com/325090.mp3"
                         Type:0];
}

//QQ空间分享
-(void)QQZoneShare
{
    [_YTsdk QQShareAudioTitle:ShareTitle
                  Description:ShareMessage
                        Image:ShareImage
                          Url:ShareURL
                     MusicURL:@"http://stream20.qqmusic.qq.com/325090.mp3"
                         Type:1];

}

//腾讯微博分享
-(void)TcWbShare
{
    //判断回调是否为授权的回调
    [_YTsdk checkAuthValidDelegate:_TcWbCB];
}

-(void)ShareMessage
{
    [_YTsdk TcWbShareMessage:_TCShareTextView.text
                 andImageUrl:ShareImageURL
                    VideoUrl:ShareVideoURL
                   Longitude:@"113.414125"
                    Latitude:@"23.063642"
                    MusicUrl:@"http://stream20.qqmusic.qq.com/325090.mp3"
                  MusicTitle:@"Back at One"
                 MusicAuthor:@"Brian McKnight"
                    delegate:_TcWbCB];
    
    [_TCShareView removeFromSuperview];
    [BlackView removeFromSuperview];
}

//人人网分享
-(void)RennShare
{
    //存储KEY值来判断回调是否为授权的回调
    [defaults setObject:@"NO" forKey:RENNAUTH];
    [_YTsdk RennShareVideoTitle:ShareTitle
                    Description:ShareMessage
                       VideoUrl:ShareVideoURL
                      ThumbData:ShareImage
                  MessageTarget:To_Renren];
    
//    //有分享回调---分享前确定人人网已经授权成功
//                [_YTsdk RennBaseShareComment:ShareMessage
//                                         Url:ShareVideoURL
//                                    Delegate:_RennCB];

}

//短信分享
-(void)MessageShare
{
    [_YTsdk ShareToMsg:[ShareMessage stringByAppendingString:ShareURL]
       ReceivePhoneNum:@""
                 Image:ShareImage     //分享图片的话必须设置这三个参数,FileName可以为任意的名字.png
        TypeIdentifier:@"image/png"
              FileName:@"0525.png"
        ViewController:self];
}

//邮件分享
-(void)EmailShare
{
    [_YTsdk ShareToMail:ShareTitle
            MessageBody:[ShareMessage stringByAppendingString:ShareURL]
                  Image:ShareImage
          ImageFileName:@"0525.png"     //附件名称
                  SetCc:@""
                  SetTo:@""
         ViewController:self];
}

-(void)ShowTcWbShareMessgaeUI
{
//    在window上加层黑色半透明View
    BlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    BlackView.backgroundColor = [UIColor colorWithRed:0/255.00f green:0/255.00f blue:0/255.00f alpha:0.5];
    [self.view.window addSubview:BlackView];
    
    //腾讯微博分享的界面
    _TCShareView = [[[NSBundle mainBundle] loadNibNamed:@"ViewController" owner:self options:nil] objectAtIndex:0];
    _TCShareView.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height - 230) / 2, [UIScreen mainScreen].bounds.size.width - 40,[UIScreen mainScreen].bounds.size.width * 0.6);
    [self.view.window addSubview:BlackView];
    _TCShareView.layer.cornerRadius = 5;
    _cancelButton.layer.cornerRadius = 5;
    _ShareButton.layer.cornerRadius = 5;
    _TCShareImageView.layer.cornerRadius = 5;
    _TCShareTextView.layer.cornerRadius = 5;
    _TCShareImageView.image = ShareImage;
    _TCShareTextView.text = ShareMessage;
    [_cancelButton addTarget:self action:@selector(CancelShare) forControlEvents:UIControlEventTouchUpInside];
    [_ShareButton addTarget:self action:@selector(ShareMessage) forControlEvents:UIControlEventTouchUpInside];
    [BlackView addSubview:_TCShareView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction)];
    [BlackView addGestureRecognizer:tap];

}
-(void)cancelButtonAction
{
    [BlackView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        table.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width);
    } completion:^(BOOL finished) {
        [table removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
