//
//  StyleDetailModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleDetailModel.h"

@implementation StyleDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":StyleDetailList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
