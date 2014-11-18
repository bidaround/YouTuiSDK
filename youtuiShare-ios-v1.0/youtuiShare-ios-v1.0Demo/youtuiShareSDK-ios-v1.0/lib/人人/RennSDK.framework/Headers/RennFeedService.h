//
//  RennFeedService.h
//  RennSDK
//
//  Created by Li Chengliang on 13-4-10.
//  Copyright (c) 2013年 Li Chengliang. All rights reserved.
//

#import "RennParam.h"

extern NSString *kRennServiceTypePutFeed;
extern NSString *kRennServiceTypeListFeed;

/*
 API链接: http://wiki.dev.renren.com/wiki/V2/feed/put
 */
@interface PutFeedParam : RennParam
//必选
@property (nonatomic, strong) NSString *message;
//必选
@property (nonatomic, strong) NSString *title;
//可选
@property (nonatomic, strong) NSString *actionTargetUrl;
//可选
@property (nonatomic, strong) NSString *imageUrl;
//必选
@property (nonatomic, strong) NSString *description;
//可选
@property (nonatomic, strong) NSString *subtitle;
//可选
@property (nonatomic, strong) NSString *actionName;
//必选
@property (nonatomic, strong) NSString *targetUrl;

@end


/*
 API链接: http://wiki.dev.renren.com/wiki/V2/feed/list
 */
@interface ListFeedParam : RennParam
//可选
@property (nonatomic, retain) NSString *feedType;
//可选
@property (nonatomic, retain) NSString *userId;
//可选
@property (nonatomic, assign) NSInteger pageSize;
//可选
@property (nonatomic, assign) NSInteger pageNumber;

@end


