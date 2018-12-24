//
//  CaseBreakLawNotice.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import <CoreData/CoreData.h>

/*
 *  交通违法行为告知书
 */
@interface CaseBreakLawNotice : NSManagedObject

@property (copy, nonatomic) NSString *myid;
@property (copy, nonatomic) NSString *caseinfo_id;  //案件ID
@property (copy, nonatomic) NSString *sendname;  //发送单位
@property (copy, nonatomic) NSString *location;  //地点
@property (copy, nonatomic) NSString *behavior;  //违法行为
@property (copy, nonatomic) NSString *tiao1;  //中华人民共和国公路法第几条
@property (copy, nonatomic) NSString *kuan1;  //第几款1
@property (copy, nonatomic) NSString *remark1;  //备注1
@property (copy, nonatomic) NSString *tiao2;  //公路安全保护条例第几条
@property (copy, nonatomic) NSString *kuan2;  //款2
@property (copy, nonatomic) NSString *remark2;  //备注2
@property (copy, nonatomic) NSString *tiao3;  //广东省公路条例第几条
@property (copy, nonatomic) NSString *kuan3;  //款3
@property (copy, nonatomic) NSString *remark3;  //备注3

// 初始化一个新的CaseBreakLawNotice
+ (id)newCaseBreakLawNoticeWithCaseId:(NSString * )caseId;

// 根据案件信息(CaseInfo)id获取违法行为告知书(CaseBreakLawNotice)
+ (CaseBreakLawNotice *)caseBreakLawNoticeFoCaseId:(NSString *)caseId;

// 更新地点(location)和案由(behavior)
- (void)update;

@end
