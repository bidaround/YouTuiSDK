//
//  YouTuiSDK.h
//  YouTuiSDK
//
//  Created by FreeGeek on 14-10-19.
//  Copyright (c) 2014年 FreeGeek. by Gz.bidaround----Version: 1.1
//

#import <Foundation/Foundation.h>
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "RennShareComponent.h"
#import <MessageUI/MessageUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <RennSDK/RennSDK.h>
@interface YouTuiSDK : NSObject
#pragma mark ----------短信分享----------
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
-(void)ShareToMsg:(NSString *)message
  ReceivePhoneNum:(NSString *)receivePhoneNum
            Image:(UIImage *)image
   TypeIdentifier:(NSString *)Typeidentifier
         FileName:(NSString *)fileName
   ViewController:(id)ViewController;

#pragma mark ----------邮件分享----------
/**
 *  邮件分享
 *
 *  @param Title          标题
 *  @param body           内容
 *  @param Image          图片附件
 *  @param fileName       图片附件名称
 *  @param CcMailAddress  发送方邮件地址
 *  @param ToMailAddress  接收方邮件地址
 *  @param ViewController self
 */
-(void)ShareToMail:(NSString *)Title
       MessageBody:(NSString *)body
             Image:(UIImage *)Image
     ImageFileName:(NSString *)fileName
             SetCc:(NSString *)CcMailAddress
             SetTo:(NSString *)ToMailAddress
    ViewController:(id)ViewController;
//获得多媒体文件的MimeType
-(NSString *)MimeType:(NSString *)FileName;

#pragma mark ----------复制链接----------
/**
 *  复制链接
 *
 *  @param Link 需要复制的内容
 */
+(void)CopyLinkWithLink:(NSString *)Link;

#pragma mark ----------腾讯微博----------
/**
 *  腾讯微博平台初始化
 *
 *  @param AppKey       腾讯微博开放平台申请的AppKey
 *  @param AppSecret    腾讯微博开放平台申请的AAsecret
 *  @param RedirectUri  回调Uri
 */
-(void)connectTcWbWithAppKey:(NSString *)AppKey
                   andSecret:(NSString *)AppSecret
              andRedirectUri:(NSString *)RedirectUri;
/**
 *  腾讯微博授权
 *
 *  @param delegate           回调方法接受对象
 *  @param rootViewController 授权窗口的父窗口
 */
-(void)TcWbLoginWithDelegate:(id)delegate
           andRootController:(UIViewController *)rootViewController;
/**
 *  判断授权是否有效,包括是否已授权,授权是否已过期
 *
 *  @param delegate 回调delegate
 */
-(void)checkAuthValidDelegate:(id)delegate;

/**
 *  腾讯微博登出授权
 */
-(void)TcWbOnLogout;
/**
 *  腾讯微博客户端回调
 *
 *  @param url 启动App的URL
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL)TcWbhandleOpenURL:(NSURL *)url;
/**
 *  腾讯微博获取当前授权用户的信息
 *
 *  @param delegate 回调delegate
 */
-(void)TcWbRequestUserInfoDelegate:(id)delegate;
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
-(void)TcWbShareMessage:(NSString *)message
            andImageUrl:(NSString *)imageUrl
               VideoUrl:(NSString *)VideoUrl
              Longitude:(NSString *)longitude
               Latitude:(NSString *)latitude
               MusicUrl:(NSString *)musicUrl
             MusicTitle:(NSString *)musicTitle
            MusicAuthor:(NSString *)musicAuthor
               delegate:(id)delegate;
#pragma mark ----------新浪微博----------
/**
 *  新浪微博初始化
 *
 *  @param AppKey 新浪微博开放平台初始化
 *
 *  @return 注册成功返回YES,失败返回NO
 */
+(BOOL)connectSinaWithAppKey:(NSString *)AppKey;
/**
 *  新浪微博设置调试模式
 *
 *  @param enabled 开启或者关闭调试模式
 */
+(void)enableDebugMode:(BOOL)enabled;
/**
 *  新浪微博授权登陆
 *
 *  @param URI 授权回调URI
 */
