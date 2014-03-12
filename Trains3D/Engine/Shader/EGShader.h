#import "objd.h"
#import "GEVec.h"
@class EGGlobal;
@class EGContext;
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGMesh;
@class EGSimpleVertexArray;
@class EGVertexBufferDesc;
@class GEMat4;
@class EGRenderTarget;
@class EGVertexArray;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;

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
@protocol EGShaderTextBuilder;

@interface EGShaderProgram : NSObject {
@private
    NSString* _name;
    unsigned int _handle;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderProgramWithName:(NSString*)name handle:(unsigned int)handle;
- (instancetype)initWithName:(NSString*)name handle:(unsigned int)handle;
- (ODClassType*)type;
+ (EGShaderProgram*)loadFromFilesName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)applyName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromShadersName:(NSString*)name vertex:(unsigned int)vertex fragment:(unsigned int)fragment;
+ (unsigned int)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source;
- (void)_init;
- (void)dealloc;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
+ (NSInteger)version;
+ (ODClassType*)type;
@end


@interface EGShader : NSObject {
@private
    EGShaderProgram* _program;
}
@property (nonatomic, readonly) EGShaderProgram* program;

+ (instancetype)shaderWithProgram:(EGShaderProgram*)program;
- (instancetype)initWithProgram:(EGShaderProgram*)program;
- (ODClassType*)type;
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
- (id)uniformMat4OptName:(NSString*)name;
- (id)uniformVec4OptName:(NSString*)name;
- (id)uniformVec3OptName:(NSString*)name;
- (id)uniformVec2OptName:(NSString*)name;
- (id)uniformF4OptName:(NSString*)name;
- (id)uniformI4OptName:(NSString*)name;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGSimpleVertexArray*)vaoVbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo;
+ (ODClassType*)type;
@end


@interface EGShaderAttribute : NSObject {
@private
    unsigned int _handle;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderAttributeWithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift;
+ (ODClassType*)type;
@end


@interface EGShaderUniformMat4 : NSObject {
@private
    unsigned int _handle;
    GEMat4* __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformMat4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyMatrix:(GEMat4*)matrix;
+ (ODClassType*)type;
@end


@interface EGShaderUniformVec4 : NSObject {
@private
    unsigned int _handle;
    GEVec4 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyVec4:(GEVec4)vec4;
+ (ODClassType*)type;
@end


@interface EGShaderUniformVec3 : NSObject {
@private
    unsigned int _handle;
    GEVec3 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec3WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyVec3:(GEVec3)vec3;
+ (ODClassType*)type;
@end


@interface EGShaderUniformVec2 : NSObject {
@private
    unsigned int _handle;
    GEVec2 __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformVec2WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyVec2:(GEVec2)vec2;
+ (ODClassType*)type;
@end


@interface EGShaderUniformF4 : NSObject {
@private
    unsigned int _handle;
    float __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformF4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyF4:(float)f4;
+ (ODClassType*)type;
@end


@interface EGShaderUniformI4 : NSObject {
@private
    unsigned int _handle;
    int __last;
}
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)shaderUniformI4WithHandle:(unsigned int)handle;
- (instancetype)initWithHandle:(unsigned int)handle;
- (ODClassType*)type;
- (void)applyI4:(int)i4;
+ (ODClassType*)type;
@end


@interface EGShaderSystem : NSObject
+ (instancetype)shaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (void)drawParam:(id)param vertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (EGShader*)shaderForParam:(id)param;
- (EGShader*)shaderForParam:(id)param renderTarget:(EGRenderTarget*)renderTarget;
- (EGVertexArray*)vaoParam:(id)param vbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo;
+ (ODClassType*)type;
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
- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b;
- (NSString*)shadow2DEXT;
@end


