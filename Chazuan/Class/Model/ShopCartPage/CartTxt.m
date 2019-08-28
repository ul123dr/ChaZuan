//
//  CartTxt.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CartTxt.h"

@implementation CartTxt

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"txtId"           : @"id",
             @"size"            : @"d_size",
             @"depth"           : @"d_depth",
             @"table"           : @"d_table",
             @"ref"             : @"d_ref",
             @"locationEn"      : @"location_en",
             @"appCheckCode"    : @"app_check_code",
             @"remark"          : @"m_remark",
             @"designNo"        : @"d_design_no",
             @"designTypeCn"    : @"d_design_type_cn",
             @"barCode"         : @"bar_code",
             @"material"        : @"d_material_cn",
             @"dHand"           : @"d_hand",
             @"weight"          : @"d_weight",
             @"materialWeight"  : @"d_material_weight",
             @"sizeType"        : @"d_size_type_cn",
             @"sizeShape"       : @"d_size_shape_cn",
             @"sizeShapeLevel"  : @"d_size_shape_level",
             @"stoneNum"        : @"side_stone_num",
             @"stoneSize"       : @"side_stone_size",
             @"stoneRemark"     : @"side_stone_remark",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    NSArray *shopCar = [[dic objectForKey:@"shopcar"] componentsSeparatedByString:@","];
    if (shopCar.count > 0) {
        self.styleNo = shopCar[0];
        self.size = validateString(shopCar[1]).length == 0?self.size:shopCar[1];
        self.caizhi = shopCar[2];
        self.hand = shopCar[3];
        self.kezi = shopCar[4];
        self.date = shopCar[5];
        self.mark = shopCar[6];
        self.num = shopCar[7];
    }
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
