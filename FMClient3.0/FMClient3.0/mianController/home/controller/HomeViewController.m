//
//  HomeViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic,assign)NSInteger index;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"飞马星";
    self.view.backgroundColor = [UIColor whiteColor];

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
