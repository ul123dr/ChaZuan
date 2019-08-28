//
//  OrderSubList.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderSubList.h"

@implementation OrderSubList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"supplierAddress"     : @"supplier_address",
             @"mRemark"             : @"m_remark",
             @"goodName"            : @"good_name",
             @"receivedTime"        : @"received_time",
             @"supplierSimpleName"  : @"supplier_simple_name",
             @"size"                : @"D_size",
             @"advancePrice"        : @"advance_price",
             @"type"                : @"d_type",
             @"diamondPrice"        : @"diamond_price",
             @"discCost"            : @"disc_cost",
             @"discGid"             : @"disc_gid",
             @"discountPrice"       : @"discount_price",
             @"finalPayment"        : @"final_payment",
             @"goodId"              : @"good_id",
             @"goodType"            : @"good_type",
             @"isDisount"           : @"is_disount",
             @"isSh"                : @"is_sh",
             @"orderGoodOtherId"    : @"order_good_other_id",
             @"orderGoodsId"        : @"order_goods_id",
             @"orderId"             : @"order_id",
             @"priceCost"           : @"price_cost",
             @"purchasePrice"       : @"purchase_price",
             @"purchasePriceRmb"    : @"purchase_price_rmb",
             @"stoneType"           : @"stone_type",
             @"styleStatus"         : @"style_status",
             @"tempStatus"          : @"temp_status",
             @"purchasePriceDisc"   : @"purchase_price_disc",
             @"sourceType"          : @"source_type",
             @"orderGoodOtherOne"   : @"order_good_other_one"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.json = [OrderJson modelWithJSON:[dic objectForKey:@"json_text"]];
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
