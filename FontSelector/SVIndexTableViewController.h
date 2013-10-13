//
//  SVIndexTableViewController.h
//  FontSelector
//
//  Created by Lee on 13-4-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVCataView.h"
#import "SVSectionHeaderView.h"
#import "SVDatabase.h"
//#import "SVFolderContentViewController.h"
#import "SVFolderView.h"
#import "SVFontDetailCell.h"
#import "UIFolderTableView.h"
@interface SVIndexTableViewController : UITableViewController<SVSectionHeaderDelegate,SVFontDetailCellDelegate,UIFolderTableViewDelegate,SVFolderViewDelegate>{
    NSInteger _selectedSection;
    NSString * _typeString;
    
    //titles
    NSMutableArray * _sectionsArray;
    
    NSInteger _previousSectionIndex;
    NSInteger _selectedSectionIndex;
    NSMutableArray * _selectedFontsArray;
    NSMutableArray * _sectionHeaderArray;
    NSMutableDictionary * _dataDictionary;
    UIImageView * shadow;
//    NSIndexPath * preOpenFolderIndex;
//    NSIndexPath * openFolderIndex;
}
//@property (nonatomic, strong)SVFolderContentViewController * folderContent;
@property (nonatomic, strong)id<SVFontDetailCellDelegate> compareDelegate;
@property (nonatomic, strong)SVFolderView * folderContent;
@property (nonatomic, assign)SVCataViewType type;
@property (assign)BOOL isOpen;
@property (nonatomic, strong)NSMutableArray * sectionHeaderArray;
@property (nonatomic,strong)NSIndexPath *selectIndex;
- (id)initWithType:(SVCataViewType)type;
- (void)resetFavoriteTable;
- (void)closeOpenFolder;
@end
