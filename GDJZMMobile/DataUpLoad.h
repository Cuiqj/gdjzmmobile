//
//  DataUpLoad.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import "WebServiceHandler.h"
#import "NSManagedObject+_NeedUpLoad_.h"

#define UPLOADCOUNT 22

//#define UPLOADCOUNT 1

#define UPLOADFINISH @"UpLoadFinished"
//#define UPLOADALLFINISH @"UpAllFinish"

@interface DataUpLoad : NSObject<WebServiceReturnString>
- (id)init;
- (void)uploadData;
@end
