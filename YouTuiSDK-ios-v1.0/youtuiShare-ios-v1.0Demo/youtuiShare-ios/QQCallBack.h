//
//  QQCallBack.h
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTuiSDK.h"
@interface QQCallBack : NSObject<WxandQQDelegate,QQAuthDelegate>
@property (strong , nonatomic) YouTuiSDK * YTsdk;
@end