-(void)SinaWbLogin:(NSString *)URI;
/**
 *  新浪微博登出授权接口
 *
 *  @param token    第三方应用之前申请的token
 *  @param delegate 用于接受微博SDK对于发起的接口请求的响应
 *  @param Tag      用户自定义
 */
-(void)SinaWbLogoutWithToken:(NSString *)token
                    Delegate:(id)delegate
                     WithTag:(NSString *)Tag;

/**
 *  根据用户id获取用户信息
 *
 *  @param Appkey 新浪微博开放平台申请的Appkey
 *  @param Uid    用户ID
 *
 *  @return 用户信息
 */
+(NSDictionary *)SinaGetUserInfoWithAppkey:(NSString *)Appkey Uid:(NSString *)Uid;
/**
 *  新浪微博客户端回调
 *
 *  @param url      启动App的Url
 *  @param delegate self 用于接受微博触发的消息
 *
 *  @return 回调成功返回YES,失败返回NO
 */
+(BOOL)SinaWbhandleOpenURL:(NSURL *)url
                  delegate:(id)delegate;
/**
 *  新浪微博图文分享
 *
 *  @param message 文本内容
 *  @param Image   图片
 *  @param url     网页的URL
 */
+(void)SinaWbShareMessage:(NSString *)message
                    Image:(UIImage *)Image
                      Url:(NSString *)url;
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
+(void)SinaWbShareMessage:(NSString *)message
                       ID:(NSString *)ID
                    Title:(NSString *)title
              Description:(NSString *)description
             ThumbnaiData:(NSData *)thumbnaiData
                      Url:(NSString *)url;

/**
 *  检查用户是否安装了微博客户端程序
 *
 *  @return 已安装返回YES,未安装返回NO
 */
+(BOOL)SinaIsAppInstalled;

#pragma mark ----------微信----------
/**
 *  微信平台初始化
 *
 *  @param AppKey      微信开放平台申请的AppKey
 *  @param description 应用附加信息
 */
-(void)connectWxWithAppKey:(NSString *)AppKey
           WithDescription:(NSString *)description;
/**
 *  微信客户端回调
 *
 *  @param url      启动App的URL
 *  @param delegate 用来接受微信触发的消息
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)WxhandleOpenURL:(NSURL *)url
              delegate:(id)delegate;
/**
 *  检查微信是否被安装
 *
 *  @return 是返回YES,否返回NO
 */
+(BOOL)WxIsAppOnstalled;
/**
 *  获取微信的itunes安装地址
 *
 *  @return 微信的安装地址字符串
 */
+(NSString *)WxGetWxAppInstallUrl;
/**
 *  打开微信
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)OpenWxApp;

/**
 *  微信第三方授权登陆
 *
 *  @param state 第三方程序本身用来标识其请求的唯一性，最后跳转回第三方程序时，由微信终端回传。
 */
+(void)WxLoginWithState:(NSString *)state;

/**
 *  微信获取当前授权用户的认证信息
 *
 *  @return 认证数据
 */
+(NSDictionary *)WxAuthGetAccessTokenWithAppId:(NSString *)AppId Secret:(NSString *)Secret Code:(NSString *)code;

/**
 *  微信获取当前授权用户的个人信息
 *
 *  @param AccessToken 调用凭证
 *  @param Openid      普通用户的标识,对当前开发者账号唯一
 *
 *  @return 个人信息
 */
+(NSDictionary *)WxAuthGetUserInfoWithAccessToken:(NSString *)AccessToken Openid:(NSString *)Openid;

