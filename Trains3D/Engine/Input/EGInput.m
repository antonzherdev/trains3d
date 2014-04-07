#import "EGInput.h"

#import "EGDirector.h"
#import "ATReact.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGRecognizer
static ODClassType* _EGRecognizer_type;
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
    if(self == [EGRecognizer class]) _EGRecognizer_type = [ODClassType classTypeWithCls:[EGRecognizer class]];
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

- (ODClassType*)type {
    return [EGRecognizer type];
}

+ (ODClassType*)type {
    return _EGRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLongRecognizer
static ODClassType* _EGLongRecognizer_type;
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
    if(self == [EGLongRecognizer class]) _EGLongRecognizer_type = [ODClassType classTypeWithCls:[EGLongRecognizer class]];
}

- (ODClassType*)type {
    return [EGLongRecognizer type];
}

+ (ODClassType*)type {
    return _EGLongRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShortRecognizer
static ODClassType* _EGShortRecognizer_type;
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
    if(self == [EGShortRecognizer class]) _EGShortRecognizer_type = [ODClassType classTypeWithCls:[EGShortRecognizer class]];
}

- (ODClassType*)type {
    return [EGShortRecognizer type];
}

+ (ODClassType*)type {
    return _EGShortRecognizer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRecognizers
static ODClassType* _EGRecognizers_type;
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
    if(self == [EGRecognizers class]) _EGRecognizers_type = [ODClassType classTypeWithCls:[EGRecognizers class]];
}

+ (EGRecognizers*)applyRecognizer:(EGRecognizer*)recognizer {
    return [EGRecognizers recognizersWithItems:(@[recognizer])];
}

- (EGShortRecognizer*)onEvent:(id<EGEvent>)event {
    return ((EGShortRecognizer*)([_items findWhere:^BOOL(EGRecognizer* item) {
        return [((EGRecognizer*)(item)) isTp:[event recognizerType]] && ((EGShortRecognizer*)(item)).on(event);
    }]));
}

- (EGLongRecognizer*)beganEvent:(id<EGEvent>)event {
    return ((EGLongRecognizer*)([_items findWhere:^BOOL(EGRecognizer* item) {
        return [((EGRecognizer*)(item)) isTp:[event recognizerType]] && ((EGLongRecognizer*)(item)).began(event);
    }]));
}

- (EGRecognizers*)addRecognizer:(EGRecognizer*)recognizer {
    return [EGRecognizers recognizersWithItems:[_items addItem:recognizer]];
}

- (EGRecognizers*)addRecognizers:(EGRecognizers*)recognizers {
    return [EGRecognizers recognizersWithItems:[_items addSeq:recognizers.items]];
}

- (id<CNSet>)types {
    return [[[_items chain] map:^EGRecognizerType*(EGRecognizer* _) {
        return ((EGRecognizer*)(_)).tp;
    }] toSet];
}

- (ODClassType*)type {
    return [EGRecognizers type];
}

+ (ODClassType*)type {
    return _EGRecognizers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"items=%@", self.items];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRecognizersState
static ODClassType* _EGRecognizersState_type;
@synthesize recognizers = _recognizers;

+ (instancetype)recognizersStateWithRecognizers:(EGRecognizers*)recognizers {
    return [[EGRecognizersState alloc] initWithRecognizers:recognizers];
}

- (instancetype)initWithRecognizers:(EGRecognizers*)recognizers {
    self = [super init];
    if(self) {
        _recognizers = recognizers;
        _longMap = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizersState class]) _EGRecognizersState_type = [ODClassType classTypeWithCls:[EGRecognizersState class]];
}

