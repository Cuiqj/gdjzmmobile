//
//  CaseMapFa.m
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-29.
//
//

#import "CaseMapFa.h"

@implementation CaseMapFa

@dynamic myid;
@dynamic caseReason;
@dynamic roadName;
@dynamic roadDirection;
@dynamic startK;
@dynamic startM;

+ (CaseMapFa *)caseMapFaForMap:(NSString *)mapId{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid==%@",mapId];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

@end
