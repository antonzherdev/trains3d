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

@implementation TRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.director.scene = [[TRGameDirector instance] restoreLastScene];
    [self.director displayStats];
}

@end