/**
 *  微信纯文本分享
 *
 *  @param message 文本内容       文本长度必须大于0且小于10K
 *  @param Type    分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMessage:(NSString *)message
                 Type:(int)Type;
/**
 *  微信纯图片分享
 *
 *  @param image 图片            长度不能超过32k
 *  @param Type  分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMessageWithImage:(UIImage *)image
                          Type:(int)Type;
/**
 *  微信图文分享
 *
 *  @param title       标题         长度不能超过512字节
 *  @param description 详细内容      长度不能超过1k
 *  @param image       消息缩略图     内存大小不能超过32k
 *  @param url         多媒体链接     
 *  @param Type        分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareTitle:(NSString *)title
        Description:(NSString *)description
              Image:(UIImage *)image
                Url:(NSString *)url
               Type:(int)Type;
/**
 *  微信音乐分享
 *
 *  @param title        标题            长度不能超过512字节
 *  @param description  详细内容         长度不能超过1K
 *  @param image        消息缩略图        内存大小不能超过32k
 *  @param MusicUrl     音乐网页的Url     长度不能超过10k
 *  @param MusicDataUrl 音乐数据Url      长度不能超过10k
 *  @param Type         分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareMusicTitle:(NSString *)title
             Description:(NSString *)description
                   Image:(UIImage *)image
                MusicUrl:(NSString *)MusicUrl
            MusicDataUrl:(NSString *)MusicDataUrl
                    Type:(int)Type;
/**
 *  微信多媒体分享
 *
 *  @param title       标题            长度不能超过512字节
 *  @param description 详细内容         长度不能超过1k
 *  @param image       消息缩略图        内存大小不能超过32k
 *  @param VideoUrl    视频Url          长度不能超过10k
 *  @param Type        分享类型 0:聊天界面   1:朋友圈    2:收藏
 */
-(void)WxShareVideoTitle:(NSString *)title
             Description:(NSString *)description
                   image:(UIImage *)image
                VideoUrl:(NSString *)VideoUrl
                    Type:(int)Type;
#pragma mark ----------QQ----------
/**
 *  QQ平台初始化
 *
 *  @param AppId    QQ开放平台申请的AppId
 *  @param delegate 第三方应用用于接受请求返回结果的委托对象
 *  @param Uri      授权回调页
 *
 *  @return 成功返回YES,失败返回NO
 */
-(id)connectQQWithAppId:(NSString *)AppId
               Delegate:(id)delegate
                    Uri:(NSString *)Uri;

/**
 *  检测是否已安装QQ
 *
 *  @return 已安装返回YES,未安装返回NO
 */
+(BOOL)QQisInstalled;
/**
 *  QQ客户端回调
 *
 *  @param url      启动App的URl
 *  @param delegate self
 *
 *  @return 成功返回YES,失败返回NO-
 */
+(BOOL)QQhandleOpenURL:(NSURL *)url
              delegate:(id<QQApiInterfaceDelegate>)delegate;
/**
 *  QQ登陆授权
 *
 *  @param AppId            QQ
 *  @param delegate         self
 *  @param permissionsArray 授权信息列
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL)QQAuthorizeAppId:(NSString *)AppId
               Delegate:(id)delegate;
/**
 *  QQ登出授权
 *
 *  @param delegate 成功返回YES,失败返回NO
 */
+(void)QQLogoutDeleaget:(id)delegate;
/**
 *  QQ获取当前授权用户信息
 */
-(void)QQGetUserInfo;
/**
 *  QQ纯文本分享
 *
 *  @param text 文本内容   (只支持分享到QQ,不支持分享到QQ空间)
 */
-(void)QQShareTextContent:(NSString *)text;
/**
 *  QQ图片分享  (只支持分享到QQ,不支持分享到QQ空间)
 *
 *  @param image       图片
 *  @param title       标题
 *  @param description 详细内容
 */
-(void)QQShareImage:(UIImage *)image
              Title:(NSString *)title
        Description:(NSString *)description;
