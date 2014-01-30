//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGDirectorIOS.h"
#import "EGOpenGLViewControllerIOS.h"
#import "EGInput.h"


@implementation EGDirectorIOS {
    __unsafe_unretained EGOpenGLViewControllerIOS *_view;
}
- (id)initWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view {
    self = [super init];
    if (self) {
        _view = view;
    }

    return self;
}

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view {
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
}

- (void)resignActive {
    if(!self.isStarted || self.isPaused) return;

    _view.paused = YES;
    [super resignActive];
}

- (void) resume {
    if(!self.isStarted || !self.isPaused) return;

    _view.paused = NO;
    [self prepare];
    [super resume];
}

- (void)redraw {
    [_view redraw];
}

- (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

- (void)registerRecognizerType:(EGRecognizerType *)recognizerType {
    [_view registerRecognizerType:recognizerType];
}

- (void)clearRecognizers {
    [_view clearRecognizers];
}

@end