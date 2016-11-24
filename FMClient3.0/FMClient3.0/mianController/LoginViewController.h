//
//  LoginViewController.h
//  ShanShuiKe2.0
//
//  Created by mzc on 16/6/20.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController :MYBaseController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sskImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sskImageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *FirstViewBottomDistanceForSecendViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secendViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topToLogin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeight;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login_action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@end
