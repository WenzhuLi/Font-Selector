//
//  SVBadgedButton.h
//  FontSelector
//
//  Created by Lee on 13-5-3.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface SVBadgedButton : UIButton{
    CustomBadge * _badgeView;
}

@property (nonatomic, strong)NSString * badgeString;

@end
