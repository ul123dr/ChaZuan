//
//  DiamondModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamondModel.h"

@implementation DiamondList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"barCode"         : @"bar_code",
             @"designNo"        : @"d_design_no",
             @"designType"      : @"d_design_type",
             @"designTypeCn"    : @"d_design_type_cn",
             @"materialTypeCn"  : @"d_material_type_cn",
             @"materialWeight"  : @"d_material_weight",
             @"size"            : @"d_size",
             @"type"            : @"d_type",
             @"typeZCn"         : @"d_type_z_cn",
             @"weight"          : @"d_weight",
             @"goodsName"       : @"goods_name",
             @"goodsPic"        : @"goods_pic",
             @"listId"          : @"id",
             @"sideStone"       : @"side_stone",
             @"stockNum"        : @"stock_num",
             @"orderSx"         : @"order_sx",
             @"orderTj"         : @"order_tj",
             @"area"            : @"d_area",
             @"priceMax"        : @"d_price_max",
             @"priceMin"        : @"d_price_min",
             @"stockPic"        : @"stock_pic",
             @"typeStone"       : @"d_type_stone",
             @"typeXq"          : @"d_type_xq",
             @"materialPt950"   : @"d_material_weight_pt950",
             @"designSeries"    : @"d_design_series",
             @"material18k"     : @"d_material_weight_18k",
             @"typeZ"           : @"d_type_z",
             @"mRemark"         : @"m_remark"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end

@implementation DiamondModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":DiamondList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
