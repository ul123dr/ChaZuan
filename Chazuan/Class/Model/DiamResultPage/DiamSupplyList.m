//
//  DiamSupplyList.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSupplyList.h"

@implementation DiamSupplyList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"updateTime"          : @"update_time",
             @"supplierLocation"    : @"supplier_location",
             @"supplierAreaType"    : @"supplier_area_type",
             @"listId"              : @"id",
             @"dollarRate"          : @"dollar_rate",
             @"isQuick"             : @"is_quick",
             @"supplierNameTrue"    : @"supplier_name_true",
             @"supplierNo"          : @"supplier_no",
             @"isJk"                : @"is_jk",
             @"orderbyTurn"         : @"orderby_turn",
             @"supplierSimpleName"  : @"supplier_simple_name",
             @"supplierTypeCn"      : @"supplier_type_cn",
             @"supplierDollarRate"  : @"supplier_dollar_rate",
             @"supplierWww"         : @"supplier_www",
             @"orderbyParam"        : @"orderby_param",
             @"isAuto"              : @"is_auto",
             @"isCustomer"          : @"is_customer",
             @"supplierName"        : @"supplier_name",
             @"disc1"               : @"Disc1"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
