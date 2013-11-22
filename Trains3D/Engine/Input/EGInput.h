#import "objd.h"
#import "GEVec.h"
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
@class EGPinchParameter;
@class EGViewEvent;
@class EGCameraEvent;
@class EGEventPhase;
@protocol EGInputProcessor;
@protocol EGEvent;

@interface EGRecognizer : NSObject
@property (nonatomic, readonly) EGRecognizerType* tp;

+ (id)recognizerWithTp:(EGRecognizerType*)tp;
- (id)initWithTp:(EGRecognizerType*)tp;
- (ODClassType*)type;
+ (EGLongRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended;
+ (EGLongRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
+ (EGShortRecognizer*)applyTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (BOOL)isTp:(EGRecognizerType*)tp;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
+ (ODClassType*)type;
@end


@interface EGLongRecognizer : EGRecognizer
@property (nonatomic, readonly) BOOL(^began)(id<EGEvent>);
@property (nonatomic, readonly) void(^changed)(id<EGEvent>);
@property (nonatomic, readonly) void(^ended)(id<EGEvent>);
@property (nonatomic, readonly) void(^canceled)(id<EGEvent>);

+ (id)longRecognizerWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
- (id)initWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShortRecognizer : EGRecognizer
@property (nonatomic, readonly) BOOL(^on)(id<EGEvent>);

+ (id)shortRecognizerWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (id)initWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
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
- (id)onEvent:(id<EGEvent>)event;
- (id)beganEvent:(id<EGEvent>)event;
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
- (BOOL)processEvent:(id<EGEvent>)event;
- (BOOL)onEvent:(id<EGEvent>)event;
- (BOOL)beganEvent:(id<EGEvent>)event;
- (BOOL)changedEvent:(id<EGEvent>)event;
- (BOOL)endedEvent:(id<EGEvent>)event;
- (BOOL)canceledEvent:(id<EGEvent>)event;
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


@interface EGPinchParameter : NSObject
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat velocity;

+ (id)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (id)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
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


@protocol EGEvent<NSObject>
- (EGRecognizerType*)recognizerType;
- (EGEventPhase*)phase;
- (GEVec2)locationInView;
- (GEVec2)viewSize;
- (id)param;
- (GEVec2)locationInViewport;
- (GEVec2)location;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (GELine3)segment;
- (BOOL)checkViewport;
@end


@interface EGViewEvent : NSObject<EGEvent>
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) EGEventPhase* phase;
@property (nonatomic, readonly) GEVec2 locationInView;
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id param;

+ (id)viewEventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (id)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCameraEvent : NSObject<EGEvent>
@property (nonatomic, readonly) id<EGEvent> event;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;
@property (nonatomic, readonly) GERect viewport;
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) GEVec2 locationInView;

+ (id)cameraEventWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
- (id)initWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
- (ODClassType*)type;
- (GELine3)segment;
- (EGEventPhase*)phase;
- (GEVec2)viewSize;
- (id)param;
- (GEVec2)location;
- (GEVec2)locationInViewport;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (BOOL)checkViewport;
+ (ODClassType*)type;
@end


