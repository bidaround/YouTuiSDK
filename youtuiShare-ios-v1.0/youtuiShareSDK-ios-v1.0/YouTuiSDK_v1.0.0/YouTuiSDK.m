//
//  YouTuiSDK.m
//  YouTuiSDK
//
//  Created by FreeGeek on 14-10-19.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "YouTuiSDK.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CommonCrypto/CommonDigest.h>
#import "SecureUDID.h"
#import "JSON.h"
#define YTAPPID @"YTAPPIDKEY"
#define SHAREURL @"SHAREURL"
#define CHANNELID @"CHANNELID"
@implementation YouTuiSDK
{
    WeiboApi * WBApi;
    WeiboSDK * SinaWB;
    TencentOAuth * TcAuth;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        WBApi = [[WeiboApi alloc]init];
        SinaWB = [[WeiboSDK alloc]init];
        TcAuth = [[TencentOAuth alloc]init];
     }
    return self;
}

/**
 *  短信分享
 *
 *  @param message         短信内容
 *  @param receivePhoneNum 接收方的手机号码
 *  @param image           图片附件
 *  @param Typeidentifier  类型标识符
 *  @param fileName        附件名称
 *  @param ViewController  self
 */
-(void)ShareToMsg:(NSString *)message ReceivePhoneNum:(NSString *)receivePhoneNum Image:(UIImage *)image TypeIdentifier:(NSString *)Typeidentifier FileName:(NSString *)fileName ViewController:(id)ViewController
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:7 forKey:CHANNELID];   //存储频道ID
    if ([MFMessageComposeViewController canSendAttachments] == YES)
    {
        MFMessageComposeViewController * MsgVC = [[MFMessageComposeViewController alloc]init];
        MsgVC.messageComposeDelegate = ViewController;
        MsgVC.body = message;
        MsgVC.recipients = [NSArray arrayWithObject:receivePhoneNum];
        [MsgVC addAttachmentData:UIImageJPEGRepresentation(image, 0) typeIdentifier:Typeidentifier filename:fileName];
        [ViewController presentViewController:MsgVC animated:NO completion:nil];
    }
}
/**
 *  邮件分享
 *
 *  @param Title          标题
 *  @param body           内容
 *  @param Image          图片附件
 *  @param fileName       图片附件名称
 *  @param CcMailAddress  抄送邮件地址
 *  @param ToMailAddress  接收方邮件地址
 *  @param ViewController self
 */
-(void)ShareToMail:(NSString *)Title MessageBody:(NSString *)body Image:(UIImage *)Image ImageFileName:(NSString *)fileName SetCc:(NSString *)CcMailAddress SetTo:(NSString *)ToMailAddress ViewController:(id)ViewController
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:8 forKey:CHANNELID];   //存储频道ID
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController * mail = [[MFMailComposeViewController alloc]init];
        [mail setMailComposeDelegate:ViewController];
        [mail setSubject:Title];
        [mail setMessageBody:body isHTML:YES];
        [mail addAttachmentData:UIImageJPEGRepresentation(Image, 0) mimeType:@"" fileName:fileName];
        [mail setCcRecipients:[NSArray arrayWithObject:CcMailAddress]];
        [mail setToRecipients:[NSArray arrayWithObject:ToMailAddress]];
        [ViewController presentViewController:mail animated:YES completion:nil];
    }
}
//获得多媒体文件的MimeType
-(NSString *)MimeType:(NSString *)FileName
{
    NSString * path = [[NSBundle mainBundle] pathForResource:FileName ofType:nil];
    NSURL * url = [NSURL fileURLWithPath:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLResponse * response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return [response MIMEType];
}

/**
 *  复制链接
 *
 *  @param Link 需要复制的内容
 */
+(void)CopyLinkWithLink:(NSString *)Link
{
    NSString * shortUrl = [self SetShortUrlType:Link];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:9 forKey:CHANNELID];   //存储频道ID
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    if (shortUrl == nil || [shortUrl isEqualToString:@""])
    {
        pasteboard.string = Link;
    }
    else
    {
        pasteboard.string = shortUrl;
    }
    [self SharePointisShare:YES];
}


#pragma mark ----------腾讯微博----------
/**
 *  腾讯微博平台初始化
 *
 *  @param AppKey       腾讯微博开放平台申请的AppKey
 *  @param AppSecret    腾讯微博开放平台申请的AAsecret
 *  @param RedirectUri  回调Uri
 */
-(void)connectTcWbWithAppKey:(NSString *)AppKey andSecret:(NSString *)AppSecret andRedirectUri:(NSString *)RedirectUri
{
    id temp = [WBApi initWithAppKey:AppKey
                          andSecret:AppSecret
                     andRedirectUri:RedirectUri
                    andAuthModeFlag:4
                     andCachePolicy:0];
    if (temp)
    {
        
    }
}

/**
 *  腾讯微博授权
 *
 *  @param delegate           回调方法接受对象
 *  @param rootViewController 授权窗口的父窗口
 */
-(void)TcWbLoginWithDelegate:(id)delegate andRootController:(UIViewController *)rootViewController
{
    [WBApi loginWithDelegate:delegate andRootController:rootViewController];
}

/**
 *  判断授权是否有效,包括是否已授权,授权是否已过期
 *
 *  @param delegate 回调delegate
 */
-(void)checkAuthValidDelegate:(id)delegate
{
    [WBApi checkAuthValid:TCWBAuthCheckLocal andDelegete:delegate];
}
/**
 *  腾讯微博登出授权
 */
-(void)TcWbOnLogout
{
    [WBApi cancelAuth];
}
/**
 *  腾讯微博客户端回调
 *
 *  @param url 启动App的URL
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL)TcWbhandleOpenURL:(NSURL *)url
{
    return [WBApi handleOpenURL:url];
}
/**
 *  腾讯微博获取当前授权用户的信息
 *
 *  @param delegate 回调delegate
 */
