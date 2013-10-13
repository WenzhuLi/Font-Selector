//
//  SVHeaderCell.h
//  FontSelector
//
//  Created by Lee on 13-4-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVHeaderCell : UITableViewCell{
    UIImageView * companyImage;
    UIImageView * tipImg;
}

- (void)setCompanyImage:(UIImage *)image;
- (void)showTip:(BOOL)show;
- (id)initWithFavoritReuseIdentifier:(NSString *)reuseid;
@end
