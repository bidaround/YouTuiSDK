//
//  TcWbCallBack.h
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTuiSDK.h"
#import "ViewController.h"
@interface TcWbCallBack : NSObject<TcWbRequestDelegate,TcWbAuthDelegate>
{
    BOOL  isTcWbAuth;
}
@property (strong , nonatomic) YouTuiSDK * YTsdk;
@property (strong , nonatomic) ViewController * view;
@end
