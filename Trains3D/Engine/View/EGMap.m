#import "EGMap.h"

NSArray *egMapSsoPickTiles(EGMapSize size, BOOL (^predicate)(id));

void egMapDrawLayout(EGMapSize size) {
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

    egMapDrawAxis();
}

void egMapDrawAxis() {
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

void egMapSsoDrawLayout(EGMapSize size) {
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
        for(id tile in egMapSsoFullTiles(size)) {
            EGMapPoint p = uval(EGMapPoint, tile);
            glVertex3d(p.x - 0.5, p.y - 0.5, 0.0);
            glVertex3d(p.x + 0.5, p.y - 0.5, 0.0);

            glVertex3d(p.x + 0.5, p.y - 0.5, 0.0);
            glVertex3d(p.x + 0.5, p.y + 0.5, 0.0);

            glVertex3d(p.x + 0.5, p.y + 0.5, 0.0);
            glVertex3d(p.x - 0.5, p.y + 0.5, 0.0);

            glVertex3d(p.x - 0.5, p.y + 0.5, 0.0);
            glVertex3d(p.x - 0.5, p.y - 0.5, 0.0);
        }
    }
    glEnd();

    egMapDrawAxis();
}

void egMapSsoDrawPlane(EGMapSize size) {
    glBegin(GL_QUADS);
    {
        EGMapRect limits = egMapSsoLimits(size);
        float l = limits.left - 1.5;
        float r = limits.right + 1.5;
        float t = limits.top - 1.5;
        float b = limits.bottom + 1.5;
        NSInteger w = limits.right - limits.left + 3;
        NSInteger h = limits.bottom - limits.top + 3;
        glTexCoord2f(0.0, 0.0); glVertex3f(l, b, 0);
        glTexCoord2f(w, 0.0); glVertex3f(r, b, 0);
        glTexCoord2f(w, h); glVertex3f(r, t, 0);
        glTexCoord2f(0.0, h); glVertex3f(l, t, 0);
    }
    glEnd();
    glPopMatrix();
}

EGMapRect egMapSsoLimits(EGMapSize size) {
    return EGMapRectMake(
            (1 - size.height)/2 - 1,
            (1 - size.width)/2 - 1,
            (2*size.width + size.height - 3)/2 + 1,
            (size.width + 2*size.height - 3)/2 + 1);
}

extern NSArray * egMapSsoFullTiles(EGMapSize size) {
    return egMapSsoPickTiles(size, ^BOOL(id t) {
        return egMapSsoIsFullTile(size, [[t a] intValue], [[t b] intValue]);
    });
}

extern NSArray * egMapSsoPartialTiles(EGMapSize size) {
    return egMapSsoPickTiles(size, ^BOOL(id t) {
        return egMapSsoIsPartialTile(size, [[t a] intValue], [[t b] intValue]);
    });
}

NSArray *egMapSsoPickTiles(EGMapSize size, BOOL (^predicate)(id)) {
    EGMapRect limits = egMapSsoLimits(size);
    return [[[[[CNChain chainWithStart:limits.left end:limits.right step:1]
            mul:[CNChain chainWithStart:limits.top end:limits.bottom step:1]]
            filter:predicate]
            map:^id(id t) {
                return val(EGMapPointMake([[t a] intValue], [[t b] intValue]));
            }]
            array];
}


