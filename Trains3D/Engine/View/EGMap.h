#import <Foundation/Foundation.h>
#import "EGTypes.h"

struct EGTilePoint {
    NSInteger x;
    NSInteger y;
};
typedef struct EGTilePoint EGTilePoint;
static inline EGTilePoint EGTilePointMake(NSInteger x, NSInteger y) {
    EGTilePoint ret;
    ret.x = x;
    ret.y = y;
    return ret;
}

struct EGMapSize {
    NSInteger width;
    NSInteger height;
};
typedef struct EGMapSize EGMapSize;
static inline EGMapSize EGMapSizeMake(NSInteger width, NSInteger height) {
    EGMapSize ret;
    ret.width = width;
    ret.height = height;
    return ret;
}

@interface EGMap : NSObject
+ (id)map;
- (id)init;
+ (void)drawLayoutWithSize:(EGMapSize)size;
@end


