//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PGDirector.h"

@class PGOpenGLViewControllerIOS;


@interface PGDirectorIOS : PGDirector
@property (readonly, assign) PGOpenGLViewControllerIOS * controller;
@property (assign) BOOL active;

- (id)initWithController:(__unsafe_unretained PGOpenGLViewControllerIOS *)controller view:(__unsafe_unretained UIView *)view;

+ (id)directorWithController:(__unsafe_unretained PGOpenGLViewControllerIOS *)controller view:(__unsafe_unretained UIView *)view;

@end