#import "EGMap.h"
#import "EGCamera.h"

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
    EGMapRect limits = egMapSsoLimits(size);

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
                if(egMapSsoIsFullTile(size, x, y)) {
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

    egMapDrawAxis();
}

EGMapRect egMapSsoLimits(EGMapSize size) {
    return EGMapRectMake(
            (1 - size.height)/2,
            (1 - size.width)/2, 
            (2*size.width + size.height - 3)/2,
            (size.width + 2*size.height - 3)/2);
}