-(void)TcWbRequestUserInfoDelegate:(id)delegate
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format", nil];
    [WBApi requestWithParams:params apiName:@"user/info" httpMethod:@"GET" delegate:delegate];
}
/**
 *  腾讯微博分享
 *
 *  @param message     文本
 *  @param imageUrl    图片url
 *  @param VideoUrl    视频url
 *  @param longitude   经度(精确到小数点后6位)
 *  @param latitude    纬度(精确到小数点后6位)
 *  @param musicUrl    音乐url
 *  @param musicTitle  歌曲名
 *  @param musicAuthor 歌手
 *  @param delegate    self
 */
-(void)TcWbShareMessage:(NSString *)message andImageUrl:(NSString *)imageUrl VideoUrl:(NSString *)VideoUrl Longitude:(NSString *)longitude Latitude:(NSString *)latitude MusicUrl:(NSString *)musicUrl MusicTitle:(NSString *)musicTitle MusicAuthor:(NSString *)musicAuthor delegate:(id)delegate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:CHANNELID];   //存储频道ID
    if (imageUrl)
    {
        imageUrl = [YouTuiSDK SetShortUrlType:imageUrl];
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                    @"json",@"format",
                                    message,@"content",
                                    imageUrl,@"pic_url",
                                    VideoUrl,@"video_url",
                                    longitude,@"longitude",
                                    latitude,@"latitude",
                                    musicUrl,@"music_url",
                                    musicTitle,@"music_title",
                                    musicAuthor,@"music_author",
                                    nil];
    
    [WBApi requestWithParams:params
                     apiName:@"t/add_multi"
                  httpMethod:@"POST"
                    delegate:delegate];
}

#pragma mark ----------新浪微博----------
/**
 *  新浪微博初始化
 *
 *  @param AppKey 新浪微博开放平台初始化
 *
 *  @return 注册成功返回YES,失败返回NO
 */
+(BOOL)connectSinaWithAppKey:(NSString *)AppKey
{
    return [WeiboSDK registerApp:AppKey];
}
/**
 *  新浪微博设置调试模式
 *
 *  @param enabled 开启或者关闭调试模式
 */
+(void)enableDebugMode:(BOOL)enabled
{
    [WeiboSDK enableDebugMode:enabled];
}
/**
 *  检查用户是否安装了微博客户端程序
 *
 *  @return 已安装返回YES,未安装返回NO
 */
+(BOOL)SinaIsAppInstalled
{
   return [WeiboSDK isWeiboAppInstalled];
}
/**
 *  新浪微博授权登陆
 *
 *  @param URI 授权回调URI
 */
-(void)SinaWbLogin:(NSString *)URI
{
    WBAuthorizeRequest * request = [WBAuthorizeRequest request];
    request.redirectURI = URI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}
/**
 *  新浪微博登出授权接口
 *
 *  @param token    第三方应用之前申请的token
 *  @param delegate 用于接受微博SDK对于发起的接口请求的响应
 *  @param Tag      用户自定义
 */
-(void)SinaWbLogoutWithToken:(NSString *)token Delegate:(id)delegate WithTag:(NSString *)Tag
{
    [WeiboSDK logOutWithToken:token delegate:delegate withTag:Tag];
}

/**
 *  新浪微博获取用户信息
 *
 *  @param Appkey 新浪微博开放平台获取的AppKey
 *  @param Uid    用户ID
 *
 *  @return 用户信息
 */
+(NSDictionary *)SinaGetUserInfoWithAppkey:(NSString *)Appkey Uid:(NSString *)Uid
{
//    NSString * body = [NSString stringWithFormat:@"source=%@&uid=%@",Appkey,Uid];
//    return [[self PostRequestData:@"https://api.weibo.com/2/users/show.json?" body:body] JSONValue];
    NSString * URLString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",Appkey,Uid];
    NSURL * URL = [NSURL URLWithString:URLString];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
    NSData * received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString * str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return [str JSONValue];
}
/**
 *  新浪微博客户端回调
 *
 *  @param url      启动App的Url
 *  @param delegate self 用于接受微博触发的消息
 *
 *  @return 回调成功返回YES,失败返回NO
 */
+(BOOL)SinaWbhandleOpenURL:(NSURL *)url delegate:(id)delegate
{
    return [WeiboSDK handleOpenURL:url delegate:delegate];
}
/**
 *  新浪微博图文分享
 *
 *  @param message 文本内容
 *  @param Image   图片
 *  @param url     网页的URL
 */
