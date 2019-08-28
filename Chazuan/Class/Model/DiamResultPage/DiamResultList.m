//
//  DiamResultList.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamResultList.h"

@implementation DiamResultList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"orderSx"             : @"order_sx",
             @"listId"              : @"id",
             @"isSizeNormal"        : @"is_size_normal",
             @"upFileName"          : @"up_file_name",
             @"locationEn"          : @"location_en",
             @"shapeEn"             : @"shape_en",
             @"insertType"          : @"insert_type",
             @"isOwnFilterStock"    : @"is_own_filter_stock",
             @"sysStatus"           : @"sys_status",
             @"dRef"                : @"d_ref",
             @"updateTime"          : @"update_time",
             @"countRate"           : @"count_rate",
             @"dDepth"              : @"d_depth",
             @"dSize"               : @"d_size",
             @"orderTj"             : @"order_tj",
             @"dTable"              : @"d_table",
             @"orderBy"             : @"order_by",
             @"isSh"                : @"is_sh",
             @"rateAdd"             : @"rate_add",
             @"isBgm"               : @"is_bgm",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
