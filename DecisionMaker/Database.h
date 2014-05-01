//
//  Database.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/4/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decision.h"
#import <sqlite3.h>

@interface Database : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (NSMutableArray *)fetchAllItems;
+ (int)saveItemWithData:(Decision *)decision;
+ (void)deleteItem:(int)rowid;
+ (void)cleanUpDatabaseForQuit;
+ (void)replaceItemWithData:(Decision *)decision atRow: (int)rid;


@end
