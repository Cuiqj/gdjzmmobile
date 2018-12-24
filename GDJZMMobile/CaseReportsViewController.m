//
//  CaseReportsViewController.m
//  GDJZMMobile
//
//  Created by quxiuyun on 14-3-14.
//
//

#import "CaseReportsViewController.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "RoadSegment.h"
#import "CaseEnd.h"
#import "CaseDeformation.h"
#import "UserInfo.h"
#import "UserPickerViewController.h"
#import "DateSelectController.h"

@interface CaseReportsViewController () <UserPickerDelegate,UITextFieldDelegate,DatetimePickerHandler>
{
    NSInteger currentTag;
}

@property (nonatomic, retain) CaseEnd *caseEndInfo;
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;

@property (nonatomic,strong) UIPopoverController *pickerPopover; // 选择器

@end

@implementation CaseReportsViewController

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
    [super viewDidLoad];
    self.textPromoterName2.delegate = self;
	// Do any additional setup after loading the view.
    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    
        NSArray *caseInvestigates = [CaseEnd CaseEndForCaseId:self.caseID];
        if (caseInvestigates.count>0) {
            self.caseEndInfo = [caseInvestigates objectAtIndex:0];
        } else {
            self.caseEndInfo = [CaseEnd newCaseEndWithCaseId:self.caseID];
            [self generateDefaultsForCaseEnd:self.caseEndInfo];
            [[AppDelegate App] saveContext];
        }
        
        [self pageLoadInfo];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextPromoterSignature:nil];
    [self setLabelYear:nil];
    [self setLabelMonth:nil];
    [self setLabelDay:nil];
    [self setTextSignTime:nil];
    [super viewDidUnload];
}

#pragma mark - 

- (void)generateDefaultsForCaseEnd:(CaseEnd *)caseEndInfo{
    
    //案件承办人名字
    NSString *currentUserName=[[UserInfo userInfoForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]] valueForKey:@"username"];
    caseEndInfo.clerk= currentUserName;
    
    //执行情况，金额
    NSArray *temp=[Citizen allCitizenNameForCase:self.caseID];
    NSArray *citizenList=[[temp valueForKey:@"automobile_number"] mutableCopy];
    
    NSArray *deformArray = [CaseDeformation deformationsForCase:self.caseID forCitizen:[citizenList objectAtIndex:0]];
    double summary = 0.0;
    if (citizenList.count > 0) {
       
        summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    }
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    NSString * money = [NSString stringWithFormat:@"%@",numString];
    //当前时间
    NSDate *now = [NSDate date];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:now];
    caseEndInfo.execute_circs = [NSString stringWithFormat:@"当事人已于%@缴纳赔（补）偿金额%@",curTime,money];
    
    // 路产
    NSString *deformsString=@"";
    if (deformArray.count>0) {
        
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
    }

    // 赔补偿决定,姓名，
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" caseId:self.caseID];
    //当事人姓名
    NSString * partiesConcernedName = citizen.party;
    //缺少损坏路段
    caseEndInfo.transact_decision = [NSString stringWithFormat:@"当事人%@损坏路产%@事实清楚，依法应赔偿路产损失费共计%@",partiesConcernedName,deformsString,money];
    
    // 签字时间
    caseEndInfo.date_underwrite = [NSDate date];
    
    [[AppDelegate App] saveContext];
}


-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"ProveInfoTable"];
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
    self.textPromoterName1.text = [[UserInfo userInfoForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]] valueForKey:@"username"];
    
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    //修改的名字
    self.textPromoterName2.text = [inspectorArray firstObject];
    //[[UserInfo userInfoForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY]] valueForKey:@"username"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textSignTime.text = [dateFormatter stringFromDate:self.caseEndInfo.date_underwrite];
    
    //案件承办人证件号(执法证号)
    UserInfo * userinfo =[UserInfo userInfoForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY]];
    self.textID1.text = userinfo.exelawid;
