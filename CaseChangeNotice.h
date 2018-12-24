//
//  CaseChangeNotice.h
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseChangeNotice : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * anhao;
@property (nonatomic, retain) NSString * sendname;
@property (nonatomic, retain) NSString * road;
@property (nonatomic, retain) NSString * behavior;
@property (nonatomic, retain) NSString * tiao;
@property (nonatomic, retain) NSString * kuan;
@property (nonatomic, retain) NSString * limitday;
@property (nonatomic, retain) NSString * change;

+(CaseChangeNotice *)caseInfoForID:(NSString *)caseID;


@end
