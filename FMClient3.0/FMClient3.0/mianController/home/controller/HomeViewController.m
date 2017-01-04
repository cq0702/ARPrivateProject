//
//  HomeViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

@interface HomeViewController ()

@property (nonatomic,assign)NSInteger index;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * phone = [self userDefaultsForKey:UD_LOGIN_TOKEN];
//    if ([MYUtils isEmpty:phone]) {
//        LoginViewController * login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//        
//        [self.navigationController pushViewController:login animated:YES];
//        
//    }

}
-(void)hideTheTabbar
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)showTheTabbar
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


@end
