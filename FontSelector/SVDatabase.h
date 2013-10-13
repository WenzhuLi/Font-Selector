//
//  SVDatabase.h
//  FontSelector
//
//  Created by Lee on 13-4-17.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>
#define kFontsTableName @"fontDetail"
@interface SVDatabase : NSObject

+ (PLSqliteDatabase *) fontDetailDatabase;
@end
