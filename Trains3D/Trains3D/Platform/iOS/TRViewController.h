//
//  TRViewController.h
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "PGOpenGLViewControllerIOS.h"

@interface TRViewController : PGOpenGLViewControllerIOS
@property (weak, nonatomic) IBOutlet UIView *startScreenView;

@end
