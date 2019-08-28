//
//  ManagerSpecialty.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ManagerSpecialty.h"

@implementation ManagerSpecialty

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"webId"           : @"id",
             @"indexLogo"       : @"index_logo",
             @"wwwCN"           : @"www_cn",
             @"mainId"          : @"www_main_id",
             @"phone"           : @"www_phone",
             @"recordNo"        : @"record_no",
             @"ebyUid"          : @"eby_uid",
             @"isWechatNotice"  : @"is_weixin_notice",
             @"weixinSign"      : @"weixin_sign",
             @"isSourceType"    : @"is_source_type_2",
             @"isOwnServer"     : @"is_own_server",
             @"isYGoodsStock"   : @"is_y_goods_stock",
             };
}

//- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
//    NSObject *status = [dic objectForKey:@"status"];
//    if (kObjectIsNotNil(status)) {
//        self.webAllow = !self.status;
//    } else {
//        self.webAllow = NO;
//    }
//    return YES;
//}

@end
