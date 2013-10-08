//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGOpenGLViewIOS.h"
#import "EGDirector.h"
#import "EGDirectorIOS.h"
#import "EGEventIOS.h"
#import "EGContext.h"


@implementation EGOpenGLViewIOS {
    EGDirector * _director;
    GEVec2 _viewSize;
}
@synthesize director = _director;
@synthesize viewSize = _viewSize;

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    _director = [EGDirectorIOS directorWithView:self];
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    GLKView *view = (GLKView *)self.view;
    [self updateViewSize];
    self.paused = YES;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    // Configure renderbuffers created by the view
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.preferredFramesPerSecond = 30;
//    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;

    // Enable multisampling
    view.drawableMultisample = GLKViewDrawableMultisample4X;

    [EAGLContext setCurrentContext:view.context];
    [self prepareOpenGL];
    [_director start];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateViewSize];
}

- (void)updateViewSize {
    GLKView *view = (GLKView *) self.view;
    CGSize size = view.bounds.size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        _viewSize = GEVec2Make(size.height*scale, size.width*scale);
    } else {
        _viewSize = GEVec2Make(size.width*scale, size.height*scale);
    }
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
    GLint defaultFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &defaultFBO);
    [[EGGlobal context] setDefaultFramebuffer:defaultFBO];
    [_director drawWithSize:_viewSize];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#define DISPATCH_EVENT(theEvent, tp) {\
[_director processEvent:[EGEventIOS eventIOSWithEvent:theEvent type:tp view:self camera:[CNOption none]]];\
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    DISPATCH_EVENT(event, EGEventTouchCanceled)
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    DISPATCH_EVENT(event, EGEventTouchBegan)
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    DISPATCH_EVENT(event, EGEventTouchMoved)
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    DISPATCH_EVENT(event, EGEventTouchEnded)
}

@end