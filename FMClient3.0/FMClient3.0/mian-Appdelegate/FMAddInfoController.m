//
//  FMAddInfoController.m
//  FMClient3.0
//
//  Created by YT on 2016/10/20.
//  Copyright © 2016年 YT.com. All rights reserved.
//
#define SCREEN_FRAME ([UIScreen mainScreen].bounds)

#import "FMAddInfoController.h"
#import "UIColor+MYColorString.h"
#import "MYMaintabcontroller.h"
#import "MYUtils.h"


@interface FMAddInfoController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSArray * addImages;


@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,assign)NSInteger indexCount;

@property(nonatomic,strong)UIButton *cancleBtn;


@end

@implementation FMAddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addImages  = @[@"addimage1.jpg",@"addimage2.jpg",@"addimage3.jpg",@"addimage4.jpg"];
    self.indexCount = 5;
    
    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
    if([MYUtils isEmpty:isShow])
    {
        [self addSubView];
        [self createImageView];
    }
    
    [self addSubWebView];
    
}
-(void)addSubWebView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.webView];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.1.208/act/index.html"]];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    self.label.text = @"10";
    self.label.font = [UIFont boldSystemFontOfSize:13];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.layer.cornerRadius = 10;
    self.label.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.label.layer.borderWidth  = 1;
    [self.view addSubview:self.label];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabelValue) userInfo:nil repeats:YES];
    
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 20, 60, 35);
    [self.cancleBtn setTitle:@"点此跳过" forState:(UIControlStateNormal)];
    self.cancleBtn.titleLabel.textColor = [UIColor whiteColor];
    self.cancleBtn.titleLabel.font  = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.cancleBtn];
    
    [self.cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
}
-(void)changeLabelValue
{
    self.indexCount --;
    self.label.text = [NSString stringWithFormat:@"%ld",self.indexCount];
    if (self.indexCount == 0) {
        
        [self removeWebViewAndLabel];
        
    }
}
-(void)cancleBtnAction
{
    [self removeWebViewAndLabel];
    
}
-(void)removeWebViewAndLabel
{
    [self.webView removeFromSuperview];
    [self.label removeFromSuperview];
    
    self.label   = nil;
    self.webView = nil;
    
    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
    if([MYUtils isNotEmpty:isShow])
    {
        [self goMainCtrl];
    }
}
- (void)addSubView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled=YES;
    [self.view addSubview:self.scrollView];
    
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 10)];
    self.pageControl.currentPageIndicatorTintColor=[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:self.pageControl];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.addImages.count, 0);
    
    self.pageControl.numberOfPages= self.addImages.count;
    
}
-(void)createImageView{
    
    for (NSInteger i=0 ; i<self.addImages.count;i++) {
        
        NSString * imgStr = self.addImages[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FRAME.size.width * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [imageView setUserInteractionEnabled:true];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imgStr];
        
        [self.scrollView addSubview:imageView];
        
        if (i == self.addImages.count - 1) {
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SCREEN_WIDTH - 100)/2,SCREEN_HEIGHT - 50, 100, 35);
            [button setTitle:@"立即体验" forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA] forState:(UIControlStateNormal)];
            
            button.layer.borderColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA].CGColor;
            button.layer.borderWidth = 1.0f;
            
            [button addTarget:self action:@selector(beginClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetWidth = self.scrollView.contentOffset.x;
    int pageNum = offsetWidth / SCREEN_WIDTH;
    self.pageControl.currentPage = pageNum;
}

#pragma mark - 点击事件

- (void)beginClick
{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.scrollView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"isShow" forKey:kShowWelcome];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self goMainCtrl];
    
    }];
}
-(void)goMainCtrl
{
    MYMaintabcontroller * tabController = [[MYMaintabcontroller alloc] init];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabController;
}
#pragma mark ----- UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self goMainCtrl];
}
@end
