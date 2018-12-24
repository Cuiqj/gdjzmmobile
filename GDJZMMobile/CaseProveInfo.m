//
//  CaseProveInfo.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CaseProveInfo.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "UserInfo.h"
#import "CaseInfo.h"

@interface CaseProveInfo ()
@property (nonatomic, retain, setter = setCaseInfo:) CaseInfo *_caseInfo;
@end

@implementation CaseProveInfo

@dynamic case_desc_id;
@dynamic case_short_desc;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic end_date_time;
@dynamic event_desc;
@dynamic invitee;
@dynamic invitee_org_duty;
@dynamic isuploaded;
@dynamic myid;
@dynamic organizer;
@dynamic organizer_org_duty;
@dynamic party;
@dynamic party_org_duty;
@dynamic prover;
@dynamic recorder;
@dynamic start_date_time;
@dynamic remark;
@dynamic secondProver;
@dynamic case_long_desc;

@synthesize _caseInfo;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseProveInfo" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

// 区分 违法案件 与 赔补偿案件 zhenlintie 2014-04-24
+ (NSString *)generateEventDescForCase:(NSString *)caseID{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    if ([caseInfo.case_type_id isEqualToString:CaseTypeIDPei]){
        return [[self class] eventDescForTypePeiWithCase:caseInfo];
    }
    else{
        return [[self class] eventDescForTypeFaWithCase:caseInfo];
    }
    return @"";
}

+ (NSString *)eventDescForTypeFaWithCase:(CaseInfo *)caseInfo{
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    NSString *caseDescString=@"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
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
        stationString=[NSString stringWithFormat:@"K%@+%@M处",stationStartKMString,stationStartMString];
    }
//    else {
//        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
//        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
//        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
//        stationString=[NSString stringWithFormat:@"K%@+%@M至K%@+%@M处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
//    }
    
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:caseInfo.myid];
    
    caseDescString = [NSString stringWithFormat:@"%@巡查%@%@%@，发现%@%@，经现场勘验",happenDate,roadName,caseInfo.place,stationString,caseInfo.side,proveInfo.case_short_desc];
    
    return caseDescString;
}

