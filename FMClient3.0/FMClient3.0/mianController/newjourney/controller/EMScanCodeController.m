//
//  EMScanCodeController.m
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define IMAGEWIDTH 150


#import "EMScanCodeController.h"
#import "CATransform3DPerspect.h"
#import <CoreLocation/CoreLocation.h>
#import "FMLocationManager.h"
#import <math.h>


@interface EMScanCodeController ()<CAAnimationDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)UIImageView * scanZomeBack;
@property(nonatomic,strong)UIImageView * readLineView;

@property (nonatomic,strong)UIImageView * targetImage;


@property (nonatomic,strong)CLLocationManager * locationManager;
@property (nonatomic,assign)float direction;

@property (nonatomic,strong)UITapGestureRecognizer * tapGes;

@property (nonatomic,assign)double targetDegree;//活动偏移角度
@property (nonatomic,assign)double targetRadian;//活动偏移弧度


@property (nonatomic,assign) float tempFromDegree;
@property (nonatomic,assign) float moveTargetDegree;

@property (nonatomic,assign)double targetDistance;//活动距离
@property (nonatomic,assign)double tempDistance;

@property (nonatomic,assign)NSInteger targetCount;







@end

@implementation EMScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self initNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self InitScan];
    
    [self startUpdatesHeading]; //开始指南针
    
    [self addSubViews];
    
//    [self makeSureImageCenter];
    
    //    [self targetImageAnimation];//添加动画
    //
    //位置动画
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeSureImageCenter) name:kLoadCurrentLocationSuccess object:nil];
    
    
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
    self.targetImage = [[UIImageView alloc]init];
    [self.readerView addSubview:self.targetImage];
    
    self.targetImage.image = [UIImage imageNamed:@"3Dimage22.png"];
    
    self.targetImage.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, IMAGEWIDTH, IMAGEWIDTH);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    
    //      CATransform3DMakeRotation(0.78, 1.0, 0.0, 0.0);
    
    CATransform3D scale = CATransform3DMakeScale(0.3, 0.3, 1);
    CATransform3D rotation = CATransform3DMakeRotation(0.1, 0, 0, 0.1);
    
    CATransform3D concat = CATransform3DConcat(rotation, scale);//X Y轴不能用
    transform = CATransform3DPerspect(concat, CGPointMake(0, 0), 1000);
    self.targetImage.layer.transform = transform;
    
    [self makeSureImageCenter];//默认手机当前方向朝北
    
    CGFloat fromDirection = [FMLocationManager sharedManager].direction;
    [self changeTargetImageStationWithMobileDirection:fromDirection];
    
    
}
#pragma mark  ---- 确定当前与活动点的相对真实位置 ----------
- (void)makeSureImageCenter
{
    //  121.423552,31.203586    31.16946672086699  121.4102669075268
    CLLocation *currentLocation = [FMLocationManager sharedManager].currentLocation.location;
    
    if (currentLocation != nil) {
        
        CLLocation *targetLocation  = [[CLLocation alloc]initWithLatitude:31.16 longitude:121.41];
        
        // 计算距离
        CLLocationDistance meters = [currentLocation distanceFromLocation:targetLocation];
        double temoLat = (targetLocation.coordinate.latitude - currentLocation.coordinate.latitude);
        
        double lngDistance = (double)fabs(temoLat) * 111320;//两维度之间，相差一度，地理相差111320m
        
        if (meters < lngDistance) {
            meters = lngDistance;
        }
//        if (lngDistance < 1) {
//            lngDistance = 1;
//        }
        self.targetRadian = (double)asin(lngDistance/meters);
        self.targetDegree = (double)(asin(lngDistance/meters) * (180.0 / M_PI));//活动地点的位置角度
        
        self.targetCount = [self getDirectionFromLocation:currentLocation andTargetLocation:targetLocation];
        
        
    }
}
#pragma mark ----  随着手机指向改变手机的位置 --------
-(void)changeTargetImageStationWithMobileDirection:(CGFloat)mobileDirection
{
    
    CGFloat marginDegree = self.targetDegree + self.targetCount * 90 - mobileDirection;
    if (marginDegree <= 0) {
        marginDegree = marginDegree + 360;
    }
    
    
    NSInteger maginIndex = marginDegree/90;
    CGFloat marginRadian = (marginDegree - maginIndex * 90) * M_PI/180;
    
    CGPoint center = self.targetImage.center;
    CGFloat cenerX  = 0;
    CGFloat centerY = 0;
    CGFloat widthX  =  SCREEN_WIDTH/2 - 20;
    
    
    if (maginIndex == 0) {
        
        cenerX =  widthX * (1 + sin(marginRadian));
        centerY = (SCREEN_HEIGHT - 113)/2 - widthX * cos(marginRadian);
        
    }else if (maginIndex == 1){
        
        
        cenerX = widthX  * (1 + cos(marginRadian));
        centerY = (SCREEN_HEIGHT - 0)/2 + widthX *  sin(marginRadian);
        
    }else if (maginIndex == 2){
        
        cenerX  = widthX  * (1 - sin(marginRadian));
        centerY = (SCREEN_HEIGHT - 0)/2 + widthX * cos(marginRadian);
        
    }else if (maginIndex == 3){
        
        cenerX = widthX  * (1 - cos(marginRadian));
        centerY = (SCREEN_HEIGHT - 113)/2 -  widthX * sin(marginRadian);
    }
    if (cenerX && centerY) {
        
        center.x = cenerX;
        center.y = centerY;
    }
//   NSLog(@" maginIndex===%ld", maginIndex);
//    NSLog(@"cenerX===%f",cenerX);
//    NSLog(@"cenerY===%f",centerY);
    if (centerY < (SCREEN_HEIGHT - 113)/2) {
        self.targetImage.alpha = 1;
    }else
    {
        self.targetImage.alpha = 0;
    }
    self.targetImage.center = center;
    
    
}
-(void)handlePinch:(UITapGestureRecognizer *)recognizer
{
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你获得奖金100万！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}

