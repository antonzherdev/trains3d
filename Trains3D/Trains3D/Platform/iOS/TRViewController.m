//
//  TRViewController.m
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TRViewController.h"
#import "PGDirector.h"
#import "TRGameDirector.h"

@implementation TRViewController

- (void)start {
    #ifdef DEMO
    [[TRGameDirector instance] startDemo];
    #else
    [[TRGameDirector instance] restoreLastScene];
    #endif
    if([[TRGameDirector instance] needFPS]) {
        [self.director displayStats];
    }
}

- (void)firstFrame {
    [UIView animateWithDuration:1.0 animations:^{
        self.startScreenView.alpha = 0.0;
    } completion:^ (BOOL ok){
        [self.startScreenView removeFromSuperview];
    }];
}
@end
