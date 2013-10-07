//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EGDirector.h"

@class EGOpenGLViewIOS;


@interface EGDirectorIOS : EGDirector
@property (readonly, assign) EGOpenGLViewIOS * view;

- (id)initWithView:(__unsafe_unretained EGOpenGLViewIOS *)view;

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewIOS *)view;

@end