//
//  CaseReserachViewController.m
//  GDJZMMobile
//
//  Created by quxiuyun on 14-3-14.
//
//

#import "CaseReserachViewController.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInvestigate.h"
#import "UserInfo.h"
#import "UserPickerViewController.h"
#import "CaseDeformation.h"
#import "AtonementNoticePrintViewController.h"

@interface CaseReserachViewController () <UserPickerDelegate,UITextFieldDelegate>
{
    NSArray *investigatorTextFields;
    NSArray *investigatorIDTextFields;
}

@property (weak, nonatomic) UITextField *currentTextField;
@property (nonatomic, retain) CaseInvestigate *caseInvestigateInfo;
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;

@property (nonatomic,strong) UIPopoverController *pickerPopover; // 选择器

@end

@implementation CaseReserachViewController

@synthesize caseID = _caseID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super setCaseID:self.caseID];
	// Do any additional setup after loading the view.
    
    investigatorIDTextFields = @[_textID1,_textID2,_textID3];
    investigatorTextFields = @[_textInvestigator1,_textInvestigator2,_textInvestigator3];
    
    if (![self.caseID isEmpty]) {
        
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if ([self.caseProveInfo.event_desc isEmpty] || self.caseProveInfo.event_desc == nil) {
            self.caseProveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
        }
        
        NSArray *caseInvestigates = [CaseInvestigate CaseInvestigateForCaseId:self.caseID];
        if (caseInvestigates.count>0) {
            self.caseInvestigateInfo = [caseInvestigates objectAtIndex:0];
        } else {
            self.caseInvestigateInfo = [CaseInvestigate newCaseInvestigateWithCaseId:self.caseID];
            [self generateDefaultsForCaseInvestigate:self.caseInvestigateInfo];
            [[AppDelegate App] saveContext];
        }
        
        [self pageLoadInfo];
        
    }
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    self.view.frame = CGRectMake(CGRectGetMinX(frame)-25, CGRectGetMinY(frame), 946, 1050);
}


#pragma mark -

- (void)generateDefaultsForCaseInvestigate:(CaseInvestigate *)investigateInfo{
    
    Citizen *citizen = [Citizen citizenForCitizenName:@"" nexus:@"当事人" caseId:self.caseID];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *payReason = @"";
    NSString *breakStr = @"";
    NSString *matchStr = @"";
    NSString *payStr = @"";
    if (matchLaws) {
        NSArray *lawids = [self.caseProveInfo.case_desc_id componentsSeparatedByString:@"#"];
        NSString *lawid = @"";
        if (lawids.count > 0){
            lawid = lawids[0];
        }
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:lawid];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        NSArray *temp=[Citizen allCitizenNameForCase:self.caseID];
        NSArray *citizenList=[[temp valueForKey:@"automobile_number"] mutableCopy];
        
        double summary = 0.0;
        if (citizenList.count > 0) {
            NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:[citizenList objectAtIndex:0]];
            summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
        }
        NSNumber *sumNum = @(summary);
        NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
        
        payReason = [NSString stringWithFormat:@"%@%@，根据%@、并依照%@的规定，当事人应当承担民事责任，拟责令其赔偿路产损失费共计%@。",citizen.party, self.caseProveInfo.case_short_desc, matchStr, payStr,numString];
        
    }
    [[AppDelegate App] saveContext];
    
    
    //-----------------------
    
    //案件承办人名字
    NSString *currentUserName=[[UserInfo userInfoForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]] valueForKey:@"username"];
    investigateInfo.investigater_name = currentUserName;
    
    //经过及结论
    investigateInfo.course = NSStringNilIsBad(self.caseProveInfo.event_desc);
    investigateInfo.conclusion = NSStringNilIsBad(payReason);
    investigateInfo.obey_laws = matchStr;
    investigateInfo.disobey_laws = breakStr;
    
    // 证据材料
    investigateInfo.witness = @"现场照片、勘验检查笔录、询问笔录、现场勘验图";
    
    // 签字时间
    investigateInfo.leader_date = [NSDate date];
    
    [[AppDelegate App] saveContext];
}

