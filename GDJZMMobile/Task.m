//
//  Task.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "Task.h"


@implementation Task

@dynamic myid;
@dynamic node_id;
@dynamic node_name;
@dynamic project_id;
@dynamic start_time;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (Task *)taskWithTaskId:(NSString *)taskId{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate;
    predicate=[NSPredicate predicateWithFormat:@"myid==%@",taskId];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}

+ (Task *)taskWithCaseId:(NSString *)caseId nodeName:(NSString *)nodeName{
    
    Task *caseTask = [Task taskWithTaskId:caseId];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate;
    predicate=[NSPredicate predicateWithFormat:@"project_id==%@ and node_name==%@",caseTask.project_id,NodeNameDictionary[nodeName]];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}

@end
