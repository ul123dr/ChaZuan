//
//  GoodOtherOne.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "GoodOtherOne.h"
#import "OrderSubList.h"

@implementation GoodOtherOne

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"orderNo"             : @"order_no",
             @"wwwType"             : @"www_type",
             @"goodType"            : @"good_type",
             @"gidUid"              : @"gid_uid",
             @"isPay"               : @"is_pay",
             @"orderSx"             : @"order_sx",
             @"orderId"             : @"order_id",
             @"orderTj"             : @"order_tj",
             @"isOk"                : @"is_ok",
             @"dollarRate"          : @"dollar_rate"
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
