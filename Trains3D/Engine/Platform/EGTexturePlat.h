#import "GEVec.h"

@class EGTextureFilter;
@class EGTextureFormat;
@class EGTextureFileFormat;

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file, EGTextureFileFormat* fileFormat, CGFloat scale, EGTextureFormat* format, EGTextureFilter* filter);
void egLoadTextureFromData(GLuint target, EGTextureFilter* filter, GEVec2 size, void *myData);
void egSaveTextureToFile(GLuint source, NSString* file);
void egInitShadowTexture(GEVec2i size);