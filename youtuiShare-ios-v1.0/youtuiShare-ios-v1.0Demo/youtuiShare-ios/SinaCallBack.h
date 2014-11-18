//
//  SinaCallBack.h
//  YoutuiSDKDemo
//
//  Created by FreeGeek on 14-11-12.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTuiSDK.h"
@interface SinaCallBack : NSObject<SinaWbDelegate>
@property (strong , nonatomic) NSString * TokenStr;
@end
