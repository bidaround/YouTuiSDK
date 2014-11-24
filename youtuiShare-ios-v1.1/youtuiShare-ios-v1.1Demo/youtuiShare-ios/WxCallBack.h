//
//  WxCallBack.h
//  youtuiShare-ios
//
//  Created by FreeGeek on 14-11-21.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTuiSDK.h"
@interface WxCallBack : NSObject<WxandQQDelegate>
@property (strong , nonatomic) YouTuiSDK * YTsdk;
@end
