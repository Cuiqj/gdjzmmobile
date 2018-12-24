//
//  TBXML+TBXML_TraverseAddition.h
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/18/13.
//
//

#import "TBXML.h"

@interface TBXML (TBXML_TraverseAddition)
+ (NSArray *)findElementsFrom:(TBXMLElement *)root byDotSeparatedPath:(NSString *)path withPredicate:(NSString *)predicate;
@end
