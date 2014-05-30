#import "objd.h"
#import "GEVec.h"
@class EGDirector;
@class CNReact;
@class CNChain;
@class EGMatrixModel;
@class GEMat4;

@class EGRecognizer;
@class EGLongRecognizer;
@class EGShortRecognizer;
@class EGInputProcessor_impl;
@class EGRecognizers;
@class EGRecognizersState;
@class EGRecognizerType;
@class EGPan;
@class EGTap;
@class EGPinch;
@class EGPinchParameter;
@class EGEvent_impl;
@class EGViewEvent;
@class EGCameraEvent;
@class EGEventPhase;
@protocol EGInputProcessor;
@protocol EGEvent;

typedef enum EGEventPhaseR {
    EGEventPhase_Nil = 0,
    EGEventPhase_began = 1,
    EGEventPhase_changed = 2,
    EGEventPhase_ended = 3,
    EGEventPhase_canceled = 4,
    EGEventPhase_on = 5
} EGEventPhaseR;
@interface EGEventPhase : CNEnum
+ (NSArray*)values;
@end
extern EGEventPhase* EGEventPhase_Values[6];
extern EGEventPhase* EGEventPhase_began_Desc;
extern EGEventPhase* EGEventPhase_changed_Desc;
extern EGEventPhase* EGEventPhase_ended_Desc;
extern EGEventPhase* EGEventPhase_canceled_Desc;
extern EGEventPhase* EGEventPhase_on_Desc;


@interface EGRecognizer : NSObject {
@protected
    EGRecognizerType* _tp;
}
@property (nonatomic, readonly) EGRecognizerType* tp;

+ (instancetype)recognizerWithTp:(EGRecognizerType*)tp;
- (instancetype)initWithTp:(EGRecognizerType*)tp;
- (CNClassType*)type;
+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended;
+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled;
+ (EGShortRecognizer*)applyTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (BOOL)isTp:(EGRecognizerType*)tp;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGLongRecognizer : EGRecognizer {
@protected
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
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShortRecognizer : EGRecognizer {
@protected
    BOOL(^_on)(id<EGEvent>);
}
@property (nonatomic, readonly) BOOL(^on)(id<EGEvent>);

+ (instancetype)shortRecognizerWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (instancetype)initWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol EGInputProcessor<NSObject>
- (BOOL)isProcessorActive;
- (EGRecognizers*)recognizers;
- (NSString*)description;
@end


@interface EGInputProcessor_impl : NSObject<EGInputProcessor>
+ (instancetype)inputProcessor_impl;
- (instancetype)init;
@end


@interface EGRecognizers : NSObject {
@protected
    NSArray* _items;
}
@property (nonatomic, readonly) NSArray* items;

+ (instancetype)recognizersWithItems:(NSArray*)items;
- (instancetype)initWithItems:(NSArray*)items;
- (CNClassType*)type;
+ (EGRecognizers*)applyRecognizer:(EGRecognizer*)recognizer;
- (EGShortRecognizer*)onEvent:(id<EGEvent>)event;
- (EGLongRecognizer*)beganEvent:(id<EGEvent>)event;
- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer;
- (EGRecognizers*)addRecognizers:(EGRecognizers*)recognizers;
- (id<CNSet>)types;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGRecognizersState : NSObject {
@protected
    EGRecognizers* _recognizers;
    CNMHashMap* _longMap;
}
@property (nonatomic, readonly) EGRecognizers* recognizers;

+ (instancetype)recognizersStateWithRecognizers:(EGRecognizers*)recognizers;
- (instancetype)initWithRecognizers:(EGRecognizers*)recognizers;
- (CNClassType*)type;
- (BOOL)processEvent:(id<EGEvent>)event;
- (BOOL)onEvent:(id<EGEvent>)event;
- (BOOL)beganEvent:(id<EGEvent>)event;
- (BOOL)changedEvent:(id<EGEvent>)event;
- (BOOL)endedEvent:(id<EGEvent>)event;
- (BOOL)canceledEvent:(id<EGEvent>)event;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGRecognizerType : NSObject
+ (instancetype)recognizerType;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGPan : EGRecognizerType {
@protected
    NSUInteger _fingers;
}
@property (nonatomic, readonly) NSUInteger fingers;

+ (instancetype)panWithFingers:(NSUInteger)fingers;
- (instancetype)initWithFingers:(NSUInteger)fingers;
- (CNClassType*)type;
+ (EGPan*)apply;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (EGPan*)leftMouse;
+ (EGPan*)rightMouse;
+ (CNClassType*)type;
@end


@interface EGTap : EGRecognizerType {
@protected
    NSUInteger _fingers;
    NSUInteger _taps;
}
@property (nonatomic, readonly) NSUInteger fingers;
@property (nonatomic, readonly) NSUInteger taps;

+ (instancetype)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (instancetype)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps;
- (CNClassType*)type;
+ (EGTap*)applyFingers:(NSUInteger)fingers;
+ (EGTap*)applyTaps:(NSUInteger)taps;
+ (EGTap*)apply;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGPinch : EGRecognizerType
+ (instancetype)pinch;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGPinchParameter : NSObject {
@protected
    CGFloat _scale;
    CGFloat _velocity;
}
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat velocity;

+ (instancetype)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (instancetype)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@protocol EGEvent<NSObject>
- (EGRecognizerType*)recognizerType;
- (EGEventPhaseR)phase;
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
- (NSString*)description;
@end


@interface EGEvent_impl : NSObject<EGEvent>
+ (instancetype)event_impl;
- (instancetype)init;
@end


@interface EGViewEvent : EGEvent_impl {
@protected
    EGRecognizerType* _recognizerType;
    EGEventPhaseR _phase;
    GEVec2 _locationInView;
    GEVec2 _viewSize;
    id _param;
}
@property (nonatomic, readonly) EGRecognizerType* recognizerType;
@property (nonatomic, readonly) EGEventPhaseR phase;
@property (nonatomic, readonly) GEVec2 locationInView;
@property (nonatomic, readonly) GEVec2 viewSize;
@property (nonatomic, readonly) id param;

+ (instancetype)viewEventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhaseR)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (instancetype)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhaseR)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGCameraEvent : EGEvent_impl {
@protected
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
- (CNClassType*)type;
- (GELine3)segment;
- (EGEventPhaseR)phase;
- (GEVec2)viewSize;
- (id)param;
- (GEVec2)location;
- (GEVec2)locationInViewport;
- (GEVec2)locationForDepth:(CGFloat)depth;
- (BOOL)checkViewport;
- (NSString*)description;
+ (CNClassType*)type;
@end


