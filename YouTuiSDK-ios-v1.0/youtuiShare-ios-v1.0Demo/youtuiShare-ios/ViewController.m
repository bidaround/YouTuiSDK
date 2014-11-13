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
#import "RennCallBack.h"
@interface ViewController ()<FreeGeekDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView * BlackView;
    UITableView * table;
    RennCallBack * RennCB;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    RennCB = [[RennCallBack alloc]init];
    //新浪平台初始化 http://open.weibo.com/
    [YouTuiSDK connectSinaWithAppKey:SinaWBAppKey];

    //腾讯微博平台初始化 http://dev.t.qq.com/
    [_YTsdk connectTcWbWithAppKey:TCWBAppKey andSecret:TCWBAppSecret andRedirectUri:TCWBURL];
    
    //微信平台初始化  https://open.weixin.qq.com/
    [_YTsdk connectWxWithAppKey:WXAppKey WithDescription:@"YouTuiSDKDemo"];

    //QQ平台初始化 http://open.qq.com/
    [_YTsdk connectQQWithAppId:QQAppID Delegate:self Uri:QQURI];

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

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    titleArray = [[NSArray alloc]init];
    imageArray = [[NSArray alloc]init];
    pointArray = [[NSArray alloc]init];
    
    titleArray = @[@"微信",@"微信朋友圈",@"新浪微博",@"QQ",@"QQ空间",@"腾讯微博",@"人人网",@"短信",@"邮件",@"复制链接"];
    imageArray = @[@"wechat",@"wechatf",@"sina",@"qq",@"qqzone",@"tcwb",@"renren",@"sms",@"email",@"fuzhilianjie"];
    
    
    //获取友推平台设置的分享获得积分项
    //http://youtui.mobi/activity/list ->推广管理->推广列表->修改->分享积分奖励设置
    
    NSDictionary * dataDict = [[YouTuiSDK GetPointRule] objectForKey:@"object"];
        
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
    FreeGeekSheet * FreegeekUI = [[FreeGeekSheet alloc]initWithTitle:@"分享到"
                                                            Delegate:self
                                                          titleArray:titleArray
                                                          imageArray:imageArray
                                                          PointArray:pointArray
                                                          ShowRedDot:YES
                                                        ActivityName:activityName
                                                              Middle:NO];
    [FreegeekUI ShowInView:self.view];
}
//ActionSheet样式二
-(IBAction)ActionSheetTypeSecond:(id)sender
{
    FreeGeekSheet * FreegeekUI = [[FreeGeekSheet alloc]initWithTitle:@"分享到"
                                                            Delegate:self
                                                          titleArray:titleArray
                                                          imageArray:imageArray
                                                          PointArray:pointArray
                                                          ShowRedDot:YES
                                                        ActivityName:activityName
                                                              Middle:YES];
    [FreegeekUI ShowInView:self.view];
}
//ActionSheet样式三
-(IBAction)ActionSheetTypeThird:(id)sender
{
    
    BlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    BlackView.backgroundColor = [UIColor colorWithRed:0/255.00f green:0/255.00f blue:0/255.00f alpha:0.3];
    [self.view.window addSubview:BlackView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction)];
    [BlackView addGestureRecognizer:tap];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    [self.view.window addSubview:table];
    [UIView animateWithDuration:0.25 animations:^{
        table.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    }completion:^(BOOL finished)
    {
        
    }];
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
    //授权信息列数组
    NSArray * getAuthListArray = @[kOPEN_PERMISSION_GET_USER_INFO,            /** 获取用户信息 **/
                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,         /** 移动端用户信息 **/
                               kOPEN_PERMISSION_ADD_ALBUM,                    /** 创建一个QQ空间相册<需要申请权限> **/
                               kOPEN_PERMISSION_ADD_IDOL,                     /** 收听腾讯微博上的用户 **/
                               kOPEN_PERMISSION_ADD_ONE_BLOG,                 /** 发表一篇日志到QQ空间<需要申请权限> **/
                               kOPEN_PERMISSION_ADD_PIC_T,                    /** 上传图片并发表消息到腾讯微博 **/
                               kOPEN_PERMISSION_ADD_SHARE,                    /** 同步分享到QQ空间、腾讯微博 **/
                               kOPEN_PERMISSION_ADD_TOPIC,                    /** 发表一条说说到QQ空间<需要申请权限> **/
                               kOPEN_PERMISSION_CHECK_PAGE_FANS,              /** 验证是否认证空间粉丝 **/
                               kOPEN_PERMISSION_DEL_IDOL,                     /** 取消收听腾讯微博上的用户 **/
                               kOPEN_PERMISSION_DEL_T,                        /** 删除一条微博信息 **/
                               kOPEN_PERMISSION_GET_FANSLIST,                 /** 获取登录用户的听众列表 **/
                               kOPEN_PERMISSION_GET_IDOLLIST,                 /** 获取登录用户的收听列表 **/
                               kOPEN_PERMISSION_GET_INFO,                     /** 获取登录用户自己的详细信息 **/
                               kOPEN_PERMISSION_GET_OTHER_INFO,               /** 获取其他用户的详细信息 **/
                               kOPEN_PERMISSION_GET_REPOST_LIST,              /** 获取一条微博的转播或评论信息列表 **/
                               kOPEN_PERMISSION_LIST_ALBUM,                   /** 获取用户QQ空间相册列表<需要申请权限> **/
                               kOPEN_PERMISSION_UPLOAD_PIC,                   /** 上传一张照片到QQ空间相册<需要申请权限> **/
                               kOPEN_PERMISSION_GET_VIP_INFO,                 /** 获取会员用户基本信息 **/
                               kOPEN_PERMISSION_GET_VIP_RICH_INFO,            /** 获取会员用户详细信息 **/
                               kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,   /** 获取微博中最近at的好友 **/
                               kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO];       /** 获取微博中匹配昵称的好友 **/
    //判断回调是否为授权的回调
    isTcWbAuth = YES;
    /**
     *  QQ授权登陆
     *  AppId               QQ开放平台申请的AppId
     *  PermissionsArray    授权信息列数组
     */
    [_YTsdk QQAuthorizeAppId:QQAppID Delegate:self PermissionsArray:getAuthListArray];
}
//QQ登出
-(IBAction)QQLogout:(id)sender
{
    [_YTsdk QQLogoutDeleaget:self];
}
//腾讯微博第三方登陆
-(IBAction)TcWbLogin:(id)sender
{
    isTcWbAuth = YES;
    [_YTsdk TcWbLoginWithDelegate:self andRootController:self];
}
//腾讯微博登出
-(IBAction)TcWbLogout:(id)sender
{
    [_YTsdk TcWbOnLogout];
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
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_YTsdk SinaWbLogoutWithToken:appdelegate.TokenStr Delegate:self WithTag:@"user"];
}
//人人网第三方登陆
-(IBAction)RennLogin:(id)sender
{
    //存储KEY值来判断回调是否为授权的回调
    [defaults setObject:@"YES" forKey:RENNAUTH];
    [_YTsdk RennLoginWithDelegate:RennCB];
}
//人人网登出
-(IBAction)RennLogout:(id)sender
{
    [_YTsdk RennLogoutWithDelegate:RennCB];
}

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

