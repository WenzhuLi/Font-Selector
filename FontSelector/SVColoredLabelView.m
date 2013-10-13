//
//  SVColoredLabelView.m
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVColoredLabelView.h"
#import <QuartzCore/QuartzCore.h>

#define kMinFontSize 1
#define kMaxFontSize 200
@implementation SVColoredLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect labelFrame = CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height);
        labelFrame.origin.y = kLabelPaddingTop;
        labelFrame.size.height -= kLabelPaddingTop;
        _textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _textLabel.numberOfLines = 0;
        [self initMaskFrames];
        [self addSubview:_textLabel];
        self.layer.masksToBounds = YES;
        /*
        self.layer.masksToBounds = YES;
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        CGRect rect = self.bounds;
        [layer setBounds:rect];
        [layer setFrame:rect];
        [layer setFillColor:[UIColor whiteColor].CGColor];
        [layer setStrokeColor:[[UIColor whiteColor] CGColor]];
        [layer setLineWidth:1.0f];
        [layer setLineJoin:kCALineJoinMiter];
        //    [layer setPosition:CGPointMake(0.5, 0.5)];
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
        [layer setPath:path.CGPath];
        [self.layer setMask:layer];
        self.layer.masksToBounds = YES;
         */
         
    }
    return self;
}
- (void)initMaskFrames{
    CGRect frame = self.frame;
    maskFrameInit = frame;
    maskFrameMost = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - 35, frame.size.height);
    maskFrameHide = CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height);
}
- (void)moveMaskOffset:(CGFloat)offsetX{
    CGFloat width = self.frame.size.width;
    NSLog(@"width:%.0f, offsetX:%.0f",width,offsetX);
    if (width + offsetX > maskFrameMost.size.width ) {
        width = maskFrameMost.size.width;
        NSLog(@"-------width + offsetX > maskFrameMost.size.width");
    }
    else if (width + offsetX < maskFrameHide.size.width){
        width =  maskFrameHide.size.width;
        NSLog(@"========width + offsetX < maskFrameMost.size.width");
    }
    else{
        width += offsetX;
        NSLog(@"++++++++width += offsetX = %.0f",width);
    }
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
    /*
    CGPoint currentPosition = self.layer.mask.position;
    if (currentPosition.x + offsetX > self.center.x - 35 ) {
        currentPosition.x =  self.center.x - 35;
    }
    else if (currentPosition.x + offsetX < -self.center.x)
        currentPosition.x =  -self.center.x;
    currentPosition.x += offsetX;
    self.layer.mask.position = currentPosition;
     */
}
- (void)changeToState:(ColorLabelMaskState)state animated:(BOOL)animated{
    
    switch (state) {
        case ColorLabelMaskInit:
            if (animated) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];

                    self.frame = maskFrameInit;
                [UIView commitAnimations];
            }
            else
                self.frame = maskFrameInit;
            break;
        case ColorLabelMaskMost:
            if (animated) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                
                self.frame = maskFrameMost;
                [UIView commitAnimations];
            }
            else
                self.frame = maskFrameMost;
            break;
        case ColorLabelMaskHide:
            if (animated) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                
                self.frame = maskFrameHide;
                [UIView commitAnimations];
            }
            else
                self.frame = maskFrameHide;
            break;
            
        default:
            break;
    }
    
    
    /*
    CALayer * maskLayer = self.layer.mask;
    if (!maskLayer) {
        CAShapeLayer * layer = [CAShapeLayer layer];
        CGRect rect = self.bounds;
        [layer setBounds:rect];
        [layer setFrame:rect];
        [layer setFillColor:[UIColor whiteColor].CGColor];
        [layer setStrokeColor:[[UIColor whiteColor] CGColor]];
        [layer setLineWidth:1.0f];
        [layer setLineJoin:kCALineJoinMiter];
        //    [layer setPosition:CGPointMake(0.5, 0.5)];
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
        [layer setPath:path.CGPath];
        [self.layer setMask:layer];
        self.layer.masksToBounds = YES;
    }
    maskLayer = self.layer.mask;
    switch (state) {
        case ColorLabelMaskInit:
            if (animated) {
                [CATransaction begin];
                maskLayer.position = kMaskPositionInit;
                [CATransaction commit];
            }
            else
                maskLayer.position = kMaskPositionInit;
            break;
        case ColorLabelMaskMost:
            if (animated) {
                [CATransaction begin];
                maskLayer.position = kMaskPositionMost;
                [CATransaction commit];
            }
            else
                maskLayer.position = kMaskPositionMost;
            break;
        case ColorLabelMaskHide:
            if (animated) {
                [CATransaction begin];
                maskLayer.position = kMaskPositionHide;
                [CATransaction commit];
            }
            else
                maskLayer.position = kMaskPositionHide;
            break;
            
        default:
            break;
    }
     */
}
- (void)setText:(NSString *)text fontName:(NSString *)fontName{
    _textLabel.text = text;
    self.fontName = fontName;
    NSInteger fitSize = [self binarySearchForFontSizeForText:text withMinFontSize:kMinFontSize withMaxFontSize:kMaxFontSize withSize:_textLabel.bounds.size];
    _textLabel.font = [UIFont fontWithName:fontName size:fitSize];
    [_textLabel setNeedsLayout];
}
- (void)setColorPair:(SVColorPair *)colorPair{
    self.backgroundColor = colorPair.backgroundColor;
    _textLabel.backgroundColor = colorPair.backgroundColor;
    _textLabel.textColor = colorPair.textColor;
}
- (NSInteger)binarySearchForFontSizeForText:(NSString *)text withMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize withSize:(CGSize)size
{
    // If the sizes are incorrect, return 0, or error, or an assertion.
    
    
    // Find the middle
    NSInteger fontSize = (minFontSize + maxFontSize) / 2;
    if (maxFontSize < minFontSize)
        return fontSize;
    // Create the font
    UIFont *font = [UIFont fontWithName:_fontName size:fontSize];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.



@end
