//
//  SVCataView.m
//  FontSelector
//
//  Created by Lee on 13-4-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVCataView.h"
#import <QuartzCore/QuartzCore.h>

static BOOL touchBlocked;
@implementation SVCataView
@synthesize delegate = _delegate;
@synthesize selected = _selected;
@synthesize type = _type;
- (id)initWithType:(SVCataViewType)type
{
    self = [super initWithFrame:CGRectMake(0, 0, 205, 704)];
    if (self) {
        // Initialization code
        _type = type;
        NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"SVCataView" owner:self options:nil];
        [self addSubview:[nibs objectAtIndex:0]];
        self.subTitleLabel.transform =  CGAffineTransformMakeRotation(M_PI_2);
        [self updateType];
        self.selected = NO;
        
        UILongPressGestureRecognizer * press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        press.minimumPressDuration = 0.0;
        press.delegate = self;
        [self addGestureRecognizer:press];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:tap];
        
//        self.layer.shadowColor = [[UIColor whiteColor] CGColor];
//        self.layer.shadowOffset = CGSizeMake(5, 0);
//        self.layer.shadowOpacity = 0.7;
//        self.layer.shadowRadius = 2;
        /*
        CAShapeLayer * layer = [CAShapeLayer layer];
        CGRect rect = self.bounds;
//        if (!layer) {
            
            [layer setBounds:rect];
            [layer setFrame:rect];
            [layer setFillColor:[UIColor whiteColor].CGColor];
            [layer setStrokeColor:[[UIColor whiteColor] CGColor]];
            [layer setLineWidth:1.0f];
            [layer setLineJoin:kCALineJoinMiter];
            //    [layer setPosition:CGPointMake(0.5, 0.5)];
            
//        }
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
        [layer setPath:path.CGPath];
        [self.layer setMask:layer];
         */
        self.layer.masksToBounds = YES;

    }
    
    return self;
}
- (void)updateType{
    NSString * type = nil;
    switch (_type) {
        case SVCataViewTypeCompany:
            self.titleLabel.text = @"公\n司";
            self.subTitleLabel.text = @"C  O  M  P  A  N  Y";
            type = @"company";
            break;
        case SVCataViewTypeFavorite:
            self.titleLabel.text = @"收\n藏";
            self.subTitleLabel.text = @"F  A  V  O  R  I  T  E";
            type = @"favorite";
            break;
        case SVCataViewTypePrice:
            self.titleLabel.text = @"价\n格";
            self.subTitleLabel.text = @"P  R  I  C  E";
            type = @"price";
            break;
        case SVCataViewTypeStyle:
            self.titleLabel.text = @"风\n格";
            self.subTitleLabel.text = @"S  T  Y  L  E";
            type = @"style";
            break;
        case SVCataViewTypeTimes:
            self.titleLabel.text = @"年\n代";
            self.subTitleLabel.text = @"T  I  M  E  S";
            type = @"time";
            break;
            
        default:
            break;
    }
    self.highlightImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"highlight_%@",type]];
    self.letterImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"cata_letter_%@",type]];
}
- (void)skinny{
    //写绝对坐标就好
    CGRect labelFrame = self.subTitleLabel.frame;
    labelFrame.origin.x = 0;
    labelFrame.origin.y = 10;
    self.subTitleLabel.frame = labelFrame;
    CGRect imgFrame = self.letterImg.frame;
    imgFrame.origin = CGPointMake(-85, 170);
    self.letterImg.frame = imgFrame;
    self.highlightImg.frame = imgFrame;
    self.letterImg.alpha = 0.6;
    
//    CGRect titleLabelFrame = self.titleLabel.frame;
//    titleLabelFrame.origin.x = -50;
//    titleLabelFrame.origin.y = 280;
//    self.titleLabel.frame = titleLabelFrame;
    
//    CAShapeLayer * layer = (CAShapeLayer *)self.titleLabel.layer.mask;
//    CGRect rect = self.titleLabel.bounds;
//    NSLog(@"fat bound layer:%@",[NSValue valueWithCGRect:rect]);
//    self.titleLabel.layer.masksToBounds = YES;
//    CGPoint center = self.subTitleLabel.center;
//    center.y = center.y - 150;
//    center.x = self.center.x;
//    self.subTitleLabel.center = center;
}
- (void)fat{
//    CGRect frame = self.frame;

    CGRect labelFrame = self.subTitleLabel.frame;
    labelFrame.origin.x = 75;
    labelFrame.origin.y = 83;
    self.subTitleLabel.frame = labelFrame;
    CGRect imgFrame = self.letterImg.frame;
    imgFrame.origin = CGPointMake(0, 0);
    self.letterImg.frame = imgFrame;
    self.highlightImg.frame = imgFrame;
    self.letterImg.alpha = 1.0;
    
//    CGRect titleLabelFrame = self.titleLabel.frame;
//    titleLabelFrame.origin.x = 50;
//    titleLabelFrame.origin.y = 150;
//    self.titleLabel.frame = titleLabelFrame;
}
- (void)handleTap:(UILongPressGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self Highlighted:YES];
            break;
        case UIGestureRecognizerStateEnded:
            
            touchBlocked = NO;
            [self Highlighted:NO];
            CGPoint location = [gesture locationInView:self];
            if (CGRectContainsPoint(self.bounds, location)) {
                //touch ended
                NSLog(@"gesture end");
                if (_delegate && [_delegate respondsToSelector:@selector(cataViewTapped:)]) {
                    [_delegate cataViewTapped:self];
                }
            }
            else{
                //touch canceled
                NSLog(@"gesture canceled");
            }
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected{
    self.subTitleLabel.textColor = selected ? [UIColor colorWithRed:0.855 green:0.118 blue:0.000 alpha:1.0] : [UIColor blackColor];
    _selected = selected;
    
}
- (void)Highlighted:(BOOL)highlighted{
    if (highlighted) {
        self.highlightImg.hidden = NO;
        self.subTitleLabel.textColor = [UIColor whiteColor];
        self.hlBackgroudview.hidden = NO;
        [self.subTitleLabel setStrokeWidth:0];
    }
    else{
        self.highlightImg.hidden = YES;
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.hlBackgroudview.hidden = YES;
        [self.subTitleLabel setStrokeWidth:kStrokeWidthDefault];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (touchBlocked) {
        return NO;
    }
    else{
        touchBlocked = YES;
        return YES;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch down");

    [self Highlighted:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self.superview];
    [self Highlighted:NO];
    if (CGRectContainsPoint(self.frame, location)) {
        NSLog(@"touch up inside");
        if (_delegate && [_delegate respondsToSelector:@selector(cataViewTapped:)]) {
            [_delegate cataViewTapped:self];
        }
    }
    else
        NSLog(@"touch cancelled");
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch cancelled");
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
