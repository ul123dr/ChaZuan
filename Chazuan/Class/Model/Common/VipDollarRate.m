//
//  VipDollarRate.m
//  chazuan
//
//  Created by BecksZ on 2019/4/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "VipDollarRate.h"

@implementation VipDollarRate

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"           : @"app_check_code"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
