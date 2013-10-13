//
//  SVFolderView.h
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVFontDetail.h"

@class SVFolderView;

@protocol SVFolderViewDelegate <NSObject>

- (void)folderViewRateChanged:(SVFolderView *)folderView;

@end
#define kFolderViewFrame CGRectMake(0, 0, 784, 290)
#define kFolderViewFrameMax CGRectMake(0, 0, 1024, 290)


@interface SVFolderView : UIView{
    NSInteger _previousStar;
    NSArray * starRectArray;
}
@property (nonatomic, strong)id<SVFolderViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *starImageView;
@property (strong, nonatomic) IBOutlet UILabel *fontNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *companyImg;
@property (strong, nonatomic) IBOutlet UIImageView *backFrameImg;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *styleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *introTextView;
@property (strong, nonatomic) IBOutlet UILabel *previewLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UIButton *starButton1;
@property (nonatomic, strong)SVFontDetail * myFont;
@property (nonatomic, strong) IBOutlet UIView * contentView;
@property (strong, nonatomic) IBOutlet UIButton *starButton3;
@property (strong, nonatomic) IBOutlet UIButton *starbutton2;
@property (nonatomic, assign)BOOL starChanged;
- (void)setFont:(SVFontDetail *)font;
- (IBAction)openLink:(id)sender;
- (IBAction)starButtonTapped:(UIButton *)sender;
- (IBAction)shareIt:(UIButton *)sender;


@end
