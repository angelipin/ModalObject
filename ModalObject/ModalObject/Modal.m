//
//  Modal.m
//  Schedule
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "Modal.h"
#import "Global.h"
#import <FMDatabase/FMDatabaseQueue.h>
#import <FMDatabase/FMDatabase.h>
#import <FMDatabase/DatabaseManager.h>
#import <objc/runtime.h>

@implementation Modal
- (id)init {
    self = [super init];
    if (self) {
        self.Id = 0;
        _queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    }
    return self;
}

- (id)initWithId:(NSInteger)Id {
    self = [self init];
    if (self) {
        [self fill:Id];
    }
    return self;
}

+ (id)objectWithId:(NSInteger)Id {
    Modal *obj = [[self alloc] initWithId:Id];
    return [obj autorelease];
}

- (BOOL)insert {
    if (_queue) {
        __block BOOL result = NO;
        [_queue inDatabase:^(FMDatabase *db) {
            NSArray      *properties = [self allProperties];
            NSDictionary *valueDict  = [self dictionaryWithValuesForKeys:properties];
            NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@ ", NSStringFromClass([self class])];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[properties count]];
            for (NSString *p in properties) {
                [array addObject:[NSString stringWithFormat:@":%@", p]];
            }
            [sql appendFormat:@"(%@) values (%@)",[properties componentsJoinedByString:@","], [array componentsJoinedByString:@","]];
            result = [db executeUpdate:sql withParameterDictionary:valueDict];
            if (!result) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
            self.Id = [db lastInsertRowId];
        }];
        return result;
    }
    return NO;
}

+ (id)find:(NSInteger)Id {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    __block Modal *obj = nil;

    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where Id = ?", NSStringFromClass([self class])];
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:Id]];
            if ([rs next]) {
                obj = [[[self alloc] init] autorelease];
                [obj setValuesForKeysWithDictionary:[rs resultDictionary]];
            }
            else if ([db hadError]){
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    
    return obj;
}

