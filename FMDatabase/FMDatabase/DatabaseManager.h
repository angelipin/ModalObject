//
//  DatabaseManager.h
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseConnectionPool.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DatabaseManager : NSObject
@property (atomic, readonly) NSMutableDictionary *registry;

+ (id)defaultManager;
- (void)registeClass:(NSString *)className databaseQueue:(FMDatabaseQueue *)queue;
- (void)unRegisteClass:(NSString *)className;

- (FMDatabaseQueue *)connectionWithClass:(NSString *)className;
@end
