//
//  Header.h
//  youtuiShare-ios
//
//  Created by FreeGeek on 14-10-21.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[函数名:%s]" "[行号:%d]" fmt),__FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#define ShowAlertss(title,msg) [[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];

#ifndef youtuiShare_Header_h
#define youtuiShare_Header_h

//友推AppKey
#define YOUTUIAPPKEY @"516291"
#define AppUserID [YouTuiSDK GetImei]  //开发者需要自己定义识别用户的ID

//腾讯微博
#define TCWBAppKey @"801539039"
#define TCWBAppSecret @"113db01894f131b9710337bd051ebe7c"
#define TCWBURL @"http://youtui.mobi/"

//新浪
#define SinaWBAppKey @"2444270328"
//#define SinaWBAppSecret @"00395da5d1d1101884352560de66f3e7"
#define SinaWBURI @"http://youtui.mobi/weiboResponse"


//微信
#define WXAppKey @"wx9b22d040f715ba8b"
#define WXAppSecret @"bf0ed46a704bb95e6ad2bde9f27397a4"

//QQ
#define QQAppID @"1103403951"
#define QQURI @"http://youtui.mobi"
//人人
#define RennAPPID @"244110"
#define RennAPIKEY @"b1a80ac1aa694090bfb9aa3a590f2161"
#define RennSecretKey @"506ccdbda36046d197801e79c4ebba23"

#define RENNAUTH @"RENNAUTH"


#endif