#pragma mark ----------QQ和微信的代理方法----------
//微信和QQ分享的回调方法
-(void)onResp:(BaseResp *)resp
{
    NSString * message;
    /**
     *  QQ回调
     */
    if ([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        SendMessageToQQResp * sendQQResp = (SendMessageToQQResp *)resp;
        
        NSLog(@"QQ分享完毕返回数据");
        NSLog(@"请求处理结果是:%@",sendQQResp.result); //-- result = 0 分享成功, 其余分享失败
        NSLog(@"具体错误描述信息:%@",sendQQResp.errorDescription);
        NSLog(@"相应类型:%d",sendQQResp.type);
        NSLog(@"扩展信息:%@",sendQQResp.extendInfo);
        
        message = [NSString stringWithFormat:@"QQ分享完毕返回数据\n请求处理结果是:%@\n具体错误描述信息:%@\n相应类型:%d\n扩展信息:%@",sendQQResp.result,sendQQResp.errorDescription,sendQQResp.type,sendQQResp.extendInfo];
        
        if ([sendQQResp.result isEqualToString:@"0"])
        {
            /**
             *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
             */
            [YouTuiSDK SharePointisShare:YES];
        }
    }
    /**
     *  微信分享回调
     */
    else if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //        errorCode   错误码
        //         0 = 成功
        //        -1 = 普通错误类型
        //        -2 = 用户点击取消返回
        //        -3 = 发送失败
        //        -4 = 授权失败
        //        -5 = 微信不支持
        SendMessageToWXResp * sendWXResp = (SendMessageToWXResp *)resp;
        
        NSLog(@"微信分享完毕返回数据");
        NSLog(@"错误码:%d",sendWXResp.errCode);
        NSLog(@"错误提示字符串:%@",sendWXResp.errStr);
        NSLog(@"相应类型:%d",sendWXResp.type);
        
        message = [NSString stringWithFormat:@"微信分享完毕返回数据\n错误码:%d\n错误提示字符串:%@\n相应类型:%d",sendWXResp.errCode,sendWXResp.errStr,sendWXResp.type];
        
        if (sendWXResp.errCode == 0)
        {
            /**
             *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
             */
            [YouTuiSDK SharePointisShare:YES];
        }
    }
    /**
     *  微信授权成功的回调
     */
    else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp * sendAuth = (SendAuthResp *)resp;
        {
            NSLog(@"返回码:%@",sendAuth.code);
            NSLog(@"状态:%@",sendAuth.state);
            message = [YouTuiSDK WxAuthGetUserInfoWithAppId:WXAppKey Secret:WXAppSecret Code:sendAuth.code];
        }
    }
        [self ShowAlertTitle:@"Results" andMessage:message];
}
/**
 *  QQ登陆成功后的回调
 */