- (void)startUpdatesHeading
{
    
    if ([CLLocationManager headingAvailable]) {
        
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
        
        
        // Do something with the event data.
        
//        [self updateHeadingDirection];
        
//        NSLog(@"startUpdatesHeading ：%lf==== %lf",d,direction);
//        
//         [self moveTargetImageAnimationWith:direction];
        
        [self changeTargetImageStationWithMobileDirection:direction];
        
        
    }
}
#pragma mark ----- 指南针指向 ------
-(void)updateHeadingDirection
{
    double targetDegreeValue = self.targetDegree + self.targetCount * 90;
    double degreeMarginValue = fabs(targetDegreeValue - self.direction);
    NSLog(@"degreeMarginValue === %lf",degreeMarginValue);
    
    if (degreeMarginValue <= 180) {
        
        self.targetImage.alpha = 1;
        
    }else{
        
        self.targetImage.alpha = 1;
    }
    
    [self moveTargetImageAnimationWith:self.direction];

}
#pragma mark ---- 图片移动动画 -----
-(void)moveTargetImageAnimationWith:(float)fromDegree
{
    NSInteger fromIndex = 0;
   
    
    NSInteger moveValue = (SCREEN_WIDTH + IMAGEWIDTH)/90;
    
    CGPoint center = self.targetImage.center;
    if (self.tempFromDegree > fromDegree) {//手机往左
        
        self.moveTargetDegree = self.targetDegree + self.tempFromDegree - fromDegree;
        
        if (center.x < SCREEN_WIDTH + 75) {//活动图片向右
            
            center.x += moveValue;
        }
    }else{
        
        self.moveTargetDegree = self.targetDegree - self.tempFromDegree + fromDegree;
        if (center.x > -75) {
            
            center.x -= moveValue;
        }
    }
    
    self.tempFromDegree   = fromDegree;
//    
//    self.moveTargetDegree = self.targetDegree + self.tempFromDegree - fromDegree;
//    NSLog(@"start::::::self.tempFromDegree- fromDegree===%lf",self.tempFromDegree- fromDegree);
//    NSLog(@"moveTargetDegree===%lf",self.moveTargetDegree);
//    self.tempFromDegree   = fromDegree;
//    
//    if (self.moveTargetDegree >= 0 && self.moveTargetDegree <= 90) {
//        fromIndex = 0;
//    }else if (self.moveTargetDegree > 90 && self.moveTargetDegree <= 180)
//    {
//        fromIndex = 1;
//    }else if (self.moveTargetDegree > 180 && self.moveTargetDegree <= 270)
//    {
//        fromIndex = 2;
//    }else if (self.moveTargetDegree > 270 && self.moveTargetDegree <= 360)
//    {
//        fromIndex = 3;
//    }
//    
//    
//    double moveTargetRadian = self.moveTargetDegree * M_PI/180;
//    
//    if (fromIndex == 0) {
//        
//        center.x = SCREEN_WIDTH/2  * (1 + sin(moveTargetRadian));
//        center.y = SCREEN_HEIGHT/2 * (1 - cos(moveTargetRadian));
//        //            NSLog(@"cos(60)===%f",cos(self.targetRadian));
//        
//    }else if (fromIndex == 1)//
//    {
//        center.x = SCREEN_WIDTH/2  * (1 + cos(moveTargetRadian));
//        center.y = SCREEN_HEIGHT/2 * (1 + sin(moveTargetRadian));
//    }
//    else if (fromIndex == 2)//
//    {
//        center.x = SCREEN_WIDTH/2  * (1 - sin(moveTargetRadian));
//        center.y = SCREEN_HEIGHT/2 * (1 + cos(moveTargetRadian));
//        
//    }else if (fromIndex == 3)//
//    {
//        center.x = SCREEN_WIDTH/2  * (1 - cos(moveTargetRadian));
//        center.y = SCREEN_HEIGHT/2 * (1 - sin(moveTargetRadian));
//    }
    
//    NSLog(@"imageCenterY===%f andImageCenterx===%f",center.y,center.x);
    self.targetImage.center = center;
    
}

#pragma mark -------- 计算活动照片是否变大 -----------
-(void)changeTargetImageSizeWithDiatance:(double)targetDistance
{
    
    static float angle = 0.3;
    
    if (self.tempDistance > targetDistance) {//靠近
        
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
    self.tempDistance = targetDistance;
    
}

#pragma mark ---- 模拟定位，图片放大缩小 ---------
-(void)simulateChangeTargetImageSize
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

#pragma mark ------ //判断大致的方向问题 ---------
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
#pragma mark  ----------  判断手机的当前指向 --------
-(NSInteger)getMobileDirectionWith:(float)direction
{
    if (direction >= 0 && direction <= 90) {
        return  0;
    }else if (direction > 90 && direction <= 180)
    {
        return   1;
    }else if (direction > 180 && direction <= 270)
    {
        return  2;
    }else if (direction > 270 && direction <= 360)
    {
        return   3;
    }else
    {
        return 0;
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
                
//                self.startIndex = 1;
                
            }];
        }];
    }];
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
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
}
@end
