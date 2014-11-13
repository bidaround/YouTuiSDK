//
//  LXActivity.h
//  LXActivityDemo
//
//  Created by lixiang on 14-3-17.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXActivityDelegate <NSObject>
- (void)didClickOnImageIndex:(NSInteger *)imageIndex;
/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
- (void)LXgoToPointStoreAction;

@optional
- (void)didClickOnCancelButton;
@end

@interface LXActivity : UIView

- (id)initWithTitle:(NSString *)title delegate:(id<LXActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor PointArray:(NSArray *)PointArray isShowPointDescription:(BOOL)isShowPointDescription activityName:(NSString *)activityName;
- (void)showInView:(UIView *)view;














@end
