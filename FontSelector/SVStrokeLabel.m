//
//  SVStrokeLabel.m
//  FontSelector
//
//  Created by Lee on 13-5-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVStrokeLabel.h"

@implementation SVStrokeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _stokeWidth = kStrokeWidthDefault;
        NSLog(@"---init");
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"---init");
    _stokeWidth = kStrokeWidthDefault;
}
//继承UILabel以后重载drawTextInRect

- (void)drawTextInRect:(CGRect)rect {
    NSLog(@"-----draw rect");
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, _stokeWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor whiteColor];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

- (void)setStrokeWidth:(NSInteger)strokeWidth{
    _stokeWidth = strokeWidth;
    [self setNeedsDisplay];
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
