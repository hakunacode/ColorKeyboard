//
//  AppDelegate.m
//  ColorKeyboard
//
//  Created by admin on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "GameUtils.h"
#import "GameUnit.h"

#ifdef ADS_MOBCLIX
#import "Mobclix/Mobclix.h"
#define kMobclixAppID	@"991CBF05-E96D-4211-8FB5-631D5BA013C3"
#endif

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [m_navigationCtrl release];
    [g_GameUtils release];
    [g_GameUnit release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    g_GameUtils = [[GameUtils alloc] init];
    g_GameUnit = [[GameUnit alloc] init];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController_iPad" bundle:nil] autorelease];
    }
    m_navigationCtrl = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = m_navigationCtrl; // SKY:121030
//    self.window.rootViewController = self.mainViewController;
//    [self.window addSubview:m_navigationCtrl.view];
    [self.window makeKeyAndVisible];

#ifdef ADS_MOBCLIX
	// Add this line to start up Mobclix
	[Mobclix startWithApplicationId:kMobclixAppID];

    [self.mainViewController addAdsView];
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[self.mainViewController updateAdsView];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end