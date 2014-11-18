//
//  GiftTalkSheetView.h
//  SystemSheetView
//
//  Created by FreeGeek on 14-11-13.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GiftTalkSheetDelegate<NSObject>
-(void)SeaYeungShareButtonAction:(NSInteger *)buttonIndex;
@end
@interface GiftTalkSheetView : UIView
-(id)initWithTitleArray:(NSArray *)titleArray ImageArray:(NSArray *)imageArray Delegate:(id<GiftTalkSheetDelegate>)delegate;
-(void)ShowInView:(UIView *)view;
@end
