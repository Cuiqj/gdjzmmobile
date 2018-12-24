//
//  CaseBreakLawNotice.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "CaseBreakLawNotice.h"
#import "RoadSegment.h"
#import "CaseProveInfo.h"
#import "CaseInfo.h"

@implementation CaseBreakLawNotice

@dynamic myid;
@dynamic behavior;
@dynamic caseinfo_id;
@dynamic kuan1;
@dynamic kuan2;
@dynamic kuan3;
@dynamic location;
@dynamic remark1;
@dynamic remark2;
@dynamic remark3;
@dynamic sendname;
@dynamic tiao1;
@dynamic tiao2;
@dynamic tiao3;

+ (CaseBreakLawNotice *)caseBreakLawNoticeFoCaseId:(NSString *)caseId{

    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    if (![caseId isEmpty]){
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseId]];
    }
    NSArray *notices = [context executeFetchRequest:fetchRequest error:nil];
    CaseBreakLawNotice *notice = nil;
    if (notices.count>0){
        notice = [notices lastObject];
    }
    return notice;
}

+ (id)newCaseBreakLawNoticeWithCaseId:(NSString * )caseId
{
    CaseBreakLawNotice * breakLawNotice =(CaseBreakLawNotice *)[NSManagedObject newDataObjectWithEntityName:NSStringFromClass([self class])];
    breakLawNotice.caseinfo_id = caseId;
    [breakLawNotice update];
    [[AppDelegate App] saveContext];
    return breakLawNotice;
}

- (void)update{
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseinfo_id];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    // 如果为空不显示
    if (0 == stationStartKMString.integerValue){
        stationString = @"";
    }
    else {
        stationString=[NSString stringWithFormat:@"K%@+%@",stationStartKMString,stationStartMString];
    }

    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:caseInfo.myid];
    
    self.location = [NSString stringWithFormat:@"%@方向%@%@",caseInfo.place,stationString,caseInfo.side];
    self.behavior = proveInfo.case_short_desc;
    [[AppDelegate App] saveContext];
}

@end
