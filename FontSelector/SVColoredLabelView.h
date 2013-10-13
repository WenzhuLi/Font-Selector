//
//  SVColoredLabelView.h
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVColorPair.h"
#define kLabelPaddingTop 30
#define kMaskPositionInit self.center
#define kMaskPositionMost CGPointMake(self.center.x - 35,self.center.y)
#define kMaskPositionHide CGPointMake(-self.center.x,self.center.y)


typedef enum{
    ColorLabelMaskInit,
    ColorLabelMaskMost,
    ColorLabelMaskHide
}ColorLabelMaskState;
@interface SVColoredLabelView : UIView{
    UILabel * _textLabel;
    NSString * _fontName;
    CGRect maskFrameInit;
    CGRect maskFrameMost;
    CGRect maskFrameHide;
}
@property (nonatomic, strong)NSString * fontName;
- (void)setText:(NSString *)text fontName:(NSString *)fontName;
- (void)setColorPair:(SVColorPair *)colorPair;
- (void)changeToState:(ColorLabelMaskState)state animated:(BOOL)animated;
- (void)moveMaskOffset:(CGFloat)offsetX;

@end
