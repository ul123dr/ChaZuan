//
//  ShopCartList.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopCartList.h"

@implementation ShopCartList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"listId"          : @"id",
             @"goodType"        : @"good_type",
             @"appCheckCode"    : @"app_check_code",
             @"goodId"          : @"good_id",
             @"wwwType"         : @"www_type",
             @"createDate"      : @"create_date",
             @"updateTime"      : @"update_time",
             @"sysStatus"       : @"sys_status"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.cartTxt = [CartTxt modelWithJSON:[dic objectForKey:@"txt"]];
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
