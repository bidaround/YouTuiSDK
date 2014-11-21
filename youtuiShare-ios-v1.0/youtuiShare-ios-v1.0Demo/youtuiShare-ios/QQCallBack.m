//
//  QQCallBack.m
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "QQCallBack.h"
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
    
    ShowAlertss(@"Results", message)

}
/**
 *  QQ登陆成功后的回调
 */
-(void)tencentDidLogin
{
    [_YTsdk QQGetUserInfo];    //授权成功回调后调用此接口,返回执行代理方法getUserInfoResponse:
}
/**
 *  登陆失败后的回调
 *
 */
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    ShowAlertss(nil, @"QQ登陆失败")
}
/**
 *  退出登陆的回调
 */
-(void)tencentDidLogout
{
    ShowAlertss(nil, @"您取消了QQ授权")
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
        
        ShowAlertss(@"QQ授权用户信息", str)
        DLog(@"QQ授权用户信息:%@",str);
    }
    else
    {
        ShowAlertss(@"获取用户信息失败", response.errorMsg)
    }
}

/**
 *  登陆时网络有问题的回调
 */
-(void)tencentDidNotNetWork
{
    ShowAlertss(nil, @"请检查网络链接")
}
@end