+(void)SinaWbShareMessage:(NSString *)message Image:(UIImage *)Image Url:(NSString *)url
{
    if ([self SinaIsAppInstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:CHANNELID];   //存储频道ID
        if (url)
        {
            url = [self SetShortUrlType:url];
        }
        WBMessageObject *Message = [WBMessageObject message];
        //分享文本
        Message.text = [NSString stringWithFormat:@"%@%@",message,url];
        //分享图片
        WBImageObject * image = [WBImageObject object];
        if (UIImagePNGRepresentation(Image) == nil)
        {
            image.imageData = UIImageJPEGRepresentation(Image, 1);
        }
        else
        {
            image.imageData = UIImagePNGRepresentation(Image);
        }
        Message.imageObject = image;
        WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:Message];
        [WeiboSDK sendRequest:request];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装新浪微博客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  新浪微博多媒体分享
 *
 *  @param message      文本内容
 *  @param ID           对象唯一ID
 *  @param title        多媒体网页标题
 *  @param description  多媒体内容描述
 *  @param thumbnaiData 多媒体内容缩略图
 *  @param url          网页的Url
 */
+(void)SinaWbShareMessage:(NSString *)message ID:(NSString *)ID Title:(NSString *)title Description:(NSString *)description ThumbnaiData:(NSData *)thumbnaiData Url:(NSString *)url
{
    if ([self SinaIsAppInstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:CHANNELID];   //存储频道ID
        
        if (url)
        {
            url = [self SetShortUrlType:url];
        }
        WBMessageObject *Message = [WBMessageObject message];
        Message.text = message;
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = ID;
        webpage.title = title;
        webpage.description = description;
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
        webpage.webpageUrl = url;
        Message.mediaObject = webpage;
        WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:Message];
        [WeiboSDK sendRequest:request];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装新浪微博客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark ----------微信----------
/**
 *  微信平台初始化
 *
 *  @param AppKey      微信开放平台申请的AppKey
 *  @param description 应用附加信息
 */
-(void)connectWxWithAppKey:(NSString *)AppKey WithDescription:(NSString *)description
{
    [WXApi registerApp:AppKey withDescription:description];
}
/**
 *  微信客户端回调
 *
 *  @param url      启动App的URL
 *  @param delegate 用来接受微信触发的消息
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)WxhandleOpenURL:(NSURL *)url delegate:(id)delegate
{
    return [WXApi handleOpenURL:url delegate:delegate];
}
/**
 *  检查微信是否被安装
 *
 *  @return 是返回YES,否返回NO
 */
+(BOOL)WxIsAppOnstalled
{
    return [WXApi isWXAppInstalled];
}
/**
 *  获取微信的itunes安装地址
 *
 *  @return 微信的安装地址字符串
 */
+(NSString *)WxGetWxAppInstallUrl
{
    return [WXApi getWXAppInstallUrl];
}
/**
 *  打开微信
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)OpenWxApp
{
    return [WXApi openWXApp];
}

/**
 *  微信第三方授权登陆
 *
 *  @param state 第三方程序本身用来标识其请求的唯一性，最后跳转回第三方程序时，由微信终端回传。
 */
+(void)WxLoginWithState:(NSString *)state
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        SendAuthReq * req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.state = state;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *  微信获取当前授权用户的信息
 *
 *  @param AppId  微信开放平台申请的AppId
 *  @param Secret 微信开房平台申请的AppSecret
 *  @param code   用户换取access_token的code，仅在ErrCode为0时有效
 *
 *  @return 用户信息
 */
+(NSString *)WxAuthGetUserInfoWithAppId:(NSString *)AppId Secret:(NSString *)Secret Code:(NSString *)code
{
    NSDictionary * AuthDict = [[YouTuiSDK PostRequestData:@"https://api.weixin.qq.com/sns/oauth2/access_token?" body:[NSString stringWithFormat:@"appid=%@&secret=%@&code=%@&grant_type=authorization_code",AppId,Secret,code]] JSONValue];
    NSString * UserInfo = [YouTuiSDK PostRequestData:@"https://api.weixin.qq.com/sns/userinfo?" body:[NSString stringWithFormat:@"access_token=%@&openid=%@",[AuthDict objectForKey:@"access_token"],[AuthDict objectForKey:@"openid"]]];
    return UserInfo;
}

/**
 *  微信获取当前授权用户的认证信息
 *
 *  @return 认证数据
 */
+(NSDictionary *)WxAuthGetAccessTokenWithAppId:(NSString *)AppId Secret:(NSString *)Secret Code:(NSString *)code
{
    NSDictionary * AuthDict = [[YouTuiSDK PostRequestData:@"https://api.weixin.qq.com/sns/oauth2/access_token?" body:[NSString stringWithFormat:@"appid=%@&secret=%@&code=%@&grant_type=authorization_code",AppId,Secret,code]] JSONValue];
    return AuthDict;
}
/**
 *  微信获取当前授权用户的个人信息
 *
 *  @param AccessToken 调用凭证
 *  @param Openid      普通用户的标识,对当前开发者账号唯一
 *
 *  @return 个人信息
 */
+(NSDictionary *)WxAuthGetUserInfoWithAccessToken:(NSString *)AccessToken Openid:(NSString *)Openid
{
    NSDictionary * UserInfo = [[YouTuiSDK PostRequestData:@"https://api.weixin.qq.com/sns/userinfo?" body:[NSString stringWithFormat:@"access_token=%@&openid=%@",AccessToken,Openid]] JSONValue];
    return UserInfo;
}



/**
 *  微信纯文本分享
 *
 *  @param message 文本内容
 *  @param Type    分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMessage:(NSString *)message Type:(int)Type
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:3 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:10 forKey:CHANNELID];   //存储频道ID
        }
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.text = message;
        req.bText = YES;
        req.scene = Type;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  微信纯图片分享
 *
 *  @param image 图片
 *  @param Type  分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMessageWithImage:(UIImage *)image Type:(int)Type
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:3 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:10 forKey:CHANNELID];   //存储频道ID
        }
        WXMediaMessage * message = [WXMediaMessage message];
        [message setThumbImage:image];
        WXImageObject * ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation(image);
        message.mediaObject = ext;
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = Type;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  微信图文分享
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       消息缩略图
 *  @param url         多媒体链接
 *  @param Type        分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image Url:(NSString *)url Type:(int)Type
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:3 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:10 forKey:CHANNELID];   //存储频道ID
        }
        if (url)
        {
            url = [YouTuiSDK SetShortUrlType:url];
        }
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        [message setThumbImage:image];
        WXWebpageObject * ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = Type;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  微信音乐分享
 *
 *  @param title        标题
 *  @param description  详细内容
 *  @param image        消息缩略图
 *  @param MusicUrl     音乐网页的Url
 *  @param MusicDataUrl 音乐数据Url
 *  @param Type         分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMusicTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image MusicUrl:(NSString *)MusicUrl MusicDataUrl:(NSString *)MusicDataUrl Type:(int)Type
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:3 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:10 forKey:CHANNELID];   //存储频道ID
        }
        if (MusicUrl)
        {
            MusicUrl = [YouTuiSDK SetShortUrlType:MusicUrl];
        }
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        [message setThumbImage:image];
        WXMusicObject * ext = [WXMusicObject object];
        ext.musicUrl = MusicUrl;
        ext.musicDataUrl = MusicDataUrl;
        message.mediaObject = ext;
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.message = message;
        req.scene = Type;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  微信多媒体分享
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       消息缩略图
 *  @param VideoUrl    视频Url
 *  @param Type        分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareVideoTitle:(NSString *)title Description:(NSString *)description image:(UIImage *)image VideoUrl:(NSString *)VideoUrl Type:(int)Type
{
    if ([YouTuiSDK WxIsAppOnstalled])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:3 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:10 forKey:CHANNELID];   //存储频道ID
        }
        if (VideoUrl)
        {
            VideoUrl = [YouTuiSDK SetShortUrlType:VideoUrl];
        }
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        [message setThumbImage:image];
        WXVideoObject * ext = [WXVideoObject object];
        ext.videoUrl = VideoUrl;
        message.mediaObject = ext;
        
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = Type;
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装微信客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark ----------QQ----------
/**
 *  QQ平台初始化--
 *
 *  @param AppId    QQ开放平台申请的AppId
 *  @param delegate 第三方应用用于接受请求返回结果的委托对象
 *  @param Uri      授权回调页
 *
 *  @return 成功返回YES,失败返回NO
 */
-(id)connectQQWithAppId:(NSString *)AppId Delegate:(id)delegate Uri:(NSString *)Uri
{
    TencentOAuth * TcOAuth = [[TencentOAuth alloc]initWithAppId:AppId andDelegate:delegate];
    TcOAuth.redirectURI = Uri;
    return TcOAuth;
}
/**
 *  检测是否已安装QQ
 *
 *  @return 已安装返回YES,未安装返回NO
 */
+(BOOL)QQisInstalled
{
    return [QQApi isQQInstalled];
}
/**
 *  QQ客户端回调
 *
 *  @param url      启动App的URl
 *  @param delegate self
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)QQhandleOpenURL:(NSURL *)url delegate:(id)delegate
{
    if (![QQApiInterface handleOpenURL:url delegate:delegate])
    {
//        return [QQApiInterface handleOpenURL:url delegate:delegate];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
/**
 *  QQ登陆授权
 *
 *  @param AppId            QQ
 *  @param delegate         self
 *  @param permissionsArray 授权信息列
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL)QQAuthorizeAppId:(NSString *)AppId Delegate:(id)delegate PermissionsArray:(NSArray *)permissionsArray
{
    if ([YouTuiSDK QQisInstalled])
    {
        TcAuth = [[TencentOAuth alloc]initWithAppId:AppId andDelegate:delegate];
        return [TcAuth authorize:permissionsArray inSafari:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装QQ客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    return YES;
}
/**
 *  QQ登出授权
 *
 *  @param delegate 成功返回YES,失败返回NO
 */
-(void)QQLogoutDeleaget:(id)delegate
{
    [[TencentOAuth alloc] logout:delegate];
}
/**
 *  QQ获取当前授权用户信息
 */
-(void)QQGetUserInfo
{
    [TcAuth getUserInfo];
}
/**
 *  QQ纯文本分享
 *
 *  @param text 文本内容   (只支持分享到QQ,不支持分享到QQ空间)
 */
-(void)QQShareTextContent:(NSString *)text
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        
        QQApiTextObject * texObj = [QQApiTextObject objectWithText:text];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:texObj];
        [QQApiInterface sendReq:req];
}
/**
 *  QQ图片分享  (只支持分享到QQ,不支持分享到QQ空间)
 *
 *  @param image       图片
 *  @param title       标题
 *  @param description 详细内容
 */
