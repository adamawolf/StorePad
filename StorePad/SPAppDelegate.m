//
//  SPAppDelegate.m
//  StorePad
//
//  Created by Adam Wolf on 12/15/13.
//  Copyright (c) 2013 Adam A. Wolf. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPCoreDataController.h"
#import "TestFlight.h"


@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef CONTENTGEN
    [[SPCoreDataController sharedController] generateContent];
#else
    [TestFlight takeOff:@"59dadeb3-8374-4ed7-8dd6-1e69dcc5080a"];
    
    [self deleteContentDatabaseIfAppropriate];
    [[SPCoreDataController sharedController] createEditableCopyOfContentDatabaseIfNeeded];
    
    [self customizeAppearance];
#endif
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Helper methods

- (void) customizeAppearance
{
    [[[[UIApplication sharedApplication] delegate] window] setTintColor:[Definitions tintColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName : [UIFont fontWithName:@"AcademyEngravedLetPlain" size:23.0f],
                                                           NSForegroundColorAttributeName : [Definitions navigationBarTitleColor],
                                                           }];
    
    [[UINavigationBar appearance] setBarTintColor:[Definitions navigationBarBackgroundColor]];
}

- (void) deleteContentDatabaseIfAppropriate
{
    BOOL shouldOverwrite = NO;
    
    NSString * lastLaunchVersion = [[NSUserDefaults standardUserDefaults] stringForKey:SPUserDefaults_LastLaunchVersion];
	NSString * appVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (!lastLaunchVersion)
    {
        shouldOverwrite = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:SPUserDefaults_LastLaunchVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([lastLaunchVersion isEqualToString:appVersionString] == NO)
    {
        shouldOverwrite = YES;
    }
    
    if (shouldOverwrite)
    {
        DLog(@"Moving from version %@ to %@. Deleting content database.", lastLaunchVersion, appVersionString);
        
        [[SPCoreDataController sharedController] deleteEditableCopyOfContentDatabase];
    }
}

@end
