//
//  AppDelegate.h
//  YouTuiSDKDemo
//
//  Created by FreeGeek on 14-10-20.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "QQCallBack.h"
#import "TcWbCallBack.h"
#import "SinaCallBack.h"
#import "WxCallBack.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong , nonatomic) UIWindow *window;
@property (strong , nonatomic) NSString * TokenStr;
@property (strong , nonatomic) ViewController * ViewDelegate;
@property (strong , nonatomic) QQCallBack * QQCB;
@property (strong , nonatomic) TcWbCallBack * TcWbCB;
@property (strong , nonatomic) SinaCallBack * SinaCB;
@property (strong , nonatomic) WxCallBack * WxCB;
@end

