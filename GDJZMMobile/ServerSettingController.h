//
//  ServerSettingController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataDownLoad.h"
#import "DataUpLoad.h"

@interface ServerSettingController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtServer;
@property (weak, nonatomic) IBOutlet UITextField *txtFile;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonInit;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonReset;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonUpload;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnInitData:(id)sender;
- (IBAction)btnUser:(id)sender;
- (IBAction)btnUpLoadData:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
