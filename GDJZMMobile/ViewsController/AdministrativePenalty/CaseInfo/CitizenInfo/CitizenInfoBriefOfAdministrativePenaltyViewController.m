//
//  CitizenInfoBriefOfAdministrativePenaltyViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CitizenInfoBriefOfAdministrativePenaltyViewController.h"
#import "CaseInquire.h"
#import "AutoNumerPickerViewController.h"

@interface CitizenInfoBriefOfAdministrativePenaltyViewController ()
@property (nonatomic,retain) UIPopoverController *picker;
@end

@implementation CitizenInfoBriefOfAdministrativePenaltyViewController
@synthesize textParty = _textParty;
@synthesize textNexus = _textNexus;
@synthesize textSex = _textSex;
@synthesize textAge = _textAge;
@synthesize textCardNO = _textCardNO;
@synthesize textAddress = _textAddress;
@synthesize textOrgName = _textOrgName;
@synthesize textProfession = _textProfession;
@synthesize textTelNumber = _textTelNumber;
@synthesize textPostalCode = _textPostalCode;
@synthesize caseID =_caseID;
@synthesize delegate=_delegate;
@synthesize picker=_picker;
@synthesize textNation = _textNation;
@synthesize textNationality = _textNationality;
@synthesize textOrgPrincipalDuty = _textOrgPrincipalDuty;
@synthesize textOriginalHome = _textOriginalHome;
@synthesize pickerType = _pickerType;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTextParty:nil];
    [self setTextNexus:nil];
    [self setTextSex:nil];   
    [self setTextAge:nil];
    [self setTextCardNO:nil];
    [self setTextAddress:nil];
    [self setTextOrgName:nil];
    [self setTextProfession:nil];
    [self setTextTelNumber:nil];
    [self setTextPostalCode:nil];
    [self setTextNation:nil];
    [self setTextNationality:nil];
    [self setTextOrgPrincipalDuty:nil];
    [self setTextOriginalHome:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate scrollViewNeedsMove];
}

//当事人仅可选择，不可编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1001) {
        return NO;
    } else {
        return YES;
    }
}




- (IBAction)showPicker:(id)sender{
    switch ([(UITextField *)sender tag]) {
        //弹出职务选择    
        case 1000:
            [self pickerPresentForIndex:kOrgPrincipalDuty fromRect:[(UITextField*)sender frame]];
            break;
        //弹出人员类型选择    
        case 1001:
            [self pickerPresentForIndex:kAPNexus fromRect:[(UITextField*)sender frame]];
            break;
        //弹出民族选择    
        case 1002:
            [self pickerPresentForIndex:kNation fromRect:[(UITextField*)sender frame]];
            break;
            //弹出籍贯选择
        case 1003:
            [self pickerPresentForIndex:kOriginalHome fromRect:[(UITextField*)sender frame]];
            break;
            //弹出国籍选择
        case 1004:
            [self pickerPresentForIndex:kNationality fromRect:[(UITextField*)sender frame]];
            break;
        default:
            break;
    }
    
}



