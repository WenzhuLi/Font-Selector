//
//  SVCataView.h
//  FontSelector
//
//  Created by Lee on 13-4-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVStrokeLabel.h"
typedef enum {
    SVCataViewTypeTimes,
    SVCataViewTypePrice,
    SVCataViewTypeCompany,
    SVCataViewTypeFavorite,
    SVCataViewTypeStyle
}SVCataViewType;
@class SVCataView;
@protocol SVCataViewDelegate <NSObject>

- (void)cataViewTapped:(SVCataView *)cView;

@end
@interface SVCataView : UIView<UIGestureRecognizerDelegate>{
    SVCataViewType _type;
}
@property (nonatomic, strong) id<SVCataViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *letterImg;
@property (strong, nonatomic) IBOutlet UIView *hlBackgroudview;
@property (strong, nonatomic) IBOutlet UIImageView *highlightImg;
@property (strong, nonatomic) IBOutlet SVStrokeLabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, readonly) SVCataViewType type;
- (id)initWithType:(SVCataViewType)type;
- (void)skinny;
- (void)fat;
- (void)Highlighted:(BOOL)highlighted;
@end
