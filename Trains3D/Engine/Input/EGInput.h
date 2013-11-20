#import "objd.h"
#import "GEVec.h"
#import "GELine.h"
@class EGDirector;
@class EGMatrixModel;
@class GEMat4;

@class EGRecognizer;
@class EGLongRecognizer;
@class EGShortRecognizer;
@class EGRecognizers;
@class EGRecognizersState;
@class EGRecognizerType;
@class EGPan;
@class EGTap;
@class EGPinch;
@class EGEventCamera;
@class EGEvent;
@class EGEventPhase;
@protocol EGInputProcessor;

@interface EGRecognizer : NSObject
@property (nonatomic, readonly) EGRecognizerType* tp;

+ (id)recognizerWithTp:(EGRecognizerType*)tp;
- (id)initWithTp:(EGRecognizerType*)tp;
- (ODClassType*)type;
+ (EGLongRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(EGEvent*))began changed:(void(^)(EGEvent*))changed ended:(void(^)(EGEvent*))ended;
+ (EGLongRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(EGEvent*))began changed:(void(^)(EGEvent*))changed ended:(void(^)(EGEvent*))ended canceled:(void(^)(EGEvent*))canceled;
+ (EGShortRecognizer*)applyTp:(EGRecognizerType*)tp on:(BOOL(^)(EGEvent*))on;
- (BOOL)isTp:(EGRecognizerType*)tp;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
+ (ODClassType*)type;
@end


@interface EGLongRecognizer : EGRecognizer
@property (nonatomic, readonly) BOOL(^began)(EGEvent*);
@property (nonatomic, readonly) void(^changed)(EGEvent*);
@property (nonatomic, readonly) void(^ended)(EGEvent*);
@property (nonatomic, readonly) void(^canceled)(EGEvent*);

+ (id)longRecognizerWithTp:(EGRecognizerType*)tp began:(BOOL(^)(EGEvent*))began changed:(void(^)(EGEvent*))changed ended:(void(^)(EGEvent*))ended canceled:(void(^)(EGEvent*))canceled;
- (id)initWithTp:(EGRecognizerType*)tp began:(BOOL(^)(EGEvent*))began changed:(void(^)(EGEvent*))changed ended:(void(^)(EGEvent*))ended canceled:(void(^)(EGEvent*))canceled;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShortRecognizer : EGRecognizer
@property (nonatomic, readonly) BOOL(^on)(EGEvent*);

+ (id)shortRecognizerWithTp:(EGRecognizerType*)tp on:(BOOL(^)(EGEvent*))on;
- (id)initWithTp:(EGRecognizerType*)tp on:(BOOL(^)(EGEvent*))on;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@protocol EGInputProcessor<NSObject>
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
@end


@interface EGRecognizers : NSObject
@property (nonatomic, readonly) id<CNSeq> items;

+ (id)recognizersWithItems:(id<CNSeq>)items;
- (id)initWithItems:(id<CNSeq>)items;
- (ODClassType*)type;
+ (EGRecognizers*)applyRecognizer:(EGRecognizer*)recognizer;
- (id)onEvent:(EGEvent*)event;
- (id)beganEvent:(EGEvent*)event;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
- (EGRecognizers*)addRecognizers:(EGRecognizers*)recognizers;
- (id<CNSet>)types;
+ (ODClassType*)type;
@end


@interface EGRecognizersState : NSObject
@property (nonatomic, readonly) EGRecognizers* recognizers;

+ (id)recognizersStateWithRecognizers:(EGRecognizers*)recognizers;
- (id)initWithRecognizers:(EGRecognizers*)recognizers;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)onEvent:(EGEvent*)event;
- (BOOL)beganEvent:(EGEvent*)event;
- (BOOL)changedEvent:(EGEvent*)event;
- (BOOL)endedEvent:(EGEvent*)event;
- (BOOL)canceledEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


@interface EGRecognizerType : NSObject
+ (id)recognizerType;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGPan : EGRecognizerType
@property (nonatomic, readonly) NSUInteger fingers;

+ (id)panWithFingers:(NSUInteger)fingers;
- (id)initWithFingers:(NSUInteger)fingers;
- (ODClassType*)type;
+ (EGPan*)apply;
+ (EGPan*)leftMouse;
+ (EGPan*)rightMouse;
+ (ODClassType*)type;
@end


@interface EGTap : EGRecognizerType
@property (nonatomic, readonly) NSUInteger fingers;
@property (nonatomic, readonly) NSUInteger taps;

+ (id)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (id)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (ODClassType*)type;
+ (EGTap*)apply;
+ (ODClassType*)type;
@end


@interface EGPinch : EGRecognizerType
+ (id)pinch;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEventPhase : ODEnum
+ (EGEventPhase*)began;
+ (EGEventPhase*)changed;
+ (EGEventPhase*)ended;
+ (EGEventPhase*)canceled;
+ (EGEventPhase*)on;
+ (NSArray*)values;
@end


@interface EGEventCamera : NSObject
@property (nonatomic, readonly) EGMatrixModel* matrixModel;
@property (nonatomic, readonly) GERect viewport;

+ (id)eventCameraWithMatrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
- (id)initWithMatrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEvent : NSObject
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) EGEventPhase* phase;
@property (nonatomic, readonly) GEVec2 locationInView;
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id camera;

+ (id)eventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;
- (id)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize camera:(id)camera;
- (ODClassType*)type;
- (GELine3)segment;
+ (EGEvent*)applyRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize;
- (EGEvent*)setCamera:(id)camera;
- (GEVec2)location;
- (GEVec2)locationInViewport;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (BOOL)checkViewport;
+ (ODClassType*)type;
@end


