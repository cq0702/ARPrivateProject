//
//  LoginViewController.m
//  ShanShuiKe2.0
//
//  Created by mzc on 16/6/20.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UMSocial.h"
#import "iToast.h"
#import "HTTPManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorTextfieldChange:) name: UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UITextFieldTextDidChangeNotification object:nil];
}
- (void)monitorTextfieldChange:(NSNotification *)notic
{
    if(_phoneNumber.text.length != 11){
        
        [[iToast makeText:@"手机号不正确 ！"] show];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.loginBtn.layer.cornerRadius = 6;
    self.phoneNumber.font = [UIFont systemFontOfSize:15];
    [self changeConstrain];
    [self setBaseNavBackStyle];
    [self setNavRightItem:@"注册"];
}
-(void)rightBarButtonAction:(id)sender
{
    RegisterViewController * regist = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)changeConstrain
{
    
    if(SCREEN_HEIGHT == 480){
        
        self.firstViewHeight.constant = 100;
        self.sskImageWidth.constant = 60;
        self.sskImageHeight.constant = 60;
        self.FirstViewBottomDistanceForSecendViewTop.constant = 20;
        self.secendViewHeight.constant = 100;
        self.loginBtnHeight.constant = 35;
        self.topToLogin.constant = 10;
        
    }else if (SCREEN_HEIGHT == 568){
        
        self.firstViewHeight.constant = 120;
        self.sskImageHeight.constant = 80;
        self.sskImageWidth.constant = 80;
        self.FirstViewBottomDistanceForSecendViewTop.constant =  20;
    }else if (SCREEN_WIDTH == 414){
        
        self.firstViewHeight.constant = 160;
        self.sskImageHeight.constant = 120;
        self.sskImageWidth.constant = 120;
        self.FirstViewBottomDistanceForSecendViewTop.constant =  40;
        self.secendViewHeight.constant = 140;
        self.topToLogin.constant = 30;
        self.loginBtnHeight.constant = 55;
        
    }
}
#pragma mark --------  第三方登录 ------
- (IBAction)thirdLogAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    NSInteger indexTag = btn.tag;
    switch (indexTag) {
        case 1000://微信登录
            [self loginWithWebChat];
            
            break;
        case 1001://QQ
            
            [self loginWithQQ];
            
            break;
        case 1002://微博
            [self loginWithWebBo];
            break;
            
        default:
            break;
    }
    
    
}
-(void)loginWithQQ
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self ThirdPathloginWithUserName:snsAccount.userName userId:snsAccount.usid headIcon:snsAccount.iconURL andType:@"3"];
            
        }});
}
- (void)loginWithWebChat
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self ThirdPathloginWithUserName:snsAccount.userName userId:snsAccount.usid headIcon:snsAccount.iconURL andType:@"1"];
        }
        
    });
}
- (void)loginWithWebBo
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self ThirdPathloginWithUserName:snsAccount.userName userId:snsAccount.usid headIcon:snsAccount.iconURL andType:@"2"];
        }
    });
}

