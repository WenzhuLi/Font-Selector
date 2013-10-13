//
//  SVFontCompareViewController.h
//  FontSelector
//
//  Created by Lee on 13-4-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "SVFolderView.h"
#import "SVInputViewController.h"
@interface SVFontCompareViewController : UITableViewController<UIFolderTableViewDelegate,UIAlertViewDelegate,SVInputViewDelegate>{
    UIButton * editButton;
}

@property (nonatomic, strong)NSMutableArray * fontsArray;
@property (nonatomic, strong)NSMutableArray * cellsArray;
@property (nonatomic, strong)SVFolderView * folderContent;

@end
