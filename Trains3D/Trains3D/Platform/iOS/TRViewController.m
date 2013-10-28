//
//  TRViewController.m
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TRViewController.h"
#import "EGDirector.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRSceneFactory.h"

@implementation TRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TRLevel *level = [TRLevelFactory levelWithNumber:3];
    EGScene *scene = [TRSceneFactory sceneForLevel:level];
    self.director.scene = scene;
    [self.director displayStats];
}

@end
