//
//  SVFontDetailCell.m
//  FontSelector
//
//  Created by Lee on 13-4-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVFontDetailCell.h"

@implementation SVFontDetailCell
@synthesize addToCompareButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.customCellWidth = 0;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPreviewFont:(SVFontDetail *)font{
    self.fontDetail = font;
    
    if (!fontNameLabel) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.frame = CGRectMake(0, 0, self.customCellWidth == 0?kCellWidth : self.customCellWidth, kCellHeight);
        UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:sepLine];
        fontNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 500, 20)];
        fontNameLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:16];
        fontNameLabel.backgroundColor = [UIColor clearColor];
        fontNameLabel.textColor = [UIColor colorWithRed:0.518 green:0.518 blue:0.518 alpha:1.0];
        [self.contentView addSubview:fontNameLabel];
        NSLog(@"content.frame:%@",[NSValue valueWithCGRect:self.contentView.bounds]);
        fontPreviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.contentView.frame.size.width - 75, self.contentView.frame.size.height - 35)];
        fontPreviewLabel.font = [UIFont systemFontOfSize:200];
        fontPreviewLabel.adjustsFontSizeToFitWidth = YES;
        if ([fontPreviewLabel respondsToSelector:@selector(setMinimumScaleFactor:)]) {
            fontPreviewLabel.minimumScaleFactor = 0.05;
        }
        else {
            fontPreviewLabel.minimumFontSize = 1;
        }
        
        
        NSString * currentText = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey];
        if (currentText) {
            fontPreviewLabel.text = currentText;
        }
        else
            fontPreviewLabel.text = kDefaultText;
        [self.contentView addSubview:fontPreviewLabel];
        fontPreviewLabel.backgroundColor = [UIColor clearColor];
        fontPreviewLabel.numberOfLines = 0;
        fontPreviewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addToCompareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addToCompareButton setImage:[UIImage imageNamed:@"fontDetail_compare"] forState:UIControlStateNormal];
        [addToCompareButton setImage:[UIImage imageNamed:@"fontDetail_compare_s"] forState:UIControlStateSelected];
        addToCompareButton.frame = CGRectMake(0, 0, 50, 50);
//        [addToCompareButton sizeToFit];
//        [addToCompareButton setShowsTouchWhenHighlighted:YES];
        [addToCompareButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        addToCompareButton.center = CGPointMake(self.contentView.frame.size.width - 30, self.contentView.frame.size.height / 2);
        [self.contentView addSubview:addToCompareButton];
    }
    NSString * currentText = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey];
    if (currentText) {
        fontPreviewLabel.text = currentText;
    }
    else
        fontPreviewLabel.text = kDefaultText;
    NSInteger fitSize = [self binarySearchForFontSizeForText:fontPreviewLabel.text withMinFontSize:kMinFontSize withMaxFontSize:kMaxFontSize withSize:fontPreviewLabel.frame.size];
    fontPreviewLabel.font = [UIFont fontWithName:self.fontDetail.fontName size:fitSize];
    NSLog(@"font name : \"%@\"",self.fontDetail.fontName);
    [fontPreviewLabel setNeedsLayout];
    
    /*
    Point sizes are defined as 1/72 of an inch. That is, a 72-point font is approximately 1 inch from the lowest descent to the highest ascent. So the maximum height of a glyph in a 72pt font is about 1 inch.
    
    Apple's iphone tech specs page claims that the iPhone currently has a resolution of 163 pixels per inch. So 72 points is 163 pixels, or about 2.2639 pixels per point.
     */
    fontNameLabel.text = [NSString stringWithFormat:@"%@  %dpx",self.fontDetail.fontName, fitSize * 163 / 72];
}
- (void)setPreviewText:(NSString *)text{
    fontPreviewLabel.text = text;
}
- (NSInteger)binarySearchForFontSizeForText:(NSString *)text withMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize withSize:(CGSize)size
{
    // If the sizes are incorrect, return 0, or error, or an assertion.
    
    
    // Find the middle
    NSInteger fontSize = (minFontSize + maxFontSize) / 2;
    if (maxFontSize < minFontSize)
        return fontSize;
    // Create the font
    UIFont *font = [UIFont fontWithName:self.fontDetail.fontName size:fontSize];
    // Create a constraint size with max height
    CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
    // Find label size for current font size
    CGSize labelSize = [text sizeWithFont:font
                        constrainedToSize:constraintSize
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    // EDIT:  The next block is modified from the original answer posted in SO to consider the width in the decision. This works much better for certain labels that are too thin and were giving bad results.
    if( labelSize.height >= (size.height+10) && labelSize.width >= (size.width + 10) && labelSize.height <= (size.height) && labelSize.width <= (size.width) ) {
        //NSLog(@"'%@' LabelSize: (%f x %f) Font imprint: (%f x %f)", text, labelSize.width, labelSize.height, size.width, size.height);
        return fontSize;
    } else if( labelSize.height > size.height || labelSize.width > size.width)
        return [self binarySearchForFontSizeForText:text withMinFontSize:minFontSize withMaxFontSize:fontSize-1 withSize:size];
    else
        return [self binarySearchForFontSizeForText:text withMinFontSize:fontSize+1 withMaxFontSize:maxFontSize withSize:size];
}
- (void)addButtonTapped:(UIButton *)sender{
    NSLog(@"compare in cell");
    if (_delegate && [_delegate respondsToSelector:@selector(cellAddToCompare:)]) {
        [_delegate cellAddToCompare:self];
    }
}

@end