+ (NSString *)eventDescForTypePeiWithCase:(CaseInfo *)caseInfo{
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    NSString *caseDescString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
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
    else if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue) {
        stationString=[NSString stringWithFormat:@"K%@+%@M处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@M至K%@+%@M处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    
    NSString *caseStatusString=@"";
    if (caseInfo.fleshwound_sum.integerValue==0 && caseInfo.badwound_sum.integerValue==0 && caseInfo.death_sum.integerValue==0) {
        caseStatusString=[caseStatusString stringByAppendingString:@"无人员伤亡，"];
    } else {
        caseStatusString=@"造成";
        if (caseInfo.fleshwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"轻伤%@人，",caseInfo.fleshwound_sum];
        }
        if (caseInfo.badwound_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"重伤%@人，",caseInfo.badwound_sum];
        }
        if (caseInfo.death_sum.integerValue!=0) {
            caseStatusString=[caseStatusString stringByAppendingFormat:@"死亡%@人，",caseInfo.death_sum];
        }
    }
    if (caseInfo.badcar_sum.integerValue!=0) {
        caseStatusString=[caseStatusString stringByAppendingFormat:@"损坏%@辆车",caseInfo.badcar_sum];
    } else {
        caseStatusString=[caseStatusString stringByAppendingString:@"未造成车辆损坏"];
    }
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSArray *citizenArray=[Citizen allCitizenNameForCase:caseInfo.myid];
    if (citizenArray.count>0) {
        if (citizenArray.count==1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            // modified by cjl
            if (caseInfo.badcar_sum.integerValue!=0) {
                //        caseStatusString=[caseStatusString stringByAppendingFormat:@"损坏%@辆车",caseInfo.badcar_sum];
                caseStatusString=[caseStatusString stringByAppendingFormat:@"，车辆%@损坏",citizen.bad_desc];
            }
            // 修复车辆未造成损害时，会重复 zhenlintie 2014-03-31
            //            else {
            //                caseStatusString=[caseStatusString stringByAppendingString:@"未造成车辆损坏"];
            //            }
            
            caseDescString=[caseDescString stringByAppendingFormat:@"   %@于%@驾驶%@%@行至%@%@%@在公路%@由于%@发生交通事故损坏公路路产，%@，经与当事人现场勘查，",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason,caseStatusString];
            NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
            NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",caseInfo.myid,citizen.automobile_number];
            [fetchRequest setEntity:deformEntity];
            [fetchRequest setPredicate:deformPredicate];
            NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
            if (deformArray.count>0) {
                NSString *deformsString=@"";
                for (CaseDeformation *deform in deformArray) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                }
                NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
                deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
                caseDescString=[caseDescString stringByAppendingFormat:@"损坏路产如下：%@。",deformsString];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"没有路产损坏。"];
            }
        }
        if (citizenArray.count>1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            caseDescString=[caseDescString stringByAppendingFormat:@"%@于%@驾驶%@%@行至%@%@%@，与",citizen.party,happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
            for (int i=1;i<citizenArray.count;i++) {
                citizen=[citizenArray objectAtIndex:i];
                if (i==1) {
                    caseDescString=[caseDescString stringByAppendingFormat:@"%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                } else {
                    caseDescString=[caseDescString stringByAppendingFormat:@"、%@驾驶的%@%@",citizen.party,citizen.automobile_number,citizen.automobile_pattern];
                }
            }
            caseDescString=[caseDescString stringByAppendingFormat:@"在公路%@由于%@发生碰撞，造成交通事故，%@，经与当事人现场勘查，",caseInfo.place,caseInfo.case_reason,caseStatusString];
            
            NSArray *deformArray=[CaseDeformation deformationsForCase:caseInfo.myid];
            NSString *roadAssetString=@"";
            NSString *deformsString=@"";
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            for (int i=0; i<citizenArray.count; i++) {
                roadAssetString=@"";
                for (CaseDeformation *deform in deformArray) {
                    if ([deform.citizen_name isEqualToString:[[citizenArray objectAtIndex:i] automobile_number]]) {
                        NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([roadSizeString isEmpty]) {
                            roadSizeString=@"";
                        } else {
                            roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                        }
                        NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([remarkString isEmpty]) {
                            remarkString=@"";
                        } else {
                            remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                        }
                        NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
                        NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                        quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                        roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                    }
                }
                roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
                if (![roadAssetString isEmpty]) {
                    deformsString=[deformsString stringByAppendingFormat:@"%@损坏路产：%@，",[[citizenArray objectAtIndex:i] automobile_number],roadAssetString];
                }
            }
            roadAssetString=@"";
            for (CaseDeformation *deform in deformArray) {
                if ([deform.citizen_name isEqualToString:@"共同"]) {
                    NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([roadSizeString isEmpty]) {
                        roadSizeString=@"";
                    } else {
                        roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                    }
                    NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([remarkString isEmpty]) {
                        remarkString=@"";
                    } else {
                        remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                    }
                    NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
                    NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                    quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                    roadAssetString=[roadAssetString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
                }
            }
            roadAssetString=[roadAssetString stringByTrimmingCharactersInSet:charSet];
            if (![roadAssetString isEmpty]) {
                NSString *citizenString=@"";
                for (int i=0; i<citizenArray.count; i++) {
                    citizenString=[citizenString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    citizenString=[citizenString stringByAppendingFormat:@"%@%@",([citizenString isEmpty]?@"":@"、"),[[citizenArray objectAtIndex:i] automobile_number]];
                }
                citizenString=[citizenString stringByTrimmingTrailingCharactersInSet:charSet];
                deformsString=[deformsString stringByAppendingFormat:@"%@共同损坏路产：%@，",[citizenString stringByTrimmingTrailingCharactersInSet:charSet],roadAssetString];
            }
            if (![deformsString isEmpty]) {
                NSCharacterSet *commaSet=[NSCharacterSet characterSetWithCharactersInString:@"，"];
                caseDescString=[caseDescString stringByAppendingFormat:@"%@。",[deformsString stringByTrimmingTrailingCharactersInSet:commaSet]];
            } else {
                caseDescString=[caseDescString stringByAppendingString:@"没有路产损坏。"];
            }
        }
    }
    return caseDescString;
}


- (NSString *) case_mark2{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    return _caseInfo.case_mark2;
}

- (NSString *) full_case_mark3{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    
    return _caseInfo.full_case_mark3;
}

- (NSString *) weater{
    if (!_caseInfo) {
        [self setCaseInfo:[CaseInfo caseInfoForID:self.caseinfo_id]];
    }
    return _caseInfo.weater;
}

- (NSString *) prover1{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if([chunks count]==2)
    {
        //勘验人1 单位职务
        return [chunks objectAtIndex:0];
    }else{
        return self.prover;
    }
}

- (NSString *) prover1_org_duty{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if([chunks count]==2)
    {
        //勘验人1 单位职务
        return [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]];
    }
    else
    {
        return [UserInfo orgAndDutyForUserName:self.prover];
    }
}

- (NSString *) prover2{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if(chunks && [chunks count]>=2)
    {
        //勘验人2 单位职务
        return [chunks objectAtIndex:1];
    }else{
        return self.secondProver;
        return @"";
    }
}

- (NSString *) prover2_org_duty{
    NSArray *chunks = [self.prover componentsSeparatedByString: @","];
    if(chunks && [chunks count]>=2)
    {
        //勘验人1 单位职务
        return [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]];
    }
    else if ([self.secondProver length] > 0)
    {
        return [UserInfo orgAndDutyForUserName:self.secondProver];
    }else {
        return @"";
    }
}
- (NSString *) citizen_org_duty{
    Citizen *citizen = [Citizen citizenForCitizenName:self.citizen_name nexus:@"当事人" caseId:self.caseinfo_id];
    return [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.org_principal_duty];
}

- (NSString *) recorder_org_duty{
    return [UserInfo orgAndDutyForUserName:self.recorder];
}

@end
