//
//  SyncModal.h
//  
//
//  Created by wang yepin on 12-11-10.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "Modal.h"

typedef enum {
    SyncStateNone = 0,
    SyncStateNew,
    SyncStateMod,
    SyncStateDel
} SyncState;

@interface SyncModal : Modal
@property (nonatomic, strong) NSDate *  created;
@property (nonatomic, strong) NSDate *  modified;
Property_Declear(NSString *, uuid, queryUuid, nonatomic, strong);
@property (nonatomic, assign) SyncState state;

- (void)markNew;
- (void)markMod;
- (void)markDel;
- (void)markNon;

- (id)initWithUuid:(NSString *)uuid;
+ (id)objectWithUuid:(NSString *)uuid;
+ (id)findWithUuid:(NSString *)uuid;
- (id)fillWithUuid:(NSString *)uuid;

+ (BOOL)markAllRemoved;
@end
