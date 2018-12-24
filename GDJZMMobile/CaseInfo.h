//
//  CaseInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

#define XIERHUAN_PEI @"西二环南高[赔]"
#define XIERHUAN_FA @"西二环南高[罚]"
#define ZHONGJIANG_PEI @"中江高[赔]"
#define ZHONGJIANG_FA @"中江高[罚]"
#define GDRM_CASE_TYPE_NAME_ARRAY ([[[AppDelegate App].projectDictionary objectForKey:@"projectname"] isEqualToString:@"xierhuan"] ? @[XIERHUAN_PEI, XIERHUAN_FA] : @[ZHONGJIANG_PEI, ZHONGJIANG_FA])

FOUNDATION_EXPORT NSString * const CaseTypeIDPei;// @"11"
FOUNDATION_EXPORT NSString * const CaseTypeIDFa;// @"12"
FOUNDATION_EXPORT NSString * const CaseTypeIDDefault;// @"11"

typedef enum:NSUInteger {
    kGDRMCaseTypeStartIndex = 10,
    kGDRMCaseTypeCompensation,   // 赔补偿
    kGDRMCaseTypeCriminalPunishment
} kGDRMCaseType;

@interface CaseInfo : BaseManageObject

@property (nonatomic, retain) NSString * badcar_sum;
@property (nonatomic, retain) NSString * badwound_sum;
@property (nonatomic, retain) NSString * case_mark2;
@property (nonatomic, retain) NSString * case_mark3;
@property (nonatomic, retain) NSString * case_reason;
@property (nonatomic, retain) NSString * case_style;
@property (nonatomic, retain) NSString * case_type;
@property (nonatomic, retain) NSString * case_type_id;
@property (nonatomic, retain) NSString * death_sum;
@property (nonatomic, retain) NSString * fleshwound_sum;
@property (nonatomic, retain) NSDate   * happen_date;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSString * weater;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSNumber * case_character;
@property (nonatomic, retain) NSNumber * case_disposal;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * peccancy_type;
@property (retain,nonatomic) NSString * caseAddressStr;

//读取案号对应的案件信息记录
+(CaseInfo *)caseInfoForID:(NSString *)caseID;
+ (NSInteger)maxCaseMark3ForAdministrativePenalty;
//删除对应案号的信息记录
+ (void)deleteCaseInfoForID:(NSString *)caseID;

//删除无用的空记录
+ (void)deleteEmptyCaseInfo;

+ (NSInteger)maxCaseMark3;

- (NSString *)station_start_km;
- (NSString *)station_start_m;
- (NSString *)side_short;

- (NSString *)full_case_mark3;
- (NSString *)fullCaseMarkAfterK:(BOOL)isAfterK;
- (NSString *)full_happen_place;
- (NSString *)full_station;
@end
