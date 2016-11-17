//
//  EMScanCodeController.m
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#import "EMScanCodeController.h"
#import "CATransform3DPerspect.h"
#import <CoreLocation/CoreLocation.h>
#import "FMLocationManager.h"
#import <math.h>


@interface EMScanCodeController ()<CAAnimationDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)UIImageView * scanZomeBack;
@property(nonatomic,strong)UIImageView * readLineView;

@property (nonatomic,strong)UIImageView * targetImage;
@property (nonatomic,strong)UIImageView * eggImage;
@property (nonatomic,strong)UIImageView * hammerImage;


@property (nonatomic,strong)CLLocationManager * locationManager;
@property (nonatomic,assign)float direction;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UITapGestureRecognizer * tapGes;

@property (nonatomic,assign)NSInteger startIndex;
@property (nonatomic,assign)int tempFromDegree;

@property (nonatomic,assign)int tempDistance;
@property (nonatomic,assign) CLLocationCoordinate2D myCoordinate;






@end

@implementation EMScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self initNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self InitScan];
    
    [self startUpdatesHeading]; //开始指南针
    
    
    [self addSubViews];
    
    
    
    //    [self targetImageAnimation];//添加动画
    //
    //位置动画
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMyCoordinateValue:) name:kLoadCurrentLocationSuccess object:nil];
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
    [self.readerView start];
    
    self.readerView.scanCrop = self.view.bounds;
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.readLineView removeFromSuperview];
    self.readLineView = nil;
    [self.readerView stop];
    //    [self ConfignavigationItemWith:NO];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)addSubViews
{
    self.targetImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 450, 150, 150)];
    [self.readerView addSubview:self.targetImage];
    
    self.targetImage.image = [UIImage imageNamed:@"3Dimage22.png"];
    self.targetImage.alpha = 1;
    
    
    
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.0;

//      CATransform3DMakeRotation(0.78, 1.0, 0.0, 0.0);
    
        CATransform3D scale = CATransform3DMakeScale(0.3, 0.3, 1);
        CATransform3D rotation = CATransform3DMakeRotation(0.1, 0, 0, 0.1);
    
        CATransform3D concat = CATransform3DConcat(rotation, scale);//X Y轴不能用
        transform = CATransform3DPerspect(concat, CGPointMake(0, 0), 1000);
        self.targetImage.layer.transform = transform;

}
-(void)handlePinch:(UITapGestureRecognizer *)recognizer
{
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你获得奖金100万！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}

#pragma mark 初始化扫描 更新
- (void)InitScan
{
    [ZBarReaderView class];
    self.readerView = [ZBarReaderView new];
    self.readerView.frame = self.view.bounds;
    self.readerView.backgroundColor = [UIColor clearColor];
//    self.readerView.layer.contents  = (id)[UIImage imageNamed:@"scanBg_icon.png"];
    self.readerView.alpha = 1;
    
    self.readerView.allowsPinchZoom = NO;//使用手势变焦
    
    //  self.readerView.showsFPS = YES;// 显示帧率  YES 显示  NO 不显示 不能设置yes 返回会报错
    self.readerView.torchMode = 0;          // 0 表示关闭闪光灯，1表示打开
    self.readerView.tracksSymbols = NO;     // Can not show trace marker
    
    self.readerView.trackingColor = [UIColor clearColor];
    self.readerView.readerDelegate = self;
    
    //设定扫描的类型，QR
    ZBarImageScanner *scanner = self.readerView.scanner;
    [scanner setSymbology:0 config:ZBAR_CFG_MAX_LEN to:0];
    
    
    //处理模拟器
    if(TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator* cameraSimulator = [[ZBarCameraSimulator alloc] initWithViewController:self];
        cameraSimulator.readerView = self.readerView;
        
    }
    [self.readerView addSubview:_scanZomeBack];
    [self.view addSubview:self.readerView];
    [self.readerView start];
    
    self.readerView.scanCrop = self.view.bounds;
    
}

