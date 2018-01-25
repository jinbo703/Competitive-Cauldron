//
//  SCSQLite.h
//
//  Created by Lucas Correa on 21/12/11.
//  Copyright (c) 2012 Siriuscode Solutions. All rights reserved.
//  Kdl%120681

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SCSQLite : NSObject {
    sqlite3 *db;
}

@property (copy, nonatomic) NSString *database;


+ (void)initWithDatabase:(NSString *)database;
+ (BOOL)executeSQL:(NSString *)sql, ...;
+ (NSArray *)selectRowSQL:(NSString *)sql;
//NS_FORMAT_FUNCTION(1,2);
+ (NSString *)getDatabaseDump;

@end
