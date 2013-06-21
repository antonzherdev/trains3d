//
//  TRAppDelegate.h
//  Trains3D
//
//  Created by Anton Zherdev on 20.06.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EGOpenGLView.h"

@interface TRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet EGOpenGLView *view;

@end
