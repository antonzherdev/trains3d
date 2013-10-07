#import <OpenGL/gl3.h>
#import "EGOpenGLViewMac.h"
#import "EGDirectorMac.h"
#import "EGEventMac.h"
#import "KWExample.h"


@implementation EGOpenGLViewMac {

@private
    EGDirector *_director;
    GEVec2 _viewSize;
}

@synthesize director = _director;

@synthesize viewSize = _viewSize;

- (id)initWithFrame:(NSRect)frame
{
    CGLPixelFormatAttribute attribs[17] = {
            kCGLPFAOpenGLProfile, (CGLPixelFormatAttribute)kCGLOGLPVersion_3_2_Core, // This sets the context to 3.2
            kCGLPFAColorSize,     (CGLPixelFormatAttribute)24,
            kCGLPFAAlphaSize,     (CGLPixelFormatAttribute)8,
            kCGLPFAAccelerated,
            kCGLPFADoubleBuffer,
            kCGLPFASampleBuffers, (CGLPixelFormatAttribute)1,
            kCGLPFASamples,       (CGLPixelFormatAttribute)4,
            kCGLPFADepthSize,     (CGLPixelFormatAttribute)24,
            kCGLPFAStencilSize, (CGLPixelFormatAttribute)0,
            (CGLPixelFormatAttribute)0
    };
    NSOpenGLPixelFormat *pix = [[NSOpenGLPixelFormat alloc] initWithAttributes:(NSOpenGLPixelFormatAttribute const *) attribs];
    return [self initWithFrame:frame pixelFormat:pix];
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
    [self setAcceptsTouchEvents:YES];
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
        CGSize nsSize = self.bounds.size;
        _viewSize = GEVec2Make((float) nsSize.width, (float) nsSize.height);
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


    GLuint VertexArrayID;
    glGenVertexArrays(1, &VertexArrayID);
    glBindVertexArray(VertexArrayID);
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

#define DISPATCH_EVENT(theEvent, tp) {\
[self lockOpenGLContext];\
[_director processEvent:[EGEventMac eventMacWithEvent:theEvent type:tp view:self camera:[CNOption none]]];\
[self unlockOpenGLContext];\
}

#pragma mark CCGLView - Mouse events

- (void)mouseDown:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSLeftMouseDown);
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSMouseMoved);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSLeftMouseDragged);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSLeftMouseUp);
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSRightMouseDown);
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSRightMouseDragged);
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSRightMouseUp);
}

- (void)otherMouseDown:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSOtherMouseDown);
}

- (void)otherMouseDragged:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSOtherMouseDragged);
}

- (void)otherMouseUp:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSOtherMouseUp);
}

- (void)mouseEntered:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSMouseEntered);
}

- (void)mouseExited:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSMouseExited);
}

-(void) scrollWheel:(NSEvent *)theEvent {
    DISPATCH_EVENT(theEvent, NSScrollWheel);
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
    DISPATCH_EVENT(theEvent, NSKeyDown);
}

- (void)keyUp:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSKeyUp);
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, NSFlagsChanged);
}

#pragma mark CCGLView - Touch events
- (void)touchesBeganWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, EGEventTouchBegan);
}

- (void)touchesMovedWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, EGEventTouchMoved);
}

- (void)touchesEndedWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, EGEventTouchEnded);
}

- (void)touchesCancelledWithEvent:(NSEvent *)theEvent
{
    DISPATCH_EVENT(theEvent, EGEventTouchCanceled);
}


@end