- (void)startUpdatesHeading
{
    
    if ([CLLocationManager headingAvailable]) {
        //创建显示方向的指南针Layer
        //        CALayer * znzLayer = [[CALayer alloc]init];
        //        NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
        //        NSInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
        //        NSInteger y = (screenHeight - 320)/2;
        //        NSInteger x = (screenWidth - 320)/2;
        //        znzLayer.frame = CGRectMake(x, y, 320, 320);
        //
        //        znzLayer.contents = (id)[[UIImage imageNamed:@"znz.png"]CGImage];
        //
        //        [self.view.layer addSublayer:znzLayer];
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingHeading];
        
    }else{
        
        //        NSLog(@"设备不支持磁力计");
    }
    
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 5.0)
    {
        [manager stopUpdatingLocation];
        
    }
}

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
    // If the accuracy is valid, go ahead and process the event.
    if (newHeading.headingAccuracy > 0)
    {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        double d = 360 - theHeading;
        
        float direction = theHeading;
        
        self.direction = direction;
        
        //        NSLog(@"startUpdatesHeading ：%lf==== %lf",d,direction);
        // Do something with the event data.
        
        [self updateStatue];
    }
}
-(void)updateStatue
{
    //  121.423552,31.203586    31.16946672086699  121.4102669075268
    CLLocation *currentLocation = [FMLocationManager sharedManager].currentLocation.location;
    if (currentLocation == nil) {
        return;
    }
    CLLocation *targetLocation  = [[CLLocation alloc]initWithLatitude:31.203586 longitude:121.423552];
    
    
    // 计算距离
    CLLocationDistance meters = [currentLocation distanceFromLocation:targetLocation];
    double temoLat = (targetLocation.coordinate.latitude - currentLocation.coordinate.latitude);
    //    double temoLng = (targetLocation.coordinate.longitude - currentLocation.coordinate.longitude);
    
    double lngDistance = (double)fabs(temoLat) * 111320;//两维度之间，相差一度，地理相差111320m
    
    double targetDegree = (double)asin(lngDistance/meters);
    
    NSInteger targetInt = [self getDirectionFromLocation:currentLocation andTargetLocation:targetLocation];
    
    //判断方向
    NSInteger fromInt = self.direction / 90;
    int fromDegree = (int)self.direction % 90;
    
    //     NSLog(@"Output radians as degrees: %f", RADIANS_TO_DEGREES(targetDegree));
    //     NSLog(@"fromDegree: %f", fromDegree);
    
    NSInteger marginDegree = 5;
    NSInteger maginMaxDegree = 20;
    
    NSInteger maxValue = RADIANS_TO_DEGREES(targetDegree) + marginDegree;
    NSInteger minVlaue = RADIANS_TO_DEGREES(targetDegree) - marginDegree;
    
    NSInteger marginMaxVlue = RADIANS_TO_DEGREES(targetDegree) + maginMaxDegree;
    NSInteger marginMinVlue = RADIANS_TO_DEGREES(targetDegree) - maginMaxDegree;
    
    
    if (fromInt == targetInt ) {//大致方向正确
        if (minVlaue < fromDegree && fromDegree < maxValue) {
            
            //图片出现
            NSLog(@"图片该出现了......");
            
            self.targetImage.alpha = 1;
            if (self.startIndex == 0) {
                
//                [self targetStartImageAnimation];
               
            }else if( self.startIndex == 1){
                //距离动画
            }
            
        }else if (fromDegree > marginMinVlue && fromDegree < minVlaue){
//            NSLog(@"marginMinVlue------");
            [self moveTargetImageAnimationWith:fromDegree];
            
        }else if (fromDegree > maxValue && fromDegree < marginMaxVlue){
            
            [self moveTargetImageAnimationWith:fromDegree];
//            NSLog(@"marginMaxVlue+++++++");
        }

        else{
            
           self.targetImage.alpha = 1;
        }
    }else{
        
        self.targetImage.alpha = 1;
        
    }
}
-(void)moveTargetImageAnimationWith:(int)fromDegree
{
    NSInteger value = 10;
    NSInteger moveValue = 5;
    
   __block CGPoint center = self.targetImage.center;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (self.tempFromDegree > fromDegree) {//往右
            if (center.x > value && center.x < SCREEN_WIDTH - value) {
                
                if (center.x < SCREEN_WIDTH - value) {
                    
                    center.x += moveValue;
                }
                
            }
        }else{
            
            if (center.x > value && center.x < SCREEN_WIDTH - value) {
                
                if (center.x > value) {
                    
                    center.x -= moveValue;
                }
                
            }
        }
    } completion:^(BOOL finished) {
        
        self.targetImage.center = center;
        self.tempFromDegree = fromDegree;
        
    }];
    
   
}
-(void)getMyCoordinateValue:(NSNotification *)userLocation
{

    //  121.423552,31.203586    31.16946672086699  121.4102669075268
    CLLocation *currentLocation = [FMLocationManager sharedManager].currentLocation.location;
   
    if (currentLocation == nil) {
        return;
    }
    CLLocation *targetLocation  = [[CLLocation alloc]initWithLatitude:31.203586 longitude:121.423552];
    // 计算距离
    CLLocationDistance meters = [currentLocation distanceFromLocation:targetLocation];
    NSLog(@"currentLocation===%@",currentLocation);
    NSLog(@"meters===%f",meters);
    
    static float angle = 0.3;
    
    if (self.tempDistance > meters) {//靠近
        
        angle += 0.1f;
        
    }else{//远离
        
        angle -= 0.1f;
    }
    
    if (angle <= 1.1 && angle > 0.2) {
        
        CATransform3D scale = CATransform3DMakeScale(angle, angle, 1);
        CATransform3D rotation = CATransform3DMakeRotation(0.1, 0, 0, 0.1);
        
        CATransform3D concat = CATransform3DConcat(rotation, scale);
        self.targetImage.layer.transform = CATransform3DPerspect(concat, CGPointMake(0, 0), 1000);
        
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished) {
            
            CGPoint center = self.targetImage.center;
            center.y += 10;
            
            self.targetImage .center = center;
            
        }];
    }else if (angle > 1.09)
    {
        if (self.tapGes == nil) {
            
            //添加手势
            self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
            
            [self.targetImage addGestureRecognizer:self.tapGes];
            self.targetImage.userInteractionEnabled = YES;
        }
    }
    self.tempDistance = meters;
    
}



