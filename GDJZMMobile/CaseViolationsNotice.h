//
//  CaseViolationsNotice.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

/*
 *  公路违法案件告知表
 */
@interface CaseViolationsNotice : NSManagedObject
@property (copy, nonatomic) NSString *myid;
@property (copy, nonatomic) NSString *caseinfo_id;  //案件ID
@property (copy, nonatomic) NSString *informingDepartment;  //被告知单位
@property (copy, nonatomic) NSString *informingDate;  //告知时间
@property (copy, nonatomic) NSString *informingMethod;  //告知方式
@property (copy, nonatomic) NSString *location;  //地址
@property (copy, nonatomic) NSString *caseBaseContent;  //案件发生的基本情况
@property (copy, nonatomic) NSString *suggesting;  //公路管理机构处理建议
@property (copy, nonatomic) NSString *receptionPerson;  //抄报
@property (copy, nonatomic) NSString *linkman;  //告知单位联系人
@property (copy, nonatomic) NSString *phone;  //联系电话
@property (copy, nonatomic) NSString *fax;  //传真
@property (copy, nonatomic) NSString *case_mark2;  //案件编号
@property (copy, nonatomic) NSString *full_case_mark3;  //案件编号
@property (copy, nonatomic) NSString *time;  //案件时间


// 初始化一个新的CaseViolationsNotice
+ (id)newCaseViolationsNoticeWithCaseId:(NSString * )caseId;

// 根据案件信息(CaseInfo)id获取公路违法案件告知表(CaseViolationsNotice)
+ (CaseViolationsNotice *)caseViolationsNoticeFoCaseId:(NSString *)caseId;

// 更新地点(location)和案由(behavior)
- (void)update;

@end
