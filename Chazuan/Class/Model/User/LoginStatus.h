//
//  LoginStatus.h
//  chazuan
//
//  Created by BecksZ on 2019/4/16.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginStatus : MHObject

@property (nonatomic, readwrite, assign) NSInteger code;
@property (nonatomic, readwrite, copy) NSString *data;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, copy) NSString *www;

//"1065-1497924541062001-df9e172591dca9241c2fe19c18514e7c--99---1,1,1,1,1,1,1,1,1,1,1,1,1-1"

@end

NS_ASSUME_NONNULL_END
