//
//  SEAppDelegate.m
//
// Copyright (c) 2013 Sergio Estevao (http://sergioestevao.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AppDelegate.h"

#import "SEMasterViewController.h"
#import "SETextEditViewController.h"
#import "SEDetailViewController.h"
#import "SEFontManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self rootViewController];
    [self.window makeKeyAndVisible];
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
    [SEFontManager sharedFontManager];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIViewController*)rootViewController
{    
	UITabBarController * tabController = [[UITabBarController alloc] init];
    UINavigationController *navigationController;
    UISplitViewController *splitViewController;
    NSArray * viewControllers = nil;
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        SEMasterViewController *masterViewController = [[SEMasterViewController alloc] init];
        navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Metrics" image:nil tag:0];
        
        UINavigationController * textEditViewController = [[UINavigationController alloc] initWithRootViewController:[[SETextEditViewController alloc] init]];
        textEditViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Picker" image:nil tag:1];
        
        viewControllers = @[navigationController, textEditViewController];
    } else {
        SEMasterViewController *masterViewController = [[SEMasterViewController alloc] init];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        SEDetailViewController *detailViewController = [[SEDetailViewController alloc] init];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
    	masterViewController.detailViewController = detailViewController;
    	
        splitViewController = [[UISplitViewController alloc] init];
        splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        splitViewController.delegate = detailViewController;
        splitViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Metrics" image:nil tag:0];
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:[[SETextEditViewController alloc] init]];
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Picker" image:nil tag:1];
        
        viewControllers = @[splitViewController, navigationController];
    }
    tabController.viewControllers = viewControllers;
    return tabController;
}

@end
