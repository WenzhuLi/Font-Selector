//
//  SVColorPair.h
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNumberOfPairs 8
@interface SVColorPair : NSObject
@property (nonatomic, retain)UIColor * backgroundColor;
@property (nonatomic, retain)UIColor * textColor;
+(SVColorPair *)colorPairOne;
+(SVColorPair *)colorPairTwo;
+(SVColorPair *)colorPairThree;
+(SVColorPair *)colorPairFour;
+(SVColorPair *)colorPairFive;
+(SVColorPair *)colorPairSix;
+(SVColorPair *)colorPairSeven;
+(SVColorPair *)colorPairEight;
- (id)initWithBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;
+ (NSArray *)colorPairsArray;
@end
