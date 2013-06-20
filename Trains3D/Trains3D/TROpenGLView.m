//
//  TROpenGLView.m
//  Trains3D
//
//  Created by Anton Zherdev on 20.06.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TROpenGLView.h"
#import <OpenGL/glu.h>
#import <GLUT/glut.h>

@implementation TROpenGLView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    /* use this length so that camera is 1 unit away from origin */
    double dist = sqrt(1 / 3.0);
    
    gluLookAt(dist, dist, dist,  /* position of camera */
              0.0,  0.0,  0.0,   /* where camera is pointing at */
              0.0,  1.0,  0.0);  /* which direction is up */
    glMatrixMode(GL_MODELVIEW);
    
    glPushMatrix();
    glTranslated(0.5, 0.5, 0.5);
    glColor3d(0.5, 0.5, 0.5);
    glutWireCube(1);
    glPopMatrix();
    
    glBegin(GL_LINES);
    
    glColor3d(1.0, 0.0, 0.0);
    glVertex3d(0.0, 0.0, 0.0);
    glVertex3d(1.0, 0.0, 0.0);
    
    glColor3d(0.0, 1.0, 0.0);
    glVertex3d(0.0, 0.0, 0.0);
    glVertex3d(0.0, 1.0, 0.0);
    
    glColor3d(0.0, 0.0, 1.0);
    glVertex3d(0.0, 0.0, 0.0);
    glVertex3d(0.0, 0.0, 1.0);
    
    glEnd();
    
    glFlush();
}

@end
