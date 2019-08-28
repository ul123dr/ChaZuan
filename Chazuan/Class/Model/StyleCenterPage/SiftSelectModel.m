//
//  SiftSelectModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SiftSelectModel.h"

@implementation SiftSelectModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"categoryList":SiftList.class,
             @"describeList":SiftList.class,
             @"styleList":SiftList.class,
             @"scoopList":SiftList.class,
             @"gemsList":SiftList.class,
             @"recommendList":SiftList.class,
             @"typeList":SiftList.class,
             @"category8List":SiftList.class,
             @"describe8List":SiftList.class,
             @"style8List":SiftList.class,
             @"scoop8List":SiftList.class
             };
}

@end
