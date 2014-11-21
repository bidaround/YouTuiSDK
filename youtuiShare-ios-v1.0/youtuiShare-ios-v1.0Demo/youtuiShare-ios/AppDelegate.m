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
    
    _QQCB = [[QQCallBack alloc]init];
    _TcWbCB = [[TcWbCallBack alloc]init];
    _SinaCB = [[SinaCallBack alloc]init];
    _WxCB = [[WxCallBack alloc]init];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //取得开发者设置的URL Schemes  通过前缀来判断回调
    NSString * UrlStr = [url absoluteString];
    if ([UrlStr hasPrefix:@"wx"])
    {
        DLog(@"微信客户端回调");
        return [YouTuiSDK WxhandleOpenURL:url delegate:_WxCB];
    }
    else if ([UrlStr hasPrefix:@"wb"])
    {
        if ([sourceApplication isEqualToString:@"com.sina.weibo"])
        {
            DLog(@"新浪微博客户端回调");
            return [YouTuiSDK SinaWbhandleOpenURL:url delegate:_SinaCB];
        }
        else
        {
            DLog(@"腾讯微博回调");
            return [_TcWbCB.YTsdk TcWbhandleOpenURL:url];
        }
    }
    else if ([UrlStr hasPrefix:@"tencent"])
    {
        DLog(@"QQ回调");
        return [YouTuiSDK QQhandleOpenURL:url delegate:_QQCB];
    }
    else if ([UrlStr hasPrefix:@"rm"])
    {
        DLog(@"人人网回调");
        return [YouTuiSDK RennHandleOpenURL:url];
    }
    return YES;
}
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