//弹窗
-(void)pickerPresentForIndex:(CasePickerType)iIndex fromRect:(CGRect)rect{
    if (([_picker isPopoverVisible]) && (self.pickerType == iIndex)) {
        [_picker dismissPopoverAnimated:YES];
    } else {
        self.pickerType = iIndex;
        AutoNumerPickerViewController *pickerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate = self;
        pickerVC.caseID = _caseID;
        pickerVC.pickerType = iIndex;
        _picker = [[UIPopoverController alloc] initWithContentViewController:pickerVC];
        if (iIndex == kNexus) {
            _picker.popoverContentSize=CGSizeMake(130, 176);
        }
        [_picker presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.popOver = _picker;
    }
}


-(void)setAutoNumberText:(NSString *)aAuotNumber{
    switch (self.pickerType) {
        case kOrgPrincipalDuty:
            self.textOrgPrincipalDuty.text = aAuotNumber;
            break;
        case kAPNexus:{
            self.textNexus.text = aAuotNumber;
            [self loadCitizenInfoForCase:self.caseID andNexus:self.textNexus.text];
        }
            break;
        case kNation:
            self.textNation.text = aAuotNumber;
            break;
        case kOriginalHome:
            self.textOriginalHome.text = aAuotNumber;
            break;
        case kNationality:
            self.textNationality.text = aAuotNumber;
            break;
        default:
            break;
    }
}

//每一个用户都有一个对应的询问笔录
-(void)saveCitizenInfoForCase:(NSString *)caseID{
    self.caseID=caseID;
    if (![self.textParty.text isEmpty]) {
        Citizen *citizen=[Citizen citizenByCaseID:caseID andNexus:self.textNexus.text];
        if (citizen==nil){
            citizen=[Citizen newDataObjectWithEntityName:@"Citizen"]; 
        }
        citizen.proveinfo_id=caseID;
        citizen.party =_textParty.text == nil? @"": _textParty.text;
        citizen.nexus = self.textNexus.text;
        switch (_textSex.selectedSegmentIndex) {
            case 0:
                citizen.sex=@"男";
                break;
            case 1:
                citizen.sex=@"女";
                break;
            default:
                break;
        }
        citizen.age=[NSNumber numberWithInteger:_textAge.text.integerValue];
        citizen.nation = self.textNation.text;
        citizen.card_no=_textCardNO.text;
        citizen.address=_textAddress.text;
        citizen.org_name=_textOrgName.text == nil?@"":_textOrgName.text;
        citizen.profession = self.textProfession.text;
        citizen.org_principal_duty = self.textOrgPrincipalDuty.text == nil ? @"" : self.textOrgPrincipalDuty.text;
        citizen.tel_number=_textTelNumber.text;
        citizen.postalcode=_textPostalCode.text;
        citizen.original_home = _textOriginalHome.text;
        citizen.nationality = _textNationality.text;
        
        
        CaseInquire* caseInquire = [CaseInquire inquireForCase:self.caseID andRelation:citizen.party];
        caseInquire.relation=citizen.nexus;
        caseInquire.answerer_name = citizen.party;
        caseInquire.sex=citizen.sex;
        caseInquire.age=citizen.age;
        caseInquire.company_duty=[NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.org_principal_duty?citizen.org_principal_duty:@""];
        caseInquire.phone=citizen.tel_number;
        caseInquire.postalcode=citizen.postalcode;
        caseInquire.address=citizen.address;
        
        
        [[AppDelegate App] saveContext];
       
    }
     [self loadCitizenInfoForCase:caseID andNexus:self.textNexus.text];
}

-(void)loadCitizenInfoForCase:(NSString *)caseID andNexus:(NSString *)nexus{
   

    {
        //姓名
        self.textParty.text = @"";
        //当事人
        self.textNexus.text = @"当事人";
        //性别
        self.textSex.selectedSegmentIndex = 0;
        //年龄
        self.textAge.text = @"30";
        //民族
        self.textNation.text = @"汉";
        //证件号码
        self.textCardNO.text = @"";
        //地址
        self.textAddress.text = @"";
        //工作单位
        self.textOrgName.text = @"";
        //职业
        self.textProfession.text = @"司机";
        //职务
        self.textOrgPrincipalDuty.text = @"司机";
        
        //电话
        self.textTelNumber.text = @"";
        
        //邮编
        self.textPostalCode.text = @"";
        
        //籍贯
        self.textOriginalHome.text = @"广东";
        
        //国籍
        self.textNationality.text = @"中国";
    }

    _caseID=caseID;
    if (!caseID || [caseID isEmpty]) {
        return;
    }    
    
    Citizen *citizen=[Citizen citizenByCaseID:caseID andNexus:nexus];
    if (citizen){
        _textParty.text=citizen.party;
        self.textNexus.text = citizen.nexus;
        if([citizen.sex isEqualToString:@"男"]){
            _textSex.selectedSegmentIndex=0;
        } else if ([citizen.sex isEqualToString:@"女"]) {
            _textSex.selectedSegmentIndex=1;
        }
        _textAge.text=(citizen.age.integerValue==0)?@"":[NSString stringWithFormat:@"%d",citizen.age.integerValue];
        self.textNation.text=citizen.nation;
        self.textCardNO.text=citizen.card_no;
        self.textAddress.text=citizen.address;
        self.textOrgName.text = citizen.org_name;
        self.textProfession.text=citizen.profession;
        self.textOrgPrincipalDuty.text = citizen.org_principal_duty;
        self.textTelNumber.text = citizen.tel_number;
        self.textPostalCode.text = citizen.postalcode;
        self.textOriginalHome.text = citizen.original_home;
        self.textNationality.text = citizen.nationality;
    } else {
        self.textNexus.text=nexus;
    }
}

-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text = @"";
        }
    }
    self.textNexus.text = @"当事人";
    self.textAge.text = @"30";
    self.textNation.text = @"汉";
    self.textOrgPrincipalDuty.text = @"司机";
    self.textOriginalHome.text = @"广东";
    self.textNationality.text = @"中国";
    self.textProfession.text = @"司机";
}

@end
