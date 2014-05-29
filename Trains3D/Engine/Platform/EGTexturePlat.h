#import "GEVec.h"
#import "EGTexture.h"

@class EGTextureFilter;
@class EGTextureFormat;
@class EGTextureFileFormat;

GEVec2 egLoadTextureFromFile(GLuint target, NSString* file, EGTextureFileFormatR fileFormat, CGFloat scale, EGTextureFormatR format, EGTextureFilterR filter);
void egLoadTextureFromData(GLuint target, EGTextureFormatR format, EGTextureFilterR filter, GEVec2 size, void *data);
void egSaveTextureToFile(GLuint source, NSString* file);
void egInitShadowTexture(GEVec2i size);