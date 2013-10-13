//
//  SVInputViewController.m
//  FontSelector
//
//  Created by Lee on 13-4-25.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVInputViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVInputCell.h"
#import "UIViewController+MJPopupViewController.h"

@interface SVInputViewController ()

@end

@implementation SVInputViewController

- (id)initWithType:(SVInputViewType)type
{
    self = [super initWithNibName:nil   bundle:nil];
    if (self) {
        // Custom initialization
        _type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.inputBar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    [self.view addSubview:self.inputBar];
//    self.inputBar.delegate = self;
    self.presetDictionary = [SVInputViewController userInputDictionary];
    if (_type == SVInputViewSmall) {
        self.smallInputView.hidden = NO;
        self.bigInputView.hidden = YES;
    }
    else{
        self.smallInputView.hidden = YES;
        self.bigInputView.hidden = NO;
        CGRect frame = self.tableView.frame;
        CGFloat offset = self.bigInputView.frame.size.height - frame.origin.y;
        frame.origin.y += offset;
        frame.size.height -= offset;
        self.tableView.frame = frame;
        CGPoint center = self.okButton.center;
        center.y += offset;
        self.okButton.center = center;
        CGRect imgFrame = self.textViewBackgroundImage.frame;
        imgFrame.size.height += 50;
        imgFrame.origin.y -= 3;
        self.textViewBackgroundImage.frame = imgFrame;
    }
    UIImage *buttonImage = [UIImage imageNamed:@"buttonbg.png"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    [self.okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    self.textViewBackgroundImage.image          = [[UIImage imageNamed:@"textbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    /*
    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 60)];
    self.textView.backgroundColor = [UIColor colorWithRed:0.855 green:0.039 blue:0.000 alpha:1.0];
    
    self.textView.delegate = self;
    self.textView.maximumNumberOfLines = 5;
    
    [self.view addSubview:self.textView];
     
//    self.textView.layer.shadowColor = [UIColor darkTextColor].CGColor;
//    self.textView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.textView.layer.shadowOpacity = 0.5;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 8.0f, 0.0f);
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [self.textView becomeFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewWillAppear)]) {
        [_delegate inputViewWillAppear];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewWillDisappearWithString:)]) {
        [self.delegate inputViewWillDisappearWithString:_type == SVInputViewSmall ? self.inputTextField.text : self.inputTextView.text];
    }
    self.textView.delegate = nil;
//    NSArray * preset = [self.presetDictionary objectForKey:kPresetKey];
    NSString * inputText = _type == SVInputViewBig ? self.inputTextView.text : self.inputTextField.text;
    
    if (![self textIsInHistory:inputText] && ![self textIsInPreset:inputText] && inputText.length > 0) {
        NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
        NSMutableArray * history1 = [NSMutableArray arrayWithArray:history];
        [history1 insertObject:inputText atIndex:0];
        [self.presetDictionary setObject:history1 forKey:kHistoryKey];
        [self.presetDictionary writeToFile:[SVInputViewController userInputDictionaryFilePath] atomically:YES];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    if (_type == SVInputViewSmall){
        [self.inputTextField becomeFirstResponder];
    }
}
#pragma mark - userInputDictionary
- (BOOL)textIsInHistory:(NSString *)text{
    NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
    return [history containsObject:text];
}
- (BOOL)textIsInPreset:(NSString *)text{
    NSArray * preset = [self.presetDictionary objectForKey:kPresetKey];
    return [preset containsObject:text];
}
+ (NSMutableDictionary *)userInputDictionary{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * path = [SVInputViewController userInputDictionaryFilePath];
    if (![fileManager fileExistsAtPath:path]) {
        NSError * err = nil;
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kPresetPlistName ofType:nil] toPath:path error:&err];
        if (err) {
            path = [[NSBundle mainBundle] pathForResource:kPresetPlistName ofType:nil];
        }
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

