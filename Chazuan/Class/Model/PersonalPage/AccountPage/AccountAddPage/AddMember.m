//
//  AddMember.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AddMember.h"

@implementation AddMember

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fromList"            : @"from_list",
             @"rateDouble"          : @"rate_double",
             @"rateDoubleZt"        : @"rate_double_zt",
             @"isExport"            : @"is_export",
             @"userType"            : @"user_level",
//             @"realGoodsNumberShow" : @"realGoodsNumber_show"
             @"sizeShow"            : @"size_show",
             @"isEyeClean"          : @"is_eyeClean",
             @"isDT"                : @"is_d_t",
             };
}

@end
