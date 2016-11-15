//
//  EMScanCodeController.m
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//


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



@end

@implementation EMScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self InitScan];
    
    [self startUpdatesHeading];
    
    
    //取消扫描动画
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(eggScalAnimation) userInfo:nil repeats:YES];
    
    [self addSubViews];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateStatue) name:kLoadCurrentLocationSuccess object:nil];
    
    
//    [self animationDaDaLogo];
    
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
    self.targetImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 200)];
    [self.readerView addSubview:self.targetImage];
    self.targetImage.clipsToBounds = YES;
    self.targetImage.contentMode = UIViewContentModeCenter;
    
    self.targetImage.image = [UIImage imageNamed:@"imageTest.png"];
    
    
    //添加手势
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    
    
    [self.targetImage addGestureRecognizer:tapGes];
    
    self.targetImage.userInteractionEnabled = YES;
    self.targetImage.hidden = YES;
    
    
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -1/500.0;
//    self.targetImage.layer.transform = transform;
    
    
//    CATransform3D translateForm = CATransform3DTranslate(transform, 0, 0, 1);
//    CATransform3D scalForm = CATransform3DScale(transform, 0.5, 0.5, 1);
//    
////    CATransform3D rotationForm  = CATransform3DRotate(transform, 60*M_PI/180, 1, 0, 0);
//    CATransform3D rotationForm  = CATransform3DMakeRotation(M_PI_2/2, 1, 0, 0);
//    
//
//    CATransform3D contactForm  = CATransform3DConcat(scalForm, rotationForm);
//    
//    self.targetImage.layer.transform = rotationForm;
    
    
    ////沿着X,Y轴旋转
//    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
//    self.targetImage.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 100), 200);
    
//    [self targetImageAction];
   
    
}
- (void)update
{
    static float angle = 0;
    angle += 0.05f;
    
    CATransform3D transloate = CATransform3DMakeTranslation(0, 0, 1);
    CATransform3D rotate = CATransform3DMakeRotation(M_PI_2/2, 1, 0, 0);
    CATransform3D mat = CATransform3DConcat(rotate, transloate);
    self.targetImage.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 10), 1000);
}
-(void)eggScalAnimation
{
    static float angle = 0;
    angle += 0.05f;
    
    if (angle < 0.8) {
        
        CATransform3D rotate = CATransform3DMakeScale(angle, angle, 1);
        CATransform3D rotation = CATransform3DMakeRotation(angle, 0.1, 0, 0);
        
        CATransform3D mat = CATransform3DConcat(rotation, rotate);
        self.targetImage.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 1000);
    }
}
-(void)handlePinch:(UITapGestureRecognizer *)recognizer
{
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你获得奖金100万！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        if (anim == [self.targetImage.layer animationForKey:@"FristAnimation"])
        {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = - 1 / 100.0f;   // 设置视点在Z轴正方形z=100
            
            // 动画开始时，在Z轴负方向60
            CATransform3D startTransform = CATransform3DTranslate(transform, 0, 0, -60);
            // 动画开始时，绕Y轴顺时针旋转90度
            CATransform3D secondTransform = CATransform3DRotate(startTransform, M_PI, 0, 1, 0);
            
            // 通过CABasicAnimation修改transform属性
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            // 向前移动同时绕Y轴逆时针旋转90度
            animation.fromValue = [NSValue valueWithCATransform3D:secondTransform];
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            animation.duration = 2.0f;
            
            // 对logoImg的图层应用动画
            [self.targetImage.layer addAnimation:animation forKey:@"SecondAnimation"];
        }
    }
}
#pragma mark 初始化扫描 更新
- (void)InitScan
{
    [ZBarReaderView class];
    self.readerView = [ZBarReaderView new];
    self.readerView.frame = self.view.bounds;
    self.readerView.backgroundColor = [UIColor clearColor];
    self.readerView.layer.contents  = (id)[UIImage imageNamed:@"scanBg_icon.png"];
    self.readerView.alpha = 1;
    
    self.readerView.allowsPinchZoom = NO;//使用手势变焦
    
    //  self.readerView.showsFPS = YES;// 显示帧率  YES 显示  NO 不显示 不能设置yes 返回会报错
    self.readerView.torchMode = 0;          // 0 表示关闭闪光灯，1表示打开
    self.readerView.tracksSymbols = NO;     // Can not show trace marker
    
    self.readerView.trackingColor = [UIColor redColor];
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
        
        self.direction = direction;
        
        NSLog(@"startUpdatesHeading ：%lf==== %lf",d,direction);
        // Do something with the event data.
        
        [self updateStatue];
    }
}
-(void)updateStatue
{
    //     121.423552,31.203586  31.16946672086699  121.4102669075268
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
    
    int targetDegree = (int)asin(lngDistance/meters);
//    int targetDegree1 = (int)asin(0.95);
//    int tempDegree   = (int)atan(lngDistance/latDistance);
    
    NSInteger targetInt = [self getDirectionFromLocation:currentLocation andTargetLocation:targetLocation];
    
    //判断方向
    NSInteger fromInt = self.direction / 90;
    int fromDegree = (int)self.direction % 90;
    
    if (fromInt == targetInt ) {//大致方向正确
        if (targetDegree - 0.5 < fromDegree < targetDegree + 0.5) {
            //图片出现
            NSLog(@"图片该出现了......");
            [UIView animateWithDuration:0.5 animations:^{
                
                
            } completion:^(BOOL finished) {
                
                
                
            }];
            self.targetImage.hidden = NO;
            
        }
    }else{
        
        self.targetImage.hidden = YES;
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

@end
