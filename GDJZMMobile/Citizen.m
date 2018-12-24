//
//  Citizen.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import "Citizen.h"


@implementation Citizen

@dynamic address;
@dynamic age;
@dynamic automobile_address;
@dynamic automobile_number;
@dynamic automobile_owner;
@dynamic automobile_pattern;
@dynamic bad_desc;
@dynamic card_name;
@dynamic card_no;
@dynamic carowner;
@dynamic carowner_address;
@dynamic proveinfo_id;
@dynamic compensate_money;
@dynamic driver;
@dynamic isuploaded;
@dynamic myid;
@dynamic nation;
@dynamic nationality;
@dynamic nexus;
@dynamic org_name;
@dynamic org_principal;
@dynamic org_principal_duty;
@dynamic org_principal_tel_number;
@dynamic org_tel_number;
@dynamic original_home;
@dynamic party;
@dynamic patry_type;
@dynamic postalcode;
@dynamic profession;
@dynamic proportion;
@dynamic remark;
@dynamic sex;
@dynamic tel_number;
@dynamic org_full_name;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

+ (NSArray *)allCitizenNameForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,@"当事人"];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}



+ (Citizen *)citizenForName:(NSString *)autoNumber nexus:(NSString *)nexus caseId:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && automobile_number==%@",caseID,nexus,autoNumber];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}

+ (Citizen *)citizenForParty:(NSString *)party caseId:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && party==%@",caseID,@"当事人",party];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}

//add by lxm 2013.05.10
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus caseId:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
//add by lxm 2013.05.10
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
#pragma mark - 行政处罚  需要注意的是跟【路政案件】的最大区别是 对应一个案件，一个类别(当事人,组织代表等)只有一个对应的当事人，不会有多个，也就说，相对于路政案件，不会有多车辆问题
+ (Citizen *)citizenByCaseID:(NSString *)caseID andNexus:(NSString *)nexus{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
+ (Citizen *)citizenByCaseID:(NSString *)caseID{
    return [Citizen citizenByCaseID:caseID andNexus:@"当事人"];
}
@end