//    NSString *t = [[NSUserDefaults standardUserDefaults] objectForKey:USERKEY];
//    NSLog(@"%@",t);
//    UserInfo * userinfo2 =[UserInfo userInfoForUserID:@"24828209"];
//    self.textID2.text = userinfo2.exelawid;
    NSArray *data=[UserInfo allUserInfo];
    for (UserInfo *user in data) {
            NSString *userName = [user valueForKey:@"username"];
            NSString *userID = [user valueForKey:@"myid"];
            if ([userName isEqualToString:self.textPromoterName2.text]) {
                 
                // self.textPromoterName2.text = name;
                self.textID2.text = [UserInfo userInfoForUserID:userID].exelawid;
        }
    }

    
    
    self.textImplementation.text = self.caseEndInfo.execute_circs;
    
    self.textDecision.text = self.caseEndInfo.transact_decision;
}

- (void)pageSaveInfo
{
    
    //案号
//    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    
    
//    self.textMark2.text = caseInfo.case_mark2;
//    self.textMark3.text = caseInfo.full_case_mark3;
    
    //案由
    self.caseProveInfo.case_short_desc = self.textcase_short_desc.text;
    
    [[AppDelegate App] saveContext];
    
}

- (NSString *)templateNameKey
{
    return DocNameKeyPei_AnJianJieAnBaoGao;
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
    
    // 案件承办人员信息（姓名及证件号）
    id caseUserData = @{@"peopleName":self.textPromoterName1.text?:@"",@"peopleId":self.textID1.text?:@""};
    id caseUserData2 = @{@"peopleName":self.textPromoterName2.text?:@"",@"peopleId":self.textID2.text?:@""};
    
    //    self.labelYear.text =[[NSString alloc] initWithFormat:@"%d",year];
    //    self.labelMonth.text =[[NSString alloc] initWithFormat:@"%d",month];
    //    self.labelDay.text =[[NSString alloc] initWithFormat:@"%d",day];
    id dateData = @{@"year":self.labelYear.text?:@"",
                    @"month":self.labelMonth.text?:@"",
                    @"day":self.labelDay.text?:@""};
    
    // 结案报告信息
    id caseReportData = @{  @"caseReason":self.textcase_short_desc.text?:@"", // 案由
                            @"resultContent":self.textDecision.text?:@"", // 赔补偿决定
                            @"executionContent":self.textImplementation.text?:@"", // 执行情况
                            @"date":dateData,
                            @"remark":self.textNote.text?:@"" // 备注
                            };
    
    id data = @{
                @"case": caseData,
                @"caseUserData":caseUserData,
                @"caseUserData2":caseUserData2,
                @"caseReportData":caseReportData,
                };
    return data;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentTag = textField.tag;
    switch (textField.tag) {
        case 100://日期选择
        case 101:// 选择调查人
        case 102:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

#pragma mark - 选择调查人

- (IBAction)userSelect:(UITextField *)sender {
    //    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker = [[UserPickerViewController alloc] init];
        acPicker.delegate = self;
        self.pickerPopover = [[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover = self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    switch (currentTag) {
        case 101:// 选择调查人
            self.textPromoterName1.text = name;
            self.textID1.text = [UserInfo userInfoForUserID:userID].exelawid;
            break;
        case 102:
            self.textPromoterName2.text = name;
            self.textID2.text = [UserInfo userInfoForUserID:userID].exelawid;
            break;
        default:
            break;
    }
    
}

//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toDateTimePicker3"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=0;
        dsVC.textFieldTag = self.textSignTime.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.caseProveInfo.start_date_time];
    }
}

//日期选择器
- (IBAction)selectDateAndTime:(UITextField *)sender
{
    UITextField* textField = (UITextField* )sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker3" sender:self];
            break;
        default:
            break;
    }
}

- (void)setPastDate:(NSDate *)date withTag:(int)tag
{
    if (tag == self.textSignTime.tag) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.caseEndInfo.date_underwrite = date;
        
        self.textSignTime.text = [dateFormatter stringFromDate:date];
    }
}



@end
