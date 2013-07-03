#import "EGDirectorMac.h"
#import "EGOpenGLView.h"


@implementation EGDirectorMac {
@private
    CVDisplayLinkRef _displayLink;
    __unsafe_unretained EGOpenGLView *_view;
}

@synthesize view = _view;

- (id)initWithView:(__unsafe_unretained EGOpenGLView *)view {
    self = [super init];
    if (self) {
        _view = view;
    }

    return self;
}

+ (id)directorWithView:(__unsafe_unretained EGOpenGLView *)view {
    return [[self alloc] initWithView:view];
}


- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
    @autoreleasepool{
        [self.view lockOpenGLContext];
        @try {
            [self tick];
            [self drawWithSize:_view.viewSize];
            [self.view.openGLContext flushBuffer];
            glFlush();

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
    if(self.started) return;

    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);

    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(_displayLink, &MyDisplayLinkCallback, (__bridge void*)self);

    // Set the display link for the current renderer
    EGOpenGLView *openGLView = self.view;
    CGLContextObj cglContext = [[openGLView openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[openGLView pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);

    // Activate the display link
    CVDisplayLinkStart(_displayLink);

    [super start];
}

- (void)stop {
    if(!self.started) return;


    if( _displayLink ) {
        CVDisplayLinkStop(_displayLink);
        CVDisplayLinkRelease(_displayLink);
        _displayLink = nil;
    }

    [super stop];
}


@end