//
//  SVBadgedButton.m
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVBadgedButton.h"

#define kBadgeCenter CGPointMake(self.frame.size.width - _badgeView.frame.size.width / 3, 2)
@implementation SVBadgedButton
@synthesize badgeString = _badgeString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setBadgeString:(NSString *)badgeString{
    _badgeString = nil;
    _badgeString = badgeString;
    if (!badgeString) {
        _badgeView.hidden = YES;
    }
    else{
        
    if (!_badgeView) {
        _badgeView = [CustomBadge customBadgeWithString:_badgeString withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.7 withShining:YES];
        _badgeView.center = kBadgeCenter;
        [self addSubview:_badgeView];
    }
    else{
        [_badgeView autoBadgeSizeWithString:_badgeString];
        _badgeView.center = kBadgeCenter;
    }
        _badgeView.hidden = NO;
    }
    
}
- (NSString *)badgeString{
    return _badgeView.badgeText;
}
- (void)sizeToFit{
    [super sizeToFit];
    if (_badgeView) {
        _badgeView.center = kBadgeCenter;
    }
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
