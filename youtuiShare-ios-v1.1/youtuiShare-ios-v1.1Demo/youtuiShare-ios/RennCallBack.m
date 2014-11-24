//
//  RennCallBack.m
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "RennCallBack.h"
@implementation RennCallBack
-(instancetype)init
{
    if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    return self;
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
    NSString * ErrorMessage = [NSString stringWithFormat:@"%@",error];
    ShowAlertss(@"人人网授权失败",ErrorMessage)
}
/**
 *  人人网取消登陆的回调
 */
-(void)rennLoginCancelded
{
    ShowAlertss(nil, @"您取消了人人网的授权")
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
    DLog(@"用户信息:%@",response);
    NSString * UserInfo = [NSString stringWithFormat:@"%@",response];
    ShowAlertss(@"RennResults",UserInfo)
      /**
        *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
        */
//     [YouTuiSDK SharePointisShare:YES];
}
/**
 *  人人网获取当前授权用户信息失败的回调
 */
-(void)rennService:(RennService *)service requestFailWithError:(NSError *)error
{
    NSString * message = [NSString stringWithFormat:@"Error Domain = %@\nError Code = %@",[error domain],[[error userInfo] objectForKey:@"code"]];
    ShowAlertss(@"人人网获取用户信息失败",message)
}

@end
