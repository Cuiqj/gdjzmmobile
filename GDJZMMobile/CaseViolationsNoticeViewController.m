//
//  ViolationsNoticeViewController.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "CaseViolationsNoticeViewController.h"
#import "CaseProveInfo.h"
#import "CaseViolationsNotice.h"

@interface CaseViolationsNoticeViewController ()

@property (strong, nonatomic) CaseViolationsNotice *caseViolationsNotice;

@end

@implementation CaseViolationsNoticeViewController

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
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    [super viewDidLoad];
    [super setCaseID:self.caseID];
    
    if ([self.caseID isEmpty]){
        return;
    }
    self.caseViolationsNotice = [CaseViolationsNotice caseViolationsNoticeFoCaseId:self.caseID];
    if (!self.caseViolationsNotice){
        self.caseViolationsNotice = [CaseViolationsNotice newCaseViolationsNoticeWithCaseId:self.caseID];
    }
    [self.caseViolationsNotice update];
    [self pageLoadInfo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCaseNumTextField:nil];
    [self setInformingDepartmentTextField:nil];
    [self setInformingDateTextField:nil];
    [self setInformingMethodTextField:nil];
    [self setTimeTextField:nil];
    [self setLocationTextField:nil];
    [self setCaseBaseContentTextView:nil];
    [self setSuggestingTextView:nil];
    [self setReceptionPersonTextField:nil];
    [self setLinkmanTextField:nil];
    [self setPhoneTextField:nil];
    [self setFaxTextField:nil];
    [super viewDidUnload];
}

- (void)pageLoadInfo
{
    
    [self informingDepartmentTextField].text = NSStringNilIsBad([self caseViolationsNotice].informingDepartment);
    [self informingDateTextField].text = NSStringNilIsBad([self caseViolationsNotice].informingDate);
    [self informingMethodTextField].text = NSStringNilIsBad([self caseViolationsNotice].informingMethod);
    [self locationTextField].text = NSStringNilIsBad([self caseViolationsNotice].location);
    [self caseBaseContentTextView].text = NSStringNilIsBad([self caseViolationsNotice].caseBaseContent);
    [self suggestingTextView].text = NSStringNilIsBad([self caseViolationsNotice].suggesting);
    [self receptionPersonTextField].text = NSStringNilIsBad([self caseViolationsNotice].receptionPerson);
    [self linkmanTextField].text = NSStringNilIsBad([self caseViolationsNotice].linkman);
    [self phoneTextField].text = NSStringNilIsBad([self caseViolationsNotice].phone);
    [self faxTextField].text = NSStringNilIsBad([self caseViolationsNotice].fax);
    [self caseNumTextField].text = NSStringNilIsBad([self caseViolationsNotice].full_case_mark3);
    [self timeTextField].text = NSStringNilIsBad([self caseViolationsNotice].time);
}

- (void)pageSaveInfo
{
    
    [self caseViolationsNotice].informingDepartment = NSStringNilIsBad([self informingDepartmentTextField].text);
    [self caseViolationsNotice].informingDate = NSStringNilIsBad([self informingDateTextField].text);
    [self caseViolationsNotice].informingMethod = NSStringNilIsBad([self informingMethodTextField].text);
    [self caseViolationsNotice].location = NSStringNilIsBad([self locationTextField].text);
    [self caseViolationsNotice].caseBaseContent = NSStringNilIsBad([self caseBaseContentTextView].text);
    [self caseViolationsNotice].suggesting = NSStringNilIsBad([self suggestingTextView].text);
    [self caseViolationsNotice].receptionPerson = NSStringNilIsBad([self receptionPersonTextField].text);
    [self caseViolationsNotice].linkman = NSStringNilIsBad([self linkmanTextField].text);
    [self caseViolationsNotice].phone = NSStringNilIsBad([self phoneTextField].text);
    [self caseViolationsNotice].fax = NSStringNilIsBad([self faxTextField].text);
    [self caseViolationsNotice].full_case_mark3 = NSStringNilIsBad([self caseNumTextField].text);
    [self caseViolationsNotice].time = NSStringNilIsBad([self timeTextField].text);
    [[AppDelegate App] saveContext];
}

- (NSString *)templateNameKey
{
    return DocNameKeyFa_GongLuWeiFaAnJianGaoZhiBiao;
}

- (id)dataForPDFTemplate
{
    id data = @{
                @"case_mark2":NSStringNilIsBad([self caseViolationsNotice].case_mark2),
                @"full_case_mark3":NSStringNilIsBad([self caseViolationsNotice].full_case_mark3),
                @"informingDepartment":NSStringNilIsBad([self caseViolationsNotice].informingDepartment),
                @"informingDate":NSStringNilIsBad([self caseViolationsNotice].informingDate),
                @"informingMethod":NSStringNilIsBad([self caseViolationsNotice].informingMethod),
                @"time":NSStringNilIsBad([self caseViolationsNotice].time),
                @"location":NSStringNilIsBad([self caseViolationsNotice].location),
                @"caseBaseContent":NSStringNilIsBad([self caseViolationsNotice].caseBaseContent),
                @"suggesting":NSStringNilIsBad([self caseViolationsNotice].suggesting),
                @"receptionPerson":NSStringNilIsBad([self caseViolationsNotice].receptionPerson),
                @"linkman":NSStringNilIsBad([self caseViolationsNotice].linkman),
                @"phone":NSStringNilIsBad([self caseViolationsNotice].phone),
                @"fax":NSStringNilIsBad([self caseViolationsNotice].fax)
                };
    return data;
    
}
@end
