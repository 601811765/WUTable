//
//  AppDelegate.m
//  WUTable
//
//  Created by 武探 on 2017/3/9.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "AppDelegate.h"
#import "TableExampleViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TableExampleViewController *exampleController = [[TableExampleViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:exampleController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
