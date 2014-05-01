//
//  Database.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/4/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Database.h"

@implementation Database

static sqlite3 *db;

static sqlite3_stmt *createItems;
static sqlite3_stmt *fetchItem;
static sqlite3_stmt *insertItem;
static sqlite3_stmt *deleteItem;
static sqlite3_stmt *replaceItem;
static sqlite3_stmt *itemsCount;

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // look for an existing contacts database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"decisions.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty contacts database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"decisions.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    // create the statement strings
    const char *createItemsString = "CREATE TABLE IF NOT EXISTS decisions (rowid INTEGER PRIMARY KEY AUTOINCREMENT, decision BLOB, title TEXT)";
    const char *fetchItemString = "SELECT * FROM decisions";
    const char *insertItemString = "INSERT INTO decisions (decision, title) VALUES (?, ?)";
    const char *deleteItemString = "DELETE FROM decisions WHERE rowid=?";
    const char *replaceItemString = "UPDATE decisions SET decision=?, title=? WHERE rowid=?";
    const char *itemsCountString = "SELECT COUNT(*) FROM decisions";
    
    
    
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"decisions.sql"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createItemsString, -1, &createItems, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare contacts create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createItems);
    sqlite3_reset(createItems);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create items table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchItemString, -1, &fetchItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item fetching statement");
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertItemString, -1, &insertItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item inserting statement");
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteItemString, -1, &deleteItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item deleting statement");
    }
    
    //init replace statement
    if (sqlite3_prepare_v2(db, replaceItemString, -1, &replaceItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item replacing statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));

    }
    
    //init count statement
    if (sqlite3_prepare_v2(db, itemsCountString, -1, &itemsCount, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare item counting statement");
    }

}

+ (NSMutableArray *)fetchAllItems
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchItem) == SQLITE_ROW) {
        // query columns from fetch statement
        const void *ptr = sqlite3_column_blob(fetchItem, 1);
        int size = sqlite3_column_bytes(fetchItem, 1);


        NSData *tempdata = [[NSData alloc] initWithBytes:ptr length:size];
        Decision *temp = [NSKeyedUnarchiver unarchiveObjectWithData:tempdata];
        
        temp.rowid = sqlite3_column_int(fetchItem, 0);

        [ret insertObject:temp atIndex:0];
        
    }
    
    sqlite3_reset(fetchItem);
    return ret;
}

+ (int)saveItemWithData:(Decision *)decision
{
    // bind data to the statement
    NSData * decisionData = [NSKeyedArchiver archivedDataWithRootObject:decision];
    sqlite3_bind_blob(insertItem, 1, [decisionData bytes], [decisionData length], SQLITE_TRANSIENT);
    sqlite3_bind_text(insertItem, 2, [decision.title UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    int success = sqlite3_step(insertItem);
    sqlite3_reset(insertItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item");
    }
    
    int rowid = (int)sqlite3_last_insert_rowid(db);

    return rowid;
}

+ (void)deleteItem:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteItem, 1, rowid);
    int success = sqlite3_step(deleteItem);
    sqlite3_reset(deleteItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete item");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchItem);
    sqlite3_finalize(insertItem);
    sqlite3_finalize(deleteItem);
    sqlite3_finalize(createItems);
    sqlite3_finalize(replaceItem);
    sqlite3_close(db);
}


+ (void)replaceItemWithData:(Decision *)decision atRow: (int)rid
{
    // bind data to the statement
    
    NSData * decisionData = [NSKeyedArchiver archivedDataWithRootObject:decision];
    sqlite3_bind_blob (replaceItem, 1, [decisionData bytes], [decisionData length], SQLITE_TRANSIENT);
    sqlite3_bind_text(replaceItem, 2, [decision.title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(replaceItem, 3, rid);


    int success = sqlite3_step(replaceItem);
    sqlite3_reset(replaceItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to replace item ");
    }
    
}

@end
