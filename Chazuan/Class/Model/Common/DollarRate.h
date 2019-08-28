//
//  DollarRate.h
//  chazuan
//
//  Created by BecksZ on 2019/4/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DollarRate : MHObject

@property (nonatomic, readwrite, strong) NSNumber *rateId;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *dollarRate;
@property (nonatomic, readwrite, assign) NSInteger orderMaxTime;
@property (nonatomic, readwrite, copy) NSString *sessionkey;
@property (nonatomic, readwrite, copy) NSString *sign;
@property (nonatomic, readwrite, copy) NSString *www;
@property (nonatomic, readwrite, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
