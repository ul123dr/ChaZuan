//
//  SearchModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list":SearchLog.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
