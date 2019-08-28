//
//  CalculatorModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CalculatorModel.h"

@implementation CalculatorModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"calculatorId"        : @"id",
             @"appCheckCode"        : @"app_check_code",
             @"maxSize"             : @"d_size_max",
             @"minSize"             : @"d_size_min",
             @"createDate"          : @"create_date"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
