//
//  CaseInvestigate.m
//  GDJZMMobile
//
//  Created by quxiuyun on 14-4-9.
//
//

#import "CaseInvestigate.h"
#import "Task.h"

@implementation CaseInvestigate

@dynamic myid;
@dynamic investigater_name;
@dynamic course;
@dynamic obey_laws;
@dynamic disobey_laws;
@dynamic conclusion;
@dynamic witness;
@dynamic leader_comment;
@dynamic leader_name;
@dynamic leader_date;
@dynamic remark;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)CaseInvestigateForCaseId:(NSString *)caseID{
    
    Task * task = [Task taskWithCaseId:caseID nodeName:NSStringFromClass([self class])];

    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",task.myid];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (id)newCaseInvestigateWithCaseId:(NSString * )caseId
{
    CaseInvestigate * caseInvestigateInfo =(CaseInvestigate *)[NSManagedObject newDataObjectWithEntityName:NSStringFromClass([self class])];
    Task *caseTask = [Task taskWithTaskId:caseId];
    Task *selfTask = [Task taskWithTaskId:caseInvestigateInfo.myid];
    selfTask.project_id = caseTask.project_id;
    
    [[AppDelegate App] saveContext];
    return caseInvestigateInfo;
}

@end
