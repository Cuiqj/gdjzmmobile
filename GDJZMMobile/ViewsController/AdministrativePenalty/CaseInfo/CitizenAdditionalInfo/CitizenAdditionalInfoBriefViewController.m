//
//  AccInfoBriefViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CitizenAdditionalInfoBriefViewController.h"
#import "Systype.h"
#import "UserInfo.h"
#import "CasePrintViewController.h"
#import "CaseInfoPickerViewController.h"

@interface CitizenAdditionalInfoBriefViewController (){
    //TextField点击标识
    //车辆类型=1；损坏程度=2
    NSInteger textIndex;
}
@property (nonatomic,retain) UIPopoverController *pickerPopover;
-(void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;
-(void)saveParkingNodeForCase:(NSString *)caseID;
@end

@implementation CitizenAdditionalInfoBriefViewController

@synthesize caseID =_caseID;
@synthesize labelParkingLocation = _labelParkingLocation;
@synthesize textParkingLocation = _textParkingLocation;
@synthesize swithIsParking = _swithIsParking;
@synthesize delegate=_delegate;
@synthesize pickerPopover=_pickerPopover;




- (void)viewDidLoad
{
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
    self.textParkingLocation.placeholder = [Systype typeValueForCodeName:@"停车地点"].count>0 ? [[Systype typeValueForCodeName:@"停车地点"] objectAtIndex:0] : @"";
    textIndex=-1;
    [super viewDidLoad];



}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [self setLabelParkingLocation:nil];
    [self setTextParkingLocation:nil];
    [self setSwithIsParking:nil];

    textIndex=-1;
	[self setTextCarownerAddress:nil];
	[self setTextOrgPrincipal:nil];
	[self setTextOrgTelNumber:nil];
	[self setTextAutomobileNumber:nil];
	[self setTextAutomobilePattern:nil];
	[self setTextBadDesc:nil];
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}





//是否停驶
- (IBAction)parkingChanged:(UISwitch *)sender {
    CGFloat alpha=sender.isOn?1.0:0.0;
    [UIView transitionWithView:self.view 
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut 
                    animations:^{
                        self.labelParkingLocation.alpha=alpha;

                        self.textParkingLocation.alpha=alpha;
                    } 
                    completion:nil];
}





//将当前页面显示数据保存至该caseID下
-(void)saveDataForCase:(NSString *)caseID{
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    if (!caseProveInfo){
        if (![caseID isEmpty]){
            caseProveInfo = [CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
            caseProveInfo.caseinfo_id=caseID;
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
            if (inspectorArray.count < 1) {
                caseProveInfo.prover = currentUserName;
            } else {
                NSString *inspectorName = @"";
                for (NSString *name in inspectorArray) {
                    if ([inspectorName isEmpty]) {
                        inspectorName = name;
                    } else {
                        inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
                    }
                }
                caseProveInfo.prover = inspectorName;
            }
            caseProveInfo.recorder = currentUserName;
        }
    }
    [self saveParkingNodeForCase:caseID];
    [[AppDelegate App] saveContext];
}



//根据caseID载入相应
-(void)loadDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    if (caseInfo) {
 
    }    
    [self loadParkingNodeForCase:caseID];
}


-(void)newDataForCase:(NSString *)caseID{
    self.caseID = caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text = @"";
        }
    }
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
}

-(void)saveParkingNodeForCase:(NSString *)caseID{
    [ParkingNode deleteAllParkingNodeForCase:caseID];
    if (self.swithIsParking.isOn) {
        if (![self.textAutomobileNumber.text isEmpty]) {
            if ([self.textParkingLocation.text isEmpty]) {
                self.textParkingLocation.text=self.textParkingLocation.placeholder;
            }
            
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            NSString *startTime = [dateFormatter stringFromDate:[NSDate date]];
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:7];
            NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:startTime] options:0];
            NSString *endTime = [dateFormatter stringFromDate:endDate];
            
            NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
            [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
            [codeFormatter setLocale:[NSLocale currentLocale]];
            if (![self.textAutomobileNumber.text isEmpty]) {
                ParkingNode *parkingNode=[ParkingNode newDataObjectWithEntityName:@"ParkingNode"];
                parkingNode.date_send = [NSDate date];
                parkingNode.code = [codeFormatter stringFromDate:parkingNode.date_send];
                parkingNode.caseinfo_id=caseID;
                parkingNode.citizen_name = self.textOrgPrincipal.text;
                parkingNode.date_end = [dateFormatter dateFromString: startTime];
                parkingNode.date_start = [dateFormatter dateFromString: endTime];
                parkingNode.address=self.textParkingLocation.text;
                [[AppDelegate App] saveContext];
            }

            codeFormatter = nil;

        } else {
            self.textParkingLocation.text=@"";
        }
    }
}

-(void)loadParkingNodeForCase:(NSString *)caseID{
    if (![caseID isEmpty]) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id ==%@",caseID];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        fetchRequest.predicate=predicate;
        fetchRequest.entity=entity;
        NSArray *parkingArray=[context executeFetchRequest:fetchRequest error:nil];
        if (parkingArray.count>0) {
            [self.swithIsParking setOn:YES];
            NSString *citizen=@"";
            for (id parkingNode in parkingArray) {
                if ([citizen isEmpty]) {
                    citizen=[citizen stringByAppendingString:[parkingNode valueForKey:@"citizen_name"]];
                } else {
                    citizen=[citizen stringByAppendingFormat:@"、%@",[parkingNode valueForKey:@"citizen_name"]];
                }
            }

            ParkingNode *parkingNode=[parkingArray objectAtIndex:0];
            self.textParkingLocation.text=parkingNode.address;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [self parkingChanged:self.swithIsParking];
        } else {
            [self.swithIsParking setOn:NO];
            [self parkingChanged:self.swithIsParking];
        }
    } else {
        [self.swithIsParking setOn:NO];
        [self parkingChanged:self.swithIsParking];
    }
}





//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate scrollViewNeedsMove];
}

#pragma mark -- 弹窗
//弹出损坏程度选择框
- (IBAction)selectBadDesc:(id)sender {
    [self pickerPresentForIndex:2 fromRect:[(UITextField*)sender frame]];
}


//弹出车辆类型选择框
- (IBAction)selectAutomobilePattern:(id)sender {
    [self pickerPresentForIndex:1 fromRect:[(UITextField*)sender frame]];
}



//弹窗
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex == textIndex) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        textIndex = iIndex;
        CaseInfoPickerViewController *acPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
        acPicker.pickerType = iIndex;
        acPicker.delegate = self;
        self.pickerPopover = [[UIPopoverController alloc] initWithContentViewController:acPicker];
        switch (iIndex) {
            case 1:{
                [self.pickerPopover setPopoverContentSize:CGSizeMake(170,308)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 170, 308)];
            }
                break;
            case 2:{
                [self.pickerPopover setPopoverContentSize:CGSizeMake(100, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 100, 176)];
            }
                break;
            default:
                break;
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}


-(void)setAuotMobilePattern:(NSString *)textPattern{
    self.textAutomobilePattern.text = textPattern;
}

-(void)setBadDesc:(NSString *)textBadDesc{
    self.textBadDesc.text = textBadDesc;
}
@end
