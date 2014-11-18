//
//  QQCallBack.m
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "QQCallBack.h"
#import "Header.h"
@implementation QQCallBack
-(instancetype)init
{
    if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    return self;
}
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
        
        DLog(@"QQ分享完毕返回数据");
        DLog(@"请求处理结果是:%@",sendQQResp.result); //-- result = 0 分享成功, 其余分享失败
        DLog(@"具体错误描述信息:%@",sendQQResp.errorDescription);
        DLog(@"相应类型:%d",sendQQResp.type);
        DLog(@"扩展信息:%@",sendQQResp.extendInfo);
        
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
        
        DLog(@"微信分享完毕返回数据");
        DLog(@"错误码:%d",sendWXResp.errCode);
        DLog(@"错误提示字符串:%@",sendWXResp.errStr);
        DLog(@"相应类型:%d",sendWXResp.type);
        
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
            DLog(@"返回码:%@",sendAuth.code);
            DLog(@"状态:%@",sendAuth.state);
            //获取授权凭证
            NSDictionary * AuthDict = [YouTuiSDK WxAuthGetAccessTokenWithAppId:WXAppKey Secret:WXAppSecret Code:sendAuth.code];
            //获取用户信息
            NSDictionary * UserInfo = [YouTuiSDK WxAuthGetUserInfoWithAccessToken:[AuthDict objectForKey:@"access_token"] Openid:[AuthDict objectForKey:@"openid"]];
            message = [NSString stringWithFormat:@"%@",UserInfo];

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

-(void)ShowAlertTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
}

@end
