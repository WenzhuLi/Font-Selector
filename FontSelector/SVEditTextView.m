//
//  SVEditTextView.m
//  FontSelector
//
//  Created by Lee on 13-4-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVEditTextView.h"

@implementation SVEditTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        self.textInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, 36)];
        self.textInput.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.textInput];
        self.textInput.center = CGPointMake(frame.size.width / 2, frame.size.width / 3);
        UIButton * ok = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ok setTitle:@"Done" forState:UIControlStateNormal];
        ok.frame = CGRectMake(0, 0, frame.size.width - 50, 35);
        ok.center = CGPointMake(frame.size.width / 2, frame.size.width / 3 * 2);
        [self addSubview:ok];
    }
    return self;
}
- (id)init{
    return [self initWithFrame:CGRectMake(0, 0, 400, 400)];
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
