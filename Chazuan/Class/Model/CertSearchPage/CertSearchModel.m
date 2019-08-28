//
//  CertSearchModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/4.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSearchModel.h"

@implementation CertSearchList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"size"                : @"d_size",
             @"shapeEn"             : @"shape_en",
             @"ref"                 : @"d_ref",
             @"listId"              : @"id",
             @"locationEn"          : @"location_en",
             @"upFileName"          : @"up_file_name",
             @"isOwnFilterStock"    : @"is_own_filter_stock",
             @"insertType"          : @"insert_type",
             @"isBgm"               : @"is_bgm",
             @"isSh"                : @"is_sh",
             @"isSizeNormal"        : @"is_size_normal",
             @"orderBy"             : @"order_by",
             @"orderSx"             : @"order_sx",
             @"orderTj"             : @"order_tj",
             @"rateAdd"             : @"rate_add",
             @"sysStatus"           : @"sys_status",
             @"depth"               : @"d_depth",
             @"table"               : @"d_table"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end

@implementation CertSearchModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":CertSearchList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
