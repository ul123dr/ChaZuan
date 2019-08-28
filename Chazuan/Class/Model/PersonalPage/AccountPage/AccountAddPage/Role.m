//
//  Role.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "Role.h"

@implementation Role

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isTrueRef"       : @"is_true_ref",
             @"createTime"      : @"create_time",
             @"isEyeClean"      : @"is_eyeClean",
             @"goodType"        : @"good_type",
             @"appCheckCode"    : @"app_check_code",
             @"isBgm"           : @"is_bgm",
             @"isColorRap"      : @"is_color_rap",
             @"isDetail"        : @"is_detail",
             @"roleName"        : @"role_name",
             @"isBlack"         : @"is_black",
             @"roleId"          : @"id",
             @"isDT"            : @"is_d_t",
             @"isRegion"        : @"is_region",
             @"isDollarRate"    : @"is_dollar_rate",
             @"isDaylight"      : @"is_daylight",
             @"isRap"           : @"is_rap",
             @"isDollar"        : @"is_dollar",
             @"isDisc"          : @"is_disc",
             @"isCertNo"        : @"is_certNo",
             @"isMeasurements"  : @"is_measurements"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    self.isRegion = [[dic objectForKey:@"is_region"] integerValue] == 1;
    self.isCertNo = [[dic objectForKey:@"is_certNo"] integerValue] == 1;
    self.isDetail = [[dic objectForKey:@"is_detail"] integerValue] == 1;
    self.isRap = [[dic objectForKey:@"is_rap"] integerValue] == 1;
    self.isDollar = [[dic objectForKey:@"is_dollar"] integerValue] == 1;
    self.isDisc = [[dic objectForKey:@"is_disc"] integerValue] == 1;
    self.isBgm = [[dic objectForKey:@"is_bgm"] integerValue] == 1;
    self.isBlack = [[dic objectForKey:@"is_black"] integerValue] == 1;
    self.isColorRap = [[dic objectForKey:@"is_color_rap"] integerValue] == 1;
    self.isDaylight = [[dic objectForKey:@"is_daylight"] integerValue] == 1;
    self.isDollarRate = [[dic objectForKey:@"is_dollar_rate"] integerValue] == 1;
    self.isTrueRef = [[dic objectForKey:@"is_true_ref"] integerValue] == 1;
    self.isMeasurements = [[dic objectForKey:@"is_measurements"] integerValue] == 1;
    self.isEyeClean = [[dic objectForKey:@"is_eyeClean"] integerValue] == 1;
    self.isDT = [[dic objectForKey:@"is_d_t"] integerValue] == 1;

    return YES;
}

@end
