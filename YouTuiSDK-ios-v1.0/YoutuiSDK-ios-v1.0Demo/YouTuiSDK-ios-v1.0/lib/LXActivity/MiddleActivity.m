//
//  LXActivity.m
//  LXActivityDemo
//
//  Created by lixiang on 14-3-17.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import "MiddleActivity.h"
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]
#define ACTIONSHEET_WHITEGROUNDCOLOR             [UIColor colorWithRed:255/255.00f green:255/255.00f blue:255/255.00f alpha:1.0]
#define ANIMATE_DURATION                        0.25f

#define CORNER_RADIUS                           5
#define SHAREBUTTON_BORDER_WIDTH                0.5f
#define SHAREBUTTON_BORDER_COLOR                [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor
#define SHAREBUTTONTITLE_FONT                   [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

#define CANCEL_BUTTON_COLOR                     [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1]

#define SHAREBUTTON_WIDTH                       50
#define SHAREBUTTON_HEIGHT                      50
#define SHAREBUTTON_INTERVAL_WIDTH              (VIEWWIDTH - SHAREBUTTON_WIDTH * 3 ) / 4
#define SHAREBUTTON_INTERVAL_HEIGHT             35

#define VIEWWIDTH                               [UIScreen mainScreen].bounds.size.width -30

#define SHARETITLE_WIDTH                        50
#define SHARETITLE_HEIGHT                       20
#define SHARETITLE_INTERVAL_WIDTH               (VIEWWIDTH - SHAREBUTTON_WIDTH * 3 ) / 4
#define SHARETITLE_INTERVAL_HEIGHT              SHAREBUTTON_WIDTH+SHAREBUTTON_INTERVAL_HEIGHT
#define SHARETITLE_FONT                         [UIFont fontWithName:@"Helvetica-Bold" size:18]

#define TITLE_INTERVAL_HEIGHT                   15
#define TITLE_HEIGHT                            35
#define TITLE_INTERVAL_WIDTH                    15
#define TITLE_WIDTH                             VIEWWIDTH - 30
#define TITLE_FONT                              [UIFont fontWithName:@"Helvetica-Bold" size:10]
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)
#define TITLE_NUMBER_LINES                      2

//图片按钮时
#define BUTTON_INTERVAL_HEIGHT                  20
#define BUTTON_HEIGHT                           48
#define BUTTON_INTERVAL_WIDTH                   (VIEWWIDTH - BUTTON_WIDTH) / 2
#define BUTTON_WIDTH                            48

//有推广活动时
#define BUTTON_ActionINTERVAL_HEIGHT                  20
#define BUTTON_ActionHEIGHT                           40
#define BUTTON_ActionINTERVAL_WIDTH                   ([UIScreen mainScreen].bounds.size.width - BUTTON_ActionWIDTH) / 2 - 15
#define BUTTON_ActionWIDTH                            [UIScreen mainScreen].bounds.size.width * 0.75


#define BUTTONTITLE_FONT                        [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define BUTTON_BORDER_WIDTH                     0.5f
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor


@interface UIImage (custom)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


@implementation UIImage (custom)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@interface MiddleActivity ()
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadShareButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat LXActivityHeight;
@property (nonatomic,assign) id<MiddleActivityDelegate>delegate;

@end

@implementation MiddleActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public method

