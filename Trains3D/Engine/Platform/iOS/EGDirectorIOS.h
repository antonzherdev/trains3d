//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EGDirector.h"

@class EGOpenGLViewControllerIOS;


@interface EGDirectorIOS : EGDirector
@property (readonly, assign) EGOpenGLViewControllerIOS * view;
@property (assign) BOOL active;

- (id)initWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view;

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view;

@end