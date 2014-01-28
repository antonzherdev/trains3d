//
// Created by Anton Zherdev on 07.10.13.
// Copyright (c) 2013 Anton Zherdev. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EGOpenGLViewIOS.h"
#import "EGDirector.h"
#import "EGDirectorIOS.h"
#import "EGContext.h"
#import "EGInput.h"


@interface EGOpenGLViewIOS () <GLKViewControllerDelegate>
@end

@implementation EGOpenGLViewIOS {
    EGDirector * _director;
    GEVec2 _viewSize;
}
@synthesize director = _director;
@synthesize viewSize = _viewSize;

- (NSUInteger) supportedInterfaceOrientations {
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    self.pauseOnWillResignActive = NO;
    self.resumeOnDidBecomeActive = NO;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director resignActive];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_director redraw];
    }];

    _director = [EGDirectorIOS directorWithView:self];
    // Create an OpenGL ES context and assign it to the view loaded from storyboard
    GLKView *view = (GLKView *)self.view;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateViewSize];
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
    _viewSize = GEVec2Make(size.width*scale, size.height*scale);
    [_director reshapeWithSize:_viewSize];
}


- (void)prepareOpenGL {

}

- (void)lockOpenGLContext {

}

- (void)unlockOpenGLContext {

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    GLint defaultFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
    [[EGGlobal context] setDefaultFramebuffer:defaultFBO];
    if([self isPaused]) [_director prepare];
    [_director draw];
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

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    [_director tick];
    EGGlobal.context.needToRestoreDefaultBuffer = NO;
    [_director prepare];
    EGGlobal.context.needToRestoreDefaultBuffer = YES;
    glFlush();
}

@end