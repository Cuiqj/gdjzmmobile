//
//  ForceNoticePrintViewController.m
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/7/13.
//
//

#import "ForceNoticePrintViewController.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "CaseChangeNotice.h"
#import "CaseInquire.h"
#import "RoadSegment.h"
#import "AtonementNotice.h"
#import "Systype.h"
#import "Citizen.h"
#import "CaseProveInfo.h"
@interface ForceNoticePrintViewController ()
@property (nonatomic, retain) CaseInquire *caseInquire;
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, retain) CaseChangeNotice *caseChangeNotice;
@end

@implementation ForceNoticePrintViewController
@synthesize textlineMan = _textlinkMan;
@synthesize textlineTel = _textlinkTel;


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
    self.caseInquire = [CaseInquire inquireForCase:self.caseID];
    [self pageLoadInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pageLoadInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    self.anhao.text = [[NSString alloc] initWithFormat:@"%@-%@",caseInfo.case_mark2, caseInfo.full_case_mark3];
    self.behavior.text = proveInfo.case_short_desc;
    RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    if (roadSegment) {
       self.road.text = roadSegment.place_prefix1;
    }

    NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
    if (typeValues.count > 0) {
        NSString *typeValue = typeValues[0];
        [self.limitday setText:typeValue];
    } else {
        [self.limitday setText:@"七"];
    }
    if (citizen) {
    
        self.sendname.text = citizen.org_name;
    }
    self.change.text = @"恢复原状";
    
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
    return DocNameKeyFa_SheXianWeiFaXingWeiGaoZhiShu;
}

-(id)dataForPDFTemplate
{
    
    NSString *anhao = @"";
    NSString *sendname = @"";
    NSString *road = @"";
    NSString *behavior = @"";
//    NSString *tiao = @"";
//    NSString *kuan = @"";
//    NSString *limitday = @"";
//    NSString *change = @"";
//    NSString *textlineMan = @"";
//    NSString *textlineTel = @"";
//    NSString *phones = @"";
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    anhao = [[NSString alloc] initWithFormat:@"%@-%@",caseInfo.case_mark2, caseInfo.full_case_mark3];
    
    RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    sendname = citizen.org_name;
    if (roadSegment) {
        road = roadSegment.place_prefix1;
    }
    if (proveInfo) {
         behavior = proveInfo.case_short_desc;
    }
   
    if (citizen) {
        
        self.sendname.text = citizen.org_name;
    }
//    tiao = self.tiao.text;
//    kuan = self.kuan.text;
//    limitday = self.limitday.text;
//    change = self.change.text;
//    textlineMan = self.textlineMan.text;
//    textlineTel = self.textlineTel.text;
//    phones = self.Phones.text;
    return @{
             @"anhao": anhao,
             @"sendname":sendname,
             @"road": road,
             @"behavior" : behavior,
//             @"tiao" : tiao,
//             @"kuan": kuan,
//             @"limitday": limitday,
//             @"change": change,
//             @"textlineMan": textlineMan,
//             @"textlineTel": textlineTel,
//             @"phones": phones
             };
}
- (void)pageSaveInfo{
    
    self.caseChangeNotice.sendname = self.sendname.text;
    self.caseChangeNotice.road = self.road.text;
    self.caseChangeNotice.behavior = self.behavior.text;
    self.caseChangeNotice.limitday = self.limitday.text;
    self.caseChangeNotice.change = self.change.text;
	[[AppDelegate App] saveContext];
}

- (void)viewDidUnload {
    [self setSendname:nil];
    [self setBehavior:nil];
    [self setBehavior:nil];
    [self setTiao:nil];
    [self setKuan:nil];
    [self setRoad:nil];
    [self setLimitday:nil];
    [self setChange:nil];
    [self setTextlineMan:nil];
    [self setTextlineTel:nil];
    [self setAnhao:nil];
    [self setPhone:nil];
    [self setPhones:nil];
    [super viewDidUnload];
}
@end
