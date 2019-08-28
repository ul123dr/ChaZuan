//
//  StyleDetailList.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleDetailList.h"

@implementation StyleDetailList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"detailId"        : @"id",
             @"appCheckCode"    : @"app_check_code",
             @"barCode"         : @"bar_code",
             @"certNo"          : @"cert_no",
             @"createTime"      : @"create_time",
             @"designNo"        : @"d_design_no",
             @"dHand"           : @"d_hand",
             @"materialCn"      : @"d_material_cn",
             @"materialWeight"  : @"d_material_weight",
             @"size"            : @"d_size",
             @"sizeShapeCn"     : @"d_size_shape_cn",
             @"sizeShapeLevel"  : @"d_size_shape_level",
             @"weight"          : @"d_weight",
             @"isDelete"        : @"is_delete",
             @"sellTime"        : @"sell_time",
             @"sideStoneNum"    : @"side_stone_num",
             @"sideStoneRemark" : @"side_stone_remark",
             @"sideStoneSize"   : @"side_stone_size",
             @"designTypeCn"    : @"d_design_type_cn",
             @"materialTypeCn"  : @"d_material_type_cn",
             @"typeZCn"         : @"d_type_z_cn",
             @"goodsPic"        : @"goods_pic",
             @"orderSx"         : @"order_sx",
             @"orderTj"         : @"order_tj",
             @"sId"             : @"s_id",
             @"sideStone"       : @"side_stone",
             @"stockNum"        : @"stock_num",
             @"sizeTypeCn"      : @"d_size_type_cn",
             @"mRemark"         : @"m_remark"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.goodsPic = [[dic objectForKey:@"goods_pic"] componentsSeparatedByString:@","];
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
