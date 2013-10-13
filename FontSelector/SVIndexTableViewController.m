//
//  SVIndexTableViewController.m
//  FontSelector
//
//  Created by Lee on 13-4-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVIndexTableViewController.h"
#import "SVFontDetail.h"
#import "SVHeaderCell.h"

#import "SVCatagoryViewController.h"
#define kFavoriteHeaderHeight 176

@interface SVIndexTableViewController ()

@end

@implementation SVIndexTableViewController
@synthesize type = _type;
- (id)initWithType:(SVCataViewType)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _type = type;
//        NSString * title = nil;
        NSString * columnName = nil;
        self.tableView = nil;
        self.tableView = [[UIFolderTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UIFolderTableView * table = (UIFolderTableView *)self.tableView;
        table.folderDelegate = self;
        UIImage * shadowImg = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 0, 18, 8)];
//        UIImage * shadowImg = [UIImage imageNamed:@"shadow"] ;
        shadow = [[UIImageView alloc] initWithImage:shadowImg];
        shadow.frame = CGRectMake(0, 0, 20, 704);
        [self.tableView addSubview:shadow];
        UIImage * upshadowImg = [UIImage imageNamed:@"upshadow"];
        //        UIImage * shadowImg = [UIImage imageNamed:@"shadow"] ;
        UIImageView * upshadow = [[UIImageView alloc] initWithImage:upshadowImg];
        [upshadow sizeToFit];
        CGRect bounds = upshadow.bounds;
        upshadow.frame = CGRectMake(0, - bounds.size.height, 786, bounds.size.height);
        [self.tableView addSubview:upshadow];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.isOpen = NO;
//        self.folderContent = [[SVFolderContentViewController alloc] initWithNibName:@"SVFolderContentViewController" bundle:nil];
        self.folderContent = [[SVFolderView alloc] initWithFrame:kFolderViewFrame];
        self.folderContent.delegate = self;
        [self.folderContent setFont:[[SVFontDetail alloc] init]];
        _selectedSectionIndex = NSNotFound;
        _previousSectionIndex = NSNotFound;
        _selectedFontsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.sectionHeaderArray = [[NSMutableArray alloc] initWithCapacity:0];
        switch (_type) {
            case SVCataViewTypeCompany:
//                title = @"Company";
                columnName = @"Publisher";
                break;
            case SVCataViewTypeFavorite:
//                title = @"Favorite";
                columnName = @"rate";
                break;
            case SVCataViewTypePrice:
//                title = @"Price";
                columnName = @"Price";
                break;
            case SVCataViewTypeStyle:
//                title = @"Style";
                columnName = @"Style";
                break;
            case SVCataViewTypeTimes:
//                title = @"Times";
                columnName = @"Year";
                break;
                
            default:
                break;
        }
        [self readSectionsFromDatabase:columnName];
        _dataDictionary = [[NSMutableDictionary alloc] init];
//        NSInteger count = [_sectionsArray count];
        for (int i = 0; i < _sectionsArray.count; i++) {
            NSString * title = [_sectionsArray objectAtIndex:i];
            NSMutableArray * array = [self readFontsFromDatabase:title];
            if (array.count > 0) {
                [_dataDictionary setObject:array forKey:title];
            }
            else{
                [_sectionsArray removeObjectAtIndex:i];
                i--;
            }
        }
    }
    return self;
}
- (NSMutableArray *)readFontsFromDatabase:(NSString *)value{
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
//    if (_selectedSectionIndex != NSNotFound) {
        PLSqliteDatabase * fontsdb = [SVDatabase fontDetailDatabase];
        NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE \"%%%@%%\"",kFontsTableName,_typeString, value];
        id<PLResultSet> result = [fontsdb executeQuery:query];
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
                [array addObject:font];
            }
            else{
                NSLog(@"TTTTTTT font not exist: %@",font.fontName);
            }
        }
    return array;