-(void)QQShareImage:(UIImage *)image Title:(NSString *)title Description:(NSString *)description
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        
        QQApiImageObject * imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 0)
                                                    previewImageData:UIImageJPEGRepresentation(image, 0)
                                                               title:title
                                                         description:description];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:imgObj];
        [QQApiInterface sendReq:req];
}
/**
 *  QQ新闻分享------本地图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       图片
 *  @param Url         分享跳转Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareNewsTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image Url:(NSString *)url Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        if (url)
        {
            url = [YouTuiSDK SetShortUrlType:url];
        }
        QQApiNewsObject * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                             title:title
                                                       description:description
                                                  previewImageData:UIImageJPEGRepresentation(image, 0)];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:newsObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else if (Type == 1)
        {
            [QQApiInterface SendReqToQZone:req];
        }
}
/**
 *  QQ新闻分享-------网络图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param imageUrl    图片Url
 *  @param url         分享跳转Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareMediaTitle:(NSString *)title Description:(NSString *)description ImageUrl:(NSString *)imageUrl url:(NSString *)url Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        if (imageUrl)
        {
            imageUrl = [YouTuiSDK SetShortUrlType:imageUrl];
        }
        QQApiNewsObject * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                             title:title
                                                       description:description
                                                   previewImageURL:[NSURL URLWithString:imageUrl]];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:newsObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else if (Type == 1)
        {
            [QQApiInterface SendReqToQZone:req];
        }
}
/**
 *  QQ音乐分享--------本地图片
 *
 *  @param title         标题
 *  @param description   详细内容
 *  @param image         图片
 *  @param url           分享跳转Url
 *  @param MusicURL      音乐URL
 *  @param Type          分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareAudioTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image Url:(NSString *)url MusicURL:(NSString *)MusicURL Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        
        if (url)
        {
            url = [YouTuiSDK SetShortUrlType:url];
        }
        QQApiAudioObject * audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:url]
                                                                title:title
                                                          description:description
                                                     previewImageData:UIImagePNGRepresentation(image)];
        [audioObj setPreviewImageData:UIImagePNGRepresentation(image)];
        [audioObj setFlashURL:[NSURL URLWithString:MusicURL]];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:audioObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else if (Type == 1)
        {
            [QQApiInterface SendReqToQZone:req];
        }
}
/**
 *  QQ音乐分享------网络图片
 *
 *  @param title         标题
 *  @param description   详细内容
 *  @param imageUrl      图片Url
 *  @param url           分享跳转Url
 *  @param MusicURL      音乐URL
 *  @param Type          分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareAudioTitle:(NSString *)title Description:(NSString *)description ImageUrl:(NSString *)imageUrl Url:(NSString *)url MusicURL:(NSString *)MusicUrl Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        
        if (url)
        {
            url = [YouTuiSDK SetShortUrlType:url];
        }
        QQApiAudioObject * audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:url]
                                                                title:title
                                                          description:description
                                                      previewImageURL:[NSURL URLWithString:imageUrl]];
        [audioObj setPreviewImageURL:[NSURL URLWithString:imageUrl]];
        [audioObj setFlashURL:[NSURL URLWithString:MusicUrl]];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:audioObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else if (Type == 1)
        {
            [QQApiInterface SendReqToQZone:req];
        }
}
/**
 *  QQ视频分享-----本地图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       图片
 *  @param VideoUrl    视频Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareVideoTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image VideoUrl:(NSString *)VideoUrl Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        
        if (VideoUrl)
        {
            VideoUrl = [YouTuiSDK SetShortUrlType:VideoUrl];
        }
        QQApiVideoObject * videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:VideoUrl]
                                                                title:title
                                                          description:description
                                                     previewImageData:UIImagePNGRepresentation(image)];
        [videoObj setPreviewImageData:UIImagePNGRepresentation(image)];
        [videoObj setFlashURL:[NSURL URLWithString:VideoUrl]];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:videoObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else
        {
            [QQApiInterface SendReqToQZone:req];
        }
}
/**
 *  QQ视频分享-------网络图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param imageUrl    图片Url
 *  @param VideoUrl    视频Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareVideoTitle:(NSString *)title Description:(NSString *)description ImageUrl:(NSString *)imageUrl VideoUrl:(NSString *)VideoUrl Type:(int)Type
{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (Type == 0)
        {
            [defaults setInteger:5 forKey:CHANNELID];   //存储频道ID
        }
        else if (Type == 1)
        {
            [defaults setInteger:2 forKey:CHANNELID];   //存储频道ID
        }
        
        if (VideoUrl)
        {
            VideoUrl = [YouTuiSDK SetShortUrlType:VideoUrl];
        }
        
        QQApiVideoObject * videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:VideoUrl]
                                                                title:title
                                                          description:description
                                                      previewImageURL:[NSURL URLWithString:imageUrl]];
        [videoObj setPreviewImageURL:[NSURL URLWithString:imageUrl]];
        [videoObj setFlashURL:[NSURL URLWithString:VideoUrl]];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:videoObj];
        if (Type == 0)
        {
            [QQApiInterface sendReq:req];
        }
        else
        {
            [QQApiInterface SendReqToQZone:req];
        }
}

#pragma mark ----------人人网----------
/**
 *  人人网平台初始化
 *
 *  @param AppId     人人网开放平台申请的AppId
 *  @param ApiKey    人人网开放平台申请的ApiKey
 *  @param secretKey 人人网开放平台申请的secretKey
 */
