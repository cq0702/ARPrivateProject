//
//  StringUtil.m
//  HRProject
//
//  Created by 王万意 on 16/9/17.
//  Copyright © 2016年 Bstcine. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (bool)checkField:(UITextField *)field msg:(NSString *)msg presentViewController:(UIViewController *)view{
    NSString *txt = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(txt.length==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [view presentViewController:alert animated:YES completion:^{
            [field becomeFirstResponder];
        }];
        return false;
    }
    return true;
}

+(void)alert:(NSString *)msg presentViewController:(UIViewController *)view{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [view presentViewController:alert animated:YES completion:nil];
}

@end
