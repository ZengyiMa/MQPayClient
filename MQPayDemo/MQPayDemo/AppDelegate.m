//
//  AppDelegate.m
//  MQPayDemo
//
//  Created by WsdlDev on 15/10/8.
//  Copyright © 2015年 mazengyi. All rights reserved.
//

#import "AppDelegate.h"
#import "MQPayClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[MQPayClient shareInstance]registerClient:MQPayClientTypeWeixin|MQPayClientTypeAlipay];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [MQPayClient handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [MQPayClient handleOpenURL:url sourceApplication:sourceApplication];
    return  YES;
}



@end
