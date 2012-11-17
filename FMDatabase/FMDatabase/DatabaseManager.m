//
//  DatabaseManager.m
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager
+ (id)defaultManager {
    static dispatch_once_t token = 0;
    __strong static DatabaseManager *_defaultManager = nil;
    dispatch_once(&token, ^() {
        _defaultManager = [[DatabaseManager alloc] init];
    });
    return _defaultManager;
}

- (void)dealloc {
    [_registry release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _registry = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registeClass:(NSString *)className databaseQueue:(FMDatabaseQueue *)queue {
    [self unRegisteClass:className];
    @synchronized (_registry) {
        if (queue) {
            [_registry setObject:queue forKey:className];
        }
    }
}

- (void)unRegisteClass:(NSString *)className {
    @synchronized (_registry) {
        if ([_registry objectForKey:className]) {
            [_registry removeObjectForKey:className];
        }
    }
}

- (FMDatabaseQueue *)connectionWithClass:(NSString *)className {
    @synchronized (_registry) {
        return [_registry objectForKey:className];
    }
}
@end
