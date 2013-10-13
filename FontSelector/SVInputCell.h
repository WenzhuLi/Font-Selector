//
//  SVInputCell.h
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"


@interface SVInputCell : UITableViewCell
//@property (nonatomic, readonly)SevenLabel * stringLabel;
+ (CGFloat)heightWithString:(NSString*)string;
@end