- (IBAction)okButtonTapped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(inputViewOKButtonTapped)]) {
        [_delegate inputViewOKButtonTapped];
    }
}
+ (NSString *)userInputDictionaryFilePath{
    return [DOCUMENTS_FOLDER stringByAppendingPathComponent:kPresetPlistName];
}
#pragma mark - UIExpandingTextViewDelegate
- (void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView{
    if ([self textIsInPreset:expandingTextView.text] || [self textIsInHistory:expandingTextView.text]) {
        return;
        
    }
    else
        [self deselectCell:[self.tableView cellForRowAtIndexPath:self.checkedItem]];
}
- (void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height{
    CGRect oldTableFrame = self.tableView.frame;
    CGRect newTableFrame = oldTableFrame;
    
    newTableFrame.origin.y = 15 + height;
    newTableFrame.size.height -= (newTableFrame.origin.y - oldTableFrame.origin.y);
    self.tableView.frame = newTableFrame;
//    float diff = (expandingTextView.frame.size.height - height);
    CGRect r = self.textView.frame;
//    r.origin.y += diff;
    r.size.height = height;
//    r.origin = CGPointMake(0, 0);
    self.textView.frame = r;
}
#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    NSLog(@"keyboardWillShow");
    CGRect keyboardBounds;
    CGRect showFrame = self.view.frame;
    showFrame.size.height = 310;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
	[UIView beginAnimations:@"willShow" context:nil];
    self.view.frame = showFrame;
	[UIView setAnimationDuration:[duration doubleValue]];
	[UIView commitAnimations];

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds;
    CGRect hideFrame = self.view.frame;
    hideFrame.size.height = 580;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.view.frame = hideFrame;
	[UIView beginAnimations:@"willShow" context:nil];
	[UIView setAnimationDuration:[duration doubleValue]];
	[UIView commitAnimations];
	
}
#pragma mark - UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * preset = [self.presetDictionary objectForKey:kPresetKey];
    NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
    if (section == 0) {
        return preset.count;
    }
    else
        return history.count;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string;
    if (indexPath.section == 0) {
        NSArray * preset = [self.presetDictionary objectForKey:kPresetKey];
        string = [preset objectAtIndex:indexPath.row];
    }
    else{
        NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
        string = [history objectAtIndex:indexPath.row];
    }
    return [SVInputCell heightWithString:string];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
    if (history.count > 0) {
        return 2;
    }
    else
        return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kPresetKey;
    }
    else
        return kHistoryKey;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == tableView.numberOfSections - 1) {
        return kTableFooter;
    }
    else
        return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"SVInputCell";
    
    SVInputCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SVInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray * preset = [self.presetDictionary objectForKey:kPresetKey];
    NSArray * history = [self.presetDictionary objectForKey:kHistoryKey];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    if (indexPath.section == 0) {
        cell.textLabel.text = [preset objectAtIndex:indexPath.row];
    }
    else
        cell.textLabel.text = [history objectAtIndex:indexPath.row];
//    NSLog(@"textLabel.frame:%@",NSStringFromCGRect(cell.stringLabel.frame));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.checkedItem) {
        if ([indexPath isEqual:self.checkedItem]) {
            [self deselectCell:cell];
        }
        else{
            [self deselectCell:[tableView cellForRowAtIndexPath:self.checkedItem]];
            [self selectCell:cell];
            self.checkedItem = indexPath;
        }
    }
    else{
        [self selectCell:cell];
        self.checkedItem = indexPath;
    }
    if (_type == SVInputViewBig) {
        self.inputTextView.text = cell.textLabel.text;
    }
    else
        self.inputTextField.text = cell.textLabel.text;
    [self okButtonTapped:nil];
}

- (void)selectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	[[cell textLabel] setTextColor:kIASKgrayBlueColor];
}

- (void)deselectCell:(UITableViewCell *)cell {
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[[cell textLabel] setTextColor:[UIColor darkTextColor]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self okButtonTapped:nil];
    return YES;
}
@end
