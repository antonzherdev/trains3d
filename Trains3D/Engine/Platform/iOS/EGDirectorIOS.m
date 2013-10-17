//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGDirectorIOS.h"
#import "EGOpenGLViewIOS.h"


@implementation EGDirectorIOS {
    __unsafe_unretained EGOpenGLViewIOS *_view;
}
- (id)initWithView:(__unsafe_unretained EGOpenGLViewIOS *)view {
    self = [super init];
    if (self) {
        _view = view;
    }

    return self;
}

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewIOS *)view {
    return [[self alloc] initWithView:view];
}


- (void)beforeDraw {
}

- (void)lock {
    [_view lockOpenGLContext];
}

- (void)unlock {
    [_view unlockOpenGLContext];
}

- (void)start {
    if(self.isStarted) return;
    _view.paused = NO;
    [super start];
}

- (void)stop {
    if(!self.isStarted) return;
    _view.paused = YES;
    [super stop];
}

- (void)pause {
    if(!self.isStarted || self.isPaused) return;

    _view.paused = YES;
    [super pause];
    [_view.view setNeedsDisplay];
}

- (void) resume {
    if(!self.isStarted || !self.isPaused) return;

    _view.paused = NO;
    [super resume];
}

@end