#import "EGDirectorMac.h"
#import "EGOpenGLViewMac.h"
#import "EGInput.h"


@implementation EGDirectorMac {
@private
    CVDisplayLinkRef _displayLink;
    __unsafe_unretained EGOpenGLViewMac *_view;
}

@synthesize view = _view;

- (id)initWithView:(__unsafe_unretained EGOpenGLViewMac *)view {
    self = [super init];
    if (self) {
        _view = view;
    }

    return self;
}

+ (id)directorWithView:(__unsafe_unretained EGOpenGLViewMac *)view {
    return [[self alloc] initWithView:view];
}

- (void)lock {
    [self.view lockOpenGLContext];
}

- (void)unlock {
    [self.view unlockOpenGLContext];
}


- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime
{
    @autoreleasepool{
        [self.view lockOpenGLContext];
        @try {
            [self tick];
            [self.view doRedraw];
        } @finally {
            [self.view unlockOpenGLContext];
        }
    }

    return kCVReturnSuccess;
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(__bridge EGDirectorMac*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (void)start {
    if(self.isStarted) return;

    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);

    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(_displayLink, &MyDisplayLinkCallback, (__bridge void*)self);

    // Set the display link for the current renderer
    EGOpenGLViewMac *openGLView = self.view;
    CGLContextObj cglContext = [[openGLView openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[openGLView pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);

    // Activate the display link
    CVDisplayLinkStart(_displayLink);

    [super start];
}

- (void)stop {
    if(!self.isStarted) return;


    if( _displayLink ) {
        [self doStopAndRelease];
        _displayLink = nil;
    }

    [super stop];
}

- (void)pause {
    if(!self.isStarted || self.isPaused) return;

    [super pause];
    [self performSelectorInBackground:@selector(doStop) withObject:nil];
}

- (void)resignActive {
    if(!self.isStarted || self.isPaused) return;

    [super resignActive];
    [self redraw];
    [self performSelectorInBackground:@selector(doStop) withObject:nil];
}

- (void)doStop {
    CVDisplayLinkStop(_displayLink);
}

- (void)doStopAndRelease {
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
}

- (void) resume {
    if(!self.isStarted || !self.isPaused) return;
    CVDisplayLinkStart(_displayLink);

    [super resume];
}

- (void)redraw {
    [_view redraw];
}

- (CGFloat)scale {
    return [[NSScreen mainScreen] backingScaleFactor];
}

- (void)registerRecognizerType:(EGRecognizerType *)recognizerType {
    [_view registerRecognizerType:recognizerType];

}

- (void)clearRecognizers {
    [_view clearRecognizers];
}


@end