- (id)initWithTitle:(NSString *)title delegate:(id<MiddleActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor PointArray:(NSArray *)PointArray isShowPointDescription:(BOOL)isShowPointDescription activityName:(NSString *)activityName;
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle shareButtonTitles:shareButtonTitlesArray withShareButtonImagesName:shareButtonImagesNameArray backgroundColor:backgroundColor titleColor:titleColor PointArray:PointArray isShowPointDescription:(BOOL)isShowPointDescription activityName:(NSString *)activityName];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - Praviate method

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle shareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray backgroundColor:(UIColor *)backgroundcolor titleColor:(UIColor *)titleColor PointArray:(NSArray *)PointArray isShowPointDescription:(BOOL)isShowPointDescription activityName:(NSString *)activityName
{
    //初始化
    self.isHadTitle = NO;
    self.isHadShareButton = NO;
    self.isHadCancelButton = NO;
    
    //初始化LXACtionView的高度为0
    self.LXActivityHeight = 0;
    
    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;
    
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width -30, self.LXActivityHeight)];
    self.backGroundView.backgroundColor = backgroundcolor;
    self.backGroundView.layer.cornerRadius = 5;
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    if (title) {
        self.isHadTitle = YES;
        UILabel *titleLabel = [self creatTitleLabelWith:title];
        titleLabel.textColor = titleColor;
        self.LXActivityHeight = self.LXActivityHeight + 2*TITLE_INTERVAL_HEIGHT+TITLE_HEIGHT;
        [self.backGroundView addSubview:titleLabel];
    }
    
    if (shareButtonImagesNameArray)
    {
        if (shareButtonImagesNameArray.count > 0)
        {
            self.isHadShareButton = YES;
            for (int i = 1; i < shareButtonImagesNameArray.count+1; i++)
            {
                //计算出行数，与列数
                int column = (int)ceil((float)(i)/3); //行
                int line = (i)%3; //列
                if (line == 0)
                {
                    line = 3;
                }
                UIButton *shareButton = [self creatShareButtonWithColumn:column andLine:line];
                shareButton.tag = self.postionIndexNumber;
                [shareButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
                
                [shareButton setBackgroundImage:[UIImage imageNamed:[shareButtonImagesNameArray objectAtIndex:i-1]] forState:UIControlStateNormal];

                    if (![[NSString stringWithFormat:@"%@",[PointArray objectAtIndex:i - 1]] isEqualToString:@"0"])
                    {
                        UIButton * RightRedButton = [[UIButton alloc]initWithFrame:CGRectMake(shareButton.frame.size.width*4/4.5,-3,9, 9)];
                        RightRedButton.layer.cornerRadius = CGRectGetHeight([RightRedButton bounds]) / 2;
                        RightRedButton.backgroundColor = [UIColor colorWithRed:232/255.00 green:36/255.00 blue:35/255.00 alpha:1];
                        [shareButton addSubview:RightRedButton];
                    }

                //有Title的时候
                if (self.isHadTitle == YES)
                {
                    [shareButton setFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH+((line-1)*(SHAREBUTTON_INTERVAL_WIDTH+SHAREBUTTON_WIDTH)), self.LXActivityHeight+((column-1)*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT)), SHAREBUTTON_WIDTH, SHAREBUTTON_HEIGHT)];
                }
                else
                {
                    [shareButton setFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH+((line-1)*(SHAREBUTTON_INTERVAL_WIDTH+SHAREBUTTON_WIDTH)), SHAREBUTTON_INTERVAL_HEIGHT+((column-1)*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT)), SHAREBUTTON_WIDTH, SHAREBUTTON_HEIGHT)];
                }
                [self.backGroundView addSubview:shareButton];
                
                self.postionIndexNumber++;
            }
        }
    }
    
    if (shareButtonTitlesArray) {
        if (shareButtonTitlesArray.count > 0 && shareButtonImagesNameArray.count > 0) {
            for (int j = 1; j < shareButtonTitlesArray.count+1; j++) {
                //计算出行数，与列数
                int column = (int)ceil((float)(j)/3); //行
                int line = (j)%3; //列
                if (line == 0) {
                    line = 3;
                }
                UILabel *shareLabel = [self creatShareLabelWithColumn:column andLine:line];
                shareLabel.text = [shareButtonTitlesArray objectAtIndex:j-1];
                shareLabel.textColor = titleColor;
                
                if (isShowPointDescription)
                {
                    //加积分的详细label
                    UILabel * pointDescriptionLabel = [[UILabel alloc]init];
                    if (!title)
                    {
                        pointDescriptionLabel.frame = CGRectMake(shareLabel.frame.origin.x, shareLabel.frame.origin.y + SHARETITLE_HEIGHT * 0.8, SHARETITLE_WIDTH, SHARETITLE_HEIGHT/2);
                    }
                    else
                    {
                        pointDescriptionLabel.frame = CGRectMake(shareLabel.frame.origin.x, shareLabel.frame.origin.y + SHARETITLE_HEIGHT * 2.3, SHARETITLE_WIDTH, SHARETITLE_HEIGHT/2);
                    }
                    pointDescriptionLabel.font = [UIFont systemFontOfSize:8];
                    pointDescriptionLabel.textColor = [UIColor colorWithRed:1.000f green:0.631f blue:0.000f alpha:1.00f];
                    pointDescriptionLabel.textAlignment = NSTextAlignmentCenter;
                    if ([[PointArray objectAtIndex:j - 1] integerValue] != 0)
                    {
                        pointDescriptionLabel.text = [NSString stringWithFormat:@"分享+%@积分",[PointArray objectAtIndex:j - 1]];
                    }
                    [self.backGroundView addSubview:pointDescriptionLabel];
                }
                
                //有Title的时候
                if (self.isHadTitle == YES) {
                    [shareLabel setFrame:CGRectMake(SHARETITLE_INTERVAL_WIDTH+((line-1)*(SHARETITLE_INTERVAL_WIDTH+SHARETITLE_WIDTH)), self.LXActivityHeight+SHAREBUTTON_HEIGHT+((column-1)*(SHARETITLE_INTERVAL_HEIGHT)), SHARETITLE_WIDTH, SHARETITLE_HEIGHT)];
                }
                [self.backGroundView addSubview:shareLabel];
            }
        }
    }
    
    //再次计算加入shareButtons后LXActivity的高度
    if (shareButtonImagesNameArray && shareButtonImagesNameArray.count > 0) {
        int totalColumns = (int)ceil((float)(shareButtonImagesNameArray.count)/3);
        if (self.isHadTitle  == YES) {
            self.LXActivityHeight = self.LXActivityHeight + totalColumns*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT);
        }
        else{
            self.LXActivityHeight = SHAREBUTTON_INTERVAL_HEIGHT + totalColumns*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT);
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle activityName:(NSString *)activityName];
        cancelButton.tag = self.postionIndexNumber;
        [cancelButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadShareButton == NO) {
            self.LXActivityHeight = self.LXActivityHeight + cancelButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
        }
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadShareButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.LXActivityHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.LXActivityHeight = self.LXActivityHeight + cancelButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
        }
        [self.backGroundView addSubview:cancelButton];
        
        self.postionIndexNumber++;
    }
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height-self.LXActivityHeight - 20, [UIScreen mainScreen].bounds.size.width - 30, self.LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}


- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle activityName:(NSString *)activityName
{
    if (![[NSString stringWithFormat:@"%@",activityName] isEqualToString:@"false"] && activityName != nil)
    {
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_ActionINTERVAL_WIDTH, BUTTON_ActionINTERVAL_HEIGHT, BUTTON_ActionWIDTH, BUTTON_ActionHEIGHT)];
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = CORNER_RADIUS;
        
        cancelButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
        cancelButton.layer.borderColor = BUTTON_BORDER_COLOR;
        
        UIImage *image = [UIImage imageWithColor:CANCEL_BUTTON_COLOR];
        [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
        
        [cancelButton setTitle:[NSString stringWithFormat:@"%@",activityName] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = BUTTONTITLE_FONT;
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(goToPointStore) forControlEvents:UIControlEventTouchUpInside];
        return cancelButton;
    }
    else
    {
        UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH , BUTTON_INTERVAL_HEIGHT , BUTTON_WIDTH , BUTTON_HEIGHT)];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel2"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
        return cancelButton;
    }

}

- (UIButton *)creatShareButtonWithColumn:(int)column andLine:(int)line
{
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH+((line-1)*(SHAREBUTTON_INTERVAL_WIDTH+SHAREBUTTON_WIDTH)), SHAREBUTTON_INTERVAL_HEIGHT+((column-1)*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT)), SHAREBUTTON_WIDTH, SHAREBUTTON_HEIGHT)];
    return shareButton;
}

- (UILabel *)creatShareLabelWithColumn:(int)column andLine:(int)line
{
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHARETITLE_INTERVAL_WIDTH+((line-1)*(SHARETITLE_INTERVAL_WIDTH+SHARETITLE_WIDTH)), SHARETITLE_INTERVAL_HEIGHT+((column-1)*(SHARETITLE_INTERVAL_HEIGHT)), SHARETITLE_WIDTH, SHARETITLE_HEIGHT)];
    
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = TITLE_FONT;
    shareLabel.textColor = [UIColor whiteColor];
    return shareLabel;
}

- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = SHARETITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}

- (void)didClickOnImageIndex:(UIButton *)button
{
    if (self.delegate) {
        if (button.tag != self.postionIndexNumber-1)
        {
            if ([self.delegate respondsToSelector:@selector(didClickOnImageIndex:)] == YES)
            {
                [self.delegate didClickOnImageIndex:(NSInteger *)button.tag];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES)
            {
                [self.delegate didClickOnCancelButton];
            }
        }
    }
   [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)goToPointStore
{
    [self.delegate MiddlegoToPointStoreAction];
}
- (void)tappedBackGroundView
{
    //
    
}

@end