-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    [self pageSaveInfo];
    
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"toCaseReserachVC"];
        for (UITextView * aTextView in [self.view subviews]) {
            if ([aTextView isKindOfClass:[UITextView class]]) {
                [aTextView.text drawInRect:aTextView.frame withFont:aTextView.font];
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFullPDFWithPath_deprecated:(NSString *)filePath{
    [self pageSaveInfo];

    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"toCaseReserachVC"];
        for (UITextView * aTextView in [self.view subviews]) {
            if ([aTextView isKindOfClass:[UITextView class]]) {
                [aTextView.text drawInRect:aTextView.frame withFont:aTextView.font];
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)pageLoadInfo
{
    //案号
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    
    
    self.textMark2.text = caseInfo.case_mark2;
    self.textMark3.text = caseInfo.full_case_mark3;
    
    //案由
    self.textcase_short_desc.text = self.caseProveInfo.case_short_desc;
    
    //案件承办人名字
    
    NSArray *names = [self.caseInvestigateInfo.investigater_name componentsSeparatedByString:@"、"];
    
    for (int i = 0; i < names.count; i++){
        //案件承办人证件号
        UserInfo * userinfo =[UserInfo userInfoForUserName:names[i]];  
        ((UITextField *)investigatorTextFields[i]).text = names[i];
        ((UITextField *)investigatorIDTextFields[i]).text = userinfo.exelawid;
    }
    
    //经过及结论
    self.textConclusionCase.text = NSStringNilIsBad(self.caseInvestigateInfo.conclusion);
    self.textCourse.text = NSStringNilIsBad(self.caseInvestigateInfo.course);
    // 证据材料
    self.textEvidenceMaterial.text = self.caseInvestigateInfo.witness;
    
    //当事人基本情况
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" caseId:self.caseID];
    if (citizen) {
        //当事人姓名
        self.textPartiesConcernedName.text = citizen.party;
        //车牌车型
        self.textprover2_duty.text =[NSString stringWithFormat:@"%@ %@",citizen.automobile_pattern,citizen.automobile_number];
        //单位名称
        self.textUnitName.text = citizen.org_name;
        //地址
        self.textAdd.text =citizen.address;
        //车辆所在地
        self.textVehicleLocated.text= citizen.automobile_address;
        //法定代表人
        self.textRepresentative.text = citizen.org_principal;
    }
    
    // 领导意见
    self.textLeadershipOpinion.text = ![self.caseInvestigateInfo.leader_comment isEmpty]?self.caseInvestigateInfo.leader_comment:@"";
    // 备注
    self.textparty.text = ![self.caseInvestigateInfo.remark isEmpty]?self.caseInvestigateInfo.remark:@"";
}

- (void)pageSaveInfo
{
    //案号
//    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    
    //案由
    self.caseProveInfo.case_short_desc = self.textcase_short_desc.text;
    
    NSString *names = @"";
    for (int i = 0; i < 3; i++){
        NSString *name = NSStringNilIsBad(((UITextField *)investigatorTextFields[i]).text);
        if (![name isEmpty]){
            NSString *and = [names isEmpty]?names:@"、";
            names = [names stringByAppendingFormat:@"%@%@",and,name];
        }
    }
    self.caseInvestigateInfo.investigater_name = names;
    
    //经过及结论
    self.caseInvestigateInfo.conclusion = NSStringNilIsBad(self.textConclusionCase.text);
    self.caseInvestigateInfo.course = NSStringNilIsBad(self.textCourse.text);
    
    // 证据材料
//    self.notice.witness = self.textEvidenceMaterial.text;
    self.caseInvestigateInfo.witness = self.textEvidenceMaterial.text;
    
    //当事人基本情况
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" caseId:self.caseID];
    if (citizen) {
        //当事人姓名
        citizen.party = self.textPartiesConcernedName.text;
        //车牌车型
//        self.textprover2_duty.text =[NSString stringWithFormat:@"%@ %@",citizen.automobile_pattern,citizen.automobile_number];
        //单位名称
        citizen.org_name = self.textUnitName.text;
        //地址
        citizen.address = self.textAdd.text;
        //车辆所在地
        citizen.automobile_address = self.textVehicleLocated.text;
        //法定代表人
        citizen.org_principal = self.textRepresentative.text;
    }
    
    [[AppDelegate App] saveContext];
    
}

- (NSString *)templateNameKey
{
    return DocNameKeyPei_AnJianDiaoChaBaoGao;
}

- (id)dataForPDFTemplate
{
    
    // 案件号
    id caseData = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        caseData = @{
                     @"mark2": caseInfo.case_mark2,
                     @"mark3": [NSString stringWithFormat:@"%@",caseInfo.full_case_mark3],
                     @"weather": caseInfo.weater,
                     };
    }
    
    NSMutableDictionary *caseInvestigatorData = [NSMutableDictionary dictionaryWithDictionary:@{
                                                 @"peopleNameAndId1":@"",
                                                 @"peopleNameAndId2":@"",
                                                 @"peopleNameAndId3":@""}];
    // 案件调查人员信息1（姓名及证件号）
    
    if ([self.textID1.text isEmpty] && ![self.textInvestigator1.text isEmpty]){
        [caseInvestigatorData setObject:self.textInvestigator1.text?:@"" forKey:@"peopleNameAndId1"];
    }
    else if (![self.textID1.text isEmpty] && ![self.textInvestigator1.text isEmpty]){
        [caseInvestigatorData setObject:[self.textInvestigator1.text?:@"" stringByAppendingFormat:@"（%@）",self.textID1.text?:@""] forKey:@"peopleNameAndId1"];
    }
    // 案件调查人员信息2（姓名及证件号
    if ([self.textID2.text isEmpty] && ![self.textInvestigator2.text isEmpty]){
        [caseInvestigatorData setObject:self.textInvestigator2.text?:@"" forKey:@"peopleNameAndId2"];
    }
    else if (![self.textID2.text isEmpty] && ![self.textInvestigator2.text isEmpty]){
        [caseInvestigatorData setObject:[self.textInvestigator2.text?:@"" stringByAppendingFormat:@"（%@）",self.textID2.text?:@""] forKey:@"peopleNameAndId2"];
    }
    // 案件调查人员信息3（姓名及证件号
    if ([self.textID3.text isEmpty] && ![self.textInvestigator3.text isEmpty]){
        [caseInvestigatorData setObject:self.textInvestigator3.text?:@"" forKey:@"peopleNameAndId3"];
    }
    else if ([self.textID3.text isEmpty] && ![self.textInvestigator3.text isEmpty]){
        [caseInvestigatorData setObject:[self.textInvestigator3.text?:@"" stringByAppendingFormat:@"（%@）",self.textID3.text?:@""] forKey:@"peopleNameAndId3"];
    }
    
    
    // 当事人基本情况
    id caseLitigantInfoData = @{@"name":self.textPartiesConcernedName.text?:@"",// 姓名
                                @"addr":self.textAdd.text?:@"",// 地址
                                @"companyName":self.textUnitName.text?:@"", // 单位名称
                                @"orgPrincipal":self.textRepresentative.text?:@"", // 法定代表人
                                @"automobileAddr":self.textVehicleLocated.text?:@"", // 车辆所在地
                                @"automobilePatternAndNumber":self.textprover2_duty.text?:@"" // 车型、车牌号
                                };
    
    // 调查信息 
    id caseResearchData = @{@"caseReason":self.textcase_short_desc.text?:@"", // 案由
                            @"resultContent":[NSString stringWithFormat:@"%@%@",NSStringNilIsBad(self.textCourse.text),NSStringNilIsBad(self.textConclusionCase.text)], // 经过及结论
                            @"material":self.textEvidenceMaterial.text?:@"", // 证据材料
                            @"leaderOpinion":self.textLeadershipOpinion.text?:@"", // 领导意见
                            @"remark":self.textparty.text?:@"" // 备注
                            };
    
    id data = @{
                @"case": caseData,
                @"caseLitigantInfo":caseLitigantInfoData,
                @"caseInvestigator":caseInvestigatorData,
                @"caseResearch": caseResearchData,
                };
    return data;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 101:// 选择调查人1
        case 102:// 选择调查人1
        case 103:// 选择调查人1
            _currentTextField = textField;
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

#pragma mark - 选择调查人

- (IBAction)resetInvestigator:(UIButton *)sender {
    ((UITextField *)investigatorTextFields[sender.tag-201]).text = @"";
    ((UITextField *)investigatorIDTextFields[sender.tag-201]).text = @"";
}

- (IBAction)userSelect:(UITextField *)sender {
//    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    _currentTextField.text = name;
    UITextField *textID = investigatorIDTextFields[_currentTextField.tag-101];
    textID.text = [UserInfo userInfoForUserID:userID].exelawid;

}

- (void)viewDidUnload {
    investigatorIDTextFields = nil;
    investigatorTextFields = nil;
    [self setTextCourse:nil];
    [self setTextInvestigator2:nil];
    [self setTextInvestigator3:nil];
    [self setTextID2:nil];
    [self setTextID3:nil];
    [super viewDidUnload];
}

@end