- (BOOL)processEvent:(id<EGEvent>)event {
    if([event phase] == EGEventPhase.on) {
        return [self onEvent:event];
    } else {
        if([event phase] == EGEventPhase.began) {
            return [self beganEvent:event];
        } else {
            if([event phase] == EGEventPhase.ended) {
                return [self endedEvent:event];
            } else {
                if([event phase] == EGEventPhase.changed) return [self changedEvent:event];
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
        EGLongRecognizer* rec = ((EGLongRecognizer*)([_longMap optKey:[event recognizerType]]));
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
        EGLongRecognizer* _ = ((EGLongRecognizer*)([_longMap optKey:tp]));
        if(_ != nil) ((EGLongRecognizer*)(_)).ended(event);
    }
    return [_longMap removeForKey:tp] != nil;
}

- (BOOL)canceledEvent:(id<EGEvent>)event {
    EGRecognizerType* tp = [event recognizerType];
    {
        EGLongRecognizer* _ = ((EGLongRecognizer*)([_longMap optKey:tp]));
        if(_ != nil) ((EGLongRecognizer*)(_)).canceled(event);
    }
    return [_longMap removeForKey:tp] != nil;
}

- (ODClassType*)type {
    return [EGRecognizersState type];
}

+ (ODClassType*)type {
    return _EGRecognizersState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"recognizers=%@", self.recognizers];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRecognizerType
static ODClassType* _EGRecognizerType_type;

+ (instancetype)recognizerType {
    return [[EGRecognizerType alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRecognizerType class]) _EGRecognizerType_type = [ODClassType classTypeWithCls:[EGRecognizerType class]];
}

- (ODClassType*)type {
    return [EGRecognizerType type];
}

+ (ODClassType*)type {
    return _EGRecognizerType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPan
static EGPan* _EGPan_leftMouse;
static EGPan* _EGPan_rightMouse;
static ODClassType* _EGPan_type;
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
        _EGPan_type = [ODClassType classTypeWithCls:[EGPan class]];
        _EGPan_leftMouse = [EGPan panWithFingers:1];
        _EGPan_rightMouse = [EGPan panWithFingers:2];
    }
}

+ (EGPan*)apply {
    return _EGPan_leftMouse;
}

- (ODClassType*)type {
    return [EGPan type];
}

+ (EGPan*)leftMouse {
    return _EGPan_leftMouse;
}

+ (EGPan*)rightMouse {
    return _EGPan_rightMouse;
}

+ (ODClassType*)type {
    return _EGPan_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPan* o = ((EGPan*)(other));
    return self.fingers == o.fingers;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.fingers;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"fingers=%lu", (unsigned long)self.fingers];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGTap
static ODClassType* _EGTap_type;
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
    if(self == [EGTap class]) _EGTap_type = [ODClassType classTypeWithCls:[EGTap class]];
}

+ (EGTap*)apply {
    return [EGTap tapWithFingers:1 taps:1];
}

- (ODClassType*)type {
    return [EGTap type];
}

+ (ODClassType*)type {
    return _EGTap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGTap* o = ((EGTap*)(other));
    return self.fingers == o.fingers && self.taps == o.taps;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.fingers;
    hash = hash * 31 + self.taps;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"fingers=%lu", (unsigned long)self.fingers];
    [description appendFormat:@", taps=%lu", (unsigned long)self.taps];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPinch
static ODClassType* _EGPinch_type;

+ (instancetype)pinch {
    return [[EGPinch alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGPinch class]) _EGPinch_type = [ODClassType classTypeWithCls:[EGPinch class]];
}

- (ODClassType*)type {
    return [EGPinch type];
}

+ (ODClassType*)type {
    return _EGPinch_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGPinchParameter
static ODClassType* _EGPinchParameter_type;
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
    if(self == [EGPinchParameter class]) _EGPinchParameter_type = [ODClassType classTypeWithCls:[EGPinchParameter class]];
}

- (ODClassType*)type {
    return [EGPinchParameter type];
}

+ (ODClassType*)type {
    return _EGPinchParameter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPinchParameter* o = ((EGPinchParameter*)(other));
    return eqf(self.scale, o.scale) && eqf(self.velocity, o.velocity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.scale);
    hash = hash * 31 + floatHash(self.velocity);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"scale=%f", self.scale];
    [description appendFormat:@", velocity=%f", self.velocity];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEventPhase
