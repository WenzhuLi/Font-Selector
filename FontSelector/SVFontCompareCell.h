//
//  SVFontCompareCell.h
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCompareCellHeight 250

@interface SVFontCompareCell : UITableViewCell{
    NSString * _fontName;
}
@property (nonatomic, strong)UIButton * deleteButton;
- (void)setText:(NSString *)text fontName:(NSString *)fontName;
- (void)updateText:(NSString *)text;
@end
