//
//  EMScanCodeController.h
//  feimaxing
//
//  Created by YT on 15/11/25.
//  Copyright © 2015年 FM. All rights reserved.
//

#import "ZBarSDK.h"

@interface EMScanCodeController : UIViewController<ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate>
{
    //    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
}
@property (retain, nonatomic) ZBarReaderView *readerView;
@property (nonatomic, assign) NSUInteger scanMode;
@property (weak, nonatomic) IBOutlet UIView *BGview;
@property (weak, nonatomic) IBOutlet UIImageView *scanView;

@end
