#import "EGMap.h"
#import "EGCamera.h"

@implementation EGMap

+ (id)map {
    return [[EGMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)drawLayoutWithSize:(EGMapSize)size {
    glBegin(GL_LINES);
    {
        for(int x = -1; x < size.width; x++) {
            glVertex3d(0.5 + x, -0.5, 0.0);
            glVertex3d(0.5 + x, -0.5 + size.height, 0.0);
        }
        for(int y = -1; y < size.height; y++) {
            glVertex3d(-0.5, 0.5 + y, 0.0);
            glVertex3d(-0.5 + size.width, 0.5 + y, 0.0);
        }
    }
    glEnd();

    [self drawAxis];
}

+ (void)drawAxis {
    glBegin(GL_LINES);
    {
        glColor3f(1, 0, 0);
        glVertex3d(0, 0, 0.0);
        glVertex3d(0.25, 0, 0.0);

        glColor3f(0, 1, 0);
        glVertex3d(0, 0, 0.0);
        glVertex3d(0, 0.25, 0.0);

        glColor3f(0, 0, 1);
        glVertex3d(0, 0, 0.0);
        glVertex3d(0, 0, 0.25);
    }
    glEnd();
}
@end


@implementation EGSquareIsoMap

+ (id)squareIsoMap {
    return [[EGSquareIsoMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)drawLayoutWithSize:(EGMapSize)size {
    EGMapRect limits = [self limitsForSize:size];

    glPushMatrix();
    glRotatef(45, 0, 0, 1);
    glBegin(GL_LINES);
    {
        double const left = -ISO;
        double const top = size.height*ISO;
        double const bottom = -size.width*ISO;
        double const right = (size.width + size.height - 1)*ISO;
        glVertex3d(left, top, 0.0);
        glVertex3d(left, bottom, 0.0);

        glVertex3d(left, bottom, 0.0);
        glVertex3d(right, bottom, 0.0);

        glVertex3d(right, bottom, 0.0);
        glVertex3d(right, top, 0.0);

        glVertex3d(right, top, 0.0);
        glVertex3d(left, top, 0.0);
    }
    glEnd();
    glPopMatrix();

    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_LINES);
    {
        for(int x = limits.left; x <= limits.right; x++) {
            for(int y = limits.top; y <= limits.bottom; y++) {
                if([self isFullTile:EGMapPointMake(x, y) size:size]) {
                    glVertex3d(x - 0.5, y - 0.5, 0.0);
                    glVertex3d(x + 0.5, y - 0.5, 0.0);

                    glVertex3d(x + 0.5, y - 0.5, 0.0);
                    glVertex3d(x + 0.5, y + 0.5, 0.0);

                    glVertex3d(x + 0.5, y + 0.5, 0.0);
                    glVertex3d(x - 0.5, y + 0.5, 0.0);

                    glVertex3d(x - 0.5, y + 0.5, 0.0);
                    glVertex3d(x - 0.5, y - 0.5, 0.0);
                }
            }
        }
    }
    glEnd();

    [EGMap drawAxis];
}

+ (BOOL)isFullTile:(EGMapPoint)tile size:(EGMapSize)size {
    return tile.y + tile.x >= 0 //left
            && tile.y - tile.x <= size.height - 1 //top
            && tile.y + tile.x <= size.width + size.height - 2 //right
            && tile.y - tile.x >= -size.width + 1; //bottom
}

+ (EGMapRect)limitsForSize:(EGMapSize)size {
    return EGMapRectMake(
            (1 - size.height)/2,
            (1 - size.width)/2, 
            (2*size.width + size.height - 3)/2,
            (size.width + 2*size.height - 3)/2);
}


@end


