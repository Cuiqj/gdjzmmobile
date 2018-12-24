//
//  CaseParkingNodePrintViewController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CaseParkingNodePrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "ParkingNode.h"
#import "CaseProveInfo.h"
#import "Systype.h"
#import "OrgInfo.h"

typedef enum _kTextFieldTag {
    kTextFieldTagCitizenName = 0x10,
    kTextFieldTagHappenDate,
    kTextFieldTagAutoMobileNumber,
    kTextFieldTagPlacePrefix,
    kTextFieldTagStationStart,
    kTextFieldTagCaseShortDescription,
    kTextFieldTagParkingNodeAddress,
    kTextFieldTagPeriodLimit,
    kTextFieldTagOfficeAddress
} kTextFieldTag;

@interface CaseParkingNodePrintViewController () <UITextFieldDelegate>

@end

@implementation CaseParkingNodePrintViewController

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
	// Do any additional setup after loading the view.
    [self assignTagsToUIControl];
    [self pageLoadInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldCitizenName:nil];
    [self setTextFieldHappenDate:nil];
    [self setTextFieldAutomobileNumber:nil];
    [self setTextFieldPlacePrefix:nil];
    [self setTextFieldStationStart:nil];
    [self setTextFieldCaseShortDescription:nil];
    [self setTextFieldParkingNodeAddress:nil];
    [self setTextFieldPeriodLimit:nil];
    [self setTextFieldOfficeAddress:nil];
    [self setLabelSendDate:nil];
    [super viewDidUnload];
}


- (void)assignTagsToUIControl
{
    self.textFieldCitizenName.tag = kTextFieldTagCitizenName;
    self.textFieldHappenDate.tag = kTextFieldTagHappenDate;
    self.textFieldAutomobileNumber.tag = kTextFieldTagAutoMobileNumber;
    self.textFieldPlacePrefix.tag = kTextFieldTagPlacePrefix;
    self.textFieldStationStart.tag = kTextFieldTagStationStart;
    self.textFieldCaseShortDescription.tag = kTextFieldTagCaseShortDescription;
    self.textFieldParkingNodeAddress.tag = kTextFieldTagParkingNodeAddress;
    self.textFieldPeriodLimit.tag = kTextFieldTagPeriodLimit;
    self.textFieldOfficeAddress.tag = kTextFieldTagOfficeAddress;
}

- (void)loadParkingInfoWithAutomobileNumber:(NSString *)automobileNumber
{
    
    [self.textFieldCitizenName setText:@""];
    [self.textFieldParkingNodeAddress setText:@""];
    [self.labelSendDate setText:@""];
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        Citizen * citizen = [Citizen citizenForName:automobileNumber nexus:@"当事人" caseId:self.caseID];
        if (citizen) {
            [self.textFieldCitizenName setText:citizen.party];
        } 
                      
        NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
        if (parkings.count > 0) {
            for (ParkingNode *parking in parkings) {
                if ([parking.citizen_name isEqualToString:automobileNumber]) {
                    [self.textFieldParkingNodeAddress setText:parking.address];
                    NSDate *sendDate = parking.date_send;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                    [dateFormatter setLocale:[NSLocale currentLocale]];
                    NSString *dateString = [dateFormatter stringFromDate:sendDate];
                    [self.labelSendDate setText:dateString];
                }
            }
        }
        
    }
}

#pragma mark - Methods from superclass

- (void)pageLoadInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
        [self.textFieldHappenDate setText:dateString];
        
        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
            [self.textFieldPlacePrefix  setText:roadSegment.place_prefix1];
        }
        
        [self.textFieldStationStart setText:[caseInfo fullCaseMarkAfterK:NO]];
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            [self.textFieldCaseShortDescription setText:caseProveInfo.case_short_desc];
        }
        
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            [self.textFieldPeriodLimit setText:typeValue];
        } else {
            [self.textFieldPeriodLimit setText:@"七"];
        }
        
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo) {
            [self.textFieldOfficeAddress setText:orgInfo.orgshortname];
        }
    
    }
}

- (BOOL)shouldGenereateDefaultDoc {
    return NO;
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
   
    return DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu;
}

- (id)dataForPDFTemplate
{
    
    NSString *citizenName = @"";
    id happenDate = @{};
    NSString *automobileNumber = @"";
    NSString *placePrefix = @"";
    NSString *stationStart = @"";
    NSString *caseDescription = @"";
    NSString *parkingAddress = @"";
    NSString *periodLimit = @"";
    NSString *officeAddress = @"";
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        Citizen * citizen = [Citizen citizenForName:self.textFieldAutomobileNumber.text nexus:@"当事人" caseId:self.caseID];
        if (citizen) {
            citizenName = citizen.party;
            automobileNumber = citizen.automobile_number;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
        NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日"]];
        if (dateComponents.count > 2) {
            happenDate = @{
                           @"year": dateComponents[0],
                           @"month": dateComponents[1],
                           @"day": dateComponents[2],
                           };
        }
        
        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
            placePrefix = roadSegment.place_prefix1;
        }
        
        stationStart = [caseInfo fullCaseMarkAfterK:NO];
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            caseDescription = caseProveInfo.case_short_desc;
        }
        
        NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
        if (parkings.count > 0) {
            for (ParkingNode *parking in parkings) {
                if ([parking.citizen_name isEqualToString:self.textFieldAutomobileNumber.text]) {
                    parkingAddress = parking.address;
                }
            }
        }
        
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            periodLimit = typeValue;
        } else {
            periodLimit = @"七";
        }
        
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo) {
            officeAddress = orgInfo.orgshortname;
        }
        
    }
    return @{
             @"citizenName": citizenName,
             @"happenDate": happenDate,
             @"automobileNumber": automobileNumber,
             @"placePrefix": placePrefix,
             @"stationStart": stationStart,
             @"caseDescription": caseDescription,
             @"parkingAddress": parkingAddress,
             @"periodLimit": periodLimit,
             @"officeAddress": officeAddress,
             };
}

#pragma mark - ListSelectPopoverDelegate

- (void)setSelectData:(NSString *)data {
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (self.popoverIndex == textField.tag) {
                [textField setText:data];
                [textField resignFirstResponder];
            }
        }
    }
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kTextFieldTagAutoMobileNumber) {
        [self loadParkingInfoWithAutomobileNumber:textField.text];
    }
}


#pragma mark - IBAction

- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender {
    
    ListSelectViewController *listSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
    listSelectViewController.delegate = self;
    NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
    listSelectViewController.data = [parkings valueForKeyPath:@"@unionOfObjects.citizen_name"];
    
    if ([self.popover isPopoverVisible] && (self.popoverIndex != sender.tag)) {
        [self.popover dismissPopoverAnimated:YES];
        return;
    }
    
    if (self.popover == nil) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:listSelectViewController];
    } else {
        [self.popover setContentViewController:listSelectViewController];
    }
    self.popoverIndex = sender.tag;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.popover setPopoverContentSize:CGSizeMake(CGRectGetWidth(listSelectViewController.view.bounds), 100) animated:YES];

}
@end
