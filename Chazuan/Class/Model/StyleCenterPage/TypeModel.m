//
//  TypeModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"designName"  : @"design_name",
             @"listId"      : @"id"
             };
}

@end

@implementation TypeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"list1"           : @"list_1",
             @"list2"           : @"list_2",
             @"list3"           : @"list_3",
             @"list4"           : @"list_4",
             @"list5"           : @"list_5",
             @"list6"           : @"list_6",
             @"list7"           : @"list_7",
             @"list8"           : @"list_8"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list1":TypeList.class,
             @"list2":TypeList.class,
             @"list3":TypeList.class,
             @"list4":TypeList.class,
             @"list5":TypeList.class,
             @"list6":TypeList.class,
             @"list7":TypeList.class,
             @"list8":TypeList.class,
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
