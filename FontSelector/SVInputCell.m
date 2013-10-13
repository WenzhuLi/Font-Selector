//
//  SVInputCell.m
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVInputCell.h"

#define kCellHeightMin 44
#define kCellHeightPadding 22
#define kLabelWidth 360
@implementation SVInputCell
+ (CGFloat)heightWithString:(NSString*)string{
    SevenLabel * label = [[SevenLabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, 0)];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = string;
    CGFloat labelH = label.frame.size.height;
    if (labelH + kCellHeightPadding < kCellHeightMin) {
        return kCellHeightMin;
    }
    else
        return labelH + kCellHeightPadding;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        _stringLabel = [[SevenLabel alloc] initWithFrame:CGRectMake(10, 10, kLabelWidth, 0)];
//        [self.contentView addSubview:_stringLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
