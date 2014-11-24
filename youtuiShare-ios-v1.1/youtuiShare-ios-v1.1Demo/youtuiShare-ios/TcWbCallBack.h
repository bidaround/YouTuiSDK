//
//  TcWbCallBack.h
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTuiSDK.h"
@interface TcWbCallBack : NSObject<TcWbRequestDelegate,TcWbAuthDelegate>
@property (strong , nonatomic) YouTuiSDK * YTsdk;
@end
