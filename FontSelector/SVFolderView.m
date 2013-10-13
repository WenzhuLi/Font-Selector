//
//  SVFolderView.m
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVFolderView.h"
#import "SVDatabase.h"
#import <ShareSDK/ShareSDK.h>
#import "UIView+screenshot.h"

@implementation SVFolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"SVFolderView" owner:self options:nil];
        _contentView.frame = self.bounds;
        [self addSubview:_contentView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starImgTapped:)];
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(starImgPan:)];
        [self.starImageView addGestureRecognizer:pan];
        [self.starImageView addGestureRecognizer:tap];
        self.starImageView.userInteractionEnabled = YES;
        self.starChanged = NO;
        starRectArray = [[NSArray alloc] initWithObjects:
                         [NSValue valueWithCGRect:CGRectMake(0, 0, 23,47)],
                         [NSValue valueWithCGRect:CGRectMake(23, 0, 56,47)],
                         [NSValue valueWithCGRect:CGRectMake(79, 0, 56,47)],
                         [NSValue valueWithCGRect:CGRectMake(135, 0, 24,47)],nil];
    }
    return self;
}
- (NSInteger)rateOfPoint:(CGPoint)location{
    for (int i = 0; i < 4; i++) {
        CGRect rect = [[starRectArray objectAtIndex:i] CGRectValue];
        if (CGRectContainsPoint(rect, location)) {
            return i;
        }
    }
    return _previousStar;
}
- (void)starImgPan:(UIGestureRecognizer *)recognizer{

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            CGPoint location = [recognizer locationInView:self.starImageView];
            NSInteger rate = [self rateOfPoint:location];
            [self.starImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d",rate]]];
            _previousStar = rate;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint location = [recognizer locationInView:self.starImageView];
            NSInteger rate = [self rateOfPoint:location];
            [self.starImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d",rate]]];
            _previousStar = rate;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGPoint location = [recognizer locationInView:self.starImageView];
            NSInteger rate = [self rateOfPoint:location];
            _previousStar = rate;
            [self.starImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d",rate]]];
                 self.myFont.star = [NSString stringWithFormat:@"%d",rate];
                 PLSqliteDatabase * db = [SVDatabase fontDetailDatabase];
                 [db executeUpdate:[NSString stringWithFormat:@"update fontDetail set rate = %@ where id = %d",self.myFont.star,self.myFont.fontID]];
                 if (self.delegate && [self.delegate respondsToSelector:@selector(folderViewRateChanged:)]) {
                     [self.delegate folderViewRateChanged:self];
                 }
        }
            break;
            
        default:
            break;
    }
}
- (void)starImgTapped:(UITapGestureRecognizer *)recognizer{
    CGPoint location = [recognizer locationInView:self.starImageView];
    NSInteger star = location.x / (self.starImageView.frame.size.width / 3) + 1;
    if (star == _previousStar) {
        return;
    }
    self.starChanged = YES;
    
    [self.starImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d",star]]];
    _previousStar = star;
    self.myFont.star = [NSString stringWithFormat:@"%d",star];
    PLSqliteDatabase * db = [SVDatabase fontDetailDatabase];
    [db executeUpdate:[NSString stringWithFormat:@"update fontDetail set rate = %@ where id = %d",self.myFont.star,self.myFont.fontID]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(folderViewRateChanged:)]) {
        [self.delegate folderViewRateChanged:self];
    }
    
}
- (void)setFont:(SVFontDetail *)font{
    UIImage * img = [[UIImage imageNamed:@"fontDetail_frame"] resizableImageWithCapInsets:UIEdgeInsetsMake(150, 20, 20, 250)];
    [self.backFrameImg setImage:img];
    self.myFont = font;
    self.fontNameLabel.text = self.myFont.fontName;
//    self.companyLabel.text = [NSString stringWithFormat:@"%@",self.myFont.publisher];
//    self.styleLabel.text = [NSString stringWithFormat:@"%@",self.myFont.style];
//    self.priceLabel.text = [NSString stringWithFormat:@"%@",self.myFont.price];
//    self.introTextView.text = [NSString stringWithFormat:@"%@",self.myFont.introduction];
    self.companyLabel.text = self.myFont.publisher;
    self.styleLabel.text = self.myFont.style;
    self.priceLabel.text = self.myFont.price;
    self.yearLabel.text = self.myFont.year;
    [self.companyImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_s",self.myFont.publisher]]];
    self.introTextView.text = self.myFont.introduction;
    self.previewLabel.font = [UIFont fontWithName:self.myFont.fontName size:20];
    [self.starImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%@",self.myFont.star]]];
    _previousStar = [self.myFont.star integerValue];
    self.starChanged = NO;
}

- (IBAction)openLink:(id)sender {
    NSLog(@"open link : %@",self.myFont.link);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.myFont.link]];
}

- (IBAction)starButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 3:
            self.starButton1.selected = YES;
            self.starbutton2.selected = YES;
            self.starButton3.selected = YES;
            break;
        case 2:
            self.starButton1.selected = YES;
            self.starbutton2.selected = YES;
            self.starButton3.selected = NO;
            break;
        case 1:
            self.starButton1.selected = YES;
            self.starbutton2.selected = NO;
            self.starButton3.selected = NO;
            break;
            
        default:
            break;
    }
}

- (IBAction)shareIt:(UIButton *)sender {
    if (sender.tag == 3) {
        UIImage * screenshot = [[[UIApplication sharedApplication] keyWindow] screenshot];
        id<ISSContent>publishContent = [ShareSDK content:[NSString stringWithFormat:@"分享字体 %@",self.fontNameLabel.text] defaultContent:@"" image:[ShareSDK jpegImageWithImage:screenshot quality:1.0] title:@"微博分享" url:nil description:@"FontSelector" mediaType:SSPublishContentMediaTypeText];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender
                                                                                   arrowDirect:UIPopoverArrowDirectionUp];
        
        //显示分享菜单
        [ShareSDK showShareViewWithType:ShareTypeSinaWeibo container:container
                                content:publishContent
                          statusBarTips:YES
                           authOptions :nil
                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"微博分享" oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:YES wxTimelineButtonHidden:YES showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil]
                                 result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo>
                                          statusInfo,id<ICMErrorInfo>error,BOOL end){
                                     if (state == SSPublishContentStateSuccess) {
                                         NSLog(@"发表成功"); }
                                     else if (state == SSPublishContentStateFail) {
                                         NSLog(@"发布失败!error code == %d, error code == %@",
                                               [error errorCode], [error errorDescription]); }
                                 }];
        return;
    }
    NSString * link = nil;
    switch (sender.tag) {
        case 0:
            link = @"http://www.facebook.com";
            break;
        case 1:
            link = @"http://www.twitter.com";
            break;
        case 2:
            link = @"https://plus.google.com";
            break;
        case 3:
            link = @"http://www.weibo.com";
            break;
            
        default:
            break;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
