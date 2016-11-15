//
//  MYTabview.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYTabview.h"
#import "MYTabbutton.h"
#import "UIColor+MYColorString.h"

@interface MYTabview()
@property (nonatomic, strong) NSMutableArray * tabBarButtons;
@property (nonatomic, strong) MYTabbutton * selectedButton;
@property (nonatomic,assign)NSInteger indexValue;


@end
@implementation MYTabview
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.indexValue = 0;
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}
- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    
    MYTabbutton *button = [[MYTabbutton alloc] init];
    [self addSubview:button];
    
    [self.tabBarButtons addObject:button];
    
    
    button.item = item;
    
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(MYTabbutton *)button
{
    // 1.通知代理
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithDtString:@"#f2f2f2"];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        
        MYTabbutton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        button.tag = index;
    }
}
- (void)forInButton
{
    if (self.tabBarButtons.count == 4) {
        
        for (NSInteger i = 0; i < self.tabBarButtons.count; i++) {
            MYTabbutton *button = self.tabBarButtons[i];
            [self buttonClick:button];
        }
    }
    
    [self buttonClick:[self.tabBarButtons firstObject]];
    
}

@end
