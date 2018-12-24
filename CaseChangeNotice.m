//
//  CaseChangeNotice.m
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/11/13.
//
//

#import "CaseChangeNotice.h"


@implementation CaseChangeNotice

@dynamic myid;
@dynamic caseinfo_id;
@dynamic anhao;
@dynamic sendname;
@dynamic road;
@dynamic behavior;
@dynamic tiao;
@dynamic kuan;
@dynamic limitday;
@dynamic change;


- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

//读取案号对应的案件信息记录
+(CaseChangeNotice *)caseInfoForID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseChangeNotice" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",caseID];
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
