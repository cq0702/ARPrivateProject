//
//  EMScanCodeController.m
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

#import "EMScanCodeController.h"

@interface EMScanCodeController ()<CAAnimationDelegate>

@property(nonatomic,strong)UIImageView * scanZomeBack;
@property(nonatomic,strong)UIImageView * readLineView;

@property (nonatomic,strong)UIImageView * targetImage;
@property (nonatomic,strong)UIImageView * eggImage;
@property (nonatomic,strong)UIImageView * hammerImage;


@end

@implementation EMScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initNavBar];
    self.view.backgroundColor = [UIColor redColor];
    
    [self InitScan];
    
    //取消扫描动画
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self addSubViews];
    
//    [self update];
    
//    [self animationDaDaLogo];
    
}


-(void)addSubViews
{
    self.targetImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 200)];
    [self.readerView addSubview:self.targetImage];
    self.targetImage.clipsToBounds = YES;
    self.targetImage.contentMode = UIViewContentModeCenter;
    
    self.targetImage.image = [UIImage imageNamed:@"imageTest.png"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    self.targetImage.layer.transform = transform;
    
    
    ////沿着X,Y轴旋转
//    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
//    self.targetImage.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 100), 200);
    
//    [self targetImageAction];
    
    
    //蒙板
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = self.targetImage.bounds;
//    [self.targetImage addSubview:effectView];  /////
    
    //添加手势
    
    UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGes.minimumNumberOfTouches = 1;
    
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePinch:)];
    
    
    
    [self.targetImage addGestureRecognizer:panGes];
    [self.targetImage addGestureRecognizer:pinchGes];
    
    self.targetImage.userInteractionEnabled = YES;
   
    
}

//旋转动画
- (void)update
{
    static float angle = 0;
    angle += 0.1f;
    
    CATransform3D transloate = CATransform3DMakeTranslation(0, 0, -200);
    CATransform3D rotate = CATransform3DMakeRotation(angle, 0, 1, 0);
    CATransform3D mat = CATransform3DConcat(rotate, transloate);
    self.targetImage.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 1000);
}
//拖动方法
-(void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
}
-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

-(void)targetImageAction
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI)];
    rotationAnimation.duration = 25.0f;
    rotationAnimation.repeatCount = 100;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
//    scaleAnimation.duration = 0.35f;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.35f;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = 1;
    animationGroup.animations =[NSArray arrayWithObjects:rotationAnimation, nil];
    [self.targetImage.layer addAnimation:rotationAnimation forKey:@"animationGroup"];
    
}

- (void) animationDaDaLogo
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1 / 100.0f;   // 设置视点在Z轴正方形z=100
    
    // 动画结束时，在Z轴负方向60
    CATransform3D startTransform = CATransform3DTranslate(transform, 0, 0, -60);
    // 动画结束时，绕Y轴逆时针旋转90度
    CATransform3D firstTransform = CATransform3DRotate(startTransform, M_PI_2, 0, 1, 0);
    
    // 通过CABasicAnimation修改transform属性
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    // 向后移动同时绕Y轴逆时针旋转90度
    animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation1.toValue = [NSValue valueWithCATransform3D:firstTransform];
    
    // 虽然只有一个动画，但用Group只为以后好扩展
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:animation1, nil];
    animationGroup.duration = 0.5f;
    animationGroup.delegate = self;     // 动画回调，在动画结束调用animationDidStop
    animationGroup.removedOnCompletion = NO;    // 动画结束时停止，不回复原样
    
    // 对logoImg的图层应用动画
    [self.targetImage.layer addAnimation:animationGroup forKey:@"FristAnimation"];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

@end
