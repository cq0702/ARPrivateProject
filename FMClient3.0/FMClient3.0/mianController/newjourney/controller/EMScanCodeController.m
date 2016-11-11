//
//  EMScanCodeController.m
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//

#import "EMScanCodeController.h"

@interface EMScanCodeController ()<CAAnimationDelegate>
{
    UIView * _topView;
    UIView * _leftView;
    UIView * _rightView;
    UIView * _bottomView;
    
}
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
    self.view.backgroundColor = [UIColor clearColor];
    
    [self InitScan];
    
    //取消扫描动画
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(targetImageAction) userInfo:nil repeats:YES];
    
    [self addSubViews];
    
//    [self animationDaDaLogo];
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self animationDaDaLogo];
//    [self targetImageAction];
}

-(void)addSubViews
{
    self.targetImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 400)];
    [self.readerView addSubview:self.targetImage];
    
    self.targetImage.image = [UIImage imageNamed:@"imageTest22.png"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    self.targetImage.layer.transform = transform;
    
    
    CATransform3D translateForm = CATransform3DTranslate(transform, 0, 0, 50);
//
    CATransform3D rotationForm  = CATransform3DRotate(transform, 30*M_PI/180, 0, 1, 0);
//
    CATransform3D contactForm  = CATransform3DConcat(translateForm, rotationForm);
    
    self.targetImage.layer.transform = contactForm;
    
//    [self targetImageAction];
    
    
    //蒙板
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = self.targetImage.bounds;
//    [self.targetImage addSubview:effectView];  /////
}
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    //
    return newPic;
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
    self.readerView.backgroundColor = [UIColor clearColor];
    self.readerView.layer.contents  = (id)[UIImage imageNamed:@"scanBg_icon.png"];
    self.readerView.alpha = 1;
    
    self.readerView.allowsPinchZoom = NO;//使用手势变焦
    
    //  self.readerView.showsFPS = YES;// 显示帧率  YES 显示  NO 不显示 不能设置yes 返回会报错
    self.readerView.torchMode = 0;          // 0 表示关闭闪光灯，1表示打开
    self.readerView.tracksSymbols = NO;     // Can not show trace marker
    
//    self.readerView.trackingColor = [UIColor redColor];
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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_topView == nil) {
        
        [self addBedgeViews];
    }
    if (self.readLineView == nil) {
        
        [self addReadLineSubViews];
    }
    
    [self.readerView start];
