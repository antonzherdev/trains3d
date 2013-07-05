#import "objd.h"
#import "EGTypes.h"

static const double ISO = 0.70710676908493;

extern void egMapSsoDrawLayout(EGISize size);
extern void egMapSsoDrawPlane(EGISize size);
inline static BOOL egMapSsoIsFullTile(EGISize size, NSInteger x, NSInteger y) {
    return y + x >= 0 //left
            && y - x <= size.height - 1 //top
            && y + x <= size.width + size.height - 2 //right
            && y - x >= -size.width + 1; //bottom
}
inline static BOOL egMapSsoIsPartialTile(EGISize size, NSInteger x, NSInteger y) {
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

extern EGIRect egMapSsoLimits(EGISize size);
extern NSArray * egMapSsoFullTiles(EGISize size);
extern NSArray * egMapSsoPartialTiles(EGISize size);

/*
 * Возвращает как плитка обрезана.
 * Если left - 0 - значит не обрезано, 1 - обрезано слева, 2 - не видно
 * Остальные значения прямоугольника по такому же принципу
 */
extern EGIRect egMapSsoTileCut(EGISize size, EGIPoint point);