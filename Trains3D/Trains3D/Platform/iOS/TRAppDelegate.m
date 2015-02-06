//
//  TRAppDelegate.m
//  Trains3Di
//
//  Created by Anton Zherdev on 07.10.13.
//  Copyright (c) 2013 Anton Zherdev. All rights reserved.
//

#import "TRAppDelegate.h"
#import "TRGameDirector.h"
#import "TestFlight.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "PGInApp.h"
#import "PGInAppPlat.h"
#import "PGShare.h"
#import "CNObserver.h"
#import <mach/mach.h>

@implementation TRAppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit]];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [TestFlight passCheckpoint:@"Resign Active"];
    [[TRGameDirector instance] synchronize];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[TRGameDirector instance] synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
            TASK_BASIC_INFO,
            (task_info_t)&info,
            &size);
    NSString *mem;
    if( kerr == KERN_SUCCESS ) {
        mem = [NSString stringWithFormat:@"MemoryWarning: Memory in use (in bytes): %u", info.resident_size];
    } else {
        mem = [NSString stringWithFormat:@"MemoryWarning: Error with task_info(): %s", mach_error_string(kerr)];
    }
    [TestFlight passCheckpoint:mem];
}

@end
