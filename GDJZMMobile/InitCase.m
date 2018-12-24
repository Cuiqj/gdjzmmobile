//
//  InitCase.m
//  GDJZMMobile
//
//  Created by xiaoxiaojia on 16/8/3.
//
//

#import "InitCase.h"
@implementation InitCase

-(void)downLoadCase{
    WebServiceInit;
    [service downloadDataSet:@"select top 50 * from CaseInfo"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"CaseInfo" andInXMLString:webString];
}

@end
