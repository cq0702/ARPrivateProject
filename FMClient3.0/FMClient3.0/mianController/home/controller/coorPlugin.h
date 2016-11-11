/********* coorPlugin.m Cordova Plugin Implementation *******/

#import <Foundation/Foundation.h>

@interface coorPlugin : NSObject

- (void)loginMethod:(CDVInvokedUrlCommand*)command;

-(void)RegistMethod:(CDVInvokedUrlCommand*)command;

-(void)genCodeMethod:(CDVInvokedUrlCommand*)command;
    
-(void)backBtnMethod:(CDVInvokedUrlCommand*)command;
    
@end

