//
//  OrderList.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderList.h"

@implementation OrderList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"address"         : @"d_address",
             @"dollarRate"      : @"dollar_rate",
             @"goodType"        : @"good_type",
             @"isPay"           : @"is_pay",
             @"orderId"         : @"order_id",
             @"orderNo"         : @"order_no",
             @"orderSx"         : @"order_sx",
             @"orderTj"         : @"order_tj",
             @"revName"         : @"rev_name",
             @"userMobile"      : @"user_mobile",
             @"userRealname"    : @"user_realname",
             @"wwwType"         : @"www_type",
             @"ok"              : @"is_ok"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":OrderSubList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
