//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GEVec.h"

@class EGDirector;
@class EGRecognizerType;


@interface EGOpenGLViewIOS : GLKViewController
@property (readonly, nonatomic) EGDirector * director;
@property (readonly, nonatomic) GEVec2 viewSize;

- (void)lockOpenGLContext;

- (void)unlockOpenGLContext;

- (void)registerRecognizerType:(EGRecognizerType *)type;

- (void)clearRecognizers;
@end