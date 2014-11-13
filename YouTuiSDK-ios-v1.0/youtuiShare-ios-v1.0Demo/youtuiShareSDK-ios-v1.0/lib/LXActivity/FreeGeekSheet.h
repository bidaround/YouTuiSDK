//
//  FreeGeekSheet.h
//  CustomSheet
//
//  Created by FreeGeek on 14-11-5.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FreeGeekDelegate <NSObject>
-(void)ShareButtonAction:(NSInteger *)buttonIndex;
@optional
-(void)goToPointStore;
@end
@interface FreeGeekSheet : UIView<UIScrollViewDelegate>
-(id)initWithTitle:(NSString *)Title Delegate:(id<FreeGeekDelegate>)delegate titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray PointArray:(NSArray *)pointArray ShowRedDot:(BOOL)ShowRedDot ActivityName:(NSString *)activityName Middle:(BOOL)Middle;
-(void)ShowInView:(UIView *)view;
@end
