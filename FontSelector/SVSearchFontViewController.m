//
//  SVSearchFontViewController.m
//  FontSelector
//
//  Created by Lee on 13-5-2.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVSearchFontViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVFontDetail.h"
#import "SVCatagoryViewController.h"



@interface SVSearchFontViewController ()

@end

@implementation SVSearchFontViewController

- (id)initWithFatherController:(SVCatagoryViewController *)fatherController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.isShowing = NO;
        self.fatherController = fatherController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"search view did load..");
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTranslucent:YES];
    self.searchBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchBarView.layer.shadowOffset = CGSizeMake(0, 2);
    self.searchBarView.layer.shadowOpacity = 0.5;
    self.searchBarView.layer.shadowRadius = 9;
    filterArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.view.alpha = 0;
    self.folderContent = [[SVFolderView alloc] initWithFrame:kFolderViewFrameMax];
//    UIFolderTableView * table = (UIFolderTableView *)self.tableView;
    self.tableView.folderDelegate = self;
//    [self.folderContent setFont:[[SVFontDetail alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)readFilterArrayWithKey:(NSString *)key{
    if (!db) {
        db = [SVDatabase fontDetailDatabase];
    }
    NSString * q = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE FontName LIKE  '%@%%';",kFontsTableName,key];
    id<PLResultSet> result = [db executeQuery:q];
    NSLog(@"query: %@",q);
    [filterArray removeAllObjects];
    while ([result next]) {
        SVFontDetail * font = [[SVFontDetail alloc] init];
        NSString * type = [result objectForColumn:@"Type"];
        if ([type isEqualToString:@"-"]) {
            font.fontName = [result objectForColumn:@"FontName"];
        }
        else
            font.fontName = [[NSString stringWithFormat:@"%@-%@",[result objectForColumn:@"FontName"],type] stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIFont * sysFont = [UIFont fontWithName:font.fontName size:15];
        if (sysFont) {
            NSLog(@"font exist: %@",font.fontName);
            font.publisher = [result objectForColumn:@"Publisher"];
            font.year = [result objectForColumn:@"Year"];
            font.price = [result objectForColumn:@"Price"];
            font.style = [result objectForColumn:@"Style"];
            font.link = [result objectForColumn:@"Link"];
            if (![result isNullForColumn:@"Intro"]) {
                font.introduction = [result objectForColumn:@"Intro"];
            }
            
            font.fontID = [[result objectForColumn:@"id"] integerValue];
            font.star = [result objectForColumn:@"rate"];
            [filterArray addObject:font];
        }
        else{
            NSLog(@"TTTTTTT font not exist: %@",font.fontName);
        }
    }
}
#pragma mark - UISearchBarDlegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        [self readFilterArrayWithKey:searchText];
    }
    else
        [filterArray removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark - UIFolderViewDelegate
- (CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _folderContent.frame.size.width / 2;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 //    return [SVSectionHeaderView headerViewWithTitle:_typeString indexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
 
 return [_sectionHeaderArray objectAtIndex:section];
 }
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filterArray.count;
}
/*
 - (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 return kSectionHeaderHeight;
 }
 */
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kFontDetailCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"fontDetailCell";
        SVFontDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SVFontDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor darkGrayColor];
            cell.customCellWidth = 1024-10;
            cell.delegate = self;
        }
    
        SVFontDetail * font = [filterArray objectAtIndex:indexPath.row];
    NSAssert([font isKindOfClass:[SVFontDetail class]], @"!!!!");
    if ([SVCatagoryViewController fontInCompareArray:font]) {
        cell.addToCompareButton.selected = YES;
    }
    else
        cell.addToCompareButton.selected = NO;
        [cell setPreviewFont:font];
        return cell;

}
#pragma mark - SVFontDetailCellDelegate
- (void)cellAddToCompare:(SVFontDetailCell *)fontCell{
    if (!_compareArray) {
        NSLog(@"compare in catagory");
        _compareArray = [SVCatagoryViewController compareArray];
    }
    if (![SVCatagoryViewController fontInCompareArray:fontCell.fontDetail]) {
        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"already added" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        //        [alert show];
        //        return;
        NSLog(@"cell frame : %@",NSStringFromCGRect(fontCell.addToCompareButton.frame));
        [_compareArray addObject:fontCell.fontDetail];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        CGRect startFrame = [fontCell convertRect:fontCell.addToCompareButton.frame toView:window];
        NSLog(@"%@",NSStringFromCGRect(startFrame));
        
        [self doCompareAnimationWithStartFrame:startFrame];
        [fontCell.addToCompareButton setSelected:YES];
    }
    else{
        //        currentCell = fontCell;
        [_compareArray removeObject:fontCell.fontDetail];
        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
//        UIButton * _compareButton = (UIButton *)self.fatherController.navigationItem.rightBarButtonItem.customView;
        self.fatherController.compareButton.transform = leftWobble;  // starting point
        
        [UIView beginAnimations:@"wobble" context:(__bridge void *)(self.fatherController.compareButton)];
        [UIView setAnimationRepeatAutoreverses:YES]; // important
        [UIView setAnimationRepeatCount:3];
        [UIView setAnimationDuration:0.15];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
        
        self.fatherController.compareButton.transform = rightWobble; // end here & auto-reverse
        
        [UIView commitAnimations];
    }
    
    //    [_compareButton setBadgeString:[NSString stringWithFormat:@"%d",[_compareArray count]]];
}
- (void)doCompareAnimationWithStartFrame:(CGRect)startFrame{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIImageView * yellow = [[UIImageView alloc] initWithFrame:startFrame];
    //    yellow.backgroundColor = [UIColor yellowColor];
    [yellow setImage:[UIImage imageNamed:@"fontDetail_compare_s"]];
    [window addSubview:yellow];
//    SVBadgedButton * _compareButton = (SVBadgedButton *)self.fatherController.navigationItem.rightBarButtonItem.customView;
    CGRect endRect = [self.fatherController.navigationController.navigationBar convertRect:self.fatherController.compareButton.frame toView:window];
    
    [UIView animateWithDuration:1 animations:^{
        yellow.frame = endRect;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1 animations:^{
            //            CGPoint center = yellow.center;
            CGRect scale = yellow.frame;
            scale.origin.x -= (scale.size.width / 2);
            scale.origin.y -= (scale.size.height / 2);
            scale.size.width *= 2;
            scale.size.height *= 2;
            
            yellow.frame = scale;
            //            yellow.center = center;
            yellow.alpha = 0.0;
        }completion:^(BOOL finished){
            [yellow removeFromSuperview];
            [self.fatherController.compareButton setBadgeString:[NSString stringWithFormat:@"%d",[_compareArray count]]];
        }];
    }];
}
- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
        [item sizeToFit];
    }
    NSInteger count = _compareArray.count;
    [self.fatherController.compareButton setBadgeString:count > 0 ? [NSString stringWithFormat:@"%d",count] : nil];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    self.tableView.rowHeight = kFontDetailCellHeight;
    SVFontDetail * font = [filterArray objectAtIndex:indexPath.row];
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    self.tableView.scrollEnabled = NO;
    
    [self.folderContent setFont:font];
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:self.folderContent
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               self.tableView.scrollEnabled = YES;
                           }];
    NSLog(@"font %@ selected...",font);
}
#pragma mark - Table show and hide
- (void)show{
    self.searchBarView.center = CGPointMake(self.searchBarView.center.x, -25);
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDidStopSelector:@selector(didShow)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    self.view.alpha = 1.0;
    self.searchBarView.center = CGPointMake(self.searchBarView.center.x, 25);
    [UIView commitAnimations];
    
}
- (void)hide{
    [self.searchBar resignFirstResponder];
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(didHide)];
    [UIView setAnimationDuration:0.2];
    self.view.alpha = 0.0;
    self.searchBarView.center = CGPointMake(self.searchBarView.center.x, -25);
    [UIView commitAnimations];
}
- (void)didShow{
    self.isShowing = YES;
    [self.searchBar becomeFirstResponder];
}
- (void)didHide{
    self.isShowing = NO;
    [filterArray removeAllObjects];
    [self.tableView reloadData];
}
@end