+ (id)findObjectByProperty:(NSString *)propertyName equalValue:(id)value {
    __block Modal *obj = nil;
    
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where %@ = ?", NSStringFromClass([self class]), propertyName];
            FMResultSet *rs = [db executeQuery:sql, value];
            if ([rs next]) {
                obj = [[[self alloc] init] autorelease];
                [obj setValuesForKeysWithDictionary:[rs resultDictionary]];
            }
            if ([db hadError]){
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return obj;
    
}

- (id)fillObjectByProperty:(NSString *)propertyName equalValue:(id)value {
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where %@ = ?", NSStringFromClass([self class]), propertyName];
            FMResultSet *rs = [db executeQuery:sql, value];
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

+ (NSArray *)findObjectsByProperty:(NSString *)propertyName equalValue:(id)value {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];

    __block NSMutableArray *array = [[NSMutableArray array] retain];
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where %@ = ?", NSStringFromClass([self class]), propertyName];
            FMResultSet *rs = [db executeQuery:sql, value];
            while ([rs next]) {
                id obj = [[self alloc] init];
                [obj setValuesForKeysWithDictionary:[rs resultDictionary]];
                [array addObject:obj];
                [obj release];
            }
            if ([db hadError]){
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return [array autorelease];
}

+ (NSArray *)findObjectsByProperty:(NSString *)propertyName condition:(int)condition referenceValue:(id)value orderby:(NSString *)orderbyProperty order:(int)order {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    
    __block NSMutableArray *array = [[NSMutableArray array] retain];
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where %@", NSStringFromClass([self class]), propertyName];
            switch (condition) {
                case QueryConditionSame:
                {
                    [sql appendString:@" = ?"];
                }
                    break;
                case QueryConditionGreaterThan:
                {
                    [sql appendString:@" > ?"];
                }
                    break;
                case QueryConditionLessThan:
                {
                    [sql appendString:@" < ?"];
                }
                    break;
                case QueryConditionNotGreaterThan:
                {
                    [sql appendString:@" <= ?"];
                }
                    break;
                case QueryConditionNotLessThan:
                {
                    [sql appendString:@" >= ?"];
                }
                    break;
                case QueryConditionNotSame:
                {
                    [sql appendString:@" != ?"];
                }
                    break;
                default:
                {
                    [sql appendString:@" = ? "];
                }
                    break;
            }
            [sql appendFormat:@" order by %@", orderbyProperty];
            
            if (order > 0) {
                [sql appendString:@" desc"];
            }
            else {
                [sql appendString:@" asc"];
            }
            
            FMResultSet *rs = [db executeQuery:sql, value];
            while ([rs next]) {
                id obj = [[self alloc] init];
                [obj setValuesForKeysWithDictionary:[rs resultDictionary]];
                [array addObject:obj];
                [obj release];
            }
            if ([db hadError]){
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return [array autorelease];
}

- (id)fill:(NSInteger)Id {
    if (_queue) {        
        [_queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where Id = ?", NSStringFromClass([self class])];
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:Id]];
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

- (BOOL)modify {
    if (_queue) {
        __block BOOL result = NO;

        [_queue inDatabase:^(FMDatabase *db) {
            NSArray      *properties = [self allProperties];
            NSMutableDictionary *valueDict  = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryWithValuesForKeys:properties]];
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"update %@ ", NSStringFromClass([self class])];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[properties count]];
            for (NSString *p in properties) {
                [array addObject:[NSString stringWithFormat:@" %@ = :%@", p, p]];
            }
            [sql appendFormat:@"set %@ where Id = :Id", [array componentsJoinedByString:@","]];
            
            [valueDict setObject:[NSNumber numberWithInt:self.Id] forKey:@"Id"];            
            result = [db executeUpdate:sql withParameterDictionary:valueDict];
            if (!result) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
        return result;
    }
    return NO;
}

- (BOOL)remove {
    if (_queue) {
        __block BOOL result = NO;
        
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where Id = ?", NSStringFromClass([self class])];
            result = [db executeUpdate:sql, [NSNumber numberWithInt:self.Id]];
            if (!result) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
        return result;
    }
    return NO;
}

+ (BOOL)removeAll {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    if (queue) {
        __block BOOL result = NO;
        
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@", NSStringFromClass([self class])];
            [db beginTransaction];
            result = [db executeUpdate:sql];
            if (result) {
                [db commit];
            }
            else {
                [db rollback];
            }
            
            if (result) {
                sql = [NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=0 where name='%@'", NSStringFromClass([self class])];
                result = [db executeUpdate:sql];
            }
            if (!result) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
        return result;
    }
    return NO;
}

+ (NSInteger)count {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    __block int result = 0;

    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"select count(*) as c from %@", NSStringFromClass([self class])];
            
            FMResultSet *rs = [db executeQuery:sql];
            if ([rs next]) {
                result = [[rs objectForColumnName:@"c"] intValue];
            }
            
            if ([db hadError]) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return result;
}

+ (NSArray *)listAllId {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    __block NSMutableArray *array = [[NSMutableArray array] retain];

    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"select id from %@", NSStringFromClass([self class])];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                [array addObject:[rs objectForColumnName:@"id"]];
            }
            if ([db hadError]) {
                NSLog_error(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return [array autorelease];
}

+ (void)inTransactionInsert:(NSArray*)array {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    if (queue && [array count] > 0) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result = NO;
            [db beginTransaction];
            for (Modal *modal in array) {
                NSArray      *properties = [modal allProperties];
                NSDictionary *valueDict  = [modal dictionaryWithValuesForKeys:properties];
                NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@ ", NSStringFromClass([modal class])];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:[properties count]];
                for (NSString *p in properties) {
                    [array addObject:[NSString stringWithFormat:@":%@", p]];
                }
                [sql appendFormat:@"(%@) values (%@)",[properties componentsJoinedByString:@","], [array componentsJoinedByString:@","]];
                result = [db executeUpdate:sql withParameterDictionary:valueDict];
                if (!result) {
                    NSLog_error(@"%@", [db lastErrorMessage]);
                    break;
                }
                modal.Id = [db lastInsertRowId];
            }
            if (result && ![db hadError]) {
                [db commit];
            }
            else {
                [db rollback];
            }
        }];
    }
}

