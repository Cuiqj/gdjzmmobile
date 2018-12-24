//
//  ViolationsNoticeViewController.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "ViolationsNoticeViewController.h"
#import "CaseProveInfo.h"
#import "CaseBreakLawNotice.h"

@interface ViolationsNoticeViewController ()

@property (strong, nonatomic) CaseBreakLawNotice *breakLawNotice;

@end

@implementation ViolationsNoticeViewController

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
    [super setCaseID:self.caseID];
    
    if ([self.caseID isEmpty]){
        return;
    }
    self.breakLawNotice = [CaseBreakLawNotice caseBreakLawNoticeFoCaseId:self.caseID];
    if (!self.breakLawNotice){
        self.breakLawNotice = [CaseBreakLawNotice newCaseBreakLawNoticeWithCaseId:self.caseID];
    }
    [self.breakLawNotice update];
    [self pageLoadInfo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLocationTextField:nil];
    [self setSendNameTextField:nil];
    [self setBehaviorTextField:nil];
    [self setTiao1TextField:nil];
    [self setKuan1TextField:nil];
    [self setRemark1TextView:nil];
    [super viewDidUnload];
}

- (void)pageLoadInfo
{
    [self sendNameTextField].text = NSStringNilIsBad([self breakLawNotice].sendname);
    [self locationTextField].text = NSStringNilIsBad([self breakLawNotice].location);
    [self behaviorTextField].text = NSStringNilIsBad([self breakLawNotice].behavior);
    [self tiao1TextField].text = NSStringNilIsBad([self breakLawNotice].tiao1);
    [self kuan1TextField].text = NSStringNilIsBad([self breakLawNotice].kuan1);
    [self remark1TextView].text = NSStringNilIsBad([self breakLawNotice].remark1);
    [self tiao2TextField].text = NSStringNilIsBad([self breakLawNotice].tiao2);
    [self kuan2TextField].text = NSStringNilIsBad([self breakLawNotice].kuan2);
    [self remark2TextView].text = NSStringNilIsBad([self breakLawNotice].remark2);
    [self tiao3TextField].text = NSStringNilIsBad([self breakLawNotice].tiao3);
    [self kuan3TextField].text = NSStringNilIsBad([self breakLawNotice].kuan3);
    [self remark3TextView].text = NSStringNilIsBad([self breakLawNotice].remark3);
}

- (void)pageSaveInfo
{
    
    [self breakLawNotice].sendname = NSStringNilIsBad([self sendNameTextField].text);
    [self breakLawNotice].location = NSStringNilIsBad([self locationTextField].text);
    [self breakLawNotice].behavior = NSStringNilIsBad([self behaviorTextField].text);
    [self breakLawNotice].tiao1 = NSStringNilIsBad([self tiao1TextField].text);
    [self breakLawNotice].kuan1 = NSStringNilIsBad([self kuan1TextField].text);
    [self breakLawNotice].remark1 = NSStringNilIsBad([self remark1TextView].text);
    [self breakLawNotice].tiao2 = NSStringNilIsBad([self tiao2TextField].text);
    [self breakLawNotice].kuan2 = NSStringNilIsBad([self kuan2TextField].text);
    [self breakLawNotice].remark2 = NSStringNilIsBad([self remark2TextView].text);
    [self breakLawNotice].tiao3 = NSStringNilIsBad([self tiao3TextField].text);
    [self breakLawNotice].kuan3 = NSStringNilIsBad([self kuan3TextField].text);
    [self breakLawNotice].remark3 = NSStringNilIsBad([self remark3TextView].text);
    [[AppDelegate App] saveContext];
}

- (NSString *)templateNameKey
{
    return DocNameKeyFa_JiaoTongWeiFaXingWeiGaoZhiShu;
}

- (id)dataForPDFTemplate
{
    id data = @{
                @"sendname":NSStringNilIsBad([self breakLawNotice].sendname),
                @"location":NSStringNilIsBad([self breakLawNotice].location),
                @"behavior":NSStringNilIsBad([self breakLawNotice].behavior),
                @"fa1":@{
                        @"tiao":NSStringNilIsBad([self breakLawNotice].tiao1),
                        @"kuan":NSStringNilIsBad([self breakLawNotice].kuan1),
                        @"remark":NSStringNilIsBad([self breakLawNotice].remark1)
                            },
                @"fa2":@{
                        @"tiao":NSStringNilIsBad([self breakLawNotice].tiao2),
                        @"kuan":NSStringNilIsBad([self breakLawNotice].kuan2),
                        @"remark":NSStringNilIsBad([self breakLawNotice].remark2)
                        },
                @"fa3":@{
                        @"tiao":NSStringNilIsBad([self breakLawNotice].tiao3),
                        @"kuan":NSStringNilIsBad([self breakLawNotice].kuan3),
                        @"remark":NSStringNilIsBad([self breakLawNotice].remark3)
                        }
                };
    return data;
    
}





@end
