//
//  SVDatabase.m
//  FontSelector
//
//  Created by Lee on 13-4-17.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVDatabase.h"
static PLSqliteDatabase * fontDetailPointer;
@implementation SVDatabase
+ (PLSqliteDatabase *) fontDetailDatabase{
    if (!fontDetailPointer) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *realPath = [documentPath stringByAppendingPathComponent:@"fonts.sqlite"];
        
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"fontsInfo" ofType:@"sqlite"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:realPath]) {
            NSError *error;
            
            if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
                
            }
        }
        fontDetailPointer = [[PLSqliteDatabase alloc] initWithPath:realPath];
        [fontDetailPointer open];
    }
//    [fontDetailPointer open];
    return fontDetailPointer;
}

@end
