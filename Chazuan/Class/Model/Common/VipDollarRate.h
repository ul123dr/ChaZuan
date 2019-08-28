//
//  VipDollarRate.h
//  chazuan
//
//  Created by BecksZ on 2019/4/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipDollarRate : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *temp1;
@property (nonatomic, readwrite, copy) NSString *temp2;
@property (nonatomic, readwrite, copy) NSString *temp3;
@property (nonatomic, readwrite, copy) NSString *temp4;

@end

NS_ASSUME_NONNULL_END
