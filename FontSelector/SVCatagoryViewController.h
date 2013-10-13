//
//  SVCatagoryViewController.h
//  FontSelector
//
//  Created by Lee on 13-4-13.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCataView.h"
#import "SVIndexTableViewController.h"
#import "SVEditTextView.h"
#import "SVInputViewController.h"
#import "SVSearchFontViewController.h"
#import "SVBadgedButton.h"
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define kTableWidth 784
#define kNumberOfCata 5
#define kBigRectWidth 1024 / kNumberOfCata
#define kSmallRectWidth (1024 - kTableWidth) / kNumberOfCata
#define kAnimationDuration 0.7
#define kViewHeight 704
@interface SVCatagoryViewController : UIViewController<SVCataViewDelegate,SVInputViewDelegate,SVFontDetailCellDelegate,UIAlertViewDelegate>{

    NSMutableArray * bigRectArray;
    NSMutableArray * smallRectArray;
    NSArray * cataViewsArray;
    NSArray * tableViewsArray;
    SVCataView * styleView;
    SVCataView * timesView;
    SVCataView * companyView;
    SVCataView * priceView;
    SVCataView * favoriteView;
    NSInteger _selectedIndex;
    SVCataViewType selectedCataType;
    SVIndexTableViewController * styleTable;
    SVIndexTableViewController * timesTable;
    SVIndexTableViewController * companyTable;
    SVIndexTableViewController * priceTable;
    SVIndexTableViewController * favoriteTable;
    SVSearchFontViewController * _searchController;
    SVBadgedButton * _compareButton;
//    SVFontDetailCell * currentCell;
    UIButton * searchButton;
    UIButton * editButton;
    SVInputViewController * inputController;
}
@property (nonatomic, strong)SVEditTextView * editView;
@property (nonatomic, strong)SVBadgedButton * compareButton;
+ (NSMutableArray *)compareArray;
+ (BOOL)fontInCompareArray:(SVFontDetail *)font;
@end
