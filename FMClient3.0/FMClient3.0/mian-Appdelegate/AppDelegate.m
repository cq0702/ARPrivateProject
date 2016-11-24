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
#import "LoginViewController.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define UMENGKEY @"58339bef1c5dd01208000496"
#define BAIDUKEY @"HQ6XUijIs4wlsn5usftDGzisAc0CagY6"
#define JPUSHKEY @"0afde7804ad9163a1df4ae23"
#define JPUSHMasterKey @"c2c52dba6bcbe3e128cf22db"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange)
                                                 name:@"KNOTIFICATION_LOGINCHANGE"
                                               object:nil];
    //设置Window主界面
    [self configRootViewController];
    
    [self initAppMap];
    //开始定位
    [[FMLocationManager sharedManager]startLocationService];
    
    
    return YES;
    
}
-(void)loginStateChange{
    MYMaintabcontroller * tabController = [[MYMaintabcontroller alloc] init];
    
    //    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
    //    if(![MYUtils isEmpty:isShow])
    //    {
    //        FMAddInfoController * addCtrl = [[FMAddInfoController alloc]init];
    //       self.window.rootViewController = addCtrl;
    
    //    }else{
    //        //设置windows根视
    self.window.rootViewController = tabController;

}
#pragma mark -----  显示主界面  --------
-(void)configRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token.length == 0) {
        //显示主界面
        MYMaintabcontroller * tabController = [[MYMaintabcontroller alloc] init];
        
        //    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
        //    if(![MYUtils isEmpty:isShow])
        //    {
        //        FMAddInfoController * addCtrl = [[FMAddInfoController alloc]init];
        //       self.window.rootViewController = addCtrl;
        
        //    }else{
        //
        //  //设置windows根视
        self.window.rootViewController = tabController;
        //    }

    }else{
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        loginVC.title = @"hrapp";
        self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    

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

- (void)jspushConfigWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10以上
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //iOS8以上可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //iOS8以下categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction = NO;// NO为开发环境，YES为生产环境
    //广告标识符
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
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

#pragma mark ===== delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (IOS7) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
        
    }else
    {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
//获取到通知信息
-(NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
//
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
