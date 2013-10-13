//
//  SVFontDetail.h
//  FontSelector
//
//  Created by Lee on 13-4-17.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kFontRateOne @"1"
#define kFontRateTwo @"2"
#define kFontRateThree @"3"
#define kFontRateZero @"0"
@interface SVFontDetail : NSObject

@property (nonatomic, strong)NSString * fontName;
@property (nonatomic, strong)NSString * publisher;
@property (nonatomic, strong)NSString * price;
@property (nonatomic, strong)NSString * style;
@property (nonatomic, strong)NSString * year;
@property (nonatomic, strong)NSString * introduction;
@property (nonatomic, strong)NSString * link;
@property (nonatomic, strong)NSString * star;
@property (nonatomic, assign)NSInteger fontID;
@end
