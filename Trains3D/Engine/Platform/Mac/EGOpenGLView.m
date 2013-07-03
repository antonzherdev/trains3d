#import "EGOpenGLView.h"
#import "EGDirectorMac.h"
#import "EGEventMac.h"


@implementation EGOpenGLView {

@private
    EGDirector *_director;
    CGSize _viewSize;
}

@synthesize director = _director;

@synthesize viewSize = _viewSize;

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
    @try {
        _viewSize = NSSizeToCGSize(self.bounds.size);
        [_director drawWithSize:_viewSize];

        [self.openGLContext flushBuffer];
    } @finally {
        [self unlockOpenGLContext];
    }
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

#define DISPATCH_EVENT(theEvent, cmd) [_director processEvent:\
    [EGEventMac eventMacWithEvent:theEvent\
                   locationInView:NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:nil])\
                         viewSize:_viewSize\
                           camera:[CNOption none]]];

#pragma mark CCGLView - Mouse events

- (void)mouseDown:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)otherMouseDown:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)otherMouseDragged:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)otherMouseUp:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)mouseExited:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

-(void) scrollWheel:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, _cmd);
}

#pragma mark CCGLView - Key events

-(BOOL) becomeFirstResponder
{
    return YES;
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

-(BOOL) resignFirstResponder
{
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)keyUp:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

#pragma mark CCGLView - Touch events
- (void)touchesBeganWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)touchesMovedWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)touchesEndedWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}

- (void)touchesCancelledWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, _cmd);
}


@end