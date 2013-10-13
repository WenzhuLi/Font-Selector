//
//  SVHeaderCell.m
//  FontSelector
//
//  Created by Lee on 13-4-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVHeaderCell.h"

@implementation SVHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        companyImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:companyImage];
        tipImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        tipImg.image = [UIImage imageNamed:@"headerTip"];
        [tipImg sizeToFit];
        tipImg.hidden = YES;
        UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(0,149, 784, 1)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        sepLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:sepLine];
        [self.contentView addSubview:tipImg];
    }
    return self;
}
- (id)initWithFavoritReuseIdentifier:(NSString *)reuseid{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    if (self) {
        // Initialization code
        
        companyImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:companyImage];
        tipImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        tipImg.image = [UIImage imageNamed:@"headerTip"];
        [tipImg sizeToFit];
        tipImg.hidden = YES;
        UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(0,175, 784, 1)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        sepLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:sepLine];
        [self.contentView addSubview:tipImg];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showTip:(BOOL)show{
    tipImg.center = CGPointMake(self.contentView.center.x, self.contentView.frame.size.height - 5);
    tipImg.hidden = !show;
}
//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    
//}
- (void)setCompanyImage:(UIImage *)image{
    companyImage.image = image;
    companyImage.center = self.contentView.center;
    [companyImage sizeToFit];
}
@end
