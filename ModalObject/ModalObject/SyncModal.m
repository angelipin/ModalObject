//
//  SyncModal.m
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "SyncModal.h"
#import "Uuid.h"
#import "Global.h"
#import <FMDatabase/FMDatabase.h>
#import <FMDatabase/DatabaseManager.h>

@implementation SyncModal
Property_Implement(uuid, queryUuid);

- (void)dealloc {
    [_created release];
    [_modified release];
    [_uuid release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.state = SyncStateNew;
        self.uuid = [Uuid uuid];
    }
    return self;
}

- (id)initWithUuid:(NSString *)uuid {
    self = [super init];
    if (self) {
        [self fillWithUuid:uuid];
    }
    return self;
}

+ (id)objectWithUuid:(NSString *)uuid {
    Modal *obj = [[self alloc] initWithUuid:uuid];
    return [obj autorelease];
}

- (void)markNew {
    self.state = SyncStateNew;
}

- (void)markMod {
    self.state = SyncStateMod;
}

- (void)markDel {
    self.state = SyncStateDel;
}

- (void)markNon {
    self.state = SyncStateNone;
}

+ (id)findWithUuid:(NSString *)uuid {
    return [self objectWithUuid:uuid];
}

- (id)fillWithUuid:(NSString *)uuid {
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where uuid = ?", NSStringFromClass([self class])];
            NSLog_infor(@"sql:%@ uuid:%@", sql, uuid);
            FMResultSet *rs = [db executeQuery:sql, uuid];
            if ([rs next]) {
                [self setValuesForKeysWithDictionary:[rs resultDictionary]];
            }
            else if ([db hadError]){
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return self;
}

+ (BOOL)markAllRemoved {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    if (queue) {
        __block BOOL result = NO;
        
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set state=?", NSStringFromClass([self class])];
            NSLog_infor(@"sql:%@ state:%d", sql, SyncStateDel);
            [db beginTransaction];
            result = [db executeUpdate:sql, [NSNumber numberWithInt:SyncStateDel]];
            if (!result) {
                [db rollback];
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
            else {
                [db commit];
            }
        }];
        return result;
    }
    return NO;
}

- (BOOL)autoSave {
    if (self.Id == 0) {
        self.created = [NSDate date];
        self.modified = [NSDate date];
        self.state = SyncStateNew;

        return [self insert];
    }
    
    Modal *obj = [[self class] objectWithId:self.Id];
    if (obj) {
        self.modified = [NSDate date];
        self.state = SyncStateMod;
        return [self modify];
    }
    else {
        self.created = [NSDate date];
        self.modified = [NSDate date];
        
        self.state = SyncStateNew;
        
        return [self insert];
    }
    return NO;
}
@end
