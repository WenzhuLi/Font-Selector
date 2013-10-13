//
//  SVFontCompareCell.m
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVFontCompareCell.h"
#import "SVColorCompareView.h"

@interface SeperateLine : UIView

@end

@implementation SeperateLine

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, 1);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context,[UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextStrokePath(context);
    
    
}

@end

typedef enum {
    LMFeedCellDirectionNone=0,
	LMFeedCellDirectionRight,
	LMFeedCellDirectionLeft,
} LMFeedCellDirection;

@interface SVFontCompareCell ()

//flag
@property (nonatomic, strong) SVColorCompareView * compareView;
@property (nonatomic, strong) UILabel * fontNameLabel;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) CGFloat initialHorizontalCenter;
@property (nonatomic,assign) CGFloat initialTouchPositionX;

@property (nonatomic,assign) LMFeedCellDirection lastDirection;
@property (nonatomic,assign) CGFloat originalCenter;

//ui
@property (nonatomic,strong) SeperateLine *seperateLine;
//@property (nonatomic,retain) UIView *bottomRightView;
//@property (nonatomic,retain) UIView *bottomLeftView;
//@property (nonatomic,retain) UILabel *titleLabel;
//@property (nonatomic,retain) UITextView *detailTextView;

@end
@implementation SVFontCompareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _compareView = [[SVColorCompareView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_compareView];
        _seperateLine = [[SeperateLine alloc]initWithFrame:CGRectZero];
        _seperateLine.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_seperateLine];
        _fontNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 500, 20)];
        _fontNameLabel.font = [UIFont systemFontOfSize:14];
        _fontNameLabel.textColor = [UIColor grayColor];
        _fontNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_fontNameLabel];
        _originalCenter=ceil(self.bounds.size.width / 2);
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
		_panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"fontDetail_compare_s"] forState:UIControlStateNormal];
        self.deleteButton.frame = CGRectMake(0, 0, 30, 30);
        self.deleteButton.center = CGPointMake(970, _fontNameLabel.center.y);
        [self.contentView addSubview:self.deleteButton];
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCompareCellHeight - 1, 1024, 1)];
        sepLine.backgroundColor = [UIColor grayColor];
//        SeperateLine *line = [[SeperateLine alloc] initWithFrame:CGRectMake(0, kCompareCellHeight - 1, 1024, 1)];
        [self.contentView addSubview:sepLine];
    }
    return self;
}
- (void)updateText:(NSString *)text{
    [_compareView updateText:text];
}
- (void)setText:(NSString *)text fontName:(NSString *)fontName{
    _fontNameLabel.text = fontName;
    _fontName = nil;
    _fontName = [fontName copy];
    [_compareView setText:text fontName:fontName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        NSLog(@"disappear?");
    }
    [super willMoveToSuperview:newSuperview];
    
}
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture{
    [_compareView panGestureHandle:gesture];
    /*
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"tap gesture began");
//        lastLocation = CGPointMake([gesture locationInView:self.label].x, self.label.frame.size.height);
//        CALayer * layer = self.label.layer.mask;
//        [layer setFrame:CGRectMake(0, 0, [gesture locationInView:self.label].x, self.label.frame.size.height)];
//        [self.label.layer setMask:layer];
//        [self.label setNeedsLayout];
        //        [self.label setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        NSLog(@"tap gesture change");
//        CAShapeLayer * layer = (CAShapeLayer *)self.label.layer.mask;
//        CGRect newFrame = CGRectMake(0, 0, [gesture locationInView:self.label].x, self.label.frame.size.height);
//        [layer setFrame:newFrame];
//        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newFrame cornerRadius:0.0];
//        [layer setPath:path.CGPath];
//        [self.label.layer setMask:layer];
        //        [self.label setNeedsLayout];
        //        [self.label setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        NSLog(@"tap gesture end");
        //        CAShapeLayer * layer = (CAShapeLayer *)self.label.layer.mask;
        //        CGRect newFrame = CGRectMake(0, 0, [gesture locationInView:self.label].x, self.label.frame.size.height);
        //        [layer setFrame:newFrame];
        //        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newFrame cornerRadius:0.0];
        //        [layer setPath:path.CGPath];
        //        [self.label.layer setMask:layer];
        //        [self.label setNeedsLayout];
        //        [self.label setNeedsDisplay];
    }
     */
    
}
#pragma mark
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == _panGesture) {
		UIScrollView *superview = (UIScrollView *)self.superview;
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
		// Make it scrolling horizontally
		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO &&
                (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
	}
	return YES;
}
 
@end
