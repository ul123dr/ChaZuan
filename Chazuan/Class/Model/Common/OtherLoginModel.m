//
//  OtherLoginModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OtherLoginModel.h"

@implementation LogList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"loginDate"           : @"login_date",
             @"loginIp"             : @"login_ip"
             };
}

@end

@implementation OtherLoginModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":LogList.class,
             };
}

@end
