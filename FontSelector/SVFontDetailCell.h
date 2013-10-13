//
//  SVFontDetailCell.h
//  FontSelector
//
//  Created by Lee on 13-4-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVFontDetail.h"
#define kDefaultText @"I love this font."
#define kCurrentTextKey @"currentText"
#define kFontDetailCellHeight 100
#define kCellWidth 784
#define kCellHeight 100
#define kMinFontSize 1
#define kMaxFontSize 200
@class SVFontDetailCell;
@protocol SVFontDetailCellDelegate <NSObject>

- (void)cellAddToCompare:(SVFontDetailCell *)fontCell;

@end
@interface SVFontDetailCell : UITableViewCell{
    UILabel * fontNameLabel;
    UILabel * fontPreviewLabel;
    UIButton * addToCompareButton;
}
@property (nonatomic, assign)SVFontDetail * fontDetail;
@property (nonatomic, assign)CGFloat customCellWidth;
@property (nonatomic, strong)id<SVFontDetailCellDelegate> delegate;
@property (nonatomic, readonly)UIButton * addToCompareButton;
- (void)setPreviewFont:(SVFontDetail *)font;
- (void)setPreviewText:(NSString *)text;

@end
