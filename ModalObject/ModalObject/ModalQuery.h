//
//  ModalQuery.h
//  ModalObject
//
//  Created by wang yepin on 12-11-18.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Modal;

@interface ModalQuery : NSMutableString
@property (nonatomic, retain) Modal *modal;

- (id)initWithModal:(id)modal;

- (id)select;
- (id)selectAll;

- (id)where;
- (id)values;

- (id)modal:(Class)cls property:(NSString *)property;
- (id)modal:(Class)cls;
- (id)property:(NSString *)property;

- (id)condition:(int)condition;
- (id)referenceValue:(id)value;
- (id)join;

- (id)orderby:(Class)cls property:(NSString *)property;
- (id)orderby:(NSInteger)numberOfProperties, ...;

- (id)asc;
- (id)desc;

- (id)modal:(Class)cls property:(NSString *)property equalValue:(id)value;
- (id)property:(NSString *)property equalValue:(id)value;

- (NSArray *)fetchAll;
@end
