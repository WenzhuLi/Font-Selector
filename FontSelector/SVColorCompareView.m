//
//  SVColorCompareView.m
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVColorCompareView.h"
#import <QuartzCore/QuartzCore.h>


@implementation SVColorCompareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 1024, 250)];
    if (self) {
        // Initialization code
        _labelsArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray * colorsArray = [SVColorPair colorPairsArray];
        
        for (int i = 0; i < kNumberOfPairs; i++) {
            
            SVColoredLabelView * label = [[SVColoredLabelView alloc] initWithFrame:self.bounds];
//            [label setText:text font:font];
            [label setColorPair:[colorsArray objectAtIndex:i]];
            [_labelsArray addObject:label];
            
            [self addSubview:label];
        }
        _direction = LabelMoveDirectionNone;
        
    }
//    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
//    _panGesture.delegate = self;
//    [self addGestureRecognizer:_panGesture];
    return self;
}

- (void)setText:(NSString *)text fontName:(NSString *)fontName{
    
    for (int i = 0; i < kNumberOfPairs; i++) {
        SVColoredLabelView * label = [_labelsArray objectAtIndex:i];
        [label setText:text fontName:fontName];
        if (i == kNumberOfPairs - 1 ) {
            [self setCurrentLabelIndex:i direction:LabelMoveDirectionLeft];
        }
        
//        [_labelsArray addObject:label];
//        [self addSubview:label];
    }
}
- (void)updateText:(NSString*)text{
    for (int i = 0; i < kNumberOfPairs; i++) {
        SVColoredLabelView * label = [_labelsArray objectAtIndex:i];
        [label setText:text fontName:label.fontName];
    }
    NSLog(@"currentIndex:%d",self.currentLabelIndex);
}
- (void)setCurrentLabelIndex:(NSInteger)currentLabelIndex direction:(LabelMoveDirection) direction{
    NSLog(@"set currentLabelIndex : %d",currentLabelIndex);
    _currentLabelIndex = currentLabelIndex;
    NSInteger preIndex = _currentLabelIndex + 1;
    NSInteger nextIndex = _currentLabelIndex - 1;
//    NSInteger nextnextIndex = _currentLabelIndex - 2;
    if (direction == LabelMoveDirectionLeft) {
        if ([self indexAvailable:preIndex]) {
            SVColoredLabelView * preLabel = [_labelsArray objectAtIndex:preIndex];
            [preLabel changeToState:ColorLabelMaskHide animated:YES];
            
        }
        if ([self indexAvailable:nextIndex]) {
            SVColoredLabelView * currentLabel = [_labelsArray objectAtIndex:currentLabelIndex];
            [currentLabel changeToState:ColorLabelMaskMost animated:NO];
        }
    }
    else{
//        NSInteger nextnextIndex = _currentLabelIndex - 2;
        if ([self indexAvailable:preIndex]) {
            SVColoredLabelView * preLabel = [_labelsArray objectAtIndex:preIndex];
            [preLabel changeToState:ColorLabelMaskHide animated:NO];
            
        }
        if ([self indexAvailable:nextIndex]) {
            SVColoredLabelView * nextLabel = [_labelsArray objectAtIndex:nextIndex];
            [nextLabel changeToState:ColorLabelMaskInit animated:NO];
        }
        if ([self indexAvailable:_currentLabelIndex]) {
            SVColoredLabelView * currentLabel = [_labelsArray objectAtIndex:_currentLabelIndex];
            [currentLabel changeToState:ColorLabelMaskMost animated:YES];
            
        }
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(currentIndexChanged:)]) {
//        [self.delegate currentIndexChanged:_currentLabelIndex];
//    }
    /*
    if ([self indexAvailable:nextnextIndex]) {
        SVColoredLabelView * preLabel = [_labelsArray objectAtIndex:nextnextIndex];
        [preLabel changeToState:ColorLabelMaskInit animated:YES];
        
    }*/
    
}
- (BOOL)indexAvailable:(NSInteger)index{
    return index >= 0 && index < kNumberOfPairs;
}
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture{

    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"tap gesture began");
        lastLocation = CGPointMake([gesture locationInView:self].x, self.frame.size.height);
        touchIsMoving = NO;
