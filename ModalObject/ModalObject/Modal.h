//
//  Modal.h
//  
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
#define Property_Declear(Type, Property, Query, ...) @property (__VA_ARGS__) Type Property; \
+ (id)Query:(id)value;

#define Property_Implement(Property, Query) + (id)Query:(id)value {  \
    return [self findObjectByProperty:@#Property equalValue:value];   \
}

@interface Modal : NSObject {
    FMDatabaseQueue *_queue;
}

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger version;

- (id)initWithId:(NSInteger)Id;

+ (id)objectWithId:(NSInteger)Id;

- (BOOL)insert;
- (BOOL)modify;
- (BOOL)remove;
+ (BOOL)removeAll;

- (BOOL)autoSave;

+ (id)find:(NSInteger)Id;
- (id)fill:(NSInteger)Id;

+ (NSArray *)findObjectsByProperty:(NSString *)propertyName equalValue:(id)value;
+ (id)findObjectByProperty:(NSString *)propertyName equalValue:(id)value;
- (id)fillObjectByProperty:(NSString *)propertyName equalValue:(id)value;

+ (NSInteger)count;

+ (NSArray *)listAllId;

+ (void)inTransactionInsert:(NSArray*)array;
+ (void)inTransactionInsertOrReplace:(NSArray*)array;

- (NSArray *)properties;
+ (NSArray *)properties;

- (NSArray *)allProperties;
+ (NSArray *)allProperties;

+ (NSArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName;
- (NSArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName;

- (FMDatabaseQueue*)dbQueue;

+ (void)registeDatabase:(NSString *)dbPath;
+ (void)unRegisteDatabase;

+ (void)initEnvironment;
@end
