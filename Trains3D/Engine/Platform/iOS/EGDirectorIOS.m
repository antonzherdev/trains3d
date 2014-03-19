//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGDirectorIOS.h"
#import "EGOpenGLViewControllerIOS.h"
#import "EGInput.h"
#import "GL.h"
#import "EGContext.h"
#import "EGSurface.h"
#import "ATReact.h"
#import "EGMultisamplingSurface.h"


@implementation EGDirectorIOS {
    __unsafe_unretained EGOpenGLViewControllerIOS *_view;
    EAGLContext *_context;
    CADisplayLink *_displayLink;
    EGRenderTargetSurface* _surface;
    GEVec2 _viewSize;
    NSLock* _drawingLock;
    BOOL _active;
    BOOL _needUpdateViewSize;
    ATObserver *_pauseObs;
}
- (id)initWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view {
    self = [super init];
    if (self) {
        _view = view;
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _active = YES;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAndDraw:)];
        [_displayLink setFrameInterval:2];

        [EAGLContext setCurrentContext:_context];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _pauseObs = [[self isPaused] observeF:^(id x) {
                [_displayLink setPaused:unumb(x)];
            }];
        _drawingLock = [[NSLock alloc] init];
        _needUpdateViewSize = YES;
        [self _init];
    }

    return self;
}

- (void)updateAndDraw:(CADisplayLink*)sender {
    if(![self isStarted] || !_active || ![_drawingLock tryLock]) return;
    @try {
        [self processFrame];
    } @finally {
        [_drawingLock unlock];
    }
}

- (void)prepare {
    if(_needUpdateViewSize) {
        [self updateViewSize];
        _needUpdateViewSize = NO;
    }

    [super prepare];
}

- (void)draw {
    if([EGGlobal context].redrawFrame || unumb([[self isPaused] value])) {
        [_surface bind];
        [super draw];
        [_surface unbind];
        [[EGGlobal context] bindRenderBufferId:_surface.renderBuffer];
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    } else {
        glFinish();
    }
}


+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewControllerIOS *)view {
    return [[self alloc] initWithView:view];
}


- (void)beforeDraw {
}

- (void)lock {
}

- (void)unlock {
}

- (void)redraw {
    [self performSelectorOnMainThread:@selector(syncRedraw) withObject:nil waitUntilDone:NO];
}

- (void)syncRedraw {
    if(!self.isStarted || !_active || ![_drawingLock tryLock]) return;
    @try {
        [self drawFrame];
    } @finally {
        [_drawingLock unlock];
    }
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

- (void)resignActive {
    [_drawingLock lock];
    _active = NO;
    [super resignActive];
    [_drawingLock unlock];
}

- (void)becomeActive {
    _active = YES;
    [super becomeActive];
    _active = YES;
    [self redraw];
}


- (void)updateViewSize {
    [EAGLContext setCurrentContext:_context];

    GLuint renderBuffer = egGenRenderBuffer();
    [[EGGlobal context] bindRenderBufferId:renderBuffer];

    if(![_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)_view.view.layer]) {
        @throw @"Error in initialize renderbufferStorage";
    }
    GLint backingWidth = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    GLint backingHeight = 0;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    EGSurfaceRenderTargetRenderBuffer *target = [EGSurfaceRenderTargetRenderBuffer surfaceRenderTargetRenderBufferWithRenderBuffer:renderBuffer
                                                                                                                              size:GEVec2iMake(backingWidth, backingHeight)];
//    _surface = [EGSimpleSurface simpleSurfaceWithRenderTarget:target depth:YES];
    _surface = [EGMultisamplingSurface multisamplingSurfaceWithRenderTarget:target depth:YES];
    _viewSize = GEVec2Make(backingWidth, backingHeight);
    _view.viewSize = _viewSize;
    [self reshapeWithSize:_viewSize];
}

@end