//        CALayer * layer = self.layer.mask;
//        [layer setFrame:CGRectMake(0, 0, [gesture locationInView:self].x, self.label.frame.size.height)];
//        [self.label.layer setMask:layer];
//        [self.label setNeedsLayout];
//        [self.label setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint touchPoint = [gesture locationInView:self];
        CGFloat offset = touchPoint.x - lastLocation.x;
        _direction = (offset > 0 ?  LabelMoveDirectionRight : LabelMoveDirectionLeft);
        if (!touchIsMoving) {
            if (_direction == LabelMoveDirectionRight) {
                _currentLabelIndex = [self indexAvailable:_currentLabelIndex + 1] ? _currentLabelIndex + 1 : _currentLabelIndex;
            }
            touchIsMoving = YES;
        }
        if (_direction == LabelMoveDirectionRight) {
            SVColoredLabelView * label = [_labelsArray objectAtIndex:self.currentLabelIndex];
            
            
            NSLog(@"tap gesture offset %.0f",offset);
            [label moveMaskOffset:offset];
        }
        else if (_direction == LabelMoveDirectionLeft && [self indexAvailable:_currentLabelIndex - 1]) {
            SVColoredLabelView * label = [_labelsArray objectAtIndex:self.currentLabelIndex];
            
            
            NSLog(@"tap gesture offset %.0f",offset);
            [label moveMaskOffset:offset];
        }
        /*
//        NSLog(@"tap gesture change");
        if ((_direction == LabelMoveDirectionLeft && [self indexAvailable:_currentLabelIndex - 1]) || (_direction == LabelMoveDirectionRight && [self indexAvailable:_currentLabelIndex + 1])) {
        }
        else{
            SVColoredLabelView * label = [_labelsArray objectAtIndex:self.currentLabelIndex];
            
            
            NSLog(@"tap gesture offset %.0f",offset);
            [label moveMaskOffset:offset];
        }
         */
        /*
        if ([self indexAvailable:_currentLabelIndex - 1] && [self indexAvailable:_currentLabelIndex + 1]) {
            SVColoredLabelView * label = [_labelsArray objectAtIndex:self.currentLabelIndex];
            
            
            NSLog(@"tap gesture offset %.0f",offset);
            [label moveMaskOffset:offset];
        }
         */
        
        lastLocation = touchPoint;
        /*
        CAShapeLayer * layer = (CAShapeLayer *)label.layer.mask;
        if (!layer) {

            layer = [CAShapeLayer layer];
            CGRect rect = label.bounds;
            [layer setBounds:rect];
            [layer setFrame:rect];
            [layer setFillColor:[UIColor whiteColor].CGColor];
            [layer setStrokeColor:[[UIColor whiteColor] CGColor]];
            [layer setLineWidth:1.0f];
            [layer setLineJoin:kCALineJoinMiter];
            //    [layer setPosition:CGPointMake(0.5, 0.5)];
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0.0];
            [layer setPath:path.CGPath];
            [label.layer setMask:layer];


        }
        CGRect newFrame = CGRectMake(0, 0, [gesture locationInView:self].x,self.frame.size.height);
        [layer setFrame:newFrame];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newFrame cornerRadius:0.0];
        [layer setPath:path.CGPath];
        [label.layer setMask:layer];
         */
//        [label setNeedsLayout];
//        [label setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){

        if (_direction == LabelMoveDirectionLeft) {
            NSInteger next = _currentLabelIndex - 1;
            if ([self indexAvailable:next]) {
                [self setCurrentLabelIndex:next direction:LabelMoveDirectionLeft];
            }
            else
                [self setCurrentLabelIndex:_currentLabelIndex direction:LabelMoveDirectionLeft];
        }
        else if (_direction == LabelMoveDirectionRight){
//            NSInteger preIndex = _currentLabelIndex + 1;
//            if ([self indexAvailable:preIndex]) {
//                self.currentLabelIndex = preIndex;
//            }
//            else
                [self setCurrentLabelIndex:_currentLabelIndex direction:LabelMoveDirectionRight];
        }

        touchIsMoving = NO;
        /*
        SVColoredLabelView * label = [_labelsArray objectAtIndex:7];
         CAShapeLayer * layer = (CAShapeLayer *)label.layer.mask;
        CGRect oldR = layer.frame;
        CGRect newR = oldR;
        if (oldR.size.width < 400) {
            NSLog(@"oldR.size.width < 400");
            [CATransaction begin];
            CGPoint position = label.layer.mask.position;
            position.x -= 100;
            [label.layer.mask setPosition:position];
            [CATransaction commit];
        }
         */
//        NSLog(@"tap gesture end");
        //        CAShapeLayer * layer = (CAShapeLayer *)self.label.layer.mask;
        //        CGRect newFrame = CGRectMake(0, 0, [gesture locationInView:self.label].x, self.label.frame.size.height);
        //        [layer setFrame:newFrame];
        //        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newFrame cornerRadius:0.0];
        //        [layer setPath:path.CGPath];
        //        [self.label.layer setMask:layer];
        //        [self.label setNeedsLayout];
        //        [self.label setNeedsDisplay];
    }
}
/*
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
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
