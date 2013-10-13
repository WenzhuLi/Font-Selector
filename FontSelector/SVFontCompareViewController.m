//
//  SVFontCompareViewController.m
//  FontSelector
//
//  Created by Lee on 13-4-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVFontCompareViewController.h"
#import "SVCatagoryViewController.h"
#import "SVFontCompareCell.h"
#import "UIViewController+MJPopupViewController.h"

@interface SVFontCompareViewController ()

@end

@implementation SVFontCompareViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.fontsArray = [SVCatagoryViewController compareArray];
        self.cellsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        self.folderContent = [[SVFolderView alloc] initWithFrame:kFolderViewFrameMax];
        [self.folderContent setFont:[[SVFontDetail alloc] init]];
    }
    return self;
}
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Font Comparison";
    self.tableView = nil;
//    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    
    self.navigationItem.hidesBackButton = YES;
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_btn_highlight"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
    self.tableView = [[UIFolderTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    UIFolderTableView * table = (UIFolderTableView *)self.tableView;
    table.folderDelegate = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
//    self.tableView.bounces = NO;
    UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.fontsArray.count > 0 ? @"compare_background" : @"compare_background_null"]];
    
    [bg sizeToFit];
//    UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBack"]];
//    [back sizeToFit];
    [self.tableView setBackgroundView:bg];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit_s"] forState:UIControlStateSelected];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit_h"] forState:UIControlStateHighlighted];
    [editButton sizeToFit];
    //    [_compareButton setBadgeString:@"13"];
    [editButton addTarget:self action:@selector(editUserText) forControlEvents:UIControlEventTouchUpInside];
    //    editButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem * edit = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = edit;
    if (self.fontsArray.count == 0) {
        editButton.enabled = NO;
    }
    else{
        UIImage * upshadowImg = [UIImage imageNamed:@"upshadow"];
        //        UIImage * shadowImg = [UIImage imageNamed:@"shadow"] ;
        UIImageView * upshadow = [[UIImageView alloc] initWithImage:upshadowImg];
        [upshadow sizeToFit];
        CGRect bounds = upshadow.bounds;
        upshadow.frame = CGRectMake(0, - bounds.size.height, 1024, bounds.size.height);
        [self.tableView addSubview:upshadow];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)editUserText{
    SVInputViewController *input = [[SVInputViewController alloc] initWithType:SVInputViewBig];
    input.delegate = self;
    editButton.selected = YES;
    [self presentPopupViewController:input animationType:MJPopupViewAnimationFade];
    [input.textView becomeFirstResponder];
    //    [ASDepthModalViewController presentView:self.editView withBackgroundColor:[UIColor blackColor] popupAnimationStyle:ASDepthModalAnimationDefault blur:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear array count : %d",self.cellsArray.count);
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear array count : %d",self.cellsArray.count);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fontsArray count];
//    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCompareCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SVFontCompareCell";
    SVFontDetail * font = [self.fontsArray objectAtIndex:indexPath.row];
    NSString * usertext = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey];
    NSLog(@"usertext:%@",usertext);
    /*
    SVFontCompareCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SVFontCompareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setText:[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey] fontName:font.fontName];
        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
//        [self.cellsArray addObject:cell];
    }
     */

    if (indexPath.row >= self.cellsArray.count) {
        SVFontCompareCell * cell = [[SVFontCompareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setText:[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey] fontName:font.fontName];
        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellsArray addObject:cell];

        return cell;
    }
     
    else{
        
        return [self.cellsArray objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
//    cell.textLabel.text = [NSString stringWithFormat:@"cell %d",indexPath.row];
    
    
//    return cell;
}
- (void)deleteRow:(UIButton*)sender{
    [self removeIndex:sender.tag];
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sure to Remove?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = sender.tag;
    [alert show];
     */
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.fontsArray removeObjectAtIndex:alertView.tag];
        [self.cellsArray removeObjectAtIndex:alertView.tag];
        NSInteger count = self.cellsArray.count ;
        for (int i = alertView.tag; i < count; i++) {
            SVFontCompareCell * cell = [self.cellsArray objectAtIndex:i];
            cell.deleteButton.tag = i;
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.fontsArray.count == 0) {
            UIImageView * bg = (UIImageView *)self.tableView.backgroundView;
            //    UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBack"]];
            //    [back sizeToFit];
            bg.image = [UIImage imageNamed:@"compare_background_null"];
            editButton.enabled = NO;
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (void)removeIndex:(NSInteger)index{
    [self.fontsArray removeObjectAtIndex:index];
    [self.cellsArray removeObjectAtIndex:index];
    NSInteger count = self.cellsArray.count ;
    for (int i = index; i < count; i++) {
        SVFontCompareCell * cell = [self.cellsArray objectAtIndex:i];
        cell.deleteButton.tag = i;
    }
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.fontsArray.count == 0) {
        UIImageView * bg = (UIImageView *)self.tableView.backgroundView;
        //    UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBack"]];
        //    [back sizeToFit];
        bg.image = [UIImage imageNamed:@"compare_background_null"];
        editButton.enabled = NO;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = kCompareCellHeight;
    SVFontDetail * font = [self.fontsArray objectAtIndex:indexPath.row];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - SVInputViewDelegate

- (void)inputViewWillDisappearWithString:(NSString *)inputString{
    if (inputString.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:inputString forKey:kCurrentTextKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //    for (SVIndexTableViewController * tableC in tableViewsArray) {
        //        [tableC.tableView beginUpdates];
        //        [tableC.tableView endUpdates];
        //    }
        //    [companyTable.tableView beginUpdates];
        //    [companyTable.tableView endUpdates];
        
        for (SVFontCompareCell * cell in self.cellsArray) {
            [cell updateText:inputString];
        }
        [self.tableView reloadData];
        
        
    }
    editButton.selected = NO;
    
}
- (void)inputViewOKButtonTapped{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