/**
 *  QQ新闻分享------本地图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       图片
 *  @param Url         分享跳转Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareNewsTitle:(NSString *)title
            Description:(NSString *)description
                  Image:(UIImage *)image
                    Url:(NSString *)url
                   Type:(int)Type;
/**
 *  QQ新闻分享-------网络图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param imageUrl    图片Url
 *  @param url         分享跳转Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareMediaTitle:(NSString *)title
             Description:(NSString *)description
                ImageUrl:(NSString *)imageUrl
                     url:(NSString *)url
                    Type:(int)Type;
/**
 *  QQ音乐分享--------本地图片
 *
 *  @param title         标题
 *  @param description   详细内容
 *  @param image         图片
 *  @param url           分享跳转Url
 *  @param MusicURL 音乐URL
 *  @param Type          分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareAudioTitle:(NSString *)title
             Description:(NSString *)description
                   Image:(UIImage *)image
                     Url:(NSString *)url
                MusicURL:(NSString *)MusicURL
                    Type:(int)Type;
/**
 *  QQ音乐分享------网络图片
 *
 *  @param title         标题
 *  @param description   详细内容
 *  @param imageUrl      图片Url
 *  @param url           分享跳转Url
 *  @param MusicURL 音乐URL
 *  @param Type          分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareAudioTitle:(NSString *)title
             Description:(NSString *)description
                ImageUrl:(NSString *)imageUrl
                     Url:(NSString *)url
                MusicURL:(NSString *)MusicUrl
                    Type:(int)Type;
/**
 *  QQ视频分享-----本地图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param image       图片
 *  @param VideoUrl    视频Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareVideoTitle:(NSString *)title
             Description:(NSString *)description
                   Image:(UIImage *)image
                VideoUrl:(NSString *)VideoUrl
                    Type:(int)Type;
/**
 *  QQ视频分享-------网络图片
 *
 *  @param title       标题
 *  @param description 详细内容
 *  @param imageUrl    图片Url
 *  @param VideoUrl    视频Url
 *  @param Type        分享路径  0:分享到QQ   1:分享到QQ空间
 */
-(void)QQShareVideoTitle:(NSString *)title
             Description:(NSString *)description
                ImageUrl:(NSString *)imageUrl
                VideoUrl:(NSString *)VideoUrl
                    Type:(int)Type;

#pragma mark ----------人人网----------
/**
 *  人人网平台初始化
 *
 *  @param AppId     人人网开放平台申请的AppId
 *  @param ApiKey    人人网开放平台申请的ApiKey
 *  @param secretKey 人人网开放平台申请的secretKey
 */
-(void)connectRennWithAppId:(NSString *)AppId
                     ApiKey:(NSString *)ApiKey
                  SecretKey:(NSString *)secretKey;
/**
 *  人人网客户端回调
 *
 *  @param url 启动App的URL
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL)RennHandleOpenURL:(NSURL *)url;
/**
 *  人人网授权
 *
 *  @param delegate self
 */
-(void)RennLoginWithDelegate:(id)delegate;
/**
 *  人人网登出
 *
 *  @param delegate self
 */
-(void)RennLogoutWithDelegate:(id)delegate;
/**
 *  人人网获取当前授权用户的信息
 *
 *  @param delegate self
 */
-(void)RennGetUserInfoDelegate:(id)delegate;
/**
 *  人人网纯文本分享  (只支持对话分享,不支持新鲜事分享)
 *
 *  @param title 标题        长度不能超过50字
 *  @param text  文本内容     长度不能超过200字
 *  @param url   跳转链接     长度不能能超过2000字节
 */
-(void)RennShareTitle:(NSString *)title
                 Text:(NSString *)text
                  Url:(NSString *)url;
/**
 *  人人网纯图片分享
 *
 *  @param title         标题          长度不能超过50字
 *  @param imageUrl      图片url       长度不能超过2000字节
 *  @param localImage    真是图片数据    大小不能超过10M
 *  @param thumbData     消息缩略图      大小不能超过40k
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 *********   PS:imageUrl与localPath为缩略图点击放大后图片信息，该两个字段不能同时为空，两个字段同时存在时默认取localPath进行处理。*******
 */
-(void)RennShareTitle:(NSString *)title
             ImageUrl:(NSString *)imageUrl
            LocalPath:(UIImage *)localImage
            ThumbData:(UIImage *)thumbData
        MessageTarget:(MessageTarget)MessageTarget;
/**
 *  人人网图文分享
 *
 *  @param title         标题          长度不能超过50字
 *  @param url           跳转链接       长度不能超过2000字节
 *  @param description   详细内容       长度不能超过2000字
 *  @param thumbData     缩略图         大小不能超过40k
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 */
-(void)RennShareTitle:(NSString *)title
                  Url:(NSString *)url
          Description:(NSString *)description
            ThumbData:(UIImage *)thumbData
        MessageTarget:(MessageTarget)MessageTarget;
/**
 *  人人网视频分享
 *
 *  @param title         标题           长度不能超过50字
 *  @param description   详细内容        长度不能超过2000字
 *  @param Url           视频来源Url     长度不能超过2000字节
 *  @param thumbData     缩略图          大小不能超过40k
 *  @param MessageTarget 分享路径    To_Talk :分享至好友对话    To_Renen :分享至新鲜事
 */
