#import "objd.h"
#import "EGSound.h"
#import "GEVec.h"
@class TRLevel;
@class SDSound;
@class TRTrain;
@class TRRailPoint;

@class TRTrainSound;
@class TRTrainSoundData;

@interface TRTrainSound : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<CNSeq> choos;

+ (id)trainSoundWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)playChoo;
+ (ODClassType*)type;
@end


@interface TRTrainSoundData : NSObject
@property (nonatomic) NSInteger chooCounter;
@property (nonatomic) CGFloat toNextChoo;
@property (nonatomic) GEVec2i lastTile;
@property (nonatomic) CGFloat lastX;

+ (id)trainSoundData;
- (id)init;
- (ODClassType*)type;
- (void)nextChoo;
- (void)nextHead:(TRRailPoint*)head;
+ (ODClassType*)type;
@end