//    }
}
- ( void)readSectionsFromDatabase:(NSString*)columnName{
    _sectionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (columnName) {
        _typeString = [[NSString alloc] initWithString:columnName];
        PLSqliteDatabase * fontsdb = [SVDatabase fontDetailDatabase];
        NSString * query = [NSString stringWithFormat:@"SELECT %@ FROM %@ GROUP BY %@",columnName,kFontsTableName,columnName];
        NSLog(@"query:%@",query);
        id<PLResultSet> result1 = [fontsdb executeQuery:query];
        if (_type == SVCataViewTypeStyle) {
             
            NSMutableSet * styleSet = [[NSMutableSet alloc] init];
            while ([result1 next]) {
                NSString * title = [result1 objectForColumn:columnName];
                if (![result1 isNullForColumn:columnName] && title.length > 0) {
                    NSArray * components = [title componentsSeparatedByString:@";"];
                    [styleSet addObjectsFromArray:components];
                }
                
            }
            [_sectionsArray addObjectsFromArray:[styleSet allObjects]];
        }
        else{
            
            
            while ([result1 next]) {
                if (![result1 isNullForColumn:columnName]) {
                    NSString * title = [result1 objectForColumn:columnName];
                    NSLog(@"%@",title);
                    if (title.length > 0) {
                        [_sectionsArray addObject:title];
                    }
                    
                }
                
            }
        }
        [_sectionsArray sortUsingSelector:@selector(compare:)];
        NSLog(@"_sectionsArray:%@",_sectionsArray);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
//    UIImage * shadowImg = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 0, 18, 8)];
    UIImage * shadowImg = [UIImage imageNamed:@"shadow"] ;
    shadow = [[UIImageView alloc] initWithImage:shadowImg];
    shadow.frame = CGRectMake(0, 0, 20, self.view.frame.size.height);
    [self.tableView addSubview:shadow];
    // Uncomment the folslowing line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)resetFavoriteTable{
    if (_type == SVCataViewTypeFavorite) {
        
        if (self.selectIndex) {
            [self tableView:self.tableView didSelectRowAtIndexPath:self.selectIndex];
        }
        _sectionsArray = nil;
        _selectedFontsArray = nil;
        [self readSectionsFromDatabase:@"rate"];
        _dataDictionary = nil;
        _dataDictionary = [[NSMutableDictionary alloc] init];
        NSInteger count = [_sectionsArray count];
        for (int i = 0; i < count; i++) {
            NSString * title = [_sectionsArray objectAtIndex:i];
            NSMutableArray * array = [self readFontsFromDatabase:title];
            
            [_dataDictionary setObject:array forKey:title];
            
        }
        [self.tableView reloadData];
    }
}
- (void)setType:(SVCataViewType)type{
    _type = type;
    [self.tableView reloadData];
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
    return _sectionsArray.count;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [SVSectionHeaderView headerViewWithTitle:_typeString indexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return [_sectionHeaderArray objectAtIndex:section];
}
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[_dataDictionary objectForKey:[_sectionsArray objectAtIndex:section]] count]+1;
        }
    }
    return 1;
}
/*
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeight;
}
*/
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_type == SVCataViewTypeFavorite) {
            return kFavoriteHeaderHeight;
        }
        return kSectionHeaderHeight;
    }
    return kFontDetailCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"fontDetailCell";
        SVFontDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            
            cell = [[SVFontDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor darkGrayColor];
        }
        NSArray *list = [_dataDictionary objectForKey:[_sectionsArray objectAtIndex:indexPath.section]];
        SVFontDetail * font = [list objectAtIndex:indexPath.row - 1];
        if ([SVCatagoryViewController fontInCompareArray:font]) {
            cell.addToCompareButton.selected = YES;
        }
        else
            cell.addToCompareButton.selected = NO;
        [cell setPreviewFont:font];
        cell.delegate = self;
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"sectionCell";
        SVHeaderCell *cell = (SVHeaderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            if (_type == SVCataViewTypeFavorite) {
                cell = [[SVHeaderCell alloc] initWithFavoritReuseIdentifier:CellIdentifier];
            }
            else
                cell = [[SVHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:60];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *name = [_sectionsArray objectAtIndex:indexPath.section];
        [cell showTip:(self.selectIndex && [indexPath isEqual:self.selectIndex]) ];
        if (_type == SVCataViewTypeCompany) {
            [cell setCompanyImage:[UIImage imageNamed:name]];
        }
        else if (_type == SVCataViewTypeFavorite){
            NSString * star = [NSString stringWithFormat:@"rate_%@",[_sectionsArray objectAtIndex:indexPath.section]];
            [cell setCompanyImage:[UIImage imageNamed:star]];
        }
        else
            cell.textLabel.text = name;
        [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backg"]]];
//        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
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
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
        //fontSelected
        self.tableView.rowHeight = kFontDetailCellHeight;
        SVFontDetail * font = [[_dataDictionary objectForKey:[_sectionsArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row - 1];
        UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
        self.tableView.scrollEnabled = NO;
        
        [self.folderContent setFont:font];
        [folderTableView openFolderAtIndexPath:indexPath WithContentView:self.folderContent
                                     openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                         // opening actions
                                     }
                                    closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                        // closing actions
                                        self.tableView.scrollEnabled = YES;
                                        NSLog(@"close");
                                    }
                               completionBlock:^{
                                   // completed actions
                                   self.tableView.scrollEnabled = YES;
                               }];
        NSLog(@"font %@ selected...",font);
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    SVHeaderCell *cell = (SVHeaderCell *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
//    [cell changeArrowWithUp:firstDoInsert];
//    [cell.contentView setBackgroundColor:(firstDoInsert?[UIColor purpleColor]:[UIColor redColor])];
    [cell showTip:firstDoInsert];
    
    [self.tableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[_dataDictionary objectForKey:[_sectionsArray objectAtIndex:section]] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {   [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	
	[self.tableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)cellAddToCompare:(SVFontDetailCell *)fontCell{
    NSLog(@"compare in indexTable");
    if (_compareDelegate && [_compareDelegate respondsToSelector:@selector(cellAddToCompare:)]) {
        [_compareDelegate cellAddToCompare:fontCell];
    }
}
- (void)closeOpenFolder{
     UIFolderTableView *folderTableView = (UIFolderTableView *)self.tableView;
    [folderTableView performClose:nil];
}
#pragma mark - SVFolderViewDelegate
- (void)folderViewRateChanged:(SVFolderView *)folderView{
    if (_type == SVCataViewTypeFavorite) {
        UIFolderTableView *folderTableView = (UIFolderTableView *)self.tableView;
        [folderTableView performClose:nil];
        [self resetFavoriteTable];
    }
}
/*
#pragma mark - SVSectionHeaderDelegate
-(void)sectionHeaderView:(SVSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     
    SVSectionHeaderView * sectionInfo = [_sectionHeaderArray objectAtIndex:sectionOpened];
    [sectionInfo setOpen:YES];
    NSInteger countOfRowsToInsert = [sectionInfo.fontsArray count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = _selectedSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SVSectionHeaderView *previousOpenSection = [_sectionHeaderArray objectAtIndex:previousOpenSectionIndex];
        [previousOpenSection setOpen:NO];
        [previousOpenSection toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.fontsArray count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    _selectedSectionIndex = sectionOpened;
    
}


-(void)sectionHeaderView:(SVSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     
	SVSectionHeaderView *sectionInfo = [_sectionHeaderArray objectAtIndex:sectionClosed];
	
    [sectionInfo setOpen:NO];
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    _selectedSectionIndex = NSNotFound;
}
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = shadow.frame;
    frame.origin.y = scrollView.contentOffset.y;
    shadow.frame = frame;
}
@end
