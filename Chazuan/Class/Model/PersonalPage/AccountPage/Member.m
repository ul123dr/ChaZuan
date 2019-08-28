//
//  Member.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "Member.h"

@implementation Member

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rateDoubleLzColor"   : @"rate_double_lz_color",
             @"userLevel"           : @"user_level",
             @"zocaiCode"           : @"zocai_code",
             @"memberId"            : @"id",
             @"rateDoubleLz"        : @"rate_double_lz",
             @"rateDouble"          : @"rate_double",
             @"userType"            : @"user_type",
             @"rateDiscount"        : @"rate_discount",
             @"isOwnLogo"           : @"is_own_logo",
             @"ownLogoNum"          : @"own_logo_num",
             @"salesmenPow"         : @"salesmen_pow",
             @"isOwnLogoDateEnd"    : @"is_own_logo_date_end",
             @"diamondShowPower"    : @"diamond_show_power",
             @"loginTimes"          : @"login_times",
             @"isExport"            : @"is_export",
             @"groupbyRateDiscount" : @"groupby_rate_discount",
             @"appCheckCode"        : @"app_check_code",
             @"ownLogo"             : @"own_logo",
             @"userTypeLevel"       : @"user_type_level",
             @"rateDoubleZt"        : @"rate_double_zt",
             @"groupbyDoubleAdd"    : @"groupby_double_add",
             @"plusDateEnd"         : @"plus_date_end",
             @"salesmenName"        : @"salesmen_name",
             @"rapIds"              : @"rap_ids",
             @"salesmenId"          : @"salesmen_id",
             @"buyerId"             : @"buyer_id",
             @"addressDetail"       : @"address_detail"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":Member.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
