//
//  SVAppDelegate.m
//  FontSelector
//
//  Created by Lee on 13-4-13.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "SVAppDelegate.h"
#import "SVCatagoryViewController.h"
#import "SVNavigationBar.h"
#import <ShareSDK/ShareSDK.h>

#define WB_APP_KEY @"3102131404"
#define WB_APP_SEC @"ea21a094561dc1cf9210c914a3ce0e90"
#define WB_URI @"http://baidu.com"
@implementation SVAppDelegate
//test commit
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString * currentText = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTextKey];
    if (!currentText) {
        [[NSUserDefaults standardUserDefaults] setObject:kDefaultText forKey:kCurrentTextKey];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    SVCatagoryViewController * root = [[SVCatagoryViewController alloc] init];
//    UIViewController * root = [[UIViewController alloc] init];
//    SVCataViewController * root = [[SVCataViewController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:root];
    SVNavigationBar * navBar = [[SVNavigationBar alloc] init];
    [nc setValue:navBar forKeyPath:@"navigationBar"];
    [self.window setRootViewController:nc];
    [self.window makeKeyAndVisible];
    
    NSLog(@"Fonts: %@", [UIFont familyNames]);
    [ShareSDK registerApp:@"42f4507b4b8"];
    [ShareSDK ssoEnabled:NO];
    [ShareSDK connectSinaWeiboWithAppKey:WB_APP_KEY appSecret:WB_APP_SEC redirectUri:WB_URI];
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

@end