static EGEventPhase* _EGEventPhase_began;
static EGEventPhase* _EGEventPhase_changed;
static EGEventPhase* _EGEventPhase_ended;
static EGEventPhase* _EGEventPhase_canceled;
static EGEventPhase* _EGEventPhase_on;
static NSArray* _EGEventPhase_values;

+ (instancetype)eventPhaseWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[EGEventPhase alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEventPhase_began = [EGEventPhase eventPhaseWithOrdinal:0 name:@"began"];
    _EGEventPhase_changed = [EGEventPhase eventPhaseWithOrdinal:1 name:@"changed"];
    _EGEventPhase_ended = [EGEventPhase eventPhaseWithOrdinal:2 name:@"ended"];
    _EGEventPhase_canceled = [EGEventPhase eventPhaseWithOrdinal:3 name:@"canceled"];
    _EGEventPhase_on = [EGEventPhase eventPhaseWithOrdinal:4 name:@"on"];
    _EGEventPhase_values = (@[_EGEventPhase_began, _EGEventPhase_changed, _EGEventPhase_ended, _EGEventPhase_canceled, _EGEventPhase_on]);
}

+ (EGEventPhase*)began {
    return _EGEventPhase_began;
}

+ (EGEventPhase*)changed {
    return _EGEventPhase_changed;
}

+ (EGEventPhase*)ended {
    return _EGEventPhase_ended;
}

+ (EGEventPhase*)canceled {
    return _EGEventPhase_canceled;
}

+ (EGEventPhase*)on {
    return _EGEventPhase_on;
}

+ (NSArray*)values {
    return _EGEventPhase_values;
}

@end


@implementation EGViewEvent
static ODClassType* _EGViewEvent_type;
@synthesize recognizerType = _recognizerType;
@synthesize phase = _phase;
@synthesize locationInView = _locationInView;
@synthesize viewSize = _viewSize;
@synthesize param = _param;

+ (instancetype)viewEventWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param {
    return [[EGViewEvent alloc] initWithRecognizerType:recognizerType phase:phase locationInView:locationInView viewSize:viewSize param:param];
}

- (instancetype)initWithRecognizerType:(EGRecognizerType*)recognizerType phase:(EGEventPhase*)phase locationInView:(GEVec2)locationInView viewSize:(GEVec2)viewSize param:(id)param {
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
    if(self == [EGViewEvent class]) _EGViewEvent_type = [ODClassType classTypeWithCls:[EGViewEvent class]];
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

- (ODClassType*)type {
    return [EGViewEvent type];
}

+ (ODClassType*)type {
    return _EGViewEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"recognizerType=%@", self.recognizerType];
    [description appendFormat:@", phase=%@", self.phase];
    [description appendFormat:@", locationInView=%@", GEVec2Description(self.locationInView)];
    [description appendFormat:@", viewSize=%@", GEVec2Description(self.viewSize)];
    [description appendFormat:@", param=%@", self.param];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCameraEvent
static ODClassType* _EGCameraEvent_type;
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
        _recognizerType = [_event recognizerType];
        _locationInView = [_event locationInView];
        __lazy_segment = [CNLazy lazyWithF:^id() {
            EGCameraEvent* _self = _weakSelf;
            return wrap(GELine3, (({
                GEVec2 loc = [_self locationInViewport];
                GEMat4* mat4 = [[_self->_matrixModel wcp] inverse];
                GEVec4 p0 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, -1.0, 1.0)];
                GEVec4 p1 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, 1.0, 1.0)];
                GELine3Make(geVec4Xyz(p0), (geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0))));
            })));
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCameraEvent class]) _EGCameraEvent_type = [ODClassType classTypeWithCls:[EGCameraEvent class]];
}

- (GELine3)segment {
    return uwrap(GELine3, [__lazy_segment get]);
}

- (EGEventPhase*)phase {
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

- (ODClassType*)type {
    return [EGCameraEvent type];
}

+ (ODClassType*)type {
    return _EGCameraEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"event=%@", self.event];
    [description appendFormat:@", matrixModel=%@", self.matrixModel];
    [description appendFormat:@", viewport=%@", GERectDescription(self.viewport)];
    [description appendString:@">"];
    return description;
}

@end


