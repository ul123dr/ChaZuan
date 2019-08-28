//
//  User.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "User.h"

@implementation UserList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"diamondShowPower"    : @"diamond_show_power",
             @"ownLogoNum"          : @"own_logo_um",
             @"loginTimes"          : @"login_times",
             @"listId"              : @"id",
             @"isOwnLogo"           : @"is_own_logo",
             @"isExport"            : @"is_export",
             @"isOwnLogoDateEnd"    : @"is_own_logo_date_end",
             @"appCheckCode"    : @"app_check_code"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end

@implementation User

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId"          : @"id",
             @"userLevel"       : @"user_level",
             @"userType"        : @"user_type",
             @"zocaiCode"       : @"zocai_code",
             @"appCheckCode"    : @"app_check_code"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":UserList.class
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
