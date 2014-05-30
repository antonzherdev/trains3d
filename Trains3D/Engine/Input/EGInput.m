#import "EGInput.h"

#import "EGDirector.h"
#import "CNReact.h"
#import "CNChain.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGRecognizer
static CNClassType* _EGRecognizer_type;
@synthesize tp = _tp;

+ (instancetype)recognizerWithTp:(EGRecognizerType*)tp {
    return [[EGRecognizer alloc] initWithTp:tp];
}

- (instancetype)initWithTp:(EGRecognizerType*)tp {
    self = [super init];
    if(self) _tp = tp;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizer class]) _EGRecognizer_type = [CNClassType classTypeWithCls:[EGRecognizer class]];
}

+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended {
    return [EGLongRecognizer longRecognizerWithTp:tp began:began changed:changed ended:ended canceled:^void(id<EGEvent> _) {
    }];
}

+ (EGRecognizer*)applyTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled {
    return [EGLongRecognizer longRecognizerWithTp:tp began:began changed:changed ended:ended canceled:canceled];
}

+ (EGShortRecognizer*)applyTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on {
    return [EGShortRecognizer shortRecognizerWithTp:tp on:on];
}

- (BOOL)isTp:(EGRecognizerType*)tp {
    return [tp isEqual:_tp];
}

- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer {
    return [EGRecognizers recognizersWithItems:(@[((EGRecognizer*)(self)), recognizer])];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Recognizer(%@)", _tp];
}

- (CNClassType*)type {
    return [EGRecognizer type];
}

