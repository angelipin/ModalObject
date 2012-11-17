//
//  DatabaseConnectionPool.h
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface DatabaseConnectionPool : NSObject
@property (nonatomic, readonly) NSMutableDictionary *connections;

+ (id)defaultConnectionPool;

- (FMDatabaseQueue *)connect:(NSString *)dbPath;
- (BOOL)disConnect:(NSString *)dbPath;
@end
