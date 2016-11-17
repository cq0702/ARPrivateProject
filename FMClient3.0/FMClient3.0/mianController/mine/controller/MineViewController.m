//
//  MineViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UIWebViewDelegate>
{
    NSInteger _userAgentLockToken;
}

@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIWebView * webView;


@end

@implementation MineViewController
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
//    [self.view addSubview:self.webView];
//    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        imageView.image = [UIImage imageNamed:@"target.JPG"];
        imageView.layer.transform = CATransform3DMakeRotation(M_PI/4, 0, 1, 0);
        [self.view addSubview:imageView];
    
        UIImageView * newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
        newImageView.image=[UIImage imageNamed:@"3Dimage22.png"];
        [self.view addSubview:newImageView];
        CATransform3D trans = CATransform3DIdentity;
        trans.m34 = -1/200.0;
        trans = CATransform3DRotate(trans, -M_PI/4, 1, 0, 0);
        newImageView.layer.transform =trans;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

@end
