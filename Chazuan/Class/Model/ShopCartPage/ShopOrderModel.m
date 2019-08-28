//
//  ShopOrderModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopOrderModel.h"

@implementation ShopOrderList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"        : @"app_check_code",
             @"cloudGoodsId"        : @"cloudGoods_id",
             @"size"                : @"D_size",
             @"type"                : @"d_type",
             @"diamondPrice"        : @"diamond_price",
             @"discCost"            : @"disc_cost",
             @"discGid"             : @"disc_gid",
             @"goodId"              : @"good_id",
             @"goodName"            : @"good_name",
             @"goodType"            : @"good_type",
             @"isDisount"           : @"is_disount",
             @"isSh"                : @"is_sh",
             @"mRemark"             : @"m_remark",
             @"orderGoodsId"        : @"order_goods_id",
             @"orderId"             : @"order_id",
             @"priceCost"           : @"price_cost",
             @"purchasePrice"       : @"purchase_price",
             @"purchasePriceDisc"   : @"purchase_price_disc",
             @"purchasePriceRmb"    : @"purchase_price_rmb",
             @"receivedTime"        : @"received_time",
             @"supplierAddress"     : @"supplier_address",
             @"supplierSimpleName"  : @"supplier_simple_name",
             @"tempStatus"          : @"temp_status"
             };
}
//@property (nonatomic, readwrite, copy) NSString *mRemark; //m_remark: "\U692d\U5706\U5f62,0.3CT,K,VS2,GIA;36.4;FNT,N,N,N,900.0,1186347,B,\U5b5f\U4e70,";
//@property (nonatomic, readwrite, copy) NSString *remark; //remark = "0.3 CT \U88f8\U94bb-;\U8bc1\U4e66\Uff1a6322259589-;K\U8272/\U51c0\U5ea6VS2/\U5207\U5de5\Uff1a-,EX,GD  GIA";

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end

@implementation ShopOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"address"         : @"d_address",
             @"goodType"        : @"good_type",
             @"isPay"           : @"is_pay",
             @"dollarRate"      : @"dollar_rate",
             @"orderId"         : @"order_id",
             @"orderNo"         : @"order_no",
             @"orderSx"         : @"order_sx",
             @"orderTj"         : @"order_tj",
             @"sendMessageType" : @"send_message_type",
             @"wwwType"         : @"www_type",
             @"wwwUrl"          : @"www_url"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":ShopOrderList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
