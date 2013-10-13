//
//  SVColorCompareView.h
//  FontSelector
//
//  Created by Lee on 13-5-4.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVColoredLabelView.h"

typedef enum{
    LabelMoveDirectionLeft,
    LabelMoveDirectionRight,
    LabelMoveDirectionNone
}LabelMoveDirection;
//@protocol SVColorCompareViewDelegate <NSObject>
//
//- (void)currentIndexChanged:(NSInteger)newCurrentIndex;
//
//@end
@interface SVColorCompareView : UIView<UIGestureRecognizerDelegate>{
    NSMutableArray * _labelsArray;
    NSInteger _currentLabelIndex;
    CGPoint lastLocation;
    LabelMoveDirection _direction;
    BOOL touchIsMoving;
}
//@property (nonatomic, strong)id<SVColorCompareViewDelegate>delegate;
@property (nonatomic, strong)NSString * text;
@property (nonatomic, assign)NSInteger currentLabelIndex;
//@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
- (void)setText:(NSString *)text fontName:(NSString *)fontName;
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture;
- (void)updateText:(NSString*)text;
@end
