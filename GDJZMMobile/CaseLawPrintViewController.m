//
//  CaseLawPrintViewController.m
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/12/13.
//
//

#import "CaseLawPrintViewController.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "Citizen.h"
#import "CaseInquire.h"
#import "CaseProveInfo.h"
@interface CaseLawPrintViewController ()
@property (nonatomic, retain) CaseInquire *caseInquire;
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;

@end

@implementation CaseLawPrintViewController

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
    [self pageLoadInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-  (void)pageLoadInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
   // RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    if (citizen) {
        self.sendname.text = [NSString stringWithFormat:@"%@（身份证号：%@）",citizen.party,citizen.card_no];
        
    }
    self.anhao.text = [[NSString alloc] initWithFormat:@"%@-%@",caseInfo.case_mark2, caseInfo.full_case_mark3];
    RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
           self.behavio.text = roadSegment.place_prefix1;
     }
}

- (NSString *)templateNameKey
{
    return DocNameKeyFa_KanYanJianChaBiLu;
}

- (id)dataForPDFTemplate
{
    NSString *anhao = @"";
    NSString *sendname = @"";
    NSString *behavio = @"";
//    NSString *tiao1 = @"";
//    NSString *kuan1 = @"";
//    NSString *xiang1 = @"";
//    NSString *tiao2 = @"";
//    NSString *kuan2 = @"";
//    NSString *xiang2 = @"";
//    NSString *tiao3 = @"";
//    NSString *kuan3 = @"";
//    NSString *xiang3 = @"";
//    NSString *tiao4 = @"";
//    NSString *kuan4 = @"";
//    NSString *xiang4 = @"";
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    // RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    if (citizen) {
        sendname = [NSString stringWithFormat:@"%@（身份证号：%@）",citizen.party,citizen.card_no];
        
    }
    anhao = [[NSString alloc] initWithFormat:@"%@-%@",caseInfo.case_mark2, caseInfo.full_case_mark3];
    RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    if (roadSegment) {
        behavio = roadSegment.place_prefix1;
    }
    
//    tiao1 = self.tiao1.text;
//    kuan1 = self.kuan1.text;
//    xiang1 = self.xiang1.text;
//    tiao2 = self.tiao2.text;
//    kuan2 = self.kuan2.text;
//    xiang2 = self.xiang2.text;
//    tiao3 = self.tiao3.text;
//    kuan3 = self.kuan3.text;
//    xiang3 = self.xiang3.text;
//    tiao4 = self.tiao4.text;
//    kuan4 = self.kuan4.text;
//    xiang4 = self.xiang4.text;
    return @{@"anhao": anhao,
             @"sendname":sendname,
             @"behavio":behavio,
//             @"tiao1": tiao1,
//             @"kuan1": kuan1,
//             @"xiang1":xiang1,
//             @"tiao2": tiao2,
//             @"kuan2": kuan2,
//             @"xiang2":xiang2,
//             @"tiao3": tiao3,
//             @"kuan3": kuan3,
//             @"xiang3":xiang3,
//             @"tiao4": tiao4,
//             @"kuan4": kuan4,
//             @"xiang4":xiang4,
             };
    
}


- (void)viewDidUnload {
    [self setBehavior:nil];
    [self setSendname:nil];
    [self setBehavio:nil];
    [self setTiao1:nil];
    [self setKuan1:nil];
    [self setXiang1:nil];
    [self setTiao2:nil];
    [self setKuan2:nil];
    [self setXiang2:nil];
    [self setTiao3:nil];
    [self setKuan3:nil];
    [self setXiang3:nil];
    [self setTiao4:nil];
    [self setKuan4:nil];
    [self setXiang4:nil];
    [self setAnhao:nil];
    [super viewDidUnload];
}
@end
