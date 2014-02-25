//
// Created by Anton Zherdev on 25/02/14.
// Copyright (c) 2014 Anton Zherdev. All rights reserved.
//

#import "NSConditionLock+CNChain.h"


@implementation NSConditionLock (CNChain)
+ (NSConditionLock *)conditionLockWithCondition:(int)i {
    return [[NSConditionLock alloc] initWithCondition:i];
}

- (void)lockWhenCondition:(int)i period:(CGFloat)period {
    [self lockWhenCondition:i beforeDate:[[NSDate date] dateByAddingTimeInterval:period]];
}
@end