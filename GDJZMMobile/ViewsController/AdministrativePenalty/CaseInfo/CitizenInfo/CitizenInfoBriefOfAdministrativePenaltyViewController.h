//
//  CitizenInfoBriefOfAdministrativePenaltyViewController
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Citizen.h"
#import "CaseIDHandler.h"
#import "AutoNumerPickerViewController.h"


@interface CitizenInfoBriefOfAdministrativePenaltyViewController : UIViewController<UITextFieldDelegate,AutoNumberPickerDelegate>
- (IBAction)showPicker:(id)sender;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *textParty;
//当事人
@property (weak, nonatomic) IBOutlet UITextField *textNexus;
//性别
@property (weak, nonatomic) IBOutlet UISegmentedControl *textSex;
//年龄
@property (weak, nonatomic) IBOutlet UITextField *textAge;
//民族
@property (weak, nonatomic) IBOutlet UITextField *textNation;
//证件号码
@property (weak, nonatomic) IBOutlet UITextField *textCardNO;
//地址
@property (weak, nonatomic) IBOutlet UITextField *textAddress;
//工作单位
@property (weak, nonatomic) IBOutlet UITextField *textOrgName;
//职业
@property (weak, nonatomic) IBOutlet UITextField *textProfession;
//职务
@property (weak, nonatomic) IBOutlet UITextField *textOrgPrincipalDuty;
//电话
@property (weak, nonatomic) IBOutlet UITextField *textTelNumber;
//邮编
@property (weak, nonatomic) IBOutlet UITextField *textPostalCode;
//籍贯
@property (weak, nonatomic) IBOutlet UITextField *textOriginalHome;
//国籍
@property (weak, nonatomic) IBOutlet UITextField *textNationality;

@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,weak) id<CaseIDHandler> delegate;

@property (nonatomic,assign) NSInteger pickerType;

-(void)saveCitizenInfoForCase:(NSString *)caseID;
//行政处罚的case_type_id为12
-(void)loadCitizenInfoForCase:(NSString *)caseID andNexus:(NSString *)nexus;
//不是生成，是清空该控制器对应的界面
-(void)newDataForCase:(NSString *)caseID;
@end

