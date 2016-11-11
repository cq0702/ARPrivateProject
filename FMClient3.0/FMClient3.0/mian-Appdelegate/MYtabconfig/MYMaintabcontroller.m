//
//  MYMaintabcontroller.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYMaintabcontroller.h"
#import "HomeViewController.h"
#import "NewjourneyViewController.h"
#import "DisCoveryViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "MYBaseNavController.h"
#import "MYTabview.h"


#import "EMScanCodeController.h"

@interface MYMaintabcontroller ()<MYTabBarDelegate>
@property (nonatomic,strong)MYTabview * customTabBar;

@property (nonatomic,strong)HomeViewController * home;
@property (nonatomic,strong)MineViewController * mine;

@property (nonatomic,strong)EMScanCodeController * journey;

@end

@implementation MYMaintabcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTabbar];
    
    [self setupAllChildViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)setupTabbar
{
    self.customTabBar      = [[MYTabview alloc] init];
    _customTabBar.frame    = self.tabBar.bounds;
    _customTabBar.delegate = self;
    [self.tabBar addSubview:_customTabBar];
}

#pragma mark - tabbar的代理方法
- (void)tabBar:(MYTabview *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    
    if (to == self.selectedIndex) {
        return;
    }else
    {
        self.selectedIndex = to;
    }
    
}
- (void)setupAllChildViewControllers
{
    self.home  = [[HomeViewController alloc] init];
    self.mine  = [[MineViewController alloc] init];
    
    self.journey  = [[EMScanCodeController alloc] initWithNibName:@"EMScanCodeController" bundle:nil];

    [self setupChildViewController:_home  withTitle:@"销毁" imageName:@"tab_homeicon"   selectedName:@"tab_homeicon_seclect"];
    [self setupChildViewController:_journey  withTitle:@"活动" imageName:@"tab_newjouricon"  selectedName:@"tab_newjouricon_seclect"];
//    [self setupChildViewController:_discover withTitle:@"会员" imageName:@"tab_discoveryicon" selectedName:@"tab_discoveryicon_seclect"];
    [self setupChildViewController:_mine  withTitle:@"个人中心" imageName:@"tab_mineicon"    selectedName:@"tab_mineicon_seclect"];
    
}

-(void)setupChildViewController:(UIViewController *)childVc withTitle:(NSString *)title imageName:(NSString *)imageName selectedName:(NSString *)selectName
{
    
    childVc.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImage = [UIImage imageNamed:selectName];
    if (IOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
//    if ([childVc isKindOfClass:[NewjourneyViewController class]]) {
        MYBaseNavController *navCtrl = [[MYBaseNavController alloc] initWithRootViewController:childVc];
//
        [self addChildViewController:navCtrl];
//
//    }else
//    {
//        [self addChildViewController:childVc];
//    }

    // 添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}


@end
