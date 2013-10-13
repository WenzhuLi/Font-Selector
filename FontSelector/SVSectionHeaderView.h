//
//  SVSectionHeaderView.h
//  FontSelector
//
//  Created by Lee on 13-4-16.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SVCatagoryViewController.h"
#import "SVCataView.h"
#define kSectionHeaderHeight 150

@class SVSectionHeaderView;
@protocol SVSectionHeaderDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SVSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SVSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;


@end

@interface SVSectionHeaderView : UIView{
    UIButton * myButton;
    NSIndexPath * _indexPath;
}
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, readonly)NSInteger section;
@property (nonatomic, assign) id<SVSectionHeaderDelegate> delegate;
@property (nonatomic, readonly)NSMutableArray * fontsArray;
@property (nonatomic, assign)BOOL open;
+ (id)headerViewWithTitle:(NSString *)title section:(NSInteger )section;
+ (id)headerViewWithImageName:(NSString *)imgName section:(NSInteger )section;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)initializeFontsArrayWithCataType:(SVCataViewType)cataType value:(NSString *)value;

@end
