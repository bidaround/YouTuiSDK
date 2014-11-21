//
//  WxCallBack.m
//  youtuiShare-ios
//
//  Created by FreeGeek on 14-11-21.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "WxCallBack.h"
@implementation WxCallBack
-(instancetype)init
{
    if (_YTsdk == nil)
    {
        _YTsdk = [[YouTuiSDK alloc]init];
    }
    return self;
}
-(void)onResp:(BaseResp *)resp
{
    NSString * message;
    /**
     *  微信分享回调
     */
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
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
    ShowAlertss(@"Results", message)
}
-(void)onReq:(BaseReq *)req
{
    
}
@end
