//
//  SVStrokeLabel.h
//  FontSelector
//
//  Created by Lee on 13-5-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kStrokeWidthDefault 5
@interface SVStrokeLabel : UILabel{
    NSInteger _stokeWidth;
}
- (void)setStrokeWidth:(NSInteger)strokeWidth;
@end
