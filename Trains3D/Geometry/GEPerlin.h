#import "GEVec.h"

#ifndef PERLIN_H_
#define PERLIN_H_



#define SAMPLE_SIZE 1024

@interface GEPerlin1 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin1WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (GEPerlin1*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyX:(CGFloat)x;
@end

@interface GEPerlin2 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin2WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (GEPerlin2*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyVec2:(GEVec2)vec2;
@end

@interface GEPerlin3 : NSObject
@property(nonatomic, readonly) NSUInteger octaves;
@property(nonatomic, readonly) CGFloat frequency;
@property(nonatomic, readonly) CGFloat amplitude;
@property(nonatomic, readonly) unsigned int seed;

- (id)initWithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (id)perlin3WithOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude seed:(unsigned int)seed;
+ (GEPerlin3*)applyOctaves:(NSUInteger)octaves frequency:(CGFloat)frequency amplitude:(CGFloat)amplitude;
- (CGFloat) applyVec3:(GEVec3)vec3;
@end


#endif