//    [self ConfignavigationItemWith:YES];
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
-  (void)addReadLineSubViews
{
//    self.readLineView = [[UIImageView alloc]init];
//    self.readLineView.image = [UIImage imageNamed:@"scan_lineview_icon.png"];
//    self.readLineView.frame = CGRectMake(8,5, SCREEN_WIDTH - 110 - 16, 1);
//    [self.scanView addSubview:self.readLineView];
    
    //设置扫描区域
    self.readerView.scanCrop = self.scanView.bounds;
    
    if (SCREEN_HEIGHT <= 568) {
        
        self.readerView.frame = CGRectMake(-5, -5, SCREEN_WIDTH + 55 + 10, SCREEN_HEIGHT + 100 + 10);
        
    }else
        
    {
        
        self.readerView.frame = CGRectMake(-5, -5, SCREEN_WIDTH + 10, SCREEN_HEIGHT + 10);
    
    }
    
}
- (void)addBedgeViews
{
    CGFloat topY    = CGRectGetMinY(self.scanView.frame) + 5;
    CGFloat leftX   = CGRectGetMinX(self.scanView.frame) + 5;
    CGFloat rightX  = CGRectGetMaxX(self.scanView.frame) + 5;
    CGFloat bottomY = CGRectGetMaxY(self.scanView.frame) - 64 + 5;
    
    CGFloat totalW  = SCREEN_WIDTH  + 5;
    CGFloat totalH  = SCREEN_HEIGHT + 5;
    
    CGRect topFram    = CGRectMake(0, 0, totalW, topY);
    CGRect leftFram   = CGRectMake(0, topY, leftX, bottomY - topY);
    CGRect rightFram  = CGRectMake(rightX, topY, leftX, bottomY - topY);
    CGRect bottomFram = CGRectMake(0, bottomY, totalW, totalH - bottomY);
    
    if (SCREEN_HEIGHT <= 568) {
        
         leftFram   = CGRectMake(0, topY, leftX, bottomY - topY - 100);
         rightFram  = CGRectMake(rightX - 55, topY, leftX, bottomY - topY - 100);
         bottomFram = CGRectMake(0, bottomY - 100, totalW, totalH - bottomY + 100);
        
    }
    
    _topView    = [self viewWithFrame:topFram    bgColor:[UIColor blackColor] transparent:YES];
    _leftView   = [self viewWithFrame:leftFram   bgColor:[UIColor blackColor] transparent:YES];
    _rightView  = [self viewWithFrame:rightFram  bgColor:[UIColor blackColor] transparent:YES];
    _bottomView = [self viewWithFrame:bottomFram bgColor:[UIColor blackColor] transparent:YES];
    
    [self.readerView addSubview:_topView];
    [self.readerView addSubview:_leftView];
    [self.readerView addSubview:_rightView];
    [self.readerView addSubview:_bottomView];
    
    //添加label
//    UILabel* lblIntroduce = [[UILabel alloc] init];
//    lblIntroduce.backgroundColor = [UIColor clearColor];
//    lblIntroduce.frame = CGRectMake(0, bottomY + 20, totalW, 30);
//    lblIntroduce.textAlignment = NSTextAlignmentCenter;
//    lblIntroduce.textColor     = [UIColor whiteColor];
//    lblIntroduce.font = [UIFont boldSystemFontOfSize:15];
//    lblIntroduce.text = @"将二维码/条码放入框内,即可自动扫描";
//    
//    [self.readerView addSubview:lblIntroduce];
    
}
//设置扫描背景Method
- (UIView*)viewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor transparent:(BOOL)transparent
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    if (transparent == YES){
        view.alpha = 0.4;
    }
    view.backgroundColor = bgColor;
    
    return view;
}
#pragma mark 设置中间扫描线体的动画
-(void)animationWithLineView
{
    
    [UIView animateWithDuration:3 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        self.readLineView.frame = CGRectMake(8,self.scanView.bounds.size.height-5, self.scanView.bounds.size.width - 16, 1);
        
    } completion:nil];
    
    
}

#pragma mark 从相册选取照片
-(void)rightClick
{
    UIImagePickerController * pickView = [[UIImagePickerController alloc]init];
    pickView.allowsEditing = YES;
    pickView.delegate = self;
    pickView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickView animated:YES completion:nil];
    
}

#pragma mark 读取从相册中选取的照片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //    UIImage * imageTemp = [info objectForKey:@"UIImagePickerControllerEditedImage"];//这种方法也可以读取照片
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate   = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol* symbol    = nil;
    
    for(symbol in [read scanImage:cgImageRef]) break;
    
    NSString *dataNum=symbol.data;
    //    [self.readerView stop];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark 扫描动画
-(void)loopDrawLine
{
    CGRect  rect = CGRectMake(_scanZomeBack.frame.origin.x, _scanZomeBack.frame.origin.y, _scanZomeBack.frame.size.width, 2);
    if (_readLineView) {
        [_readLineView removeFromSuperview];
    }
    _readLineView = [[UIImageView alloc] initWithFrame:rect];
    [_readLineView setImage:[UIImage imageNamed:@"u16_line"]];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         _readLineView.frame =CGRectMake(_scanZomeBack.frame.origin.x, _scanZomeBack.frame.origin.y+_scanZomeBack.frame.size.height, _scanZomeBack.frame.size.width, 2);
                         [_readLineView setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         //                         if (!is_Anmotion) {
                         //                             [self loopDrawLine];
                         //                         }
                     }];
    
    [self.readerView addSubview:_readLineView];
    
}
#pragma mark 获取扫描结果
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr         = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        // 是否QR二维码
    }
    
//    [readerView.captureReader captureFrame];
//    
//    [readerView stop];
    

}

@end