-(void)RennShareVideoTitle:(NSString *)title
               Description:(NSString *)description
                  VideoUrl:(NSString *)Url
                 ThumbData:(UIImage *)thumbData
             MessageTarget:(MessageTarget)MessageTarget;
/**
 *  人人网新鲜事分享------有回调
 *
 *  @param title       新鲜事标题          长度不能超过30字符
 *  @param message     用户输入的自定义内容  长度不能超过200字符
 *  @param description 新鲜事主题内容       长度不能超过200字符
 *  @param url         新鲜事标题和图片指向的链接
 *  @param delegate    self
 */
-(void)RennBaseShareTitle:(NSString *)title
                  Message:(NSString *)message
              Description:(NSString *)description
                      Url:(NSString *)url
                 Delegate:(id)delegate;
/**
 *  人人网外部资源分享
 *
 *  @param comment  分享时用户的评论    长度不能超过500字符
 *  @param url      分享资源的URL
 *  @param delegate self
 */
-(void)RennBaseShareComment:(NSString *)comment
                        Url:(NSString *)url
                   Delegate:(id)delegate;

#pragma mark ----------友推积分系统----------
/**
 *  友推平台初始化
 *
 *  @param AppId      平台注册的AppId
 *  @param inviteCode 邀请码
 *  @param appUserId  用户ID
 *  @param imei       唯一标识符
 */
+(void)connectYouTuiSDKWithAppId:(NSString *)AppId
                      inviteCode:(NSString *)inviteCode
                       appUserId:(NSString *)appUserId;

/**
 *  分享获得积分
 *
 *  @param channelid 频道ID
 *  @param Url       分享的URL
 *  @param point     积分数
 */
+(NSString *)SharePointisShare:(BOOL)isShare;
/**
 *  获取社交平台可以获得的积分
 */
+(NSDictionary *)GetPointRule;
/**
 *  获取唯一设备码
 *
 *  @return 唯一设备码
 */
+(NSString *)GetImei;
/**
 *  积分商城URLRequest
 *
 *  @return URLRequest
 */
+(NSURLRequest *)getPointStoreRequest;
/**
 *  获取友推后台设置的分享内容
 *
 *  @return 分享内容字典
 */
+(NSDictionary *)GetShareContent;

/**
 *  赠送积分
 *
 *  @param Point     赠送的积分数
 *  @param appUserId 到账用户Id
 */
-(NSString *)GetPoint:(NSString *)Point
            appUserId:(NSString *)appUserId;

/**
 *  获得签到积分
 */
-(NSString *)GetloginPoint;

/**
 *  开发者自己添加积分项
 *
 *  @param PointName 用户自定义的积分项目,例如"发帖子","分享"等,具体获得分数需要在友推后台设置
 */
-(NSString *)CustomPoint:(NSString *)PointName;
/**
 *  获取用户积分数
 *
 *  @param AppUserId 用户Id
 */
-(NSString *)addUserPointAppUserId:(NSString *)AppUserId;

/**
 *  扣除用户积分
 *
 *  @param AppUserId   用户Id
 *  @param reducePoint 减少的积分数
 *  @param reason      扣除积分的原因
 */
-(NSString *)reduceUserPointAppUserId:(NSString *)AppUserId
                          reducePoint:(NSString *)reducePoint
                               reason:(NSString *)reason;

/**
 *  用户积分明细
 *
 *  @param AppUserId 用户Id
 */
-(NSString *)checkUserPointAppUserId:(NSString *)AppUserId;

/**
 *  关闭应用时发送相关信息
 */
-(NSString *)CloseApp;
@end


#pragma mark ----------短信代理回调----------
@protocol MessageCallBackDelegate<NSObject,MFMessageComposeViewControllerDelegate>
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result;
@end

#pragma mark ----------邮件代理回调----------
@protocol MailCallBackDelegate<NSObject,MFMailComposeViewControllerDelegate>
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
@end

