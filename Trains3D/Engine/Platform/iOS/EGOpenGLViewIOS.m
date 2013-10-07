//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGOpenGLViewIOS.h"
#import "EGDirector.h"
#import "EGDirectorIOS.h"


@implementation EGOpenGLViewIOS {
    EGDirector * _director;
    GEVec2 _viewSize;
}
@synthesize director = _director;
@synthesize viewSize = _viewSize;

- (void)viewDidLoad {
    [super viewDidLoad];

    _director = [EGDirectorIOS directorWithView:self];
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    GLKView *view = (GLKView *)self.view;
    CGSize size = view.bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    _viewSize = GEVec2Make(size.width*scale, size.height*scale);
    self.paused = YES;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.preferredFramesPerSecond = 60;
//    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;

    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;

    [EAGLContext setCurrentContext:view.context];
    [self prepareOpenGL];
    [_director start];
}

- (void)prepareOpenGL {

}

- (void)lockOpenGLContext {

}

- (void)unlockOpenGLContext {

}

- (void)update {
    [_director tick];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [_director drawWithSize:_viewSize];
}

@end