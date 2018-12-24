//
//  CaseCount.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-7.
//
//

#import "CaseCount.h"
#import "NSNumber+NumberConvert.h"


@implementation CaseCount

@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic sum;
@dynamic chinese_sum;
@synthesize case_count_list;

-(NSString *) chinese_sum_w{
    if (![self.chinese_sum isEmpty]) {
        if (![self.chinese_sum isEmpty]) {
            NSRange found = [self.chinese_sum rangeOfString:@"万"];
            if (found.location != NSNotFound) {
                NSString *result = [self.chinese_sum substringToIndex:found.location];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_q{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"仟"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_b{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"佰"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_s{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange found = [chinese rangeOfString:@"拾"];
            if (found.location != NSNotFound) {
                NSString *result = [chinese substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_y{
    if (![self.chinese_sum isEmpty]) {
        double num = fmod([self.sum doubleValue], 10000);
        NSString *chinese = [[NSNumber numberWithDouble:num] numberConvertToChineseCapitalNumberString];
        if (![chinese isEmpty]) {
            NSRange single = [chinese rangeOfString:@"元"];
            if (single.location != NSNotFound) {
                NSRange ten = [chinese rangeOfString:@"拾"];
                if (ten.location == NSNotFound || abs(ten.location - single.location) > 1) {
                    NSString *result = [chinese substringWithRange:NSMakeRange(single.location-1, 1)];
                    return result;
                }
            }
        }
    }
    return @"零";
}

-(NSString *) chinese_sum_j{
    if (![self.chinese_sum isEmpty]) {
        if (![self.chinese_sum isEmpty]) {
            NSRange found = [self.chinese_sum rangeOfString:@"角"];
            if (found.location != NSNotFound) {
                NSString *result = [self.chinese_sum substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}
-(NSString *) chinese_sum_f{
    if (![self.chinese_sum isEmpty]) {
        if (![self.chinese_sum isEmpty]) {
            NSRange found = [self.chinese_sum rangeOfString:@"分"];
            if (found.location != NSNotFound) {
                NSString *result = [self.chinese_sum substringWithRange:NSMakeRange(found.location-1, 1)];
                return result;
            }
        }
    }
    return @"零";
}

@end
