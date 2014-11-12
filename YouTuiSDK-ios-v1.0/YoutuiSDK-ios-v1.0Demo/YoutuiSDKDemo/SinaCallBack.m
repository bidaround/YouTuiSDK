//
//  SinaCallBack.m
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "SinaCallBack.h"

@implementation SinaCallBack
#pragma mark ----------新浪微博分享回调----------
/**
 *  收到新浪微博客户端的相应
 *
 *  @param response 具体的相应对象
 */
#pragma mark 新浪微博授权回调
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"分享结果";
        //        response.statusCode    响应状态码
        //         0 :  成功
        //        -1 :  用户取消发送
        //        -2 :  发送失败
        //        -3 :  授权失败
        //        -4 :  用户取消安装微博客户端
        //        -99:  不支持的请求
        //    response.userInfo         用户信息
        //    response.requestUserInfo  用户详细信息
        
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        /**
         *  分享成功以后,获取友推后台的对应积分 isShare 是否为友推分享
         */
        [YouTuiSDK SharePointisShare:YES];
    }
    else if([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //        response.statusCode    响应状态码
        //         0 :  成功
        //        -1 :  用户取消发送
        //        -2 :  发送失败
        //        -3 :  授权失败
        //        -4 :  用户取消安装微博客户端
        //        -99:  不支持的请求
        
        //        [(WBAuthorizeResponse *)response userInfo]        用户信息
        //        [(WBAuthorizeResponse *)response userID]          用户ID
        //        [(WBAuthorizeResponse *)response accessToken]     认证口令
        //        response.requestUserInfo                          用户详细信息
        NSLog(@"响应状态码:%d",response.statusCode);
        _TokenStr = [(WBAuthorizeResponse *)response accessToken];   //授权获得的认证口令,登出的时候需要调用它
        NSString * message = [NSString stringWithFormat:@"用户信息:%@",response.userInfo];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"新浪微博授权用户信息"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  收到新浪微博客户端程序的请求
 *
 *  @param request 具体的请求对象
 */

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"---");
}
@end
