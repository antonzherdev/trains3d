#import "objd.h"
#import "GEVec.h"
#import "EGContext.h"
#import "EGMaterial.h"
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGMesh;
@class EGSimpleVertexArray;
@class EGVertexBufferDesc;
@class GEMat4;
@class EGVertexArray;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniformMat4;
@class EGShaderUniformVec4;
@class EGShaderUniformVec3;
@class EGShaderUniformVec2;
@class EGShaderUniformF4;
@class EGShaderUniformI4;
@class EGShaderSystem;
@class EGShaderTextBuilder_impl;
@protocol EGShaderTextBuilder;

@interface EGShaderProgram : NSObject {
@protected
    NSString* _name;
    unsigned int _handle;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderProgramWithName:(NSString*)name handle:(unsigned int)handle;
- (instancetype)initWithName:(NSString*)name handle:(unsigned int)handle;
- (CNClassType*)type;
+ (EGShaderProgram*)loadFromFilesName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)applyName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromShadersName:(NSString*)name vertex:(unsigned int)vertex fragment:(unsigned int)fragment;
+ (unsigned int)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source;
- (void)_init;
- (void)dealloc;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (NSString*)description;
+ (NSInteger)version;
+ (CNClassType*)type;
@end


@interface EGShader : NSObject {
@protected
    EGShaderProgram* _program;
}
@property (nonatomic, readonly) EGShaderProgram* program;

+ (instancetype)shaderWithProgram:(EGShaderProgram*)program;
- (instancetype)initWithProgram:(EGShaderProgram*)program;
- (CNClassType*)type;
- (void)drawParam:(id)param vertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao;
- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao start:(NSUInteger)start end:(NSUInteger)end;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
- (EGShaderUniformMat4*)uniformMat4Name:(NSString*)name;
- (EGShaderUniformVec4*)uniformVec4Name:(NSString*)name;
- (EGShaderUniformVec3*)uniformVec3Name:(NSString*)name;
- (EGShaderUniformVec2*)uniformVec2Name:(NSString*)name;
- (EGShaderUniformF4*)uniformF4Name:(NSString*)name;
- (EGShaderUniformI4*)uniformI4Name:(NSString*)name;
- (EGShaderUniformMat4*)uniformMat4OptName:(NSString*)name;
- (EGShaderUniformVec4*)uniformVec4OptName:(NSString*)name;
- (EGShaderUniformVec3*)uniformVec3OptName:(NSString*)name;
- (EGShaderUniformVec2*)uniformVec2OptName:(NSString*)name;
- (EGShaderUniformF4*)uniformF4OptName:(NSString*)name;
- (EGShaderUniformI4*)uniformI4OptName:(NSString*)name;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGSimpleVertexArray*)vaoVbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderAttribute : NSObject {
@protected
    unsigned int _handle;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderAttributeWithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformMat4 : NSObject {
@protected
    unsigned int _handle;
    GEMat4* __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformMat4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyMatrix:(GEMat4*)matrix;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformVec4 : NSObject {
@protected
    unsigned int _handle;
    GEVec4 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec4:(GEVec4)vec4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformVec3 : NSObject {
@protected
    unsigned int _handle;
    GEVec3 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec3WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec3:(GEVec3)vec3;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformVec2 : NSObject {
@protected
    unsigned int _handle;
    GEVec2 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec2WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyVec2:(GEVec2)vec2;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformF4 : NSObject {
@protected
    unsigned int _handle;
    float __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformF4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyF4:(float)f4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderUniformI4 : NSObject {
@protected
    unsigned int _handle;
    int __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformI4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (CNClassType*)type;
- (void)applyI4:(int)i4;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShaderSystem : NSObject
+ (instancetype)shaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (void)drawParam:(id)param vertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (EGShader*)shaderForParam:(id)param;
- (EGShader*)shaderForParam:(id)param renderTarget:(EGRenderTarget*)renderTarget;
- (EGVertexArray*)vaoParam:(id)param vbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo;
- (NSString*)description;
+ (CNClassType*)type;
@end


@protocol EGShaderTextBuilder<NSObject>
- (NSString*)versionString;
- (NSString*)vertexHeader;
- (NSString*)fragmentHeader;
- (NSString*)fragColorDeclaration;
- (BOOL)isFragColorDeclared;
- (NSInteger)version;
- (NSString*)ain;
- (NSString*)in;
- (NSString*)out;
- (NSString*)fragColor;
- (NSString*)texture2D;
- (NSString*)shadowExt;
- (NSString*)sampler2DShadow;
- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3;
- (NSString*)blendMode:(EGBlendModeR)mode a:(NSString*)a b:(NSString*)b;
- (NSString*)shadow2DEXT;
- (NSString*)description;
@end


@interface EGShaderTextBuilder_impl : NSObject<EGShaderTextBuilder>
+ (instancetype)shaderTextBuilder_impl;
- (instancetype)init;
@end


