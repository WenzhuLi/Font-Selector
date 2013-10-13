//
//  SVSectionHeaderView.m
//  FontSelector
//
//  Created by Lee on 13-4-16.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVSectionHeaderView.h"
#import "SVDatabase.h"
#import "SVFontDetail.h"
@implementation SVSectionHeaderView
@synthesize isOpen = _isOpen;


- (id)initWithTitle:(NSString *)title section:(NSInteger )section{
    self = [super initWithFrame:CGRectMake(0, 0, 784, kSectionHeaderHeight)];
    if (self) {
        // Initialization code
        _isOpen = NO;
        _delegate = nil;
        _section = section;
        self.backgroundColor = [UIColor redColor];
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = self.bounds;
        [myButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        myButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [myButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        myButton.titleLabel.textColor = [UIColor whiteColor];
        [myButton setTitle:title forState:UIControlStateNormal];
        [self addSubview:myButton];
    }
    return self;
}
- (id)initWithImageName:(NSString *)imgName section:(NSInteger )section{
    self = [super initWithFrame:CGRectMake(0, 0, 784, kSectionHeaderHeight)];
    if (self) {
        // Initialization code
        _isOpen = NO;
        _section = section;
        self.backgroundColor = [UIColor redColor];
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = self.bounds;
        [myButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [myButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [self addSubview:myButton];
    }
    return self;
}
+ (id)headerViewWithTitle:(NSString *)title section:(NSInteger )section{
    return [[self alloc] initWithTitle:title section:section];
}
+ (id)headerViewWithImageName:(NSString *)imgName  section:(NSInteger )section{
    return [[self alloc] initWithImageName:imgName section:section];
}
- (void)toggleOpen:(UIButton *)sender{
    NSLog(@"toggleOpen");
    [self toggleOpenWithUserAction:YES];
}
-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    myButton.selected = !myButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (myButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}
- (void)initializeFontsArrayWithCataType:(SVCataViewType)cataType value:(NSString *)value{
    NSString * columnName = nil;
    _fontsArray = [[NSMutableArray alloc] initWithCapacity:0];
    switch (cataType) {
        case SVCataViewTypeCompany:
            //                title = @"Company";
            columnName = @"Publisher";
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
    PLSqliteDatabase * fontsdb = [SVDatabase fontDetailDatabase];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = \"%@\"",kFontsTableName,columnName, value];
    id<PLResultSet> result = [fontsdb executeQuery:query];
    while ([result next]) {
        SVFontDetail * font = [[SVFontDetail alloc] init];
        font.fontName = [[NSString stringWithFormat:@"%@-%@",[result objectForColumn:@"FontName"],[result objectForColumn:@"Type"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        font.publisher = [result objectForColumn:@"Publisher"];
        font.year = [result objectForColumn:@"Year"];
        font.price = [result objectForColumn:@"Price"];
        font.style = [result objectForColumn:@"Style"];
        font.link = [result objectForColumn:@"Link"];
        if (![result isNullForColumn:@"Intro"]) {
            font.introduction = [result objectForColumn:@"Intro"];
        }
        [_fontsArray addObject:font];
    }

}
- (void)setOpen:(BOOL)open{
    _open = open;
    myButton.selected = open;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
