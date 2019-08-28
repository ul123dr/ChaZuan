//
//  LoginIpModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface IpData : MHObject

@property (nonatomic, readwrite, copy) NSString *region;
@property (nonatomic, readwrite, copy) NSString *city;

@end

@interface LoginIpModel : MHObject

@property (nonatomic, readwrite, strong) IpData *data;

@end

NS_ASSUME_NONNULL_END
