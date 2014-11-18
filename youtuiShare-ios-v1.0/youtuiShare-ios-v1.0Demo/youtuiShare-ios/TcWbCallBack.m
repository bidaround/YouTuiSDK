//
//  TcWbCallBack.m
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "TcWbCallBack.h"
#import "Header.h"
#import "ViewController.h"
@implementation TcWbCallBack
-(instancetype)init
{
    if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    //腾讯微博平台初始化 http://dev.t.qq.com/
    [_YTsdk connectTcWbWithAppKey:TCWBAppKey andSecret:TCWBAppSecret andRedirectUri:TCWBURL];
    
    return self;
}

#pragma mark ----------腾讯微博代理回调方法----------

/**
 *  腾讯微博授权成功的回调
 *
 *  @param wbobj 返回的对象
 */
-(void)DidAuthFinished:(WeiboApiObject *)wbobj
{
//    ViewController * VC = [[ViewController alloc]init];
    [_YTsdk TcWbRequestUserInfoDelegate:self];   //登陆成功获取当前授权用户的信息
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
    NSString * message = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];

//        /**
//         *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
//         */
//        [YouTuiSDK SharePointisShare:YES];
    
    [self ShowAlertTitle:@"Results" andMessage:[NSString stringWithFormat:@"%@",message]];
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TCWBSHAREUI" object:nil];
        DLog(@"腾讯微博授权有效");
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TCWBAUTH" object:nil];
        DLog(@"腾讯微博授权无效");
    }
}
-(void)ShowAlertTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
}

@end
