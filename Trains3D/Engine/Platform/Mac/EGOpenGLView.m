#import "EGOpenGLView.h"
#import "EGDirectorMac.h"


@implementation EGOpenGLView {

@private
    EGDirector *_director;
}

@synthesize director = _director;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }

    return self;
}

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format {
    self = [super initWithFrame:frameRect pixelFormat:format];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)doInit {
    if(_director != nil) return;

    _director = [[EGDirectorMac alloc] initWithView:self];
    [_director start];
}

- (id)init {
    self = [super init];
    if (self) {
        [self doInit];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInit];
}


- (void)reshape {
    // We draw on a secondary thread through the display link
    // When resizing the view, -reshape is called automatically on the main thread
    // Add a mutex around to avoid the threads accessing the context simultaneously when resizing

    [self lockOpenGLContext];

    NSRect rect = [self bounds];

    [_director reshapeWithSize:NSSizeToCGSize(rect.size)];

    // avoid flicker
    [_director draw];
//	[self setNeedsDisplay:YES];

    [self unlockOpenGLContext];
}

- (void) prepareOpenGL {
    // XXX: Initialize OpenGL context
    [super prepareOpenGL];

    // Make this openGL context current to the thread
    // (i.e. all openGL on this thread calls will go to this context)
    [[self openGLContext] makeCurrentContext];

    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];

//	GLint order = -1;
//	[[self openGLContext] setValues:&order forParameter:NSOpenGLCPSurfaceOrder];
}

- (NSUInteger) depthFormat {
    return 24;
}


-(void) lockOpenGLContext
{
    NSOpenGLContext *glContext = [self openGLContext];
    NSAssert( glContext, @"FATAL: could not get openGL context");

    [glContext makeCurrentContext];
    CGLLockContext([glContext CGLContextObj]);
}

-(void) unlockOpenGLContext
{
    NSOpenGLContext *glContext = [self openGLContext];
    NSAssert( glContext, @"FATAL: could not get openGL context");

    CGLUnlockContext([glContext CGLContextObj]);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [_director draw];
    glFlush();
}


@end