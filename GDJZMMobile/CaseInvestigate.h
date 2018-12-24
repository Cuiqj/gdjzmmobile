//
//  CaseInvestigate.h
//  GDJZMMobile
//
//  Created by quxiuyun on 14-4-9.
//
//

#import "BaseManageObject.h"

//调查报告
@interface CaseInvestigate : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * investigater_name;//调查人名称，“、”号隔开
@property (nonatomic, retain) NSString * course;//案件调查经过
@property (nonatomic, retain) NSString * obey_laws;//依据的法律条文
@property (nonatomic, retain) NSString * disobey_laws;//违反的法律条文
@property (nonatomic, retain) NSString * conclusion;//案件调查结论
@property (nonatomic, retain) NSString * witness;//所附证据材料
@property (nonatomic, retain) NSString * leader_comment;//领导意见
@property (nonatomic, retain) NSString * leader_name;//领导签名结论
@property (nonatomic, retain) NSDate   * leader_date;//领导签字时间
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, assign) BOOL isuploaded;

/*
 *  根据一个caseId获取到caseInvestigate
 */
+ (NSArray *)CaseInvestigateForCaseId:(NSString *)caseID;

/*
 *   根据一个caseId生成一个caseInvestigate
 */
+ (id)newCaseInvestigateWithCaseId:(NSString * )caseId;

@end