//模拟位置动画
-(void)diatanceImageFromLocation:(CLLocation *)fromLoaction andTargetLocation:(CLLocation *)TatgetLocation
{
    NSInteger targetInt = [self getDirectionFromLocation:fromLoaction andTargetLocation:TatgetLocation];
    
    static float angle = 0.3;
    angle += 0.05f;
    
    if (angle <= 1.1) {
        
        CATransform3D scale = CATransform3DMakeScale(angle, angle, 1);
        CATransform3D rotation = CATransform3DMakeRotation(0.1, 0, 0, 0.1);
        
        CATransform3D concat = CATransform3DConcat(rotation, scale);
        self.targetImage.layer.transform = CATransform3DPerspect(concat, CGPointMake(0, 0), 1000);
        
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished) {
            
            CGPoint center = self.targetImage.center;
            center.y += 10;
            
            self.targetImage .center = center;
            
        }];
        
    }else if (angle > 1.1)
    {
        if (self.tapGes == nil) {
            
            //添加手势
            self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
            
            [self.targetImage addGestureRecognizer:self.tapGes];
            self.targetImage.userInteractionEnabled = YES;
        }
    }
}

//判断大致的方向问题
-(NSInteger)getDirectionFromLocation:(CLLocation *)fromLoaction andTargetLocation:(CLLocation *)TatgetLocation
{
    double fromLng = fromLoaction.coordinate.longitude;
    double fromLat = fromLoaction.coordinate.latitude;
    
    double targetLng = TatgetLocation.coordinate.longitude;
    double targetLat = TatgetLocation.coordinate.latitude;
    
    if (targetLat > fromLat) {
        if (targetLng > fromLng) {
            return 0;
        }else{
            return 3;
        }
    }else{
        
        if (targetLng > fromLng) {
            return 1;
        }else{
            return 2;
        }
    }
    
}

//开始出现的动画
-(void)targetStartImageAnimation
{
    self.targetImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5   animations:^{
        
        self.targetImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
    }completion:^(BOOL finish){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.targetImage.transform = CGAffineTransformMakeScale(0.5, 0.5);
            
        }completion:^(BOOL finish){
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.targetImage.transform = CGAffineTransformMakeScale(0.3, 0.3);
                
            }completion:^(BOOL finish){
                
                self.startIndex = 1;
                
            }];
        }];
    }];
}
@end
