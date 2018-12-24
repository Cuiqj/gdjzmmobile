//
//  CaseMapPrinterViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "AdministrativePenaltyMapPrinterViewController.h"
#import "CaseMap.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"

@interface AdministrativePenaltyMapPrinterViewController ()

@end

@implementation AdministrativePenaltyMapPrinterViewController
@synthesize labelTime = _labelTime;
@synthesize labelLocality = _labelLocality;
@synthesize labelCitizen = _labelCitizen;
@synthesize labelWeather = _labelWeather;
@synthesize labelRoadType = _labelRoadType;
@synthesize textViewRemark = _textViewRemark;
@synthesize labelDraftMan = _labelDraftMan;
@synthesize labelDraftTime = _labelDraftTime;
@synthesize mapImage = _mapImage;
@synthesize caseID = _caseID;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:@"AdministrativePenaltyMapTable"];
    [self loadPageInfo];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabelTime:nil];
    [self setLabelLocality:nil];
    [self setLabelCitizen:nil];
    [self setLabelWeather:nil];
    [self setLabelRoadType:nil];
    [self setTextViewRemark:nil];
    [self setLabelDraftMan:nil];
    [self setLabelDraftTime:nil];
    [self setMapImage:nil];
    [self setLabelCaseDesc:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadPageInfo{
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    if (caseMap) {
        self.labelRoadType.text = caseMap.road_type;
        self.textViewRemark.text = caseMap.remark;
        self.labelDraftMan.text = caseMap.draftsman_name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.labelDraftTime.text = [dateFormatter stringFromDate:caseMap.draw_time];
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
        mapPath=[documentPath stringByAppendingPathComponent:mapPath];
        NSString *mapName = @"casemap.jpg";
        NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
            self.mapImage.image = imageFile;
        }
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        self.labelTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
        NSString *locality = [[NSString alloc] initWithFormat:@"%@高速%@%02dKm+%03dm",[[AppDelegate App].projectDictionary objectForKey:@"cityname"] ,caseInfo.side,caseInfo.station_start.integerValue/1000,caseInfo.station_start.integerValue%1000];
        self.labelLocality.text = locality;
        self.labelWeather.text = caseInfo.weater;
        CaseProveInfo *info = [CaseProveInfo proveInfoForCase:caseInfo.myid];
        if (info) {
            self.labelCaseDesc.text = info.case_short_desc;
        }else{
            self.labelCaseDesc.text = @"";
        }
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            self.labelProver.text = caseProveInfo.prover;
        }
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        self.labelCitizen.text = citizen.automobile_number;
    }
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"AdministrativePenaltyMapTable"];
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        [self drawDateTable:@"AdministrativePenaltyMapTable" withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
@end
