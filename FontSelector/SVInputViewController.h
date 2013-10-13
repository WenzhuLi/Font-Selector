//
//  SVInputViewController.h
//  FontSelector
//
//  Created by Lee on 13-4-25.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"

#define DOCUMENTS_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPresetPlistName @"preset.plist"
#define kPresetKey @"Preset content"
#define kHistoryKey @"History"
#define kTableFooter @"Select a preset content above or type yourself."
#define kIASKgrayBlueColor                    [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0]
typedef enum{
    SVInputViewSmall,
    SVInputViewBig
}SVInputViewType;
@class SVInputViewController;
@protocol SVInputViewDelegate <NSObject>

- (void)inputViewWillDisappearWithString:(NSString *)inputString;
- (void)inputViewWillAppear;
- (void)inputViewOKButtonTapped;
@end
@interface SVInputViewController : UIViewController<UIExpandingTextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIInputToolbarDelegate,UITextFieldDelegate>{
    SVInputViewType _type;
}
@property (nonatomic, strong)id<SVInputViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *bigInputView;
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property(nonatomic, strong) IBOutlet UIInputToolbar * inputBar;
@property (strong, nonatomic) IBOutlet UIImageView *textViewBackgroundImage;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property(nonatomic, strong) IBOutlet UIExpandingTextView * textView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UIView *smallInputView;
@property (nonatomic, strong)NSMutableDictionary * presetDictionary;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSIndexPath * checkedItem;
+ (NSMutableDictionary *)userInputDictionary;
- (IBAction)okButtonTapped:(UIButton *)sender;
+ (NSString *)userInputDictionaryFilePath;
- (id)initWithType:(SVInputViewType)type;

@end