+ (void)inTransactionInsertOrReplace:(NSArray*)array {
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result = NO;
            [db beginTransaction];
            for (Modal *modal in array) {
                NSArray      *properties = [modal allProperties];
                NSDictionary *valueDict  = [modal dictionaryWithValuesForKeys:properties];
                NSMutableString *sql = [NSMutableString stringWithFormat:@"insert Or replace into %@ ", NSStringFromClass([modal class])];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:[properties count]];
                for (NSString *p in properties) {
                    [array addObject:[NSString stringWithFormat:@":%@", p]];
                }
                [sql appendFormat:@"(%@) values (%@)",[properties componentsJoinedByString:@","], [array componentsJoinedByString:@","]];
                result = [db executeUpdate:sql withParameterDictionary:valueDict];
                if (!result) {
                    NSLog_error(@"%@", [db lastErrorMessage]);
                    break;
                }
                modal.Id = [db lastInsertRowId];
            }
            if (result && ![db hadError]) {
                [db commit];
            }
            else {
                [db rollback];
            }
        }];
    }
}

- (BOOL)autoSave {
    if (self.Id == 0) {
        return [self insert];
    }

    Modal *obj = [[self class] objectWithId:self.Id];
    if (obj) {
        return [self modify];
    }
    else {
        return [self insert];
    }
    return NO;
}

- (NSArray *)properties {
    return [self runtimeProperties:NO baseClass:NSStringFromClass([Modal class])];
}

+ (NSArray *)properties {
    return [self runtimeProperties:NO baseClass:NSStringFromClass([Modal class])];
}

- (NSArray *)allProperties {
    return [self runtimeProperties:YES baseClass:NSStringFromClass([Modal class])];
}

+ (NSArray *)allProperties {
    return [self runtimeProperties:YES baseClass:NSStringFromClass([Modal class])];
}

+ (NSArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName {
    NSMutableArray* propertyArray = [[[NSMutableArray alloc] init] autorelease];
    
    Class clazz = [self class];
    do {
        if (clazz == NULL || [NSStringFromClass(clazz) compare:baseClassName] == NSOrderedSame) {
            break;
        }
        
        u_int count;
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        clazz = clazz.superclass;
    } while (deepCopy);
    
    return [NSArray arrayWithArray:propertyArray];
}

- (NSArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName {
    NSMutableArray* propertyArray = [[[NSMutableArray alloc] init] autorelease];
    
    Class clazz = [self class];
    do {
        if (clazz == NULL || [NSStringFromClass(clazz) compare:baseClassName] == NSOrderedSame) {
            break;
        }
        
        u_int count;
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        clazz = clazz.superclass;
    } while (deepCopy);
    
    return [NSArray arrayWithArray:propertyArray];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNull class]]) {
        NSLog_infor(@"NSNull object");
    }
    [super setValue:value forKey:key];
}

- (FMDatabaseQueue*)dbQueue {
    return _queue;
}

+ (void)registeDatabase:(NSString *)dbPath {
    DatabaseConnectionPool *pool = [DatabaseConnectionPool defaultConnectionPool];
    FMDatabaseQueue *queue = [pool connect:dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *className = NSStringFromClass([self class]);
        [db executeQuery:[NSString stringWithFormat:@"select 1 from %@", className]];
        if ([db hadError]) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"create table %@", className];
            NSArray *properties = [self allProperties];
            [sql appendFormat:@"(Id INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL,%@);", [properties componentsJoinedByString:@","]];
            BOOL result = [db executeUpdate:sql];
            if ([db hadError]) {
                NSLog_error(@"result %d:%@", result, [db lastErrorMessage]);
            }
        }
    }];
    [[DatabaseManager defaultManager] registeClass:NSStringFromClass([self class]) databaseQueue:queue];
}

+ (void)unRegisteDatabase {
    [[DatabaseManager defaultManager] unRegisteClass:NSStringFromClass([self class])];
}

+ (void)initEnvironment {
    [DatabaseManager defaultManager];
    [DatabaseConnectionPool defaultConnectionPool];
}

+ (ModalQuery *)newQuery {
    return [[[ModalQuery alloc] initWithModal:[[[self alloc] init] autorelease]] autorelease];
}

- (ModalQuery *)newQuery {
    return [[[ModalQuery alloc] initWithModal:self] autorelease];
}

+ (NSArray *)executeQuery:(ModalQuery *)query {
    __block NSMutableArray *result = [NSMutableArray array];
    FMDatabaseQueue *queue = [[DatabaseManager defaultManager] connectionWithClass:NSStringFromClass([self class])];
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:query];
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }];
    }
    return result;
}

- (NSArray *)executeQuery:(ModalQuery *)query {
    __block NSMutableArray *result = [NSMutableArray array];
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:query];
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }];
    }
    return result;
}
@end
