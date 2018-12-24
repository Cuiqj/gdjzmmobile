//
//  CaseFaMapPrintViewController.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-28.
//
//

#import "CaseFaMapPrintViewController.h"
#import "CaseMapFa.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"

@interface CaseFaMapPrintViewController ()

@property (strong, nonatomic) CaseMapFa *mapFa;
@property (strong, nonatomic) CaseMap *map;

@end

@implementation CaseFaMapPrintViewController
@synthesize labelTime = _labelTime;
@synthesize textRoadName = _textRoadName;
@synthesize roadDrection = _roadDrection;
@synthesize textStartK = _textStartK;
@synthesize textStartM = _textStartM;
@synthesize textViewRemark = _textViewRemark;
@synthesize labelDraftMan = _labelDraftMan;
@synthesize labelDraftTime = _labelDraftTime;
@synthesize mapImage = _mapImage;
@synthesize caseID = _caseID;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:@"CaseMapTable"];
    
    [self initData];
    [self loadPageInfo];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabelTime:nil];
    [self setTextRoadName:nil];
    [self setRoadDrection:nil];
    [self setTextStartK:nil];
    [self setTextStartM:nil];
    [self setTextViewRemark:nil];
    [self setLabelDraftMan:nil];
    [self setLabelDraftTime:nil];
    [self setMapImage:nil];
    [self setLabelCaseMark:nil];
    [self setTextCaseReason:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// 初始化数据
- (void)initData{
    self.map = [CaseMap caseMapForCase:self.caseID];
    if (!self.map){
        return;
    }
    self.mapFa = [CaseMapFa caseMapFaForMap:self.map.myid];
    // 第一次时 初始化数据
    if (!self.mapFa){
        self.mapFa = [CaseMapFa newDataObjectWithEntityName:NSStringFromClass([CaseMapFa class])];
        [self mapFa].myid = [self map].myid;
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self mapFa].roadName =  NSStringNilIsBad([RoadSegment roadNameFromSegment:caseInfo.roadsegment_id]);
        [self mapFa].roadDirection =  NSStringNilIsBad(caseInfo.place);
        
        NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
        [numFormatter setPositiveFormat:@"000"];
        NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
        NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
        NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
        [self mapFa].startK = stationStartKMString;
        [self mapFa].startM = stationStartMString;
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self mapFa].caseReason = NSStringNilIsBad(proveInfo.case_short_desc);
        
        [[AppDelegate App]saveContext];
    }
}

- (void)loadPageInfo{
    
    if (self.map) {
        
        self.textViewRemark.text = [self map].remark;
        self.labelDraftMan.text = [self map].draftsman_name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.labelDraftTime.text = [dateFormatter stringFromDate:[self map].draw_time];
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
        
        //        NSString *locality = [[NSString alloc] initWithFormat:@"西二环南段%@%dKm+%03dm",caseInfo.side,caseInfo.station_start.integerValue/1000,caseInfo.station_start.integerValue%1000];
        //        self.labelLocality.text = locality;
        self.textRoadName.text = [self mapFa].roadName;
        self.roadDrection.text = [self mapFa].roadDirection;
        self.textStartK.text = [self mapFa].startK;
        self.textStartM.text = [self mapFa].startM;
        self.textCaseReason.text = [self mapFa].caseReason;
        
        self.labelCaseMark.text = [NSString stringWithFormat:@"%@年%@号", caseInfo.case_mark2, caseInfo.full_case_mark3];
//        self.labelWeather.text = caseInfo.weater;
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            self.labelProver.text = caseProveInfo.prover;
        }
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" caseId:self.caseID];
//        self.labelCitizen.text = citizen.automobile_number;
    }
}

- (void)pageSaveInfo
{
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    caseMap.remark = self.textViewRemark.text;
    
    [self mapFa].roadName = self.textRoadName.text;
    [self mapFa].roadDirection = self.roadDrection.text;
    [self mapFa].startK = self.textStartK.text;
    [self mapFa].startM = self.textStartM.text;
    [self mapFa].caseReason = self.textCaseReason.text;
    
    [[AppDelegate App] saveContext];
}

- (NSURL *)toFullPDFWithPath_deprecated:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"CaseMapTable"];
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" caseId:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath_deprecated:(NSString *)filePath{
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseMap];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseInfo];
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:caseProveInfo];
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" caseId:self.caseID];
        [self drawDateTable:@"CaseMapTable" withDataModel:citizen];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
    return DocNameKeyFa_XianChangKanYanTu;
}

- (id)dataForPDFTemplate
{
    NSString *caseWord = @"";
    NSString *caseNo = @"";
    id dateData = @{};
    id place = @"";
    NSString *eventReason = @"";
    NSString *comment = @"";
    NSString *draftsman = @"";
    NSString *inquestman = @"";
    NSString *imagePath = @"";
    NSString *weater = @"";
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    
    
    if (caseInfo) {
        caseWord = caseInfo.case_type;
        caseNo = [NSString stringWithFormat:@"%@年%@",caseInfo.case_mark2,caseInfo.full_case_mark3];
        
        //        NSString *dateString = NSStringFromNSDateAndFormatter(caseInfo.happen_date, NSDateFormatStringCustom1);
        
        NSString *dateString = self.labelTime.text;
        dateData = DateDataFromDateString(dateString);
        dateData = (dateData == nil ? @{} : dateData);
        //        place = NSStringNilIsBad(caseInfo.full_happen_place);
        
        
        place = @{@"gaosu":[self mapFa].roadName,
                      @"fangxiang":[self mapFa].roadDirection,
                      @"k":[self mapFa].startK,
                      @"m":[self mapFa].startM};
        weater = NSStringNilIsBad(caseInfo.weater);
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (proveInfo) {
            //            eventReason = NSStringNilIsBad(proveInfo.case_short_desc);
            inquestman = NSStringNilIsBad(proveInfo.prover);
        }
        
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        if (caseMap) {
            eventReason = NSStringNilIsBad([self mapFa].caseReason);
            comment = NSStringNilIsBad(caseMap.remark);
            draftsman = NSStringNilIsBad(caseMap.draftsman_name);
            imagePath = caseMap.map_file;
        }
        
    }
    return @{
             @"caseWord":@"中江高违",
             @"caseNo": caseNo,
             @"date": dateData,
             @"place": place,
             @"eventReason": eventReason,
             @"comment": comment,
             @"draftsman": draftsman,
             @"inquestman": inquestman,
             @"imagePath": imagePath,
             @"weater":weater,
             };
}


@end