-(void)connectRennWithAppId:(NSString *)AppId ApiKey:(NSString *)ApiKey SecretKey:(NSString *)secretKey
{
    [RennShareComponent initWithAppId:AppId apiKey:ApiKey secretKey:secretKey];
    [RennClient initWithAppId:AppId apiKey:ApiKey secretKey:secretKey];
}
/**
 *  人人网客户端回调
 *
 *  @param url 启动App的URL
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)RennHandleOpenURL:(NSURL *)url
{
    return [RennClient handleOpenURL:url];
}
/**
 *  人人网授权
 *
 *  @param delegate self
 */
-(void)RennLoginWithDelegate:(id)delegate
{
    [RennClient loginWithDelegate:delegate];
}
/**
 *  人人网登出
 *
 *  @param delegate self
 */
-(void)RennLogoutWithDelegate:(id)delegate
{
    [RennClient logoutWithDelegate:delegate];
}
/**
 *  人人网获取当前授权用户的信息
 *
 *  @param delegate self
 */
-(void)RennGetUserInfoDelegate:(id)delegate
{
    GetUserParam * param = [[GetUserParam alloc]init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:delegate];
}
/**
 *  人人网纯文本分享  (只支持对话分享,不支持新鲜事分享)
 *
 *  @param title 标题
 *  @param text  文本内容
 *  @param url   跳转链接
 */
-(void)RennShareTitle:(NSString *)title Text:(NSString *)text Url:(NSString *)url
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID
    if (url)
    {
        url = [YouTuiSDK SetShortUrlType:url];
    }
    RennTextMessage * msg = [[RennTextMessage alloc]init];
    msg.title = title;
    msg.text = text;
    msg.url = url;
    NSInteger errorCode = [RennShareComponent SendMessage:msg msgTarget:To_Renren];
    [self RennMessageErrorTips:(int)errorCode];
}
/**
 *  人人网纯图片分享
 *
 *  @param title         标题
 *  @param imageUrl      图片url
 *  @param localImage    真是图片数据
 *  @param thumbData     消息缩略图
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 *********   PS:imageUrl与localPath为缩略图点击放大后图片信息，该两个字段不能同时为空，两个字段同时存在时默认取localPath进行处理。*******
 */
