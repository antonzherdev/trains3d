#import <Foundation/Foundation.h>
#import "EGTypes.h"

struct EGMapPoint {
    NSInteger x;
    NSInteger y;
};
typedef struct EGMapPoint EGMapPoint;
static inline EGMapPoint EGMapPointMake(NSInteger x, NSInteger y) {
    EGMapPoint ret;
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

struct EGMapRect {
    NSInteger left;
    NSInteger top;
    NSInteger right;
    NSInteger bottom;
};
typedef struct EGMapRect EGMapRect;
static inline EGMapRect EGMapRectMake(NSInteger left, NSInteger top, NSInteger right, NSInteger bottom) {
    EGMapRect ret;
    ret.left = left;
    ret.top = top;
    ret.right = right;
    ret.bottom = bottom;
    return ret;
}

@interface EGMap : NSObject
+ (id)map;
- (id)init;
+ (void)drawLayoutWithSize:(EGMapSize)size;
+ (void)drawAxis;
@end


@interface EGSquareIsoMap : NSObject
+ (id)squareIsoMap;
- (id)init;
+ (void)drawLayoutWithSize:(EGMapSize)size;
+ (BOOL)isFullTile:(EGMapPoint)tile size:(EGMapSize)size;
+ (EGMapRect)limitsForSize:(EGMapSize)size;
@end


