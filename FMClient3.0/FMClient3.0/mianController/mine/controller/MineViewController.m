//
//  MineViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MineViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MineViewController ()<CLLocationManagerDelegate>
{
    NSInteger _userAgentLockToken;
}

@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)CLLocationManager * locationManager;


@end

@implementation MineViewController
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startUpdates];
    
}
- (void)startUpdates
{
    // Create the location manager if this object does not
//    // already have one.
//    if (nil == _locationManager)
//        _locationManager = [[CLLocationManager alloc] init];
//    
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    // Set a movement threshold for new events
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    _locationManager.headingFilter = 5;
//    
//    [_locationManager startUpdatingLocation];
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
//    }
//    
//    CLHeading * heading = [[CLHeading alloc]init];
    
    
    if ([CLLocationManager headingAvailable]) {
        //创建显示方向的指南针Layer
        CALayer * znzLayer = [[CALayer alloc]init];
        NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
        NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
        NSInteger y = (screenHeight - 320)/2;
        NSInteger x = (screenWidth - 320)/2;
        znzLayer.frame = CGRectMake(x, y, 320, 320);
        //设置znzLayer显示的照片
        znzLayer.contents = (id)[[UIImage imageNamed:@"znz.png"]CGImage];
        //将znzLayer添加刀系统的UIView中
        [self.view.layer addSublayer:znzLayer];
        //创建CLLocationManager对象
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingHeading];
    }else{
        //如果磁力计不可用告知
        NSLog(@"设备不支持磁力计");
    }
    
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 5.0)
    {
        [manager stopUpdatingLocation];
        
        printf("latitude %+.6f, longitude %+.6f\n",
               newLocation.coordinate.latitude,
               newLocation.coordinate.longitude);
    }
    // else skip the event and process the next one.
}

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
    // If the accuracy is valid, go ahead and process the event.
    if (newHeading.headingAccuracy > 0)
    {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        double d = 360 - theHeading;
        
        float direction = theHeading;
        
        NSLog(@"locationManager ：%lf==== %lf",d,direction);
        // Do something with the event data.
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

@end
