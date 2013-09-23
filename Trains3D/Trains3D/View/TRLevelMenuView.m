#import "TRLevelMenuView.h"

#import "TRLevel.h"
#import "EGCamera2D.h"
#import "EGContext.h"
#import "EGProgress.h"
#import "EGSchedule.h"
#import "TRScore.h"
#import "TRRailroad.h"
#import "TRNotification.h"
@implementation TRLevelMenuView{
    TRLevel* _level;
    id<EGCamera> _camera;
    EGFont* _smallFont;
    EGFont* _bigFont;
    GEVec4(^_notificationProgress)(float);
    NSString* _notificationText;
    EGCounter* _notificationAnimation;
}
static ODClassType* _TRLevelMenuView_type;
@synthesize level = _level;
@synthesize camera = _camera;
@synthesize smallFont = _smallFont;
@synthesize bigFont = _bigFont;
@synthesize notificationProgress = _notificationProgress;

+ (id)levelMenuViewWithLevel:(TRLevel*)level {
    return [[TRLevelMenuView alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _camera = [EGCamera2D camera2DWithSize:GEVec2Make(16.0, 1.0)];
        _smallFont = [EGGlobal fontWithName:@"verdana" size:14];
        _bigFont = [EGGlobal fontWithName:@"verdana" size:28];
        _notificationProgress = ^id() {
            float(^__l)(float) = [EGProgress gap2T1:0.7 t2:1.0];
            GEVec4(^__r)(float) = ^GEVec4(float _) {
                return GEVec4Make(1.0, 1.0, 1.0, 1 - _);
            };
            return ^GEVec4(float _) {
                return __r(__l(_));
            };
        }();
        _notificationText = @"";
        _notificationAnimation = [EGCounter apply];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelMenuView_type = [ODClassType classTypeWithCls:[TRLevelMenuView class]];
}

- (EGFont*)font {
    if([EGGlobal.context viewport].size.y > 50) return _bigFont;
    else return _smallFont;
}

- (void)drawView {
    [[self font] drawText:[NSString stringWithFormat:@"%li", [_level.score score]] color:GEVec4Make(1.0, 1.0, 1.0, 1.0) at:GEVec2Make(0.0, 0.0) alignment:egTextAlignmentApplyXY(-1.0, -1.0)];
    NSInteger seconds = ((NSInteger)([_level.schedule time]));
    [[self font] drawText:[NSString stringWithFormat:@"%li", seconds] color:GEVec4Make(1.0, 1.0, 1.0, 1.0) at:GEVec2Make(16.0, 0.0) alignment:egTextAlignmentApplyXY(1.0, -1.0)];
    [_notificationAnimation forF:^void(CGFloat t) {
        [[self font] drawText:_notificationText color:_notificationProgress(((float)(t))) at:GEVec2Make(8.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, -1.0)];
    }];
    if(!([[_level.railroad damagesPoints] isEmpty]) && [[_level repairer] isEmpty]) {
    }
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_notificationAnimation isRun]) {
        [_notificationAnimation updateWithDelta:delta];
    } else {
        if(!([_level.notifications isEmpty])) {
            _notificationText = [[_level.notifications take] get];
            _notificationAnimation = [EGCounter applyLength:1.0];
        }
    }
}

- (EGEnvironment*)environment {
    return EGEnvironment.aDefault;
}

- (ODClassType*)type {
    return [TRLevelMenuView type];
}

+ (ODClassType*)type {
    return _TRLevelMenuView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRLevelMenuView* o = ((TRLevelMenuView*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


