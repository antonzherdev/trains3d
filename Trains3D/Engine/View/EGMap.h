#import "objd.h"
#import "EGTypes.h"

static const double ISO = 0.70710676908493;

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


extern void egMapDrawLayout(EGMapSize size);
extern void egMapDrawAxis();

extern void egMapSsoDrawLayout(EGMapSize size);
extern void egMapSsoDrawPlane(EGMapSize size);
inline static BOOL egMapSsoIsFullTile(EGMapSize size, int x, int y) {
    return y + x >= 0 //left
            && y - x <= size.height - 1 //top
            && y + x <= size.width + size.height - 2 //right
            && y - x >= -size.width + 1; //bottom
}
inline static BOOL egMapSsoIsPartialTile(EGMapSize size, int x, int y) {
    return y + x >= -1 //left
            && y - x <= size.height //top
            && y + x <= size.width + size.height - 1 //right
            && y - x >= -size.width && (
                y + x == -1 //left
                || y - x == size.height //top
                || y + x == size.width + size.height - 1 //right
                || y - x == -size.width //bottom
            );
}

extern EGMapRect egMapSsoLimits(EGMapSize size);
extern NSArray * egMapSsoFullTiles(EGMapSize size);
extern NSArray * egMapSsoPartialTiles(EGMapSize size);

/*
 * Возвращает как плитка обрезана.
 * Если left - 0 - значит не обрезано, 1 - обрезано слева, 2 - не видно
 * Остальные значения прямоугольника по такому же принципу
 */
extern EGMapRect egMapSsoTileCut(EGMapSize size, EGMapPoint point);