#pragma mark ----------腾讯微博代理方法----------
//授权回调
@protocol TcWbAuthDelegate<NSObject,WeiboAuthDelegate>
@optional
/**
 *  腾讯微博授权成功的回调
 *
 *  @param wbobj 成功后返回的对象,accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 */
-(void)DidAuthFinished:(WeiboApiObject *)wbobj;
/**
 *  腾讯微博授权取消后的回调
 *
 *  @param wbobj 取消授权后,授权信息会被清空
 */
-(void)DidAuthCanceled:(WeiboApiObject *)wbobj;
/**
 *  腾讯微博授权失败后的回调
 *
 *  @param error 标准出错信息
 */
-(void)DidAuthFailWithError:(NSError *)error;
/**
 *  选择使用服务器验证token有效性时,需实现此回调 
 *
 *  @param bResult       检查结果,YES为有效,NO为无效
 *  @param strSuggestion 当bResult 为NO时,此参数为建议
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion;
@end

//腾讯微博分享回调
@protocol TcWbRequestDelegate <NSObject,WeiboRequestDelegate>
@optional
/**
 *  腾讯微博分享成功后的回调
 *
 *  @param data  接口返回的数据
 */
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno;
/**
 *  腾讯微博分享失败后的回调
 *
 *  @param error 接口返回的错误信息
 */
-(void)didFailWithError:(NSError *)error reqNo:(int)reqno;
/**
 *  腾讯微博分享失败,且失败原因为授权无效
 *
 *  @param error 接口返回的错误信息
 */
-(void)didNeedRelogin:(NSError *)error reqNo:(int)reqno;
@end

#pragma mark ----------新浪微博代理方法----------
@protocol SinaWbDelegate<NSObject,WeiboSDKDelegate,WBHttpRequestDelegate>
@optional
/**
 *  收到新浪微博客户端程序的请求
 *
 *  @param request 具体的请求对象
 */
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request;
/**
 *  收到新浪微博客户端的相应
 *
 *  @param response 具体的相应对象
 */
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response;
@end

#pragma mark ----------微信和QQ代理方法----------
@protocol WxandQQDelegate<NSObject,WXApiDelegate,QQApiInterfaceDelegate>
/**
 *  微信和QQ分享的回调方法
 *
 *  @param resp <#resp description#>
 */
-(void)onResp:(BaseResp *)resp;
@optional
/**
 *  微信和QQ的发送分享信息
 *
 *  @param req <#req description#>
 */
-(void)onReq:(BaseReq *)req;
@end

//QQ授权回调
@protocol QQAuthDelegate <NSObject,TencentSessionDelegate>
@optional
/**
 *  QQ获取用户个人信息的回调
 *
 *  @param response API返回结果
 */
-(void)getUserInfoResponse:(APIResponse *)response;

/**
 *  QQ授权成功的回调
 */
-(void)tencentDidLogin;

/**
 *  QQ授权失败的回调
 *
 *  @param cancelled 代表用户是否主动退出登录
 */
-(void)tencentDidNotLogin:(BOOL)cancelled;

/**
 *  QQ取消授权的回调
 */
-(void)tencentDidLogout;

/**
 *  登陆时网络有问题的回调
 */
-(void)tencentDidNotNetWork;
@end

#pragma mark ----------人人网代理方法----------
@protocol RenRenLoginDelegate<NSObject,RennLoginDelegate>
/**
 *  人人网授权成功的回调
 */
-(void)rennLoginSuccess;

/**
 *  人人网登出的回调
 */
-(void)rennLogoutSuccess;

/**
 *  人人网授权失败的回调
 *
 *  @param error 错误信息
 */
-(void)rennLoginDidFailWithError:(NSError *)error;

/**
 *  人人网取消登陆的回调
 */
-(void)rennLoginCancelded;
@end

@protocol RenRenServiveDelegate <NSObject,RennServiveDelegate>
/**
 *  人人网获取用户信息成功的回调
 *
 *  @param service  <#service description#>
 *  @param response 成功的回调对象
 */
-(void)rennService:(RennService *)service requestSuccessWithResponse:(id)response;

/**
 *  人人网获取用户信息失败的回调
 *
 *  @param service <#service description#>
 *  @param error   错误信息
 */
-(void)rennService:(RennService *)service requestFailWithError:(NSError *)error;
@end

