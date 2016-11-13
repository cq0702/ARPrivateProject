//
//  StringUtil.h
//  HRProject
//
//  Created by 王万意 on 16/9/17.
//  Copyright © 2016年 Bstcine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StringUtil : NSObject

+ (bool)checkField:(UITextField *)field msg:(NSString *)msg presentViewController:(UIViewController *)view;

+(void)alert:(NSString *)msg presentViewController:(UIViewController *)view;

@end
