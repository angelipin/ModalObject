//
//  ModalQuery.m
//  ModalObject
//
//  Created by wang yepin on 12-11-18.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import "ModalQuery.h"
#import "Modal.h"

@implementation ModalQuery
- (void)dealloc {
    [_modal release];
    
    [super dealloc];
}

- (id)initWithModal:(Modal *)modal {
    self = [super init];
    if (self) {
        self.modal = modal;
    }
    return self;
}

- (id)select {
    [self appendString:@" select "];
    return self;
}

- (id)selectAll {
    [self appendString:@" select * "];
    return self;
}

- (id)where {
    [self appendString:@" where "];
    return self;
}

- (id)values  {
    [self appendString:@" values "];
    return self;
}

- (id)modal:(Class)cls property:(NSString *)property {
    [self appendFormat:@" %@.%@ ", NSStringFromClass(cls), property];
    return self;
}

- (id)modal:(Class)cls {
    [self appendFormat:@" %@ ", NSStringFromClass(cls)];
    return self;
}

- (id)property:(NSString *)property {
    [self appendFormat:@" %@ ", property];
    return self;
}

- (id)condition:(int)condition {
    switch (condition) {
        case QueryConditionSame:
        {
            [self appendString:@" = "];
        }
            break;
        case QueryConditionGreaterThan:
        {
            [self appendString:@" > "];
        }
            break;
        case QueryConditionLessThan:
        {
            [self appendString:@" < "];
        }
            break;
        case QueryConditionNotGreaterThan:
        {
            [self appendString:@" <= "];
        }
            break;
        case QueryConditionNotLessThan:
        {
            [self appendString:@" >= "];
        }
            break;
        case QueryConditionNotSame:
        {
            [self appendString:@" != "];
        }
            break;
        case QueryConditionAnd:
        {
            [self appendString:@" and "];
        }
            break;
        case QueryConditionOr:
        {
            [self appendString:@" or "];
        }
            break;
        default:
        {
            [self appendString:@" = "];
        }
            break;
    }
    return self;
}

- (id)modal:(Class)cls property:(NSString *)property equalValue:(id)value {
    [self appendFormat:@"%@.%@ = '%@'", NSStringFromClass(cls), property, value];
    return self;
}

- (id)property:(NSString *)property equalValue:(id)value {
    [self appendFormat:@" %@ = '%@' ", property, value];
    return self;
}

- (id)referenceValue:(id)value {
    [self appendFormat:@" %@ ", value];
    return self;
}

- (id)join {
    [self appendString:@" join "];
    return self;
}

- (id)orderby {
    [self appendString:@" order by "];
    return self;
}

- (id)orderby:(Class)cls property:(NSString *)property {
    [self appendFormat:@" order by %@.%@", NSStringFromClass(cls), property];
    return self;
}

- (id)orderby:(NSInteger)numberOfProperties, ... {
    va_list args;
    [self appendFormat:@" order by "];
    NSMutableArray *properties = [NSMutableArray array];

    va_start(args, numberOfProperties);
    while (numberOfProperties --) {
        [properties addObject:va_arg(args, id)];
    }
    va_end(args);
    [self appendFormat:@" %@ ", [properties componentsJoinedByString:@","]];
    return self;
}

- (id)asc {
    [self appendString:@" asc "];
    return self;
}

- (id)desc {
    [self appendString:@" desc "];
    return self;
}

- (NSArray *)fetchAll {
    return [self.modal executeQuery:self];
}
@end
