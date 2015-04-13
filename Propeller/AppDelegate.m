//
//  AppDelegate.m
//  Propeller
//
//  Created by Michel Balamou on 18/03/2015.
//  Copyright (c) 2015 Michel Balamou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Override point for customization after application launch.
   
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
          {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
    
            int h=floor(result.height);
            NSString* story_board=(h==960)?@"Main_iPhone4":@"Main";
            
            
            if (story_board!=nil)
            {
                self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:story_board bundle:nil];
                UIViewController *initViewController = [storyBoard instantiateInitialViewController];
                [self.window setRootViewController:initViewController];
                [self.window makeKeyAndVisible];
            }
        }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme: %@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        NSArray* urlParameters = [[url query] componentsSeparatedByString:@"&"];
    
        
        NSArray* param=[urlParameters[0] componentsSeparatedByString:@"="];
        NSArray* param2=[urlParameters[1] componentsSeparatedByString:@"="];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if ([param[0] isEqualToString:@"tKn"]) //token
        {
            [prefs setObject:param[1] forKey:@"Reset_token"];
        }
        
        if ([param2[0] isEqualToString:@"DN"]) //identifier
        {
            NSArray* param3=[param2[1] componentsSeparatedByString:@"."];
            
            [prefs setObject:param3[1] forKey:@"identifier"];
        }
        
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        int h=floor(result.height);
        NSString* story_board=(h==960)?@"Main_iPhone4":@"Main";
        
        
        //story_board=@"Main_iPhone4";
        
        if (story_board!=nil)
        {
            self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:story_board bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
}

@end