-(void)RennShareTitle:(NSString *)title ImageUrl:(NSString *)imageUrl LocalPath:(UIImage *)localImage ThumbData:(UIImage *)thumbData MessageTarget:(MessageTarget)MessageTarget
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID

    if (imageUrl)
    {
        imageUrl = [YouTuiSDK SetShortUrlType:imageUrl];
    }
    RennImageMessage * msg = [[RennImageMessage alloc]init];
    msg.title = title;
    msg.imageUrl = imageUrl;
    msg.imageData = UIImagePNGRepresentation(localImage);
    msg.thumbData = UIImagePNGRepresentation(thumbData);
    NSInteger errorCode = [RennShareComponent SendMessage:msg msgTarget:MessageTarget];
    [self RennMessageErrorTips:(int)errorCode];
}
/**
 *  人人网图文分享
 *
 *  @param title         标题
 *  @param url           跳转链接
 *  @param description   详细内容
 *  @param thumbData     缩略图
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 */
-(void)RennShareTitle:(NSString *)title Url:(NSString *)url Description:(NSString *)description ThumbData:(UIImage *)thumbData MessageTarget:(MessageTarget)MessageTarget
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID
    if (url)
    {
        url = [YouTuiSDK SetShortUrlType:url];
    }
    RennImgTextMessage * msg = [[RennImgTextMessage alloc]init];
    msg.title = title;
    msg.description = description;
    msg.url = url;
    msg.thumbData = UIImagePNGRepresentation(thumbData);
    NSInteger errorCode = [RennShareComponent SendMessage:msg msgTarget:MessageTarget];
    [self RennMessageErrorTips:(int)errorCode];
}
/**
 *  人人网视频分享
 *
 *  @param title         标题
 *  @param description   详细内容
 *  @param Url           视频来源Url
 *  @param thumbData     缩略图
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 */
-(void)RennShareVideoTitle:(NSString *)title Description:(NSString *)description VideoUrl:(NSString *)Url ThumbData:(UIImage *)thumbData MessageTarget:(MessageTarget)MessageTarget
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID

    if (Url)
    {
        Url = [YouTuiSDK SetShortUrlType:Url];
    }
    RennVideoMessage * msg = [[RennVideoMessage alloc]init];
    msg.title = title;
    msg.description = description;
    msg.url = Url;
    msg.thumbData = UIImagePNGRepresentation(thumbData);
    NSInteger errorCode = [RennShareComponent SendMessage:msg msgTarget:MessageTarget];
    [self RennMessageErrorTips:(int)errorCode];
}
/**
 *  人人网新鲜事分享------有回调
 *
 *  @param title       新鲜事标题
 *  @param message     用户输入的自定义内容
 *  @param description 新鲜事主题内容
 *  @param url         新鲜事标题和图片指向的链接
 *  @param delegate    self
 */
-(void)RennBaseShareTitle:(NSString *)title Message:(NSString *)message Description:(NSString *)description Url:(NSString *)url Delegate:(id)delegate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID

    if (url)
    {
        url = [YouTuiSDK SetShortUrlType:url];
    }
    PutFeedParam * param = [[PutFeedParam alloc]init];
    param.message = message;
    param.title = title;
    param.description = description;
    param.targetUrl = url;
    [RennClient sendAsynRequest:param delegate:delegate];
}
/**
 *  人人网外部资源分享---------有回调
 *
 *  @param comment  分享时用户的评论
 *  @param url      分享资源的URL
 *  @param delegate self
 */
-(void)RennBaseShareComment:(NSString *)comment Url:(NSString *)url Delegate:(id)delegate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:4 forKey:CHANNELID];   //存储频道ID

    if (url)
    {
        url = [YouTuiSDK SetShortUrlType:url];
    }
    PutShareUrlParam * param = [[PutShareUrlParam alloc]init];
    param.comment = comment;
    param.url = url;
    [RennClient sendAsynRequest:param delegate:delegate];
}

/**
 *  人人网分享错误返回的信息
 *
 *  @param ErrorNumber 错误码
 */
-(void)RennMessageErrorTips:(int)ErrorNumber
{
    NSString * message;
    switch (ErrorNumber)
    {
        case 1000:
            message = @"人人网客户端不存在或现有版本不支持,请下载最新的人人网客户端";
            break;
        case 1001:
            message = @"没有初始化AppId,ApiKey,SecretKey";
            break;
        case 1002:
            message = @"人人客户端处发送消息失败";
            break;
        case 1003:
            message = @"发送的消息不能为nil";
            break;
        case 1010:
            message = @"纯文本信息text字段不能空";
            break;
        case 1020:
            message = @"缩略图thumbData字段不能为空";
            break;
        case 1021:
            message = @"纯图片信息thumbData字段与imageUrl字段不能全为空";
            break;
        case 1022:
            message = @"纯图片信息localPath字段的文件不存在";
            break;
        case 1030:
            message = @"图文混排信息thumbData,text,title字段不能全为空";
            break;
        case 1031:
            message = @"图文混排信息url字段不能为空";
            break;
        case 1032:
            message = @"缩略图大小不能超过40kb";
            break;
        default:
            break;
    }
    if (ErrorNumber == 1000)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未安装人人网客户端" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark ----------bidaround----------
/**
 *  Post请求
 *
 *  @param url  url
 *  @param body 参数
 *
 *  @return <#return value description#>
 */
+(NSString *)PostRequestData:(NSString *)url body:(NSString *)body
{
    NSURL * URL = [NSURL URLWithString:url];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:50];
    [request setHTTPMethod:@"POST"];
    NSString * strBody = body;
    NSData * dataBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:dataBody];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString * str_data = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str_data;
}
/**
 *  获取唯一设备码
 *
 *  @return 唯一设备码
 */
+(NSString *)GetImei
{
    NSString * domain = @"com.example.myapp";
    NSString * key = @"difficult-to-guess-key";
    return [SecureUDID UDIDForDomain:domain usingKey:key];
}

