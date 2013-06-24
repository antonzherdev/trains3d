//
//  TRAppDelegate.m
//  Trains3D
//
//  Created by Anton Zherdev on 20.06.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TRAppDelegate.h"

@implementation TRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    EGScene *scene = [EGScene scene];
    _view.director.scene = scene;
    _view.director.displayStats = YES;
    scene.camera = [EGIsometricCamera isometricCameraWithCenter:CGPointMake(0, 0) tilesOnScreen:CGSizeMake(3, 3)];
}

@end
