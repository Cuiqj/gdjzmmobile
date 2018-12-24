//
//  ParkingNode.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "ParkingNode.h"


@implementation ParkingNode

@dynamic address;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic code;
@dynamic date_end;
@dynamic date_send;
@dynamic date_start;
@dynamic myid;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (void)deleteAllParkingNodeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}

+ (NSArray *)parkingNodesForCase:(NSString *)caseID
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    return results;
}

@end
