//
//  SVNavigationBar.m
//  FontSelector
//
//  Created by Lee on 13-4-11.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVNavigationBar.h"

@implementation SVNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    UIImage * background = [[UIImage imageNamed:@"navigation_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [background drawInRect:rect];
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
