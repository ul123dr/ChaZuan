//
//  SearchLog.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchLog.h"

@implementation SearchLog

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"logId"           : @"id",
             @"createTime"      : @"create_time"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

//sessionkey: ""
//sign: ""
//type: 1
//uid: "1497924541062001"
//www: "www.caisezuanshi.com"

@end
