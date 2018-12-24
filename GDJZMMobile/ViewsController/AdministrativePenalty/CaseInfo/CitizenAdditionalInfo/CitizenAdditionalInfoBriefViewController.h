//
//  AccInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseInfo.h"

#import "CaseIDHandler.h"
#import "CaseProveInfo.h"
#import "AccInfoPickerViewController.h"
#import "ParkingNode.h"
#import "DateSelectController.h"

@interface CitizenAdditionalInfoBriefViewController : UIViewController<UITextFieldDelegate,DatetimePickerHandler,CaseIDHandler>

@property (nonatomic,copy) NSString * caseID;
//法人代表
@property (weak, nonatomic) IBOutlet UITextField *textOrgPrincipal;
//电话
@property (weak, nonatomic) IBOutlet UITextField *textOrgTelNumber;
//车号
@property (weak, nonatomic) IBOutlet UITextField *textAutomobileNumber;
//车型
@property (weak, nonatomic) IBOutlet UITextField *textAutomobilePattern;
//损坏程度
@property (weak, nonatomic) IBOutlet UITextField *textBadDesc;
//车辆所在地
@property (weak, nonatomic) IBOutlet UITextField *textCarownerAddress;

//停驶地点
@property (weak, nonatomic) IBOutlet UILabel *labelParkingLocation;
//停驶地点
@property (weak, nonatomic) IBOutlet UITextField *textParkingLocation;
//责令车辆停驶 
@property (weak, nonatomic) IBOutlet UISwitch *swithIsParking;

@property (nonatomic,weak) id<CaseIDHandler> delegate;
- (IBAction)selectAutomobilePattern:(id)sender;
- (IBAction)selectBadDesc:(id)sender;



- (IBAction)parkingChanged:(UISwitch *)sender;
- (void)saveDataForCase:(NSString *)caseID;
- (void)loadDataForCase:(NSString *)caseID;
- (void)newDataForCase:(NSString *)caseID;
@end
