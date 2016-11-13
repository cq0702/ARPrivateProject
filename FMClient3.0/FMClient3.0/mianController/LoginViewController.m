//
//  LogonViewController.m
//  HRProject
//
//  Created by 王万意 on 23/8/16.
//  Copyright © 2016年 Bstcine. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetWorking.h"
#import "StringUtil.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)registerAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.phone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.phone.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.password.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    [self.code setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.code.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (IBAction)loginAction:(UIButton *)sender {

    if(![StringUtil checkField:_phone msg:@"用户名不能为空" presentViewController:self]){
        return;
    }
    if(![StringUtil checkField:_password msg:@"密码不能为空！" presentViewController:self]){
        return;
    }
    if(![StringUtil checkField:_code msg:@"验证码不能为空！" presentViewController:self]){
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_LOGINCHANGE" object:@YES];
    NSLog(@"phone=====%@",self.phone);
    NSLog(@"password====%@",self.password);

//    NSDictionary *params = @{
//                             @"phone":self.phone.text,
//                             @"pwd": self.password,
//                             };
//    NSString *url =@"http://hzgas.seemse.com/api/login";
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (!error) {
//            if (responseObject[@"data"]) {
//                [[NSUserDefaults standardUserDefaults] setObject:self.phone.text forKey:@"loginPhone"];
//                [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"loginPassword"];
//                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_LOGINCHANGE" object:@YES];
//            }else{
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"登录失败"preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                }]];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//        } else {
//            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//        }
//    }] resume];
    /*
     *    出现如下请求error:Request failed: unacceptable content-type: text/plain
     *    使用下面一行代码解决
     */
    //    session.responseSerializer = [AFHTTPResponseSerializer serializer];

}

- (IBAction)registerAction:(UIButton *)sender {
    RegisterViewController *RegisterVC=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:RegisterVC animated:YES];
}
@end