/**
 *  获取SDK版本号
 *
 *  @return Verison
 */
+(NSString *)GetSDKVerison
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
/**
 *  设备名称
 *
 *  @return 设备名称
 */
+(NSString *)GetModelName
{
    return [[UIDevice currentDevice] model];
}
/**
 *  系统版本号
 *
 *  @return 系统版本号
 */
+(NSString *)GetSysVerison
{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 *  获取手机分辨率
 *
 *  @return 手机分辨率
 */
+(NSString *)GetResolution
{
    UIScreen * MainScreen = [UIScreen mainScreen];
    CGSize Size = [MainScreen bounds].size;
    CGFloat Scale = [MainScreen scale];
    return [NSString stringWithFormat:@"%.0f*%.0f",Size.width * Scale,Size.height * Scale];
}
/**
 *  获取运营商
 *
 *  @return 运营商
 */
+(NSString *)GetOperator
{
    CTTelephonyNetworkInfo * netWorkInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = netWorkInfo.subscriberCellularProvider;
    return [carrier carrierName];
}
/**
 *  网络连接类型
 *
 *  @return 网络连接
 */
+(NSString *)GetNetWorkName
{
    UIApplication * app = [UIApplication sharedApplication];
    NSArray * children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSString * NetWorkName;
    switch(type)
    {
        case 0:
        {
            NetWorkName = @"无网络";
        }
            break;
        case 1:
        {
            NetWorkName = @"2G网络";
        }
            break;
        case 2:
        {
            NetWorkName = @"3G网络";
        }
            break;
        case 3:
        {
            NetWorkName = @"4G网络";
        }
            break;
        case 5:
        {
            NetWorkName = @"WIFI";
        }
    }
    return NetWorkName;
}


/**
 *  友推平台初始化
 *
 *  @param AppId      平台注册的AppId
 *  @param inviteCode 邀请码
 *  @param appUserId  用户ID
 *  @param imei       唯一标识符
 */
+(void)connectYouTuiSDKWithAppId:(NSString *)AppId inviteCode:(NSString *)inviteCode appUserId:(NSString *)appUserId
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:AppId forKey:YTAPPID];   //AppID存进沙盒
    NSString * body = [NSString stringWithFormat:@"appId=%@&inviteCode=%@&imei=%@&appUserId=%@&sdkVersion=%@&phoneType=%@&sysVersion=%@&type=%@&resolution=%@&operator=%@&gprs=%@",AppId,inviteCode,[self GetImei],appUserId,[self GetSDKVerison],[self GetModelName],[self GetSysVerison],@"auto",[self GetResolution],[self GetOperator],[self GetNetWorkName]];
    [self PostRequestData:@"http://youtui.mobi/activity/checkCode?" body:body];
}
/**
 *  获取社交平台可以获得的积分
 */
+(NSDictionary *)GetPointRule
{
    NSString * Appid = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"imei=%@&appId=%@&phoneType=%@&sysVersion=%@",[YouTuiSDK GetImei],Appid,[YouTuiSDK GetModelName],[YouTuiSDK GetSysVerison]];
    return [[YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/sharePointRule?" body:body] JSONValue];
}
/**
 *  分享获得积分
 *
 *  @param channelid 频道ID
 *  @param Url       分享的URL
 *  @param point     积分数
 */
+(NSString *)SharePointisShare:(BOOL)isShare
{
    NSString * Appid = [YouTuiSDK GetYouTuiAppID];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dataDict = [[YouTuiSDK GetPointRule] objectForKey:@"object"];
    int channelid = (int)[defaults integerForKey:CHANNELID];    //获取沙盒中存储的频道ID
    NSString * Channelpoint = [dataDict objectForKey:[NSString stringWithFormat:@"channel%d",channelid]];
    NSString * body;
    NSString * Url = [defaults stringForKey:SHAREURL];    //获取沙盒中分享的Url
    if (isShare)
    {
        if ([Channelpoint intValue] != 0)
        {

            body = [NSString stringWithFormat:@"imei=%@&appId=%@&channelId=%d&realUrl=%@&virtualUrl=%@&shareContent=%d&isYoutui=%d&point=%@",[YouTuiSDK GetImei],Appid,channelid,Url,[YouTuiSDK GetShortUrl:Url],true,true,Channelpoint];
            return [YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/sharePoint?" body:body];
        }
        else
        {
            return @"该平台没有积分了...";
        }

    }
    else
    {
        return @"你没有设置分享";
    }
}
/**
 *  赠送积分
 *
 *  @param Point     赠送的积分数
 *  @param appUserId 到账用户Id
 */
-(NSString *)GetPoint:(NSString *)Point appUserId:(NSString *)appUserId
{
    NSString * Appid = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"imei=%@&appId=%@&givePoint=%@&appUserId=%@",[YouTuiSDK GetImei],Appid,Point,appUserId];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/givePoint?" body:body];
}
/**
 *  获得签到积分
 */
-(NSString *)GetloginPoint
{
    NSString * AppId = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"imei=%@&appId=%@",[YouTuiSDK GetImei],AppId];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/login?" body:body];
}
/**
 *  开发者自己添加积分项
 *
 *  @param PointName 用户自定义的积分项目,例如"发帖子","分享"等,具体获得分数需要在友推后台设置
 */
-(NSString *)CustomPoint:(NSString *)PointName
{
    NSString * AppId = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"pointName=%@&imei=%@&appId=%@",PointName,[YouTuiSDK GetImei],AppId];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/customPoint?" body:body];
}
/**
 *  获取用户积分数
 *
 *  @param AppUserId 用户Id
 */
