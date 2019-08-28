//
//  NoteList.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NoteList.h"

@implementation NoteList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appCheckCode"    : @"app_check_code",
             @"createTime"      : @"create_time",
             @"listId"          : @"id",
             @"pushTemp"        : @"push_temp"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.appCheckCode = [[dic objectForKey:@"app_check_code"] integerValue] == 1;
    return YES;
}

@end