#pragma  mark ---------   第三方登录  -----------
- (void)ThirdPathloginWithUserName:(NSString *)userName userId:(NSString *)userId headIcon:(NSString *)iconUrl  andType:(NSString *)type
{
    /**
     /e_UserService.svc/Mobile_ThirdPartLoginUser/ADS234uyt/3/joke/ewf13413/qefdfa
     参数1：第三方唯一编码
     参数2：第三方类型（微信1、微博2、QQ 3）
     参数3：UserName
     参数4：UserPhotoUrl
     参数5：设备号
     {"EThirdPartUser":{"ThirdPartCode": "ZZZAAA",
     "ThirdPartType":"3",
     "UserName":"keinv.yang",
     "UserPhoto":"http://122.34.2.456/image/kevinyang.jpg",
     "DeviceId":"aslkdjfoe"}}
     */
    
//    NSString * udid = [OpenUDID value];
    NSString * udid = @"udid";
    NSString * baseUrl = @"e_UserService.svc/Mobile_ThirdPartLoginUser";
    

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:userId   forKey:@"ThirdPartCode"];
    [dict setObject:type     forKey:@"ThirdPartType"];
    [dict setObject:userName forKey:@"UserName"];
    [dict setObject:iconUrl  forKey:@"UserPhoto"];
    [dict setObject:udid     forKey:@"DeviceId"];
    

    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    [param setObject:dict forKey:@"EThirdPartUser"];
   
    
    [[HTTPManager sharedInstance]postWithAPI:baseUrl dictionary:param success:^(id responseObject) {
        if (responseObject) {
            
            NSString * userId  = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"Mobile_ThirdPartLoginUserResult"] objectForKey:@"UserId"]];
            NSString * traceId = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"Mobile_ThirdPartLoginUserResult"] objectForKey:@"TraceId"]];
            NSInteger code = [[responseObject objectForKey:@"Code"] integerValue];
            
            if (code == 100 || code == 0) {
                
                if ([MYUtils isNotEmpty:userId]) {
                    
//                    [[iToast makeText:@"登陆成功"] show];
//                    [self userDefaultsValue:userId  forKey:UD_LOGIN_USERID];
                    [self userDefaultsValue:traceId forKey:UD_LOGIN_SUCCESS];
                    
                    [[iToast sharedInstance] makeImage:ImageNamed(@"registerOK") withText:@"登陆成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }else if (code == -100){
                
//                [[iToast makeText:@"用户还没注册"] show];
                [[iToast sharedInstance] makeImage:ImageNamed(@"logerroe_item.png") withText:@"用户还没注册"];
            }else if (code == -200){
                
               [[iToast sharedInstance] makeImage:ImageNamed(@"logerroe_item.png") withText:@"密码错误"];
            }
            
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {}];
    
}
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}
- (IBAction)getbackPassWord:(id)sender {
    
//    ForgetPasswordViewController * forget = [[ForgetPasswordViewController alloc] init];
//    
//    
//    [self.navigationController pushViewController:forget animated:YES];
}
- (IBAction)lookPassWord_action:(id)sender {
    
    UIButton * eyeBtn = (UIButton *)sender;
    
    if(eyeBtn.tag == 100){
        
        NSString * password = self.password.text;
        self.password.text = @"";
        self.password.font = [UIFont systemFontOfSize:15];
        self.password.text = password;
        [eyeBtn setImage:[UIImage imageNamed:@"eyeClose.jpg"] forState:UIControlStateNormal];
        eyeBtn.tag = 101;
        self.password.secureTextEntry = NO;
    }else{
        
        [eyeBtn setImage:[UIImage imageNamed:@"login_eye.png"] forState:UIControlStateNormal];
        eyeBtn.tag = 100;
        self.password.secureTextEntry = YES;
    }
}
#pragma mark ----  登录  -----------
- (IBAction)login_action:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![self isMobileNumber:self.phoneNumber.text]) {
        [[iToast makeText:@"手机号码格式不正确!"] show];
        return;
    }
    if ([MYUtils isEmpty:self.phoneNumber.text]) {
        [[iToast makeText:@"手机号码不能为空 ！"] show];
        return;
    }
    if ([MYUtils isEmpty:self.password.text]) {
        [[iToast makeText:@"密码不能为空 ！"] show];
        return;
    }
    [self loginAcntion];
}
- (void)loginAcntion
{
//    NSString * udid = [OpenUDID value];
    NSString * udid = @"udid";
    
    NSString * baseUrl = @"e_UserService.svc/Mobile_LoginUser";
    NSString * url = [NSString stringWithFormat:@"%@/%@/%@/%@",baseUrl,self.phoneNumber.text,self.password.text,udid];
   
    [[HTTPManager sharedInstance]requestWithAPI:url dictionary:nil success:^(id responseObject) {
        if (responseObject) {
            
            NSInteger code = [[responseObject objectForKey:@"Code"] integerValue];
            NSString * mes = [responseObject objectForKey:@"Message"];
            
            NSString * userId  = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"Data"] objectForKey:@"UserId"]];
            NSString * traceId = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"Data"] objectForKey:@"TraceId"]];
            
            
            if (code == 100) {
                
//                [self userDefaultsValue:userId  forKey:UD_LOGIN_USERID];
                [self userDefaultsValue:traceId forKey:UD_LOGIN_SUCCESS];
                [[iToast sharedInstance] makeImage:ImageNamed(@"registerOK") withText:mes];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{

                [[iToast sharedInstance] makeImage:ImageNamed(@"logerroe_item.png") withText:mes];
            }
            
            
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}
#pragma mark ----- UITextFieldDelegate  --------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//验证手机号
- (BOOL)isMobileNumber:(NSString *)string{
    NSString *phoneRegex = @"^(1)[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}
@end
