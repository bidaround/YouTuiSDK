//
//  AppDelegate.m
//  YouTuiSDKDemo
//
//  Created by FreeGeek on 14-10-20.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate () //新浪微博代理
{
    YouTuiSDK * YTSdk;
}
@end

@implementation AppDelegate

#import "YouTuiSDK.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    /**
     *  注意 :一部设备只对应一个appUserId   appUserId为开发者自定义的用户ID
     *  AppId 替换为开发者在友推后台申请的AppKey
     *  inviteCode 邀请码
     */
    [YouTuiSDK connectYouTuiSDKWithAppId:YOUTUIAPPKEY inviteCode:@"" appUserId:AppUserID];
    
    _ViewDelegate = [[ViewController alloc]init];
    _QQCB = [[QQCallBack alloc]init];
    _TcWbCB = [[TcWbCallBack alloc]init];
    _SinaCB = [[SinaCallBack alloc]init];
    
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //取得开发者设置的URL Schemes  通过前缀来判断回调
    NSString * UrlStr = [url absoluteString];
    if ([UrlStr hasPrefix:@"wx"])
    {
        NSLog(@"微信客户端回调");
        return [YouTuiSDK WxhandleOpenURL:url delegate:_ViewDelegate];
    }
    else if ([UrlStr hasPrefix:@"wb"])
    {
        if ([sourceApplication isEqualToString:@"com.sina.weibo"])
        {
            NSLog(@"新浪微博客户端回调");
            return [YouTuiSDK SinaWbhandleOpenURL:url delegate:_SinaCB];
        }
        else
        {
            NSLog(@"腾讯微博回调");
            return [_ViewDelegate.YTsdk TcWbhandleOpenURL:url];
        }
        
    }
    else if ([UrlStr hasPrefix:@"tencent"])
    {
        NSLog(@"QQ回调");
        return [YouTuiSDK QQhandleOpenURL:url delegate:_QQCB];
    }
    else if ([UrlStr hasPrefix:@"rm"])
    {
        NSLog(@"人人网回调");
        return [YouTuiSDK RennHandleOpenURL:url];
    }
    return YES;
}

//#pragma mark ----------新浪微博分享回调----------
///**
// *  收到新浪微博客户端的相应
// *
// *  @param response 具体的相应对象
// */
//#pragma mark 新浪微博授权回调
//-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        NSString *title = @"分享结果";
//        //        response.statusCode    响应状态码
//        //         0 :  成功
//        //        -1 :  用户取消发送
//        //        -2 :  发送失败
//        //        -3 :  授权失败
//        //        -4 :  用户取消安装微博客户端
//        //        -99:  不支持的请求
//        //    response.userInfo         用户信息
//        //    response.requestUserInfo  用户详细信息
//
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        /**
//         *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
//         */
//        [YouTuiSDK SharePointisShare:YES];
//    }
//    else if([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        //        response.statusCode    响应状态码
//        //         0 :  成功
//        //        -1 :  用户取消发送
//        //        -2 :  发送失败
//        //        -3 :  授权失败
//        //        -4 :  用户取消安装微博客户端
//        //        -99:  不支持的请求
//        
//        //        [(WBAuthorizeResponse *)response userInfo]        用户信息
//        //        [(WBAuthorizeResponse *)response userID]          用户ID
//        //        [(WBAuthorizeResponse *)response accessToken]     认证口令
//        //        response.requestUserInfo                          用户详细信息
//        NSLog(@"响应状态码:%d",response.statusCode);
//        _TokenStr = [(WBAuthorizeResponse *)response accessToken];   //授权获得的认证口令,登出的时候需要调用它
//        NSString * message = [NSString stringWithFormat:@"用户信息:%@\n用户ID:%@",response.userInfo,[(WBAuthorizeResponse *)response userID]];
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"新浪微博授权用户信息"
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"好"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}
///**
// *  收到新浪微博客户端程序的请求
// *
// *  @param request 具体的请求对象
// */
//
//-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    NSLog(@"---");
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    /**
     *  关闭应用时调用此方法,记录时间
     */
    [YTSdk CloseApp];
}

@end
