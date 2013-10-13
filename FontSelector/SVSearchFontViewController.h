//
//  SVSearchFontViewController.h
//  FontSelector
//
//  Created by Lee on 13-5-2.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVDatabase.h"
#import "UIFolderTableView.h"
#import "SVFolderView.h"
#import "SVFontDetailCell.h"
@class SVCatagoryViewController;
@interface SVSearchFontViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIFolderTableViewDelegate,SVFontDetailCellDelegate>{
    NSMutableArray * filterArray;
    PLSqliteDatabase * db;
    NSMutableArray * _compareArray;
}
@property (nonatomic, strong)SVCatagoryViewController * fatherController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *searchBarView;
@property (strong, nonatomic) IBOutlet UIFolderTableView *tableView;
@property (nonatomic, assign)BOOL isShowing;
@property (nonatomic, strong)SVFolderView * folderContent;
- (void)show;
- (void)hide;
- (id)initWithFatherController:(SVCatagoryViewController *)fatherController;
@end
