//
//  FreeGeekSheet.m
//  CustomSheet
//
//  Created by FreeGeek on 14-11-5.
//  Copyright (c) 2014年 FreeGeek. All rights reserved.
//

#import "FreeGeekSheet.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenHeightInterval 50
#define ButtonWidthInterval (CurrentWidth - ShareButtonWidth * 3) / 4 //分享按钮的间距
#define CancelButtonWidth 240                                         //取消按钮的宽度
#define CancelButtonHeight 40                                         //取消按钮的高度
#define CancelButtonBottomInterval 20                                 //取消按钮的间距
                                       
#define ShareButtonWidth  ScreenWidth / 6                             //分享按钮宽度
#define ShareButtonHeight ScreenWidth / 6                             //分享按钮高度
#define ShareTitleHeight 10                                           //分享平台Label高度
#define SharePointHeight 10                                           //分享奖励说明Label高度
#define grayColor [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1]
@interface FreeGeekSheet ()
@property (assign , nonatomic) id<FreeGeekDelegate>delegate;
@property (strong , nonatomic) UIView * SheetView;
@property (strong , nonatomic) UIButton * CancelButton;
@property (strong , nonatomic) UIView * blackView;
@property (strong , nonatomic) UIScrollView * ScrollView;
@property (strong , nonatomic) UIPageControl * page;
@property (strong , nonatomic) UIButton * Sharebutton;
@property (strong , nonatomic) UILabel * SharePointLabel;
@property (assign , nonatomic) float CustomScrollViewHeight;
@property (assign , nonatomic) float CustomScrollHeightInterval;
@property (assign , nonatomic) float CurrentWidth;
@property (assign , nonatomic) float ScreenWidthInterval;
@property (strong , nonatomic) UIColor * backgroundColor;
@end
@implementation FreeGeekSheet
@synthesize SheetView,CancelButton,blackView,ScrollView,page,Sharebutton,SharePointLabel,CurrentWidth,ScreenWidthInterval,backgroundColor;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    
    }
    return self;
}
-(id)initWithTitle:(NSString *)Title Delegate:(id<FreeGeekDelegate>)delegate titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray PointArray:(NSArray *)pointArray ShowRedDot:(BOOL)ShowRedDot ActivityName:(NSString *)activityName Middle:(BOOL)Middle
{
    if (Middle)
    {
        ScreenWidthInterval = 20;
        CurrentWidth = ScreenWidth - ScreenWidthInterval * 2;
        backgroundColor = [UIColor colorWithRed:255/255.00f green:255/255.00f blue:255/255.00f alpha:0.95];
    }
    else
    {
        ScreenWidthInterval = 0;
        CurrentWidth = ScreenWidth;
        backgroundColor = [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.95];
    }
    self = [super init];
    if (self)
    {
    self.frame = CGRectMake(0, 0, CurrentWidth, ScreenHeight);
    if (delegate)
    {
        self.delegate = delegate;
    }
    if (Title == nil)
    {
        _CustomScrollHeightInterval = 10;
    }
    else
    {
        _CustomScrollHeightInterval = 40;
    }
    _CustomScrollViewHeight = 0;

    if (0 < imageArray.count && imageArray.count < 4)      //icon只有一排
    {
        _CustomScrollViewHeight = ShareButtonHeight + SharePointHeight + ShareTitleHeight + 15;
    }
    else if (3 < imageArray.count && imageArray.count < 7) //icon有两排
    {
        _CustomScrollViewHeight = (ShareButtonHeight + SharePointHeight + ShareTitleHeight + 15) * 2;
    }
    else                                                    //icon有三排或者以上
    {
        _CustomScrollViewHeight = (ShareButtonHeight + SharePointHeight + ShareTitleHeight + 15) * 3;
    }
        
    //背景黑色阴影
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.4];
    [self addSubview:blackView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancelButtonAction)];
    [blackView addGestureRecognizer:tap];
    
    //展现视图
    SheetView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidthInterval,ScreenHeight, CurrentWidth, 0)];
    SheetView.backgroundColor = backgroundColor;
        if (Middle)
        {
            SheetView.layer.cornerRadius = 5;
        }
    [self addSubview:SheetView];
        
    UILabel * TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10, CurrentWidth, 30)];
    TitleLabel.text = Title;
        if (Middle)
        {
            TitleLabel.textColor = grayColor;
            TitleLabel.font = [UIFont boldSystemFontOfSize:16];
        }
        else
        {
            TitleLabel.textColor = [UIColor whiteColor];
            TitleLabel.font = [UIFont boldSystemFontOfSize:17];
        }
    
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [SheetView addSubview:TitleLabel];
    
    CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CancelButton.layer.cornerRadius = 5;
        if (imageArray.count > 9)
        {
            CancelButton.frame = CGRectMake((CurrentWidth - CancelButtonWidth) / 2,_CustomScrollHeightInterval + _CustomScrollViewHeight + 20, CancelButtonWidth, CancelButtonHeight);
        }
        else
        {
            CancelButton.frame = CGRectMake((CurrentWidth - CancelButtonWidth) / 2,_CustomScrollHeightInterval + _CustomScrollViewHeight + 10, CancelButtonWidth, CancelButtonHeight);
        }
    if (![activityName isEqualToString:@"false"] && ![activityName isEqualToString:@""] && ![activityName isEqual:[NSNull null]] && ![activityName isKindOfClass:[NSNull class]] && activityName != nil)
    {
        [CancelButton setTitle:activityName forState:UIControlStateNormal];
        [CancelButton addTarget:self action:@selector(GoToPointStore) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [CancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [CancelButton addTarget:self action:@selector(CancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    CancelButton.backgroundColor = [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1];
    [SheetView addSubview:CancelButton];
    
    //中间ScrollView
    ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_CustomScrollHeightInterval,CurrentWidth,_CustomScrollViewHeight)];
    ScrollView.pagingEnabled = YES;
    ScrollView.contentSize = CGSizeMake((imageArray.count / 10 + 1) * CurrentWidth, 0);
    ScrollView.showsHorizontalScrollIndicator = NO;    //水平
    ScrollView.showsVerticalScrollIndicator = NO;      //垂直
    ScrollView.delegate = self;
    [SheetView addSubview:ScrollView];
    UIView * ShareButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentWidth,_CustomScrollViewHeight)];
    [ScrollView addSubview:ShareButtonView];
    UIView * ShareButtonTwo = [[UIView alloc]initWithFrame:CGRectMake(CurrentWidth, 0, CurrentWidth,_CustomScrollViewHeight)];
    [ScrollView addSubview:ShareButtonTwo];
    for (int i = 0; i < [imageArray count]; i++)
    {
        //图片按钮
        Sharebutton = [[UIButton alloc]init];
        [Sharebutton setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        Sharebutton.tag = i;
        
        //平台Title
        UILabel * ShareTitleLabel = [[UILabel alloc]init];
        if (Middle)
        {
            ShareTitleLabel.textColor = grayColor;
            ShareTitleLabel.font = [UIFont boldSystemFontOfSize:9];
        }
        else
        {
            ShareTitleLabel.textColor = [UIColor whiteColor];
            ShareTitleLabel.font = [UIFont boldSystemFontOfSize:10];
        }
        
        ShareTitleLabel.textAlignment = NSTextAlignmentCenter;
        ShareTitleLabel.text = [titleArray objectAtIndex:i];
        
        //积分奖励详情
        SharePointLabel = [[UILabel alloc]init];
        SharePointLabel.textColor = [UIColor colorWithRed:1.000f green:0.631f blue:0.000f alpha:1.00f];
        if ([[pointArray objectAtIndex:i] integerValue] != 0)
        {
            SharePointLabel.text = [NSString stringWithFormat:@"分享+%@积分",[pointArray objectAtIndex:i]];
        }
        SharePointLabel.textAlignment = NSTextAlignmentCenter;
        SharePointLabel.font = [UIFont boldSystemFontOfSize:7];
        if (i < 9)
        {
            Sharebutton.frame = CGRectMake(ButtonWidthInterval * (i % 3 + 1) + ShareButtonHeight * (i % 3),5 + 90 * (i / 3), ShareButtonWidth, ShareButtonHeight);
            ShareTitleLabel.frame = CGRectMake(ButtonWidthInterval * (i % 3 + 1) + ShareButtonHeight * (i % 3),Sharebutton.frame.origin.y +ShareButtonHeight + 3, ShareButtonWidth, ShareTitleHeight);
            SharePointLabel.frame = CGRectMake(ButtonWidthInterval * (i % 3 + 1) + ShareButtonHeight * (i % 3),ShareTitleLabel.frame.origin.y + ShareTitleHeight, ShareButtonWidth, SharePointHeight);
            
            [ShareButtonView addSubview:Sharebutton];
            [ShareButtonView addSubview:ShareTitleLabel];
            [ShareButtonView addSubview:SharePointLabel];
        }
        if (i > 8)
        {
            int k = i - 9;
            Sharebutton.frame = CGRectMake(ButtonWidthInterval * (k % 3 + 1) + (imageArray.count / 10 - 1) * CurrentWidth + ShareButtonHeight * (k % 3), 10 + 91 * (k / 3), ShareButtonWidth, ShareButtonHeight);
            ShareTitleLabel.frame = CGRectMake(ButtonWidthInterval * (k % 3 + 1) + (imageArray.count / 10 - 1) * CurrentWidth + ShareButtonHeight * (k % 3),Sharebutton.frame.origin.y +ShareButtonHeight + 3, ShareButtonWidth, ShareTitleHeight);
            SharePointLabel.frame = CGRectMake(ButtonWidthInterval * (k % 3 + 1) + (imageArray.count / 10 - 1) * CurrentWidth + ShareButtonHeight * (k % 3),ShareTitleLabel.frame.origin.y + ShareTitleHeight, ShareButtonWidth, SharePointHeight);
            [ShareButtonTwo addSubview:Sharebutton];
            [ShareButtonTwo addSubview:ShareTitleLabel];
            [ShareButtonTwo addSubview:SharePointLabel];
        }
        [Sharebutton addTarget:self action:@selector(ShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (ShowRedDot)
        {
            if (![[NSString stringWithFormat:@"%@",[pointArray objectAtIndex:i]] isEqualToString:@"0"] && ![[NSString stringWithFormat:@"%@",[pointArray objectAtIndex:i]] isEqualToString:@""])
            {
                UIButton * RightRedButton = [[UIButton alloc]initWithFrame:CGRectMake(Sharebutton.frame.size.width*4/4.51,-2,9, 9)];
                RightRedButton.layer.cornerRadius = CGRectGetHeight([RightRedButton bounds]) / 2;
                RightRedButton.backgroundColor = [UIColor colorWithRed:232/255.00 green:36/255.00 blue:35/255.00 alpha:1];
                [Sharebutton addSubview:RightRedButton];
            }
        }
    }
    if (imageArray.count > 9)
    {
        page = [[UIPageControl alloc]initWithFrame:CGRectMake(0,_CustomScrollHeightInterval + _CustomScrollViewHeight,CurrentWidth, 10)];
        page.numberOfPages = imageArray.count / 10 + 1;
        page.currentPage = 0;
        if (Middle)
        {
            page.pageIndicatorTintColor = [UIColor lightGrayColor];
            page.currentPageIndicatorTintColor = grayColor;
        }
        else
        {
            page.pageIndicatorTintColor = [UIColor lightGrayColor];
            page.currentPageIndicatorTintColor = [UIColor whiteColor];
        }
        [SheetView addSubview:page];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        SheetView.frame = CGRectMake(ScreenWidthInterval, (ScreenHeight - (CancelButton.frame.origin.y + CancelButtonHeight + 10)) / (Middle? 2 : 1), CurrentWidth, CancelButton.frame.origin.y + CancelButtonHeight + 10);
    } completion:^(BOOL finished) {
        
    }];
    }
    return self;
}

-(void)GoToPointStore
{
    [self CancelButtonAction];
    [self.delegate FreeGeekgoToPointStore];
}

-(void)ShowInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void)ShareButtonAction:(UIButton *)button
{
    [self.delegate ShareButtonAction:(NSInteger *)button.tag];
    [self CancelButtonAction];
}

-(void)CancelButtonAction
{
    [blackView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        SheetView.frame = CGRectMake(ScreenWidthInterval,ScreenHeight,CurrentWidth,0);
    } completion:^(BOOL finished) {
        [SheetView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = ScrollView.contentOffset;
    page.currentPage = lroundf(point.x / ScreenWidth);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
