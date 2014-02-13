//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGOpenGLViewControllerIOS.h"
#import "EGDirector.h"
#import "EGDirectorIOS.h"
#import "EGContext.h"
#import "EGInput.h"
#import "GL.h"
#import "EGMultisamplingSurface.h"


@implementation EGOpenGLViewControllerIOS {
    EGDirector * _director;
    GEVec2 _viewSize;
    BOOL _paused;
    CADisplayLink *_displayLink;
    EAGLContext *_context;
    EGRenderTargetSurface* _surface;
    BOOL _needUpdateViewSize;
    BOOL _appeared;
    BOOL _active;
    NSLock* _drawingLock;
}
@synthesize director = _director;
@synthesize viewSize = _viewSize;
@synthesize paused = _paused;

- (NSUInteger) supportedInterfaceOrientations {
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _drawingLock = [[NSLock alloc] init];
    _needUpdateViewSize = YES;
    _active = YES;
    self.view.backgroundColor = [UIColor blackColor];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_drawingLock lock];
        _active = NO;
        [_director resignActive];
        [_drawingLock unlock];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        _active = YES;
        [_director redraw];
    }];

    _director = [EGDirectorIOS directorWithView:self];
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    self.paused = YES;
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAndDraw:)];
    [_displayLink setFrameInterval:2];
    
    [EAGLContext setCurrentContext:_context];

    const CGFloat scale = [UIScreen mainScreen].scale;
    self.view.contentScaleFactor = scale;
    CAEAGLLayer *layer = (CAEAGLLayer *) self.view.layer;
    layer.contentsScale = scale;
    layer.opaque = YES;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

    [self start];

    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)start {

}

- (void)setPaused:(BOOL)paused {
    if(_paused != paused) {
        [_displayLink setPaused:paused];
        _paused = paused;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _appeared = YES;
    [_director start];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    _needUpdateViewSize = YES;
}

- (void)updateViewSize {
    [EAGLContext setCurrentContext:_context];

    GLuint renderBuffer = egGenRenderBuffer();
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);

    if(![_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.view.layer]) {
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
    [_director reshapeWithSize:_viewSize];
    [[EGGlobal context] setDefaultFramebuffer:_surface.frameBuffer];
}

- (void)lockOpenGLContext {

}

- (void)unlockOpenGLContext {

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#define DISPATCH_EVENT(theEvent, tp) {\
[_director processEvent:[EGEventIOS eventIOSWithEvent:theEvent type:tp view:self camera:[CNOption none]]];\
}

- (IBAction)tap:(UITapGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[EGTap tapWithFingers:recognizer.numberOfTouchesRequired taps:recognizer.numberOfTapsRequired] phase:[EGEventPhase on] param:nil ];
}

- (IBAction)pan:(UIPanGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[EGPan panWithFingers:recognizer.minimumNumberOfTouches] phase:[self phase:recognizer] param:nil ];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)recognizer {
    [self processRecognizer:recognizer tp:[EGPinch pinch] phase:[self phase:recognizer]
                      param:[EGPinchParameter pinchParameterWithScale:recognizer.scale velocity:recognizer.velocity] ];
}

- (EGEventPhase *)phase:(UIGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) return [EGEventPhase began];
    if(recognizer.state == UIGestureRecognizerStateEnded) return [EGEventPhase ended];
    if(recognizer.state == UIGestureRecognizerStateChanged) return [EGEventPhase changed];
    return [EGEventPhase canceled];
}

- (void)processRecognizer:(UIGestureRecognizer *)recognizer tp:(EGRecognizerType *)tp phase:(EGEventPhase *)phase param:(id)param {
    [_director processEvent:[EGViewEvent viewEventWithRecognizerType:tp
                                                               phase:phase locationInView:[self locationForRecognizer:recognizer]
                                                            viewSize:self.viewSize
                                                               param:param
    ]];
}


- (GEVec2)locationForRecognizer:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return GEVec2Make(scale* (float) point.x, _viewSize.y - scale*(float) point.y);
}


- (void)registerRecognizerType:(EGRecognizerType *)type {
    if([type isKindOfClass:[EGTap class]]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        NSUInteger f = ((EGTap*)type).fingers;
        tap.numberOfTouchesRequired = f;
        NSUInteger t = ((EGTap*)type).taps;
        tap.numberOfTapsRequired = t;
        if(t > 1) {
            [[[self.view gestureRecognizers] findWhere:^BOOL(id x) {
                return [x isMemberOfClass:[UITapGestureRecognizer class]] && [x numberOfTapsRequired] == t - 1  && [x numberOfTouchesRequired] == f;
            }] forEach:^(id o) {
                [o requireGestureRecognizerToFail:tap];
            }];
        }
        [[[self.view gestureRecognizers] findWhere:^BOOL(id x) {
            return [x isMemberOfClass:[UITapGestureRecognizer class]] && [x numberOfTapsRequired] == t + 1 && [x numberOfTouchesRequired] == f;
        }] forEach:^(id o) {
            [tap requireGestureRecognizerToFail:o];
        }];
        [self.view addGestureRecognizer:tap];
    } else if([type isKindOfClass:[EGPan class]]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.minimumNumberOfTouches = ((EGPan*)type).fingers;
        pan.maximumNumberOfTouches = ((EGPan*)type).fingers;
        [self.view addGestureRecognizer:pan];
    } else if([type isKindOfClass:[EGPinch class]]) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self.view addGestureRecognizer:pinch];
    }
}

- (void)clearRecognizers {
    UIView *view = self.view;
    for(UIGestureRecognizer * recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}


- (void)updateAndDraw:(CADisplayLink*)sender {
    if(!_director.isStarted || !_active || ![_drawingLock tryLock]) return;
    @try {
        [_director tick];
        [self doRedraw];
    } @finally {
        [_drawingLock unlock];
    }
}

- (void)redraw {
    if(!_director.isStarted || !_active || ![_drawingLock tryLock]) return;
    @try {
        [self doRedraw];

    } @finally {
        [_drawingLock unlock];
    }
}

- (void)doRedraw {
    [EAGLContext setCurrentContext:_context];

    if(_needUpdateViewSize && _appeared) {
        [self updateViewSize];
        _needUpdateViewSize = NO;
    }

    if(!eqf(_viewSize.x, 0) && !eqf(_viewSize.y, 0)) {
        EGGlobal.context.needToRestoreDefaultBuffer = NO;
        [_director prepare];
        EGGlobal.context.needToRestoreDefaultBuffer = YES;

        if([EGGlobal context].redrawFrame || _paused) {
            [_surface bind];
            [_director draw];
            [_surface unbind];
            glBindRenderbuffer(GL_RENDERBUFFER, _surface.renderBuffer);
            [_context presentRenderbuffer:GL_RENDERBUFFER];
        } else {
            glFinish();
        }
    }
}
@end