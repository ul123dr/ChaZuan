//
//  DollarRate.m
//  chazuan
//
//  Created by BecksZ on 2019/4/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DollarRate.h"

@implementation DollarRate

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rateId"          : @"id",
             @"appCheckCode"    : @"app_check_code",
             @"dollarRate"      : @"dollar_rate",
             @"orderMaxTime"    : @"order_max_time",
             @"updateTime"      : @"update_time"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
