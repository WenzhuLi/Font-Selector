//
//  SVColorPair.m
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVColorPair.h"

@implementation SVColorPair

- (id)initWithBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor{
    self = [super init];
    if (self) {
        self.backgroundColor = backgroundColor;
        self.textColor = textColor;
    }
    return self;
}
+ (NSArray *)colorPairsArray{
    return [NSArray arrayWithObjects:
            [SVColorPair colorPairOne],
            [SVColorPair colorPairTwo],
            [SVColorPair colorPairThree],
            [SVColorPair colorPairFour],
            [SVColorPair colorPairFive],
            [SVColorPair colorPairSix],
            [SVColorPair colorPairSeven],
            [SVColorPair colorPairEight], nil];
}
+(SVColorPair *)colorPairOne{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.365 green:0.616 blue:0.235 alpha:1.0] textColor:[UIColor colorWithRed:0.945 green:0.671 blue:0.086 alpha:1.0]] autorelease];
}
+(SVColorPair *)colorPairTwo{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.475 green:0.000 blue:0.475 alpha:1.0] textColor:[UIColor colorWithRed:0.000 green:1.000 blue:0.518 alpha:1.0]] autorelease];
}
+(SVColorPair *)colorPairThree{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.304 green:0.356 blue:0.682 alpha:1.0] textColor:[UIColor colorWithRed:1.000 green:0.861 blue:0.616 alpha:1.0]] autorelease];
}
+(SVColorPair *)colorPairFour{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.141 green:0.824 blue:1.000 alpha:1.0] textColor:[UIColor colorWithRed:0.918 green:1.000 blue:0.000 alpha:1.0]] autorelease];
}
+(SVColorPair *)colorPairFive{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.929 green:0.000 blue:0.004 alpha:1.0] textColor:[UIColor whiteColor]] autorelease];
}
+(SVColorPair *)colorPairSix{
    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:1.000 green:0.878 blue:0.047 alpha:1.0] textColor:[UIColor blackColor]] autorelease];
}
+(SVColorPair *)colorPairSeven{
//    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.580 green:0.682 blue:0.086 alpha:1.0] textColor:[UIColor colorWithRed:0.980 green:0.925 blue:0.576 alpha:1.0]] autorelease];
     return [[[self alloc] initWithBackgroundColor:[UIColor blackColor] textColor:[UIColor whiteColor]] autorelease];
}
+(SVColorPair *)colorPairEight{
//    return [[[self alloc] initWithBackgroundColor:[UIColor colorWithRed:0.063 green:0.310 blue:0.404 alpha:1.0] textColor:[UIColor colorWithRed:0.588 green:0.780 blue:0.855 alpha:1.0]] autorelease];
     return [[[self alloc] initWithBackgroundColor:[UIColor whiteColor] textColor:[UIColor blackColor]] autorelease];
}
- (void)dealloc{
    [_backgroundColor release];
    [_textColor release];
    [super dealloc];
}
@end
