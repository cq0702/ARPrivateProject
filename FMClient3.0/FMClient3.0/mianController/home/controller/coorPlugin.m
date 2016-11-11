/********* coorPlugin.m Cordova Plugin Implementation *******/

#define kTimeOutInterval 100
#import <AFNetworking.h>
#import "iToast.h"
#import "MYUtils.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define LOGINURL @"http://192.168.1.244/api.php/"
#define UD_LOGIN_TOKEN  @"ud_login_token"

@interface coorPlugin : NSObject
{
    // Member variables go here.
}
@property (nonatomic,strong)UIViewController * controller;
@property (nonatomic,strong)UIWebView * subWeb;
@property (nonatomic,strong)AFHTTPSessionManager * sessManager;

@end


@implementation coorPlugin

// 懒加载
- (AFHTTPSessionManager *)sessManager {
    
    if (!_sessManager) {
        _sessManager = [AFHTTPSessionManager manager];
        
        self.sessManager.requestSerializer.timeoutInterval = kTimeOutInterval;// 设置超时时间
        self.sessManager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 设置上传格式
        self.sessManager.requestSerializer = [AFJSONRequestSerializer serializer]; // JSON格式
        
        //        application/json
        
        self.sessManager.responseSerializer = [AFJSONResponseSerializer serializer]; //声明返回数据
        self.sessManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        
        
        [self.sessManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.sessManager.requestSerializer setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    }
    return _sessManager;
}
//- (void)loginMethod:(NSString *)phone  andPassword:(NSString *)password
//{
//    if (command.arguments.count > 2) {
//        
//        if ([MYUtils isEmpty:phone]) {
//            [[iToast makeText:@"手机号不能为空"] show];
//            return;
//        }
//        
//        if ([MYUtils isEmpty:code]) {
//            [[iToast makeText:@"验证码不能为空"] show];
//            return;
//        }
//        [self loginFunction:phone code:code inviteCode:invite withCommand:command];
//        
//    }else
//    {
//        [[iToast makeText:@"登录信息获取失败"] show];
//        return;
//        
//    }
//    
//}
//-(void)loginFunction:(NSString *)phone code:(NSString *)codeValue inviteCode:(NSString *)inviteValue withCommand:(CDVInvokedUrlCommand*)command{
//    
//    //登陆结果
//    __block CDVPluginResult* pluginResult = nil;
//    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setObject:phone       forKey:@"phone"];
//    [params setObject:inviteValue forKey:@"invite1"];
//    [params setObject:codeValue   forKey:@"code"];
//    NSString * url = [NSString stringWithFormat:@"%@%@",LOGINURL,@"login"];
//    
//    [self.sessManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        if(responseObject){
//            NSArray * array = (NSArray *)responseObject;
//            
//            if ([[array firstObject] integerValue] == 0 ) {
//                
//                NSDictionary * resDic = [array lastObject];
//                
//                // 请求成功
//                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[resDic objectForKey:@"_token"]];
//                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                
//                [self userDefaultsValue:[resDic objectForKey:@"_token"] forKey:UD_LOGIN_TOKEN];
//                
//            }else{
//                
//                NSString * mes = [NSString stringWithFormat:@"%@",array[1]];
//                
//                if ([MYUtils isEmpty:mes]) {
//                    
//                    return;
//                }else
//                {
//                    [[iToast makeText:mes] show];
//                }
//            }
//            
//        } else {
//            
//            [[iToast makeText:@"登录失败！"] show];
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            //
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//            
//            NSLog(@"post,error--%@",[error debugDescription]);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[iToast makeText:@"当前网络不稳定！"] show];
//                
//            });
//        }
//        //取消请求
//        [task cancel];
//    }];
//}
//-(void)RegistMethod:(CDVInvokedUrlCommand*)command{
//    
//    if (command.arguments.count >= 2) {
//        NSString * phone = [command.arguments firstObject];
//        NSString * paswd   = [command.arguments lastObject];
//        
//        if ([MYUtils isEmpty:phone]) {
//            [[iToast makeText:@"手机号不能为空"] show];
//            return;
//        }
//        
//        if ([MYUtils isEmpty:paswd]) {
//            [[iToast makeText:@"密码不能为空"] show];
//            return;
//        }
//        [self RegistMethod:phone password:paswd withCommand:command];
//        
//    }else
//    {
//        [[iToast makeText:@"登录信息获取失败"] show];
//        return;
//        
//    }
//}
//- (void)RegistMethod:(NSString *)phone password:(NSString *)password withCommand:(CDVInvokedUrlCommand*)command {
//    
//    //登陆结果
//    __block CDVPluginResult* pluginResult = nil;
//    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setObject:phone       forKey:@"phone"];
//    [params setObject:password    forKey:@"pwd"];
//    
//    NSString * url = [NSString stringWithFormat:@"%@%@",LOGINURL,@"login"];
//    [self.sessManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        if(responseObject){
//            NSArray * array = (NSArray *)responseObject;
//            
//            if ([[array firstObject] integerValue] == 0 ) {
//                
//                NSDictionary * resDic = [array lastObject];
//                // 请求成功
//                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[resDic objectForKey:@"_token"]];
//                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                
//                [self userDefaultsValue:[resDic objectForKey:@"_token"] forKey:UD_LOGIN_TOKEN];
//                
//            }else{
//                
//                NSString * mes = [NSString stringWithFormat:@"%@",array[1]];
//                
//                if ([MYUtils isEmpty:mes]) {
//                    
//                    return;
//                }else{
//                    [[iToast makeText:mes] show];
//                }
//            }
//        }else {
//            
//            [[iToast makeText:@"登录失败！"] show];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            //
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//            
//            NSLog(@"post,error--%@",[error debugDescription]);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[iToast makeText:@"当前网络不稳定！"] show];
//                
//            });
//        }
//        //取消请求
//        [task cancel];
//    }];
//}
////获取验证码
//
//-(void)genCodeMethod:(CDVInvokedUrlCommand*)command
//{
//    NSString * phone = [command.arguments firstObject];
//    
//    if ([MYUtils isEmpty:phone]) {
//        [[iToast makeText:@"手机号不能为空"] show];
//        return;
//    }
//    
//    //登陆结果
//    __block CDVPluginResult* pluginResult = nil;
//    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//    [params setObject:phone       forKey:@"phone"];
//    NSString * url = [NSString stringWithFormat:@"%@%@",LOGINURL,@"gencode"];
//    
//    [self.sessManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        if(responseObject){
//            
//            // 请求成功
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"codeisok"];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//            [[iToast makeText:@"请您查收验证码！"] show];
//            
//        } else {
//            
//            [[iToast makeText:@"验证码获取失败！"] show];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            //
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//            
//            NSLog(@"post,error--%@",[error debugDescription]);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [[iToast makeText:@"当前网络不稳定！"] show];
//                
//            });
//        }
//        //取消请求
//        [task cancel];
//    }];
//}
//
//-(void)backBtnMethod:(CDVInvokedUrlCommand*)command
//{
//    [self.controller dismissViewControllerAnimated:YES completion:nil];
//}

- (void)userDefaultsValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

@end
