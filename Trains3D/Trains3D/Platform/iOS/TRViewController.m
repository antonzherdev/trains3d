//
//  TRViewController.m
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TRViewController.h"
#import "EGDirector.h"
#import "TRGameDirector.h"
#import "TestFlight.h"

@implementation TRViewController

- (void)start {
    [TestFlight takeOff:@"4c288980-f39e-4323-9f5c-7835e0d516a6"];
    [[TRGameDirector instance] restoreLastScene];
    if([[TRGameDirector instance] needFPS]) {
        [self.director displayStats];
    }
}

@end
