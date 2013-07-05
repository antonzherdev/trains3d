#import "EGMap.h"

void egMapDrawLayout(EGISize size) {
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
