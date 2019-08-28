//
//  LoginStatus.m
//  chazuan
//
//  Created by BecksZ on 2019/4/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "LoginStatus.h"

@implementation LoginStatus

- (BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic {
    self.www = [dic objectForKey:@"www"];
    if([[NSString stringWithFormat:@"%@",self.www.class] isEqualToString:@"__NSCFString"]){
        //user.name的json数据没有双引号，格式为_NSCFString
        self.www = [NSString stringWithFormat:@"%@",self.www];
    }
    return YES;
}

@end
