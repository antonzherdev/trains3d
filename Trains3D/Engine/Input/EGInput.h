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

@interface EGRecognizer : NSObject {
@private
    EGRecognizerType* _tp;
}
@property (nonatomic, readonly) EGRecognizerType* tp;

+ (instancetype)recognizerWithTp:(EGRecognizerType*)tp;
- (instancetype)initWithTp:(EGRecognizerType*)tp;
- (ODClassType*)type;
+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended;
+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
+ (EGShortRecognizer*)applyTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (BOOL)isTp:(EGRecognizerType*)tp;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
+ (ODClassType*)type;
@end


@interface EGLongRecognizer : EGRecognizer {
@private
    BOOL(^_began)(id<EGEvent>);
    void(^_changed)(id<EGEvent>);
    void(^_ended)(id<EGEvent>);
    void(^_canceled)(id<EGEvent>);
}
@property (nonatomic, readonly) BOOL(^began)(id<EGEvent>);
@property (nonatomic, readonly) void(^changed)(id<EGEvent>);
@property (nonatomic, readonly) void(^ended)(id<EGEvent>);
@property (nonatomic, readonly) void(^canceled)(id<EGEvent>);

+ (instancetype)longRecognizerWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
- (instancetype)initWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShortRecognizer : EGRecognizer {
@private
    BOOL(^_on)(id<EGEvent>);
}
@property (nonatomic, readonly) BOOL(^on)(id<EGEvent>);

+ (instancetype)shortRecognizerWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (instancetype)initWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@protocol EGInputProcessor<NSObject>
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
@end


@interface EGRecognizers : NSObject {
@private
    id<CNImSeq> _items;
}
@property (nonatomic, readonly) id<CNImSeq> items;

+ (instancetype)recognizersWithItems:(id<CNImSeq>)items;
- (instancetype)initWithItems:(id<CNImSeq>)items;
- (ODClassType*)type;
+ (EGRecognizers*)applyRecognizer:(EGRecognizer*)recognizer;
- (id)onEvent:(id<EGEvent>)event;
- (id)beganEvent:(id<EGEvent>)event;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
- (EGRecognizers*)addRecognizers:(EGRecognizers*)recognizers;
- (id<CNSet>)types;
+ (ODClassType*)type;
@end


@interface EGRecognizersState : NSObject {
@private
    EGRecognizers* _recognizers;
    NSMutableDictionary* _longMap;
}
@property (nonatomic, readonly) EGRecognizers* recognizers;

+ (instancetype)recognizersStateWithRecognizers:(EGRecognizers*)recognizers;
- (instancetype)initWithRecognizers:(EGRecognizers*)recognizers;
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
+ (instancetype)recognizerType;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGPan : EGRecognizerType {
@private
    NSUInteger _fingers;
}
@property (nonatomic, readonly) NSUInteger fingers;

+ (instancetype)panWithFingers:(NSUInteger)fingers;
- (instancetype)initWithFingers:(NSUInteger)fingers;
- (ODClassType*)type;
+ (EGPan*)apply;
+ (EGPan*)leftMouse;
+ (EGPan*)rightMouse;
+ (ODClassType*)type;
@end


@interface EGTap : EGRecognizerType {
@private
    NSUInteger _fingers;
    NSUInteger _taps;
}
@property (nonatomic, readonly) NSUInteger fingers;
@property (nonatomic, readonly) NSUInteger taps;

+ (instancetype)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (instancetype)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (ODClassType*)type;
+ (EGTap*)apply;
+ (ODClassType*)type;
@end


@interface EGPinch : EGRecognizerType
+ (instancetype)pinch;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGPinchParameter : NSObject {
@private
    CGFloat _scale;
    CGFloat _velocity;
}
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat velocity;

+ (instancetype)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (instancetype)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
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
- (EGMatrixModel*)matrixModel;
- (GERect)viewport;
- (GEVec2)locationInViewport;
- (GEVec2)location;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (GELine3)segment;
- (BOOL)checkViewport;
@end


@interface EGViewEvent : NSObject<EGEvent> {
@private
    EGRecognizerType* _recognizerType;
    EGEventPhase* _phase;
    GEVec2 _locationInView;
    GEVec2 _viewSize;
    id _param;
}
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) EGEventPhase* phase;
@property (nonatomic, readonly) GEVec2 locationInView;
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id param;

+ (instancetype)viewEventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (instancetype)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCameraEvent : NSObject<EGEvent> {
@private
    id<EGEvent> _event;
    EGMatrixModel* _matrixModel;
    GERect _viewport;
    EGRecognizerType* _recognizerType;
    GEVec2 _locationInView;
    CNLazy* __lazy_segment;
}
@property (nonatomic, readonly) id<EGEvent> event;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;
@property (nonatomic, readonly) GERect viewport;
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) GEVec2 locationInView;

+ (instancetype)cameraEventWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
- (instancetype)initWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport;
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


