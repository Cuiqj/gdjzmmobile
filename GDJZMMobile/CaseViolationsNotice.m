//
//  CaseBreakLawNotice.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "CaseViolationsNotice.h"
#import "RoadSegment.h"
#import "CaseProveInfo.h"
#import "CaseInfo.h"

@implementation CaseViolationsNotice

@dynamic myid;
@dynamic caseinfo_id;
@dynamic informingDepartment;
@dynamic informingDate;
@dynamic informingMethod;
@dynamic location;
@dynamic caseBaseContent;
@dynamic suggesting;
@dynamic receptionPerson;
@dynamic linkman;
@dynamic phone;
@dynamic fax;
@dynamic full_case_mark3;
@dynamic case_mark2;
@dynamic time;

+ (id)newCaseViolationsNoticeWithCaseId:(NSString * )caseId{

    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    if (![caseId isEmpty]){
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseId]];
    }
    NSArray *notices = [context executeFetchRequest:fetchRequest error:nil];
    CaseViolationsNotice *notice = nil;
    if (notices.count>0){
        notice = [notices lastObject];
    }
    return notice;
}

+ (CaseViolationsNotice *)caseViolationsNoticeFoCaseId:(NSString *)caseId
{
    CaseViolationsNotice * caseViolationsNotice =(CaseViolationsNotice *)[NSManagedObject newDataObjectWithEntityName:@"CaseViolationsNotice"];
    caseViolationsNotice.caseinfo_id = caseId;
    [caseViolationsNotice update];
    [[AppDelegate App] saveContext];
    return caseViolationsNotice;
}

- (void)update{
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseinfo_id];
    self.case_mark2 = caseInfo.case_mark2;
    self.full_case_mark3 = caseInfo.full_case_mark3;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
    self.time = dateString;
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM = caseInfo.station_start.integerValue % 1000;
    NSString *stationStartKMString = [NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString = [numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    // 如果为空不显示
    if (0 == stationStartKMString.integerValue){
        stationString = @"";
    }
    else {
        stationString=[NSString stringWithFormat:@"K%@+%@",stationStartKMString,stationStartMString];
    }
   
    self.location = [NSString stringWithFormat:@"%@方向%@%@",caseInfo.place,stationString,caseInfo.side];
    [[AppDelegate App] saveContext];
}

@end
