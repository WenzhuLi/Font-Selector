//
//  SVCatagoryViewController.m
//  FontSelector
//
//  Created by Lee on 13-4-13.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVCatagoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVFontCompareViewController.h"
//#import "SVSearchFontViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ASDepthModalViewController.h"
#import "SVFontDetailCell.h"


static NSMutableArray * _compareArray;
@interface SVCatagoryViewController ()

@end

@implementation SVCatagoryViewController

+ (NSMutableArray *)compareArray{
    if (!_compareArray) {
        _compareArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _compareArray;
}
+ (BOOL)fontInCompareArray:(SVFontDetail *)font{
    for (SVFontDetail * cFont in [SVCatagoryViewController compareArray]) {
        if ([cFont.fontName isEqualToString:font.fontName]) {
            return YES;
        }
    }
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedCataType = SVCataViewTypeCompany;
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    for (SVIndexTableViewController * table in tableViewsArray) {
        [table.tableView reloadData];
    }
    NSInteger count = _compareArray.count;
    if(count > 0){
        [_compareButton setBadgeString:[NSString stringWithFormat:@"%d",count]];
    }
    else
        [_compareButton setBadgeString:nil];
    for (SVCataView * cata in cataViewsArray) {
        [cata Highlighted:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"FontSelector";
    CGFloat rectHeight = kViewHeight;
    bigRectArray = [[NSMutableArray alloc] init];
    smallRectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfCata; i++) {
        CGRect bigRect = CGRectMake(kBigRectWidth * i, 0, kBigRectWidth, rectHeight);
        CGRect smallRect = CGRectMake(kSmallRectWidth * i, 0, kSmallRectWidth, rectHeight);
        [bigRectArray addObject:[NSValue valueWithCGRect:bigRect]];
        [smallRectArray addObject:[NSValue valueWithCGRect:smallRect]];
    }
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"navigation_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"navigation_search_s"] forState:UIControlStateSelected];
    [searchButton setImage:[UIImage imageNamed:@"navigation_search_h"] forState:UIControlStateHighlighted];
    [searchButton sizeToFit];
    //    [_compareButton setBadgeString:@"13"];
    [searchButton addTarget:self action:@selector(searchFont) forControlEvents:UIControlEventTouchUpInside];
//    searchButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit_s"] forState:UIControlStateSelected];
    [editButton setImage:[UIImage imageNamed:@"navigation_edit_h"] forState:UIControlStateHighlighted];
    [editButton sizeToFit];
    //    [_compareButton setBadgeString:@"13"];
    [editButton addTarget:self action:@selector(editUserText) forControlEvents:UIControlEventTouchUpInside];
//    editButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem * edit = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    _compareButton = [SVBadgedButton buttonWithType:UIButtonTypeCustom];
    [_compareButton setImage:[UIImage imageNamed:@"navigation_compare"] forState:UIControlStateNormal];
    [_compareButton sizeToFit];
//    [_compareButton setBadgeString:@"13"];
    [_compareButton addTarget:self action:@selector(pushCompare) forControlEvents:UIControlEventTouchUpInside];
    _compareButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem * compare = [[UIBarButtonItem alloc] initWithCustomView:_compareButton];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:search,edit, nil];
    self.navigationItem.rightBarButtonItem = compare;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    indexTable = [[SVIndexTableViewController alloc] initWithType:selectedCataType];
//    [indexTable.view setFrame:CGRectMake(0, 0, kTableWidth, rectHeight)];
//    [self.view addSubview:indexTable.view];
    
    [self layoutTablesDefault];
    [self layoutBigCataViews];
    self.editView = [[SVEditTextView alloc] init];
    self.editView.layer.cornerRadius = 12;
    self.editView.layer.shadowOpacity = 0.7;
    self.editView.layer.shadowOffset = CGSizeMake(6, 6);
    self.editView.layer.shouldRasterize = YES;
    self.editView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	// Do any additional setup after loading the view.
    /*
    self.navigationItem.title = @"FontSelector";
    CGFloat bigRectWidth = 1024 / kNumberOfCata;
    CGFloat rectHeight = self.view.frame.size.height;
    CGFloat smallRectWidth = (1024 - kTableWidth) / kNumberOfCata;
    bigRectArray = [[NSMutableArray alloc] init];
    smallRectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfCata; i++) {
        CGRect bigRect = CGRectMake(bigRectWidth * i, 0, bigRectWidth, rectHeight);
        CGRect smallRect = CGRectMake(smallRectWidth * i, 0, smallRectWidth, rectHeight);
        [bigRectArray addObject:[NSValue valueWithCGRect:bigRect]];
        [smallRectArray addObject:[NSValue valueWithCGRect:smallRect]];
    }
    [self layoutBigLabels];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)layoutSmallCataTableIndex:(NSInteger)index tableAnimated:(BOOL)animated{
//    CGRect tableFrame = indexTable.view.frame;
//    tableFrame.origin.x = (kSmallRectWidth) * (_selectedIndex + 1);
//    [indexTable.view setFrame:tableFrame];
//    if (!animated) {
//        [self layoutTablesIndex];
//    }
    [UIView beginAnimations:@"layoutSmallCataTable" context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
//    [UIView setAnimationDelay:delay];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    CGFloat pointX = 0;
    for (int i = 0; i < kNumberOfCata; i++) {
        SVCataView * button = [cataViewsArray objectAtIndex:i];
        [button skinny];
        CGRect rect = [[smallRectArray objectAtIndex:i] CGRectValue];
        if (i > _selectedIndex) {
            rect.origin.x += kTableWidth;
        }
        button.frame = rect;
        
        //        button.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:30];
//        button.transform = CGAffineTransformMakeScale(0.5, 0.5);
//        button.backgroundColor = [UIColor blueColor];
    }
//    if (animated) {
        [self layoutTablesIndex];
//    }
    [UIView commitAnimations];

}
- (void)layoutTablesIndex{
    for (int i = 0; i < kNumberOfCata; i++) {
        SVIndexTableViewController * tableVC = [tableViewsArray objectAtIndex:i];
        CGRect tableRect = [[smallRectArray objectAtIndex:i] CGRectValue];
        tableRect.origin.x += kSmallRectWidth;
        tableRect.size.width = kTableWidth;
        if (i > _selectedIndex) {
            tableRect.origin.x += kTableWidth;
        }
        tableVC.view.frame = tableRect;
        //        button.titleLabel.font = [UIFont fontWithName:@"Avenir Heavy" size:30];
        //        button.transform = CGAffineTransformMakeScale(0.5, 0.5);
        //        button.backgroundColor = [UIColor blueColor];
    }
}
- (void)layoutTablesDefault{
    if (!styleTable) {
        styleTable = [[SVIndexTableViewController alloc] initWithType:SVCataViewTypeStyle];
        styleTable.compareDelegate = self;
        timesTable = [[SVIndexTableViewController alloc] initWithType:SVCataViewTypeTimes];
        timesTable.compareDelegate = self;
        companyTable = [[SVIndexTableViewController alloc] initWithType:SVCataViewTypeCompany];
        companyTable.compareDelegate = self;
        priceTable = [[SVIndexTableViewController alloc] initWithType:SVCataViewTypePrice];
        priceTable.compareDelegate = self;
        favoriteTable = [[SVIndexTableViewController alloc] initWithType:SVCataViewTypeFavorite];
        favoriteTable.compareDelegate = self;
        tableViewsArray = [[NSArray alloc] initWithObjects:styleTable,timesTable,companyTable,priceTable,favoriteTable, nil];
        for (int i = 0; i < bigRectArray.count; i++) {
            CGRect tableRect = [[bigRectArray objectAtIndex:i] CGRectValue];
            tableRect.origin.x += tableRect.size.width;
            tableRect.size.width = kTableWidth;
            SVIndexTableViewController * tableVC = [tableViewsArray objectAtIndex:i];
            tableVC.view.autoresizingMask = UIViewAutoresizingNone;
            UIImageView * back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBack"]];
            [back sizeToFit];
            [tableVC.tableView setBackgroundView:back];
            tableVC.view.frame = tableRect;
            [self.view addSubview:tableVC.view];
        }
    }
    else{
        for (int i = 0; i < bigRectArray.count; i++) {
            CGRect tableRect = [[bigRectArray objectAtIndex:i] CGRectValue];
            tableRect.origin.x += tableRect.size.width;
            tableRect.size.width = kTableWidth;
            tableRect.size.width = kTableWidth;
            SVIndexTableViewController * tableVC = [tableViewsArray objectAtIndex:i];
            tableVC.view.frame = tableRect;
        }
    }
}
- (void)layoutBigCataViewAnimatedWithEnd:(BOOL)end{
    [UIView beginAnimations:@"layoutBigCataView" context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(layoutTablesDefault)];
    [self layoutTablesDefault];
    [self layoutBigCataViews];
    [UIView commitAnimations];
}
- (void)layoutBigCataViews{
    if (!styleView) {
        styleView = [[SVCataView alloc]initWithType:SVCataViewTypeStyle];
        styleView.delegate = self;
        timesView = [[SVCataView alloc]initWithType:SVCataViewTypeTimes];
        timesView.delegate = self;
        companyView = [[SVCataView alloc]initWithType:SVCataViewTypeCompany];
        companyView.delegate = self;
        priceView = [[SVCataView alloc]initWithType:SVCataViewTypePrice];
        priceView.delegate = self;
        favoriteView = [[SVCataView alloc]initWithType:SVCataViewTypeFavorite];
        favoriteView.delegate = self;
        cataViewsArray = [[NSArray alloc] initWithObjects:styleView,timesView,companyView,priceView,favoriteView, nil];
        styleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBack"]];
        timesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBack"]];
        priceView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBack"]];
        favoriteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBack"]];
        companyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barBack"]];
        [self.view addSubview:styleView];
        [self.view addSubview:timesView];
        [self.view addSubview:priceView];
        [self.view addSubview:companyView];
        [self.view addSubview:favoriteView];
    }
    for (int i = 0; i < kNumberOfCata; i++) {
        SVCataView * cView = [cataViewsArray objectAtIndex:i];
        cView.frame = [[bigRectArray objectAtIndex:i] CGRectValue];
        [cView fat];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
- (void)unselectAllCataViews{
    for (SVCataView * cView in cataViewsArray) {
        cView.selected = NO;
    }
}
- (void)setUserInput:(NSString *)input{
    [[NSUserDefaults standardUserDefaults] setObject:input forKey:kCurrentTextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    for (SVIndexTableViewController * tableC in tableViewsArray) {
//        [tableC.tableView beginUpdates];
//        [tableC.tableView endUpdates];
//    }
//    [companyTable.tableView beginUpdates];
//    [companyTable.tableView endUpdates];

    [styleTable.tableView reloadData];
    [timesTable.tableView reloadData];
    [companyTable.tableView reloadData];
    [priceTable.tableView reloadData];
    [favoriteTable.tableView reloadData];
    if (_searchController) {
        [_searchController.tableView reloadData];
    }
}


#pragma mark - BarButtonItemAction
- (void)searchFont{
    if (!_searchController) {
         _searchController = [[SVSearchFontViewController alloc] initWithFatherController:self];
        [self.view addSubview:_searchController.view];
        _searchController.view.alpha = 0.0;
    }
    if (_searchController.view.alpha == 0.0) {
        [_searchController show];
        searchButton.selected = YES;
    }
    else{
        [_searchController hide];
        searchButton.selected = NO;
    }
}
- (void)editUserText{
    if (inputController) {
        inputController = nil;
    }
    inputController = [[SVInputViewController alloc] initWithType:SVInputViewSmall];
    inputController.delegate = self;
    editButton.selected = YES;
    [self presentPopupViewController:inputController animationType:MJPopupViewAnimationFade];
//    [input.textView becomeFirstResponder];
//    [ASDepthModalViewController presentView:self.editView withBackgroundColor:[UIColor blackColor] popupAnimationStyle:ASDepthModalAnimationDefault blur:NO];
}
- (void)pushCompare{

    SVFontCompareViewController * compare = [[SVFontCompareViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:compare animated:YES];
/*
    SVNewCompareViewController * compare = [[SVNewCompareViewController alloc] init];
    [self.navigationController pushViewController:compare animated:YES];
 */
}
#pragma mark - SVCataViewDelegate
- (void)cataViewTapped:(SVCataView *)cView{
    if ([cView.layer animationKeys]) {
        return;
    }
    NSLog(@"cataViewTapped");
    NSInteger index = [cataViewsArray indexOfObject:cView];
    if (index == NSNotFound) {
        NSLog(@"index not found");
        return;
    }
    if (cView.selected) {
        cView.selected = NO;
        SVIndexTableViewController * tc = [tableViewsArray objectAtIndex:index];
        [tc closeOpenFolder];
        [self layoutBigCataViewAnimatedWithEnd:NO];
        return;
    }
    else{
        [self unselectAllCataViews];
        cView.selected = YES;
        SVIndexTableViewController * tc = [tableViewsArray objectAtIndex:_selectedIndex];
        [tc closeOpenFolder];
        if (cView.type == SVCataViewTypeFavorite) {
            [favoriteTable resetFavoriteTable];
        }
        
//        if (cView.frame.size.width == kSmallRectWidth) {
            _selectedIndex = index;
            selectedCataType = cView.type;
            [self layoutSmallCataTableIndex:_selectedIndex tableAnimated:(cView.frame.size.width == kSmallRectWidth)];
//        }
    }
}
#pragma mark - SVInputViewDelegate
- (void)inputViewWillAppear{
    [_searchController.searchBar resignFirstResponder];
//    self.editView
}
- (void)inputViewWillDisappearWithString:(NSString *)inputString{
    if (inputString.length > 0) {
        [self setUserInput:inputString];
    }
    editButton.selected = NO;
}
- (void)inputViewOKButtonTapped{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
#pragma mark - SVFontDetailCellDelegate
- (void)cellAddToCompare:(SVFontDetailCell *)fontCell{
    if (!_compareArray) {
        NSLog(@"compare in catagory");
        _compareArray = [[NSMutableArray alloc] initWithCapacity:0];
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
        fontCell.addToCompareButton.selected = NO;
        [_compareArray removeObject:fontCell.fontDetail];
        if (_compareButton.layer.animationKeys.count == 0) {
            CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
            CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
            
            _compareButton.transform = leftWobble;  // starting point
            
            [UIView beginAnimations:@"wobble" context:(__bridge void *)(_compareButton)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:3];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            
            _compareButton.transform = rightWobble; // end here & auto-reverse
            
            [UIView commitAnimations];
        }
        
    }
    
//    [_compareButton setBadgeString:[NSString stringWithFormat:@"%d",[_compareArray count]]];
}
- (void)doCompareAnimationWithStartFrame:(CGRect)startFrame{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIImageView * yellow = [[UIImageView alloc] initWithFrame:startFrame];
//    yellow.backgroundColor = [UIColor yellowColor];
    [yellow setImage:[UIImage imageNamed:@"fontDetail_compare_s"]];
    [window addSubview:yellow];
    CGRect endRect = [self.navigationController.navigationBar convertRect:_compareButton.frame toView:window];
    
    [UIView animateWithDuration:1 animations:^{
        yellow.frame = endRect;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1 animations:^{
//            CGPoint center = yellow.center;
            [yellow sizeToFit];
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
            [_compareButton setBadgeString:[NSString stringWithFormat:@"%d",[_compareArray count]]];
        }];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {// remove
        
        
        
    }
}
- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
        [item sizeToFit];
    }
    [self removeFromCompareComplete];
}
- (void)removeFromCompareComplete{
    NSInteger count = _compareArray.count;
    if(count > 0){
        [_compareButton setBadgeString:[NSString stringWithFormat:@"%d",count]];
    }
    else
        [_compareButton setBadgeString:nil];
    switch (selectedCataType) {
        case SVCataViewTypeCompany:
            [companyTable.tableView reloadData];
            break;
        case SVCataViewTypePrice:
            [priceTable.tableView reloadData];
            break;
        case SVCataViewTypeStyle:
            [styleTable.tableView reloadData];
            break;
        case SVCataViewTypeTimes:
            [timesTable.tableView reloadData];
            break;
            
        default:
            break;
    }
}
@end
