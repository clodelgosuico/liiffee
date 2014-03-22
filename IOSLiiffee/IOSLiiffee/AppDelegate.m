//
//  AppDelegate.m
//  IOSLiiffee
//
//  Created by Agathe Battestini on 3/22/14.
//  Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupFoursquare];
    [self setupInstagram];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 3rd Party apps

- (void)setupFoursquare
{
    [Foursquare2 setupFoursquareWithClientId:@"HKYQG3UVFUV51A0STFEXL3ANNALDIVCZOYJVK14AFYA5IFQ1"
                                      secret:@"REK5RKPZG3JAOIWC0Q1KXKG1YRJ0AXPN2QMURADJLUGFPHOS"
                                 callbackURL:@"liiffee://foursquare"];

    NSLog(@"access token? %@",[Foursquare2 accessToken]);
//    [Foursquare2 venueSearchNearByLatitude:@ longitude:<#(NSNumber *)longitude#> query:<#(NSString *)query#> limit:<#(NSNumber *)limit#> intent:<#(FoursquareIntentType)intent#> radius:<#(NSNumber *)radius#> categoryId:<#(NSString *)categoryId#> callback:<#(Foursquare2Callback)callback#>]
}

- (void)setupInstagram
{
    InstagramEngine *sharedEngine = [InstagramEngine sharedEngine];

    // testing
//    [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media) {
//        NSLog(@"%@", media);
//    } failure:^(NSError *error) {
//        NSLog(@"Load Popular Media Failed");
//    }];
}

#pragma mark - Handle incoming URLs


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Foursquare2 handleURL:url];
}

@end
