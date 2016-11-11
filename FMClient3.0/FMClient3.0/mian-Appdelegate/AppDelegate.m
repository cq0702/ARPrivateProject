//
//  AppDelegate.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/1.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MYMaintabcontroller.h"
#import "FMAddInfoController.h"
#import "MYUtils.h"
#import "FMLocationManager.h"
#define BAIDUKEY @"uGIwfMfh0s5bEB1dqLGW5GtAji7QGa4D"
@interface AppDelegate ()

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //设置Window主界面
    [self configRootViewController];
    
    [self initAppMap];
    //开始定位
    [[FMLocationManager sharedManager]startLocationService];
    
    
    return YES;
    
}
#pragma mark -----  显示主界面  --------
-(void)configRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //显示主界面
    MYMaintabcontroller * tabController = [[MYMaintabcontroller alloc] init];
    
//    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
//    if(![MYUtils isEmpty:isShow])
//    {
//        FMAddInfoController * addCtrl = [[FMAddInfoController alloc]init];
//       self.window.rootViewController = addCtrl;
    
//    }else{
//        
//        //设置windows根视
        self.window.rootViewController = tabController;
//    }
    

    self.window.backgroundColor    = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}
- (void)initAppMap
{
    
    self.mapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [self.mapManager start:BAIDUKEY  generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // 监听设备激活状态
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceDidBecomeActive object:nil];
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
