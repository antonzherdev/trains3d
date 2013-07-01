#import "EGDirector.h"

static inline EGDirector * egDirector() {
    return [EGDirector current];
}

static inline EGContext * egContext() {
    return egDirector().context;
}

static inline EGTexture * egTexture(NSString * file) {
    return [egContext() textureForFile:file];
}