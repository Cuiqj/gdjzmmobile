//
//  NSArray+NewCaseDescArray.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaseDescString.h"

@interface NSArray(NewCaseDescArray)
//建立一个案由描述组
+(NSArray *)newCaseDescArray:(NSString *)caseTypeId;
//建立行政处罚的案由描述数组
+(NSArray *)newAdministrativePenaltyCaseDescArray;
@end
