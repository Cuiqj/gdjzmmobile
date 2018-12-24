//
//  CaseEnd.h
//  GDJZMMobile
//
//  Created by quxiuyun on 14-4-9.
//
//

#import "BaseManageObject.h"

//结案报告
@interface CaseEnd : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * clerk;//案件调查员/案件承办人 "、"隔开
@property (nonatomic, retain) NSDate   * date_caseend;//结案时间
@property (nonatomic, retain) NSString * leader_name;//主管领导签名
@property (nonatomic, retain) NSDate   * date_underwrite;//主管领导签名时间
@property (nonatomic, retain) NSString * transact_decision;//赔补偿决定
@property (nonatomic, retain) NSString * execute_circs;//执行情况
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, assign) BOOL isuploaded;

/*
 *  根据一个caseId获取到caseEnd
 */
+ (NSArray *)CaseEndForCaseId:(NSString *)caseID;

/*
 *  根据一个caseId生成一个caseEnd
 */
+ (id)newCaseEndWithCaseId:(NSString * )caseId;

@end