+ (CNClassType*)type {
    return _EGRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGLongRecognizer
static CNClassType* _EGLongRecognizer_type;
@synthesize began = _began;
@synthesize changed = _changed;
@synthesize ended = _ended;
@synthesize canceled = _canceled;

+ (instancetype)longRecognizerWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled {
    return [[EGLongRecognizer alloc] initWithTp:tp began:began changed:changed ended:ended canceled:canceled];
}

- (instancetype)initWithTp:(EGRecognizerType*)tp began:(BOOL(^)(id<EGEvent>))began changed:(void(^)(id<EGEvent>))changed ended:(void(^)(id<EGEvent>))ended canceled:(void(^)(id<EGEvent>))canceled {
    self = [super initWithTp:tp];
    if(self) {
        _began = [began copy];
        _changed = [changed copy];
        _ended = [ended copy];
        _canceled = [canceled copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLongRecognizer class]) _EGLongRecognizer_type = [CNClassType classTypeWithCls:[EGLongRecognizer class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [EGLongRecognizer type];
}

+ (CNClassType*)type {
    return _EGLongRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShortRecognizer
static CNClassType* _EGShortRecognizer_type;
@synthesize on = _on;

+ (instancetype)shortRecognizerWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on {
    return [[EGShortRecognizer alloc] initWithTp:tp on:on];
}

- (instancetype)initWithTp:(EGRecognizerType*)tp on:(BOOL(^)(id<EGEvent>))on {
    self = [super initWithTp:tp];
    if(self) _on = [on copy];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShortRecognizer class]) _EGShortRecognizer_type = [CNClassType classTypeWithCls:[EGShortRecognizer class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [EGShortRecognizer type];
}

+ (CNClassType*)type {
    return _EGShortRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGInputProcessor_impl

+ (instancetype)inputProcessor_impl {
    return [[EGInputProcessor_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (BOOL)isProcessorActive {
    return !(unumb([[EGDirector current].isPaused value]));
}

- (EGRecognizers*)recognizers {
    @throw @"Method recognizers is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRecognizers
static CNClassType* _EGRecognizers_type;
@synthesize items = _items;

+ (instancetype)recognizersWithItems:(NSArray*)items {
    return [[EGRecognizers alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray*)items {
    self = [super init];
    if(self) _items = items;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizers class]) _EGRecognizers_type = [CNClassType classTypeWithCls:[EGRecognizers class]];
}

+ (EGRecognizers*)applyRecognizer:(EGRecognizer*)recognizer {
    return [EGRecognizers recognizersWithItems:(@[recognizer])];
}

- (EGShortRecognizer*)onEvent:(id<EGEvent>)event {
    return ((EGShortRecognizer*)([_items findWhere:^BOOL(EGRecognizer* item) {
        return [[event recognizerType].type isInstanceObj:item] && ((EGShortRecognizer*)(item)).on(event);
    }]));
}

- (EGLongRecognizer*)beganEvent:(id<EGEvent>)event {
    return ((EGLongRecognizer*)([_items findWhere:^BOOL(EGRecognizer* item) {
        return [[event recognizerType].type isInstanceObj:item] && ((EGLongRecognizer*)(item)).began(event);
    }]));
}

- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer {
    return [EGRecognizers recognizersWithItems:[_items addItem:recognizer]];
}

- (EGRecognizers*)addRecognizers:(EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:[_items addSeq:recognizers.items]];
}

- (id<CNSet>)types {
    return [[[_items chain] mapF:^EGRecognizerType*(EGRecognizer* _) {
        return ((EGRecognizer*)(_)).tp;
    }] toSet];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Recognizers(%@)", _items];
}

- (CNClassType*)type {
    return [EGRecognizers type];
}

+ (CNClassType*)type {
    return _EGRecognizers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRecognizersState
static CNClassType* _EGRecognizersState_type;
@synthesize recognizers = _recognizers;

+ (instancetype)recognizersStateWithRecognizers:(EGRecognizers*)recognizers {
    return [[EGRecognizersState alloc] initWithRecognizers:recognizers];
}

- (instancetype)initWithRecognizers:(EGRecognizers*)recognizers {
    self = [super init];
    if(self) {
        _recognizers = recognizers;
        _longMap = [CNMHashMap hashMap];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizersState class]) _EGRecognizersState_type = [CNClassType classTypeWithCls:[EGRecognizersState class]];
}

- (BOOL)processEvent:(id<EGEvent>)event {
    if([event phase] == EGEventPhase_on) {
        return [self onEvent:event];
    } else {
        if([event phase] == EGEventPhase_began) {
            return [self beganEvent:event];
        } else {
            if([event phase] == EGEventPhase_ended) {
                return [self endedEvent:event];
            } else {
                if([event phase] == EGEventPhase_changed) return [self changedEvent:event];
                else return [self canceledEvent:event];
            }
        }
    }
}

- (BOOL)onEvent:(id<EGEvent>)event {
    return [_recognizers onEvent:event] != nil;
}

- (BOOL)beganEvent:(id<EGEvent>)event {
    EGRecognizerType* tp = [event recognizerType];
    return [_longMap modifyKey:tp by:^EGLongRecognizer*(EGLongRecognizer* _) {
        return [_recognizers beganEvent:event];
    }] != nil;
}

- (BOOL)changedEvent:(id<EGEvent>)event {
    id __tmp;
    {
        EGLongRecognizer* rec = [_longMap applyKey:[event recognizerType]];
        if(rec != nil) {
            ((EGLongRecognizer*)(rec)).changed(event);
            __tmp = @YES;
        } else {
            __tmp = nil;
        }
    }
    if(__tmp != nil) return unumb(__tmp);
    else return NO;
}

- (BOOL)endedEvent:(id<EGEvent>)event {
    EGRecognizerType* tp = [event recognizerType];
    {
        void(^__nd)(id<EGEvent>) = ((EGLongRecognizer*)([_longMap applyKey:tp])).ended;
        if(__nd != nil) __nd(event);
    }
    return [_longMap removeKey:tp] != nil;
}

- (BOOL)canceledEvent:(id<EGEvent>)event {
    EGRecognizerType* tp = [event recognizerType];
    {
        void(^__nd)(id<EGEvent>) = ((EGLongRecognizer*)([_longMap applyKey:tp])).canceled;
        if(__nd != nil) __nd(event);
    }
    return [_longMap removeKey:tp] != nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RecognizersState(%@)", _recognizers];
}

- (CNClassType*)type {
    return [EGRecognizersState type];
}

+ (CNClassType*)type {
    return _EGRecognizersState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRecognizerType
static CNClassType* _EGRecognizerType_type;

+ (instancetype)recognizerType {
    return [[EGRecognizerType alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizerType class]) _EGRecognizerType_type = [CNClassType classTypeWithCls:[EGRecognizerType class]];
}

- (NSString*)description {
    return @"RecognizerType";
}

- (CNClassType*)type {
    return [EGRecognizerType type];
}

+ (CNClassType*)type {
    return _EGRecognizerType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPan
static EGPan* _EGPan_leftMouse;
static EGPan* _EGPan_rightMouse;
static CNClassType* _EGPan_type;
@synthesize fingers = _fingers;

+ (instancetype)panWithFingers:(NSUInteger)fingers {
    return [[EGPan alloc] initWithFingers:fingers];
}

- (instancetype)initWithFingers:(NSUInteger)fingers {
    self = [super init];
    if(self) _fingers = fingers;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPan class]) {
        _EGPan_type = [CNClassType classTypeWithCls:[EGPan class]];
        _EGPan_leftMouse = [EGPan panWithFingers:1];
        _EGPan_rightMouse = [EGPan panWithFingers:2];
    }
}

+ (EGPan*)apply {
    return _EGPan_leftMouse;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Pan(%lu)", (unsigned long)_fingers];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGPan class]])) return NO;
    EGPan* o = ((EGPan*)(to));
    return _fingers == o.fingers;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _fingers;
    return hash;
}

- (CNClassType*)type {
    return [EGPan type];
}

+ (EGPan*)leftMouse {
    return _EGPan_leftMouse;
}

+ (EGPan*)rightMouse {
    return _EGPan_rightMouse;
}

+ (CNClassType*)type {
    return _EGPan_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGTap
static CNClassType* _EGTap_type;
@synthesize fingers = _fingers;
@synthesize taps = _taps;

+ (instancetype)tapWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps {
    return [[EGTap alloc] initWithFingers:fingers taps:taps];
}

- (instancetype)initWithFingers:(NSUInteger)fingers taps:(NSUInteger)taps {
    self = [super init];
    if(self) {
        _fingers = fingers;
        _taps = taps;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGTap class]) _EGTap_type = [CNClassType classTypeWithCls:[EGTap class]];
}

+ (EGTap*)applyFingers:(NSUInteger)fingers {
    return [EGTap tapWithFingers:fingers taps:1];
}

+ (EGTap*)applyTaps:(NSUInteger)taps {
    return [EGTap tapWithFingers:1 taps:taps];
}

+ (EGTap*)apply {
    return [EGTap tapWithFingers:1 taps:1];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Tap(%lu, %lu)", (unsigned long)_fingers, (unsigned long)_taps];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGTap class]])) return NO;
    EGTap* o = ((EGTap*)(to));
    return _fingers == o.fingers && _taps == o.taps;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _fingers;
    hash = hash * 31 + _taps;
    return hash;
}

- (CNClassType*)type {
    return [EGTap type];
}

+ (CNClassType*)type {
    return _EGTap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPinch
static CNClassType* _EGPinch_type;

+ (instancetype)pinch {
    return [[EGPinch alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPinch class]) _EGPinch_type = [CNClassType classTypeWithCls:[EGPinch class]];
}

- (NSString*)description {
    return @"Pinch";
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGPinch class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (CNClassType*)type {
    return [EGPinch type];
}

+ (CNClassType*)type {
    return _EGPinch_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGPinchParameter
static CNClassType* _EGPinchParameter_type;
@synthesize scale = _scale;
@synthesize velocity = _velocity;

+ (instancetype)pinchParameterWithScale:(CGFloat)scale velocity:(CGFloat)velocity {
    return [[EGPinchParameter alloc] initWithScale:scale velocity:velocity];
}

- (instancetype)initWithScale:(CGFloat)scale velocity:(CGFloat)velocity {
    self = [super init];
    if(self) {
        _scale = scale;
        _velocity = velocity;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPinchParameter class]) _EGPinchParameter_type = [CNClassType classTypeWithCls:[EGPinchParameter class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"PinchParameter(%f, %f)", _scale, _velocity];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGPinchParameter class]])) return NO;
    EGPinchParameter* o = ((EGPinchParameter*)(to));
    return eqf(_scale, o.scale) && eqf(_velocity, o.velocity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_scale);
    hash = hash * 31 + floatHash(_velocity);
    return hash;
}

- (CNClassType*)type {
    return [EGPinchParameter type];
}

+ (CNClassType*)type {
    return _EGPinchParameter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

EGEventPhase* EGEventPhase_Values[6];
EGEventPhase* EGEventPhase_began_Desc;
EGEventPhase* EGEventPhase_changed_Desc;
EGEventPhase* EGEventPhase_ended_Desc;
EGEventPhase* EGEventPhase_canceled_Desc;
EGEventPhase* EGEventPhase_on_Desc;
@implementation EGEventPhase

+ (instancetype)eventPhaseWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGEventPhase alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)load {
    [super load];
    EGEventPhase_began_Desc = [EGEventPhase eventPhaseWithOrdinal:0 name:@"began"];
    EGEventPhase_changed_Desc = [EGEventPhase eventPhaseWithOrdinal:1 name:@"changed"];
    EGEventPhase_ended_Desc = [EGEventPhase eventPhaseWithOrdinal:2 name:@"ended"];
    EGEventPhase_canceled_Desc = [EGEventPhase eventPhaseWithOrdinal:3 name:@"canceled"];
    EGEventPhase_on_Desc = [EGEventPhase eventPhaseWithOrdinal:4 name:@"on"];
    EGEventPhase_Values[0] = nil;
    EGEventPhase_Values[1] = EGEventPhase_began_Desc;
    EGEventPhase_Values[2] = EGEventPhase_changed_Desc;
    EGEventPhase_Values[3] = EGEventPhase_ended_Desc;
    EGEventPhase_Values[4] = EGEventPhase_canceled_Desc;
    EGEventPhase_Values[5] = EGEventPhase_on_Desc;
}

+ (NSArray*)values {
    return (@[EGEventPhase_began_Desc, EGEventPhase_changed_Desc, EGEventPhase_ended_Desc, EGEventPhase_canceled_Desc, EGEventPhase_on_Desc]);
}

@end

@implementation EGEvent_impl

+ (instancetype)event_impl {
    return [[EGEvent_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (EGRecognizerType*)recognizerType {
    @throw @"Method recognizerType is abstract";
}

- (EGEventPhaseR)phase {
    @throw @"Method phase is abstract";
}

- (GEVec2)locationInView {
    @throw @"Method locationInView is abstract";
}

- (GEVec2)viewSize {
    @throw @"Method viewSize is abstract";
}

- (id)param {
    @throw @"Method param is abstract";
}

- (EGMatrixModel*)matrixModel {
    return EGMatrixModel.identity;
}

- (GERect)viewport {
    return geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
}

- (GEVec2)locationInViewport {
    return [self locationInView];
}

- (GEVec2)location {
    return [self locationInView];
}

- (GEVec2)locationForDepth:(CGFloat)depth {
    return [self locationInView];
}

- (GELine3)segment {
    return GELine3Make((geVec3ApplyVec2Z([self locationInView], 0.0)), (GEVec3Make(0.0, 0.0, 1000.0)));
}

- (BOOL)checkViewport {
    return YES;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGViewEvent
static CNClassType* _EGViewEvent_type;
@synthesize recognizerType = _recognizerType;
@synthesize phase = _phase;
@synthesize locationInView = _locationInView;
@synthesize viewSize = _viewSize;
@synthesize param = _param;

+ (instancetype)viewEventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhaseR)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param {
    return [[EGViewEvent alloc] initWithRecognizerType:recognizerType phase:phase locationInView:locationInView viewSize:viewSize param:param];
}

- (instancetype)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhaseR)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param {
    self = [super init];
    if(self) {
        _recognizerType = recognizerType;
        _phase = phase;
        _locationInView = locationInView;
        _viewSize = viewSize;
        _param = param;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewEvent class]) _EGViewEvent_type = [CNClassType classTypeWithCls:[EGViewEvent class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ViewEvent(%@, %@, %@, %@, %@)", _recognizerType, EGEventPhase_Values[_phase], geVec2Description(_locationInView), geVec2Description(_viewSize), _param];
}

- (CNClassType*)type {
    return [EGViewEvent type];
}

+ (CNClassType*)type {
    return _EGViewEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCameraEvent
static CNClassType* _EGCameraEvent_type;
@synthesize event = _event;
@synthesize matrixModel = _matrixModel;
@synthesize viewport = _viewport;
@synthesize recognizerType = _recognizerType;
@synthesize locationInView = _locationInView;

+ (instancetype)cameraEventWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport {
    return [[EGCameraEvent alloc] initWithEvent:event matrixModel:matrixModel viewport:viewport];
}

- (instancetype)initWithEvent:(id<EGEvent>)event matrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport {
    self = [super init];
    __weak EGCameraEvent* _weakSelf = self;
    if(self) {
        _event = event;
        _matrixModel = matrixModel;
        _viewport = viewport;
        _recognizerType = [event recognizerType];
        _locationInView = [event locationInView];
        __lazy_segment = [CNLazy lazyWithF:^id() {
            EGCameraEvent* _self = _weakSelf;
            if(_self != nil) return wrap(GELine3, (({
                GEVec2 loc = [_self locationInViewport];
                GEMat4* mat4 = [[matrixModel wcp] inverse];
                GEVec4 p0 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, -1.0, 1.0)];
                GEVec4 p1 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, 1.0, 1.0)];
                GELine3Make(geVec4Xyz(p0), (geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0))));
            })));
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraEvent class]) _EGCameraEvent_type = [CNClassType classTypeWithCls:[EGCameraEvent class]];
}

- (GELine3)segment {
    return uwrap(GELine3, [__lazy_segment get]);
}

- (EGEventPhaseR)phase {
    return [_event phase];
}

- (GEVec2)viewSize {
    return [_event viewSize];
}

- (id)param {
    return [_event param];
}

- (GEVec2)location {
    return [self locationForDepth:0.0];
}

- (GEVec2)locationInViewport {
    return geVec2SubVec2((geVec2MulF4((geVec2DivVec2((geVec2SubVec2(_locationInView, _viewport.p)), _viewport.size)), 2.0)), (GEVec2Make(1.0, 1.0)));
}

- (GEVec2)locationForDepth:(CGFloat)depth {
    return geVec3Xy((geLine3RPlane([self segment], (GEPlaneMake((GEVec3Make(0.0, 0.0, ((float)(depth)))), (GEVec3Make(0.0, 0.0, 1.0)))))));
}

- (BOOL)checkViewport {
    return geRectContainsVec2(_viewport, _locationInView);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CameraEvent(%@, %@, %@)", _event, _matrixModel, geRectDescription(_viewport)];
}

- (CNClassType*)type {
    return [EGCameraEvent type];
}

+ (CNClassType*)type {
    return _EGCameraEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

