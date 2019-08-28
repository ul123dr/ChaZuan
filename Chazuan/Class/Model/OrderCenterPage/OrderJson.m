//
//  OrderJson.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderJson.h"

@implementation OrderJson

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"jsonId"          : @"id",
             @"designTypeCn"    : @"d_design_type_cn",
             @"materialTypeCn"  : @"d_material_type_cn",
             @"dhand"           : @"d_hand",
             @"weight"          : @"d_weight",
             @"materialWeight"  : @"d_material_weight",
             @"size"            : @"d_size",
             @"goodsPic"        : @"goods_pic",
             @"stockNum"        : @"stock_num",
             @"barCode"         : @"bar_code",
             @"designNo"        : @"d_design_no",
             @"certNo"          : @"cert_no",
             @"sellTime"        : @"sell_time",
             @"sideStoneSize"   : @"side_stone_size",
             @"sideStoneRemark" : @"side_stone_remark",
             @"sizeShapeCn"     : @"d_size_shape_cn",
             @"sideStoneNum"    : @"side_stone_num",
             @"materialCn"      : @"d_material_cn",
             @"sizeTypeCn"      : @"d_size_type_cn",
             @"sizeShapeLevel"  : @"d_size_shape_level"
             };
}

@end
