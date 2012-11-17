//
//  DatabaseConnectionPool.m
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "DatabaseConnectionPool.h"

@implementation DatabaseConnectionPool
+ (id)defaultConnectionPool {
    static dispatch_once_t token = 0;
    __strong static DatabaseConnectionPool *_defaultConnectionPool = nil;
    dispatch_once(&token, ^() {
        _defaultConnectionPool = [[DatabaseConnectionPool alloc] init];
    });
    return _defaultConnectionPool;
}

- (void)dealloc {
    [_connections release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _connections = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (FMDatabaseQueue *)connect:(NSString *)dbPath {
    FMDatabaseQueue *fmdbQueue  = nil;
    @synchronized (_connections) {
        fmdbQueue = [_connections objectForKey:dbPath];
        if (fmdbQueue == nil) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL success = [fileManager fileExistsAtPath:dbPath];
            if (success) {
                fmdbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
            }
            if (fmdbQueue != nil) {
                [_connections setObject:fmdbQueue forKey:dbPath];
            }
        }
    }
    return fmdbQueue;
}

- (BOOL)disConnect:(NSString *)dbPath {
    FMDatabaseQueue *fmdbQueue  = nil;
    @synchronized (_connections) {
        fmdbQueue = [_connections objectForKey:dbPath];
        if (fmdbQueue != nil) {
            [_connections removeObjectForKey:dbPath];
        }
    }
    return YES;
}
@end
