//
//  MYTabview.h
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYTabview;

@protocol MYTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MYTabview *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabBarDidClickedPlusButton:(MYTabview *)tabBar;

@end
@interface MYTabview : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<MYTabBarDelegate> delegate;

@end