-(NSString *)addUserPointAppUserId:(NSString *)AppUserId
{
    NSString * AppId = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"appId=%@&appUserId=%@",AppId,AppUserId];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/app/getPoint?" body:body];
}
/**
 *  扣除用户积分
 *
 *  @param AppUserId   用户Id
 *  @param reducePoint 减少的积分数
 *  @param reason      扣除积分的原因
 */
-(NSString *)reduceUserPointAppUserId:(NSString *)AppUserId reducePoint:(NSString *)reducePoint reason:(NSString *)reason
{
    NSString * Appid = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"appId=%@&appUserId=%@&reducePoint=%@&reason=%@",Appid,AppUserId,reducePoint,reason];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/app/reducePoint?" body:body];
}
/**
 *  用户积分明细
 *
 *  @param AppUserId 用户Id
 */
-(NSString *)checkUserPointAppUserId:(NSString *)AppUserId
{
    NSString * AppId = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"appId=%@&appUserId=%@",AppId,AppUserId];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/app/allRecord?" body:body];
}
/**
 *  关闭应用时发送相关信息
 */
-(NSString *)CloseApp
{
    NSString * AppId = [YouTuiSDK GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"appId=%@&imei=%@",AppId,[YouTuiSDK GetImei]];
    return [YouTuiSDK PostRequestData:@"http://youtui.mobi/activity/closeApp?" body:body];
}

/**
 *  获得存在沙盒中的平台AppID
 *
 *  @return AppID
 */
+(NSString *)GetYouTuiAppID
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:YTAPPID];
}
/**
 *  积分商城URLRequest
 *
 *  @return URLRequest
 */
+(NSURLRequest *)getPointStoreRequest
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://youtui.mobi/activity/comExchange?appId=%@&imei=%@",[self GetYouTuiAppID],[self GetImei]]]];
}
/**
 *  获取友推后台设置的分享内容
 *
 *  @return 分享内容字典
 */
+(NSDictionary *)GetShareContent
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * body = [NSString stringWithFormat:@"appId=%@&imei=%@",[defaults stringForKey:YTAPPID],[self GetImei]];
    NSDictionary * ContentDict = [[self PostRequestData:@"http://youtui.mobi/app/shareContent?" body:body] JSONValue];
    return ContentDict;
}

//长链接和短链接上传到服务器
+(void)RecordUrl:(NSString *)longurl
{
    NSString * AppId = [self GetYouTuiAppID];
    NSUserDefaults * defaluts = [NSUserDefaults standardUserDefaults];
    NSString * body = [NSString stringWithFormat:@"imei=%@&appId=%@&channelId=%@&realUrl=%@&virtualUrl=%@&isYoutui=%@",[self GetImei],AppId,[defaluts stringForKey:CHANNELID],[self URLEncode:longurl],[self GetShortUrl:longurl],@"true"];
    [self PostRequestData:@"http://youtui.mobi/activity/recordUrl?" body:body];
}
//URl中编码..(URL中可能含有=,会被判断成参数,所以要进行解码...)
+(NSString *)URLEncode:(NSString *)UrlString
{
    NSString * encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)UrlString,NULL,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8));
    return encodeString;
}

//MD5加密
+(NSString *)GetMD5Data:(NSString *)SrcString
{
    if (SrcString == nil || [SrcString isEqualToString:@""])
    {
        return SrcString;
    }
    else
    {
    const char * cStr = [SrcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest);
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x",digest[i]];
    }
        return result;
    }
    
}
//拼接公司短链接
+(NSString *)GetCompanyShortUrl:(NSString *)url
{
    NSString * shorturl = [self GetShortUrl:url];
    [self RecordUrl:url];
    url = [@"http://youtui.mobi/link/" stringByAppendingString:shorturl];
    return url;
}

//获取短链接
+(NSString *)GetShortUrl:(NSString *)longurl
{
    return [[[YouTuiSDK GetMD5Data:longurl] substringToIndex:8] uppercaseString];
}


//获取后台设置的短链接
+(NSDictionary *)GetShortUrlType
{
    NSString * appid = [self GetYouTuiAppID];
    NSString * body = [NSString stringWithFormat:@"appId=%@",appid];
    NSDictionary * dataDict = [[self PostRequestData:@"http://youtui.mobi/app/infoById?" body:body] JSONValue];
    return dataDict;
}

//短链接类型
+(NSString *)SetShortUrlType:(NSString *)url
{
    
    NSDictionary * shortUrlType = [self GetShortUrlType];
    NSString * Type = [NSString stringWithFormat:@"%@",[[shortUrlType objectForKey:@"object"] objectForKey:@"statisticsType"]];
    NSString * otherUrl = [[NSString alloc]init];
    if ([Type isEqualToString:@"1"] || [Type isEqualToString:@""])
    {
        otherUrl = [self GetCompanyShortUrl:url];
    }
    else if ([Type isEqualToString:@"2"])
    {
        if ([[NSString stringWithFormat:@"%@",[[shortUrlType objectForKey:@"object"] objectForKey:@"effect"]] isEqualToString:@"false"])
        {
            otherUrl = [self GetCompanyShortUrl:url];
        }
        else
        {
            [self RecordUrl:url];

            otherUrl = [NSString stringWithFormat:@"%@%@%@%@",[[shortUrlType objectForKey:@"object"]objectForKey:@"infoURL"],[[shortUrlType objectForKey:@"object"]objectForKey:@"linkUrl"],@"/link/",[self GetShortUrl:url]];
        }
    }
    else if ([Type isEqualToString:@"3"])
    {
        [self RecordUrl:url];
        if ([url rangeOfString:@"?"].location != NSNotFound)  //存在?号
        {
            otherUrl = [url stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"&youtui=",[self GetShortUrl:url]]];
        }
        else
        {
            otherUrl = [url stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"?youtui=",[self GetShortUrl:url]]];
        }
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:SHAREURL];     //把要分享的Url存进沙盒
    return otherUrl;
}
@end