-(void)tencentDidLogin
{
    [_YTsdk QQGetUserInfo];
}
/**
 *  登陆失败后的回调
 *
 */
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    [self ShowAlertTitle:nil andMessage:@"QQ登陆失败"];
}
/**
 *  退出登陆的回调
 */
-(void)tencentDidLogout
{
    [self ShowAlertTitle:@"您取消了QQ的授权" andMessage:nil];
}
/**
 *  获取当前授权用户信息的回调
 *
 */
-(void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSMutableString * str = [NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse)     //-----返回用户信息的json数据
        {
            [str appendString:[NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        
        [self ShowAlertTitle:@"QQ授权用户信息" andMessage:str];
    }
    else
    {
        [self ShowAlertTitle:@"获取用户信息失败" andMessage:[NSString stringWithFormat:@"%@",response.errorMsg]];
    }
}

/**
 *  登陆时网络有问题的回调
 */
-(void)tencentDidNotNetWork
{
    [self ShowAlertTitle:@"请检查网络连接.." andMessage:nil];
}

#pragma mark ----------腾讯微博代理回调方法----------
/**
 *  腾讯微博授权成功的回调
 *
 *  @param wbobj 返回的对象
 */
-(void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    if (isTcWbAuth == YES)         //-------------第三方登陆回调
    {
        [_YTsdk TcWbRequestUserInfoDelegate:self];   //登陆成功获取当前授权用户的信息
    }
    else if (isTcWbAuth == NO)     //----------腾讯微博分享的回调
    {
        NSString * message = [NSString stringWithFormat:@"用户微博账号:%@\n用户微博昵称:%@\nOpenid:%@\naccessToken:%@",wbobj.userName,wbobj.userNick,wbobj.openid,wbobj.accessToken];
        
        [self ShowAlertTitle:@"分享结果" andMessage:message];
    }
}
/**
 *  腾讯微博取消授权的回调
 *
 *  @param wbobj 返回的对象
 */
-(void)DidAuthCanceled:(WeiboApiObject *)wbobj
{
    [self ShowAlertTitle:@"取消了腾讯微博的授权" andMessage:nil];
}
/**
 *  腾讯微博授权失败的回调
 *
 *  @param error 返回的对象
 */
-(void)DidAuthFailWithError:(NSError *)error
{
    [self ShowAlertTitle:@"授权失败" andMessage:nil];
}

//腾讯微博调用接口成功的回调--------(分享,获取当前授权用户信息)
/**
 *  腾讯微博分享成功后的回调
 *
 *  @param data  接口返回的数据
 */
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString * message;
    NSString * title;
    if (isTcWbAuth == YES)   //------授权成功后获取用户信息的回调
    {
        title = @"腾讯微博授权用户信息";
        message = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    }
    else if (isTcWbAuth == NO)
    {
        title = @"腾讯微博分享成功";
        message = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        /**
         *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
         */
        [YouTuiSDK SharePointisShare:YES];
    }
    [self ShowAlertTitle:title andMessage:[NSString stringWithFormat:@"%@",message]];

}
/**
 *  腾讯微博分享失败后的回调
 *
 *  @param error 接口返回的错误信息
 */
-(void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    [self ShowAlertTitle:@"腾讯微博分享失败" andMessage:[NSString stringWithFormat:@"%@",error.userInfo]];
}

/**
 *  腾讯微博分享失败,且失败原因为授权无效
 *
 *  @param error 接口返回的错误信息
 */
-(void)didNeedRelogin:(NSError *)error reqNo:(int)reqno
{
    [self ShowAlertTitle:@"分享错误" andMessage:@"请先授权"];
}

/**
 *  选择使用服务器验证token有效性时,需实现此回调
 *
 *  @param bResult       检查结果,YES为有效,NO为无效
 *  @param strSuggestion 当bResult 为NO时,此参数为建议
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    if(bResult) //授权有效
    {
        [self ShowTcWbShareMessgaeUI];
    }
    else
    {
        [self TcWbLogin:self];
    }
}


#pragma mark ----------人人网代理回调----------
/**
 *  人人网授权成功的回调
 */
-(void)rennLoginSuccess
{
    [_YTsdk RennGetUserInfoDelegate:self];    //获取当前授权用户信息
}
/**
 *  人人网授权失败的回调
 *
 *  @param error 错误信息
 */
-(void)rennLoginDidFailWithError:(NSError *)error
{
    [self ShowAlertTitle:@"人人网授权失败" andMessage:[NSString stringWithFormat:@"%@",error]];
}
/**
 *  人人网取消登陆的回调
 */
-(void)rennLoginCancelded
{
    [self ShowAlertTitle:@"您取消了人人网的的授权" andMessage:nil];
}
/**
 *  人人网登出成功的回调
 */
-(void)rennLogoutSuccess
{
  
}
/**
 *  人人网获取当前授权用户信息成功的回调
 */
-(void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSString * isRennAuth = [defaults stringForKey:RENNAUTH];
    if ([isRennAuth isEqualToString:@"YES"])
    {
        [self ShowAlertTitle:@"人人网授权用户信息" andMessage:[NSString stringWithFormat:@"%@",response]];
    }
    else if ([isRennAuth isEqualToString:@"NO"])
    {
        [self ShowAlertTitle:@"人人网分享成功" andMessage:[NSString stringWithFormat:@"%@",response]];
        /**
         *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
         */
        [YouTuiSDK SharePointisShare:YES];
    }
}
/**
 *  人人网获取当前授权用户信息失败的回调
 */
-(void)rennService:(RennService *)service requestFailWithError:(NSError *)error
{
    [self ShowAlertTitle:@"人人网获取用户信息失败" andMessage:[NSString stringWithFormat:@"Error Domain = %@\nError Code = %@",[error domain],[[error userInfo] objectForKey:@"code"]]];
}

-(void)ShowAlertTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
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
    [self MiddlegoToPointStoreAction];
}
/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
-(void)MiddlegoToPointStoreAction
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
/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
-(void)LXgoToPointStoreAction
{
    [self MiddlegoToPointStoreAction];
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
    isTcWbAuth = NO;
    [_YTsdk checkAuthValidDelegate:self];
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
                    delegate:self];
    
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
    
    //有分享回调---分享前确定人人网已经授权成功
    //            [_YTsdk RennBaseShareComment:ShareMessage
    //                                     Url:ShareVideoURL
    //                                Delegate:self];

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

-(void)goToPointStore
{
    [self MiddlegoToPointStoreAction];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithRed:0.184f green:0.580f blue:0.706f alpha:1.00f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelButtonAction];
    [self ShareButtonAction:(NSInteger *)indexPath.row];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(18, 10,80, 30)];
    label.text = @"分享到";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:0.184f green:0.580f blue:0.706f alpha:1.00f];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.184f green:0.580f blue:0.706f alpha:1.00f] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:0.918f green:0.918f blue:0.918f alpha:0.60f];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return cancelButton